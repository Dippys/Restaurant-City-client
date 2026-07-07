package com.playfish.rpc.share
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.Timer;
   
   public class RpcRequestBase
   {
      
      private static const HEX_CHARS:String = "0123456789ABCDEF";
      
      private var timer:Timer;
      
      internal var responseHandler:Function;
      
      internal var responseInitialTimeoutMillis:uint = RpcClientBase.responseInitialTimeoutMillis;
      
      private var client:RpcClientBase;
      
      internal var msgType:uint;
      
      private var body:ByteArray;
      
      internal var numResourceCopies:uint;
      
      internal var successCallback:Function;
      
      private var urlLoader:URLLoader;
      
      internal var triedGet:Boolean = RpcClientBase.disableRetryAsGet;
      
      internal var errorCallback:Function;
      
      private var partOfBatch:Boolean;
      
      private var requestMsg:ByteArray;
      
      public function RpcRequestBase()
      {
         super();
      }
      
      internal static function dumpByteArray(param1:ByteArray) : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc2_:String = "";
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = "";
            _loc6_ = "";
            _loc7_ = 0;
            while(_loc7_ < 16 && _loc4_ + _loc7_ < _loc3_)
            {
               _loc8_ = uint(param1[_loc4_ + _loc7_]);
               _loc5_ += " " + HEX_CHARS.charAt(_loc8_ >> 4) + HEX_CHARS.charAt(_loc8_ & 0x0F);
               _loc6_ += _loc8_ >= 32 && _loc8_ <= 126 ? String.fromCharCode(_loc8_) : "•";
               _loc7_++;
            }
            while(_loc5_.length < 48)
            {
               _loc5_ += " ";
            }
            while(_loc6_.length < 16)
            {
               _loc6_ += " ";
            }
            _loc2_ += HEX_CHARS.charAt(_loc4_ >> 12 & 0x0F) + HEX_CHARS.charAt(_loc4_ >> 8 & 0x0F) + HEX_CHARS.charAt(_loc4_ >> 4 & 0x0F) + HEX_CHARS.charAt(_loc4_ & 0x0F) + ":  " + _loc5_ + "    " + _loc6_ + "\n";
            _loc4_ += 16;
         }
         return _loc2_;
      }
      
      private static function loadResources(param1:Array, param2:Function) : void
      {
         var xxxrr:ResourceRequest = null;
         var remain:uint = 0;
         var resourceTimer:Timer = null;
         var rr:ResourceRequest = null;
         var resourceDone:Function = null;
         var resourceTimeout:Function = null;
         var resourceRequests:Array = param1;
         var doneCallback:Function = param2;
         resourceDone = function():void
         {
            RpcClientBase.debug("loadResources: resourceDone: remain: " + remain + " -> " + (remain - 1));
            --remain;
            if(remain == 0)
            {
               resourceTimer.reset();
               doneCallback();
            }
         };
         resourceTimeout = function(param1:TimerEvent):void
         {
            var _loc2_:ResourceRequest = null;
            RpcClientBase.debug("loadResources: resourceTimeout: remain=" + remain);
            for each(_loc2_ in resourceRequests)
            {
               _loc2_.cancel();
            }
            doneCallback();
         };
         RpcClientBase.debug("loadResources: count=" + resourceRequests.length + ":");
         for each(xxxrr in resourceRequests)
         {
            RpcClientBase.debug("\t" + xxxrr);
         }
         remain = resourceRequests.length;
         resourceTimer = new Timer(RpcClientBase.resourceLoadTimeoutMillis,1);
         resourceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,resourceTimeout);
         for each(rr in resourceRequests)
         {
            rr.load(resourceDone);
         }
         resourceTimer.start();
      }
      
      public function writeSparseArray(param1:Array, param2:Function) : void
      {
         var _loc4_:String = null;
         var _loc3_:uint = param1.length;
         writeUintvar32(_loc3_);
         for(_loc4_ in param1)
         {
            writeUintvar32(uint(_loc4_));
            param2(param1[_loc4_]);
         }
      }
      
      public function writeNetworkUid(param1:NetworkUid) : void
      {
         if(param1 == null)
         {
            writeUintvar31(0);
         }
         else
         {
            writeUintvar31(param1._network);
            writeString(param1._networkUid);
            writeUintvar31(param1._playfishUid);
         }
      }
      
      public function writeUintvar31(param1:uint) : void
      {
         if((param1 & 0x80000000) != 0)
         {
            throw new Error();
         }
         writeUintvar32(param1);
      }
      
      public function writeUintvar32(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if((param1 & 0xF0000000) != 0)
         {
            _loc2_ = 28;
         }
         else if((param1 & 0x0FE00000) != 0)
         {
            _loc2_ = 21;
         }
         else if((param1 & 0x1FC000) != 0)
         {
            _loc2_ = 14;
         }
         else if((param1 & 0x3F80) != 0)
         {
            _loc2_ = 7;
         }
         else
         {
            _loc2_ = 0;
         }
         while(_loc2_ > 0)
         {
            body.writeByte(param1 >>> _loc2_ | 0x80);
            _loc2_ -= 7;
         }
         body.writeByte(param1 & 0x7F);
      }
      
      private function sendRequest(param1:String, param2:ByteArray) : void
      {
         urlLoader = new URLLoader();
         urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         urlLoader.addEventListener(Event.COMPLETE,completeHandler);
         urlLoader.addEventListener(Event.OPEN,progressHandler);
         urlLoader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
         urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
         var _loc3_:URLRequest = new URLRequest(param1);
         if(param2 != null)
         {
            _loc3_.method = URLRequestMethod.POST;
            _loc3_.contentType = "application/octet-stream";
            _loc3_.data = param2;
         }
         timer = new Timer(responseInitialTimeoutMillis,1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,timeoutHandler);
         timer.start();
         urlLoader.load(_loc3_);
      }
      
      private function completeHandler(param1:Event) : void
      {
         var response:RpcResponseBase;
         var responseBody:ByteArray = null;
         var encapsulationType:uint = 0;
         var responseType:uint = 0;
         var errorReason:uint = 0;
         var wrappedSuccessCallback:Function = null;
         var event:Event = param1;
         timer.reset();
         try
         {
            responseBody = urlLoader.data;
            encapsulationType = responseBody.readUnsignedByte();
            RpcClientBase.debug("response: encapsulationType=" + encapsulationType);
            responseType = responseBody.readUnsignedByte();
            if(responseType == RpcClientBase.ERROR_RESPONSE)
            {
               errorReason = responseBody.readUnsignedByte();
               if(errorReason == RpcClientBase.ERROR_REASON_FORMAT && !triedGet)
               {
                  retryRequestAsGet();
                  return;
               }
               errorCallback();
               return;
            }
            if(responseType != msgType)
            {
               RpcClientBase.debug("ERROR: unexpected response type: got=" + responseType + " expected=" + msgType);
               errorCallback();
               return;
            }
         }
         catch(e:Error)
         {
            errorCallback();
            return;
         }
         response = client.createResponse();
         response.init(client,responseBody,responseBody.bytesAvailable,new Array(),numResourceCopies);
         try
         {
            wrappedSuccessCallback = responseHandler(response,successCallback);
         }
         catch(e:Error)
         {
            RpcClientBase.debug("ERROR: caught error calling response handler: " + e);
            RpcClientBase.debug("ERROR: stackTrace: " + e.getStackTrace());
            errorCallback();
            return;
         }
         if(!response.isDone())
         {
            RpcClientBase.debug("ERROR: response handler returned but response.isDone() is false");
            errorCallback();
            return;
         }
         if(response.resourceRequests.length != 0)
         {
            RpcClientBase.debug("response: need to load " + response.resourceRequests.length + " resources to complete request");
            loadResources(response.resourceRequests,wrappedSuccessCallback);
            return;
         }
         RpcClientBase.debug("response: no images need to be loaded");
         RpcClientBase.debug("RPC: calling success callback");
         wrappedSuccessCallback();
      }
      
      public function writeBitSet(param1:BitSet) : void
      {
         writeUintvar32(param1.bits.length);
         body.writeBytes(param1.bits);
      }
      
      private function retryRequestAsGet() : void
      {
         var _loc3_:uint = 0;
         triedGet = true;
         var _loc1_:String = client.url + "?msg=" + requestMsg.length + "-";
         var _loc2_:uint = 0;
         while(_loc2_ < requestMsg.length)
         {
            _loc3_ = uint(requestMsg[_loc2_]);
            _loc1_ += "0123456789ABCDEF".charAt(_loc3_ >> 4 & 0x0F) + "0123456789ABCDEF".charAt(_loc3_ & 0x0F);
            _loc2_++;
         }
         sendRequest(_loc1_,null);
      }
      
      internal function init(param1:RpcClientBase, param2:Boolean, param3:uint, param4:uint, param5:Function, param6:Function, param7:Function) : void
      {
         this.client = param1;
         this.partOfBatch = param2;
         this.numResourceCopies = param3;
         this.msgType = param4;
         this.body = new ByteArray();
         this.body.endian = Endian.BIG_ENDIAN;
         this.responseHandler = param5;
         this.successCallback = param6;
         this.errorCallback = param7;
         if(!param2)
         {
            writeUint8(RpcClientBase.ENCAPSULATION_NULL);
            writeUint8(param4);
            writeString(param1.sessionId);
         }
      }
      
      public function writeByteArray(param1:ByteArray) : void
      {
         writeUintvar32(param1.length);
         body.writeBytes(param1);
      }
      
      public function writeFloat32(param1:Number) : void
      {
         body.writeFloat(param1);
      }
      
      private function progressHandler(param1:Event) : void
      {
         timer.reset();
         timer.delay = RpcClientBase.responseProgressTimeoutMillis;
         timer.start();
      }
      
      public function writeString(param1:String) : void
      {
         writeUintvar32(param1.length);
         body.writeUTFBytes(param1);
      }
      
      public function writeBoolean(param1:Boolean) : void
      {
         body.writeByte(param1 ? 1 : 0);
      }
      
      internal function writeSubRequest(param1:RpcRequestBase) : void
      {
         writeUint8(param1.msgType);
         writeUintvar32(param1.body.length);
         body.writeBytes(param1.body);
      }
      
      private function errorHandler(param1:Event) : void
      {
         RpcClientBase.debug("ERROR: error event during network operation: " + param1);
         timer.reset();
         if(!triedGet)
         {
            retryRequestAsGet();
            return;
         }
         errorCallback();
      }
      
      public function writeDate(param1:Date) : void
      {
         writeUintvar32(param1 == null ? 0 : uint(param1.getTime() / 1000));
      }
      
      public function writeTimingData(param1:TimingData) : void
      {
         writeByteArray(param1.token);
         writeUintvar32(param1.rtt);
      }
      
      private function timeoutHandler(param1:Event) : void
      {
         var event:Event = param1;
         RpcClientBase.debug("ERROR: timeout during network operation");
         try
         {
            urlLoader.close();
         }
         catch(e:Error)
         {
            RpcClientBase.debug("ERROR: caught exception in URLLoader.close(): " + e);
         }
         errorCallback();
      }
      
      public function perform() : void
      {
         RpcClientBase.debug("perform: type=" + msgType + " length=" + body.length + " partOfBatch=" + partOfBatch + " body=\n" + dumpByteArray(body));
         if(partOfBatch)
         {
            RpcClientBase.debug("perform: request is part of a batch: no operation in perform()");
            return;
         }
         requestMsg = body;
         body = null;
         sendRequest(client.url,requestMsg);
      }
      
      public function writeArray(param1:Array, param2:Function) : void
      {
         var _loc3_:uint = param1.length;
         writeUintvar32(_loc3_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            param2(param1[_loc4_]);
            _loc4_++;
         }
      }
      
      public function writeFloat64(param1:Number) : void
      {
         body.writeDouble(param1);
      }
      
      public function writeIntvar32(param1:int) : void
      {
         var _loc2_:uint = 0;
         if(param1 < 0)
         {
            _loc2_ = uint(~param1 << 1 | 1);
         }
         else
         {
            _loc2_ = uint(param1 << 1);
         }
         writeUintvar32(_loc2_);
      }
      
      public function writeUint8(param1:uint) : void
      {
         body.writeByte(param1);
      }
   }
}


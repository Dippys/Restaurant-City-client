package com.playfish.rpc.share
{
   import flash.errors.EOFError;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class RpcResponseBase
   {
      
      private var client:RpcClientBase;
      
      private var body:ByteArray;
      
      private var numResourceCopies:uint;
      
      private var endPosition:uint;
      
      internal var resourceRequests:Array;
      
      public function RpcResponseBase()
      {
         super();
      }
      
      internal function readPurchasableItem() : PurchasableItem
      {
         var _loc1_:uint = readUintvar32();
         var _loc2_:uint = readUintvar32();
         var _loc3_:String = readString();
         var _loc4_:String = readString();
         return new PurchasableItem(client.purchaseBase,_loc1_,_loc2_,_loc3_,_loc4_);
      }
      
      public function readFloat32() : Number
      {
         return body.readFloat();
      }
      
      public function readDate() : Date
      {
         var _loc1_:uint = readUintvar32();
         return _loc1_ == 0 ? null : new Date(_loc1_ * 1000);
      }
      
      public function readString() : String
      {
         var _loc4_:uint = 0;
         var _loc1_:uint = readUintvar32();
         var _loc2_:String = "";
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = readUint8();
            switch(_loc4_ >>> 4)
            {
               case 0:
               case 1:
               case 2:
               case 3:
               case 4:
               case 5:
               case 6:
               case 7:
                  break;
               case 12:
               case 13:
                  _loc4_ &= 31;
                  _loc4_ = uint(_loc4_ << 6 | readUtf8Extension());
                  break;
               case 14:
                  _loc4_ &= 15;
                  _loc4_ = uint(_loc4_ << 6 | readUtf8Extension());
                  _loc4_ = uint(_loc4_ << 6 | readUtf8Extension());
                  break;
               default:
                  RpcClientBase.debug("malformed UTF-8: found char beginning with octet " + _loc4_);
                  throw new Error();
            }
            _loc2_ += String.fromCharCode(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function readBitSet() : BitSet
      {
         var _loc1_:BitSet = new BitSet();
         _loc1_.setArray(readByteArray());
         return _loc1_;
      }
      
      internal function isDone() : Boolean
      {
         if(body.position != endPosition)
         {
            RpcClientBase.debug("RpcResponse: isDone: position=" + body.position + " endPosition=" + endPosition);
         }
         return body.position == endPosition;
      }
      
      internal function init(param1:RpcClientBase, param2:ByteArray, param3:uint, param4:Array, param5:uint) : void
      {
         this.client = param1;
         this.body = param2;
         this.body.endian = Endian.BIG_ENDIAN;
         this.endPosition = param2.position + param3;
         this.resourceRequests = param4;
         this.numResourceCopies = param5;
         RpcClientBase.debug("RpcResponse: create: position=" + param2.position + " length=" + param3 + " endPosition=" + endPosition + " numResourceCopies=" + param5);
      }
      
      private function readUtf8Extension() : uint
      {
         var _loc1_:uint = readUint8();
         if((_loc1_ & 0xC0) != 128)
         {
            RpcClientBase.debug("malformed UTF-8: found invalid extension octet " + _loc1_);
            throw new Error();
         }
         return _loc1_ & 0x3F;
      }
      
      public function get profileBase() : String
      {
         return client.profileBase;
      }
      
      internal function readPricepoint() : Pricepoint
      {
         var _loc1_:uint = readUintvar31();
         var _loc2_:uint = readUintvar31();
         var _loc3_:uint = readUintvar31();
         var _loc4_:uint = readUintvar31();
         var _loc5_:String = readString();
         var _loc6_:uint = readUintvar31();
         var _loc7_:String = readString();
         var _loc8_:String = readString();
         return new Pricepoint(client.purchaseBase,_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
      }
      
      public function registerResourceUrl(param1:String) : Array
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = new Array();
         RpcClientBase.debug("registerResourceUrl: url=\"" + param1 + "\" numResourceCopies=" + numResourceCopies);
         if(param1 != "")
         {
            _loc3_ = 0;
            while(_loc3_ < numResourceCopies)
            {
               resourceRequests.push(new ResourceRequest(param1,_loc2_));
               _loc3_++;
            }
         }
         else
         {
            RpcClientBase.debug("registerResourceUrl: url is empty string: skipping image");
         }
         return _loc2_;
      }
      
      internal function initAsSubResponse(param1:RpcResponseBase, param2:uint, param3:uint) : void
      {
         init(param1.client,param1.body,param2,param1.resourceRequests,param3);
      }
      
      internal function skipToEnd() : void
      {
         RpcClientBase.debug("RpcResponse: skipToEnd: position=" + body.position + " endPosition=" + endPosition);
         body.position = endPosition;
      }
      
      public function readArray(param1:Function) : Array
      {
         var _loc2_:uint = readUintvar32();
         var _loc3_:Array = new Array(_loc2_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_[_loc4_] = param1();
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function readFloat64() : Number
      {
         return body.readDouble();
      }
      
      public function readUint8() : uint
      {
         if(body.position >= endPosition)
         {
            throw new EOFError();
         }
         return body.readUnsignedByte();
      }
      
      public function readServerInfo() : ServerInfo
      {
         var _loc1_:String = readString();
         var _loc2_:Array = readSparseArray(readString);
         var _loc3_:ServerInfo = new ServerInfo();
         _loc3_.url = _loc1_;
         _loc3_.sessionId = client.sessionId;
         _loc3_.profileBase = client.profileBase;
         _loc3_.purchaseBase = client.purchaseBase;
         return _loc3_;
      }
      
      public function readSparseArray(param1:Function) : Array
      {
         var _loc4_:uint = 0;
         var _loc2_:uint = readUintvar32();
         var _loc3_:Array = new Array();
         while(_loc2_ > 0)
         {
            _loc4_ = readUintvar32();
            _loc3_[_loc4_] = param1();
            _loc2_--;
         }
         return _loc3_;
      }
      
      public function readIntvar32() : int
      {
         var _loc1_:uint = readUintvar32();
         if((_loc1_ & 1) != 0)
         {
            return ~(_loc1_ >>> 1);
         }
         return _loc1_ >>> 1;
      }
      
      public function readUintvar31() : uint
      {
         var _loc1_:uint = readUintvar32();
         if((_loc1_ & 0x80000000) != 0)
         {
            throw new Error();
         }
         return _loc1_;
      }
      
      public function readUintvar32() : uint
      {
         var _loc2_:* = undefined;
         var _loc1_:uint = 0;
         do
         {
            _loc2_ = readUint8();
            _loc1_ = uint(_loc1_ << 7 | _loc2_ & 0x7F);
         }
         while((_loc2_ & 0x80) != 0);
         return _loc1_;
      }
      
      public function readNetworkUid() : NetworkUid
      {
         var _loc1_:uint = readUintvar31();
         if(_loc1_ == 0)
         {
            return null;
         }
         var _loc2_:String = readString();
         var _loc3_:uint = readUintvar31();
         return new NetworkUid(_loc1_,_loc2_,_loc3_);
      }
      
      public function readBoolean() : Boolean
      {
         var _loc1_:uint = readUint8();
         if(_loc1_ == 0)
         {
            return false;
         }
         if(_loc1_ == 1)
         {
            return true;
         }
         throw new Error();
      }
      
      public function readByteArray() : ByteArray
      {
         var _loc1_:uint = readUintvar32();
         if(body.position + _loc1_ > endPosition)
         {
            throw new EOFError();
         }
         var _loc2_:ByteArray = new ByteArray();
         body.readBytes(_loc2_,0,_loc1_);
         return _loc2_;
      }
   }
}


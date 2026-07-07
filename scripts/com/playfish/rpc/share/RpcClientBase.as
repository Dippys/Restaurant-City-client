package com.playfish.rpc.share
{
   import flash.events.TimerEvent;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class RpcClientBase
   {
      
      public static var debug:Function = trace;
      
      public static var responseInitialTimeoutMillis:uint = 30000;
      
      public static var responseProgressTimeoutMillis:uint = 15000;
      
      public static var resourceLoadTimeoutMillis:uint = 15000;
      
      public static var disableRetryAsGet:Boolean = false;
      
      public static var asyncPollErrorMaxRetryCount:uint = 3;
      
      public static var asyncPollErrorDefaultRetryInterval:uint = 5000;
      
      public static var asyncPollDefaultResponseInitialTimeoutMillis:uint = 30000;
      
      private static const BATCHMODE_NONE:uint = 0;
      
      public static const BATCHMODE_ASYNC:uint = 1;
      
      public static const BATCHMODE_INORDER:uint = 2;
      
      public static const BATCHMODE_CONDITIONAL:uint = 3;
      
      public static const GAME_EVENT_AD_IMPRESSION:uint = 255;
      
      public static const GAME_EVENT_SELL_PAGE:uint = 254;
      
      public static const GAME_EVENT_IS_PLAYING:uint = 250;
      
      public static const PURCHASE_CASH_OK:uint = 0;
      
      public static const PURCHASE_CASH_FAIL_NOT_ENOUGH_CREDIT:uint = 1;
      
      public static const DELIVERY_FAILED_OFF_LINE_SHARD:uint = 7;
      
      public static const GAME_SPECIFIC_EVENT_TYPE_MIN:uint = 1;
      
      public static const GAME_SPECIFIC_EVENT_TYPE_MAX:uint = 127;
      
      public static const WARNING_EVENT:uint = 4294967295;
      
      internal static const ENCAPSULATION_NULL:uint = 0;
      
      internal static const CALL_TYPE_init:uint = 1;
      
      internal static const CALL_TYPE_getPricepoints:uint = 246;
      
      internal static const CALL_TYPE_pollEvents:uint = 247;
      
      internal static const CALL_TYPE_getCashBalance:uint = 248;
      
      internal static const CALL_TYPE_getServerTime:uint = 249;
      
      internal static const CALL_TYPE_getPurchasableItems:uint = 250;
      
      internal static const CALL_TYPE_recordGameEvent:uint = 251;
      
      internal static const CALL_TYPE_getTimeToken0:uint = 253;
      
      internal static const CALL_TYPE_ping:uint = 254;
      
      internal static const CALL_TYPE_batchOperation:uint = 255;
      
      internal static const ERROR_RESPONSE:uint = 0;
      
      internal static const ERROR_REASON_UNKNOWN:uint = 0;
      
      internal static const ERROR_REASON_FORMAT:uint = 1;
      
      private static const NOTE_TIME_MAX_ATTEMPTS:uint = 3;
      
      private static const NOTE_TIME_MAX_RTT:uint = 5000;
      
      private var asyncPollResponseInitialTimeoutMillis:uint;
      
      private var epoch:Number;
      
      private var asyncEventErrorCallback:Function = null;
      
      internal var profileBase:String;
      
      private var asyncPollErrorRetryInterval:uint;
      
      private var eventHandlers:Array;
      
      private var subRequests:Array;
      
      private var mustAckEventIds:Array;
      
      private var _numResourceCopies:uint;
      
      private var asyncPollErrorCount:uint = 0;
      
      private var timeCallback:Function;
      
      private var _timingData:Array;
      
      public var sessionId:String;
      
      private var loaderParameters:Object;
      
      protected var initResponseTime:uint = 0;
      
      private var eventTypeResponseHandlers:Array;
      
      private var asyncEventTimer:Timer;
      
      private var eventInitDone:Boolean = false;
      
      private var defaultNumResourceCopies:uint;
      
      internal var url:String;
      
      internal var purchaseBase:String;
      
      internal var createRequest:Function;
      
      private var batchMode:uint = 0;
      
      internal var createResponse:Function;
      
      public function RpcClientBase(param1:Object, param2:uint, param3:Function, param4:Function)
      {
         var _loc5_:ServerInfo = null;
         eventTypeResponseHandlers = new Array();
         eventHandlers = new Array();
         mustAckEventIds = new Array();
         asyncPollErrorRetryInterval = asyncPollErrorDefaultRetryInterval;
         asyncPollResponseInitialTimeoutMillis = asyncPollDefaultResponseInitialTimeoutMillis;
         _numResourceCopies = defaultNumResourceCopies;
         super();
         this.loaderParameters = param1;
         this.defaultNumResourceCopies = param2;
         this.createRequest = param3;
         this.createResponse = param4;
         if(param1 is ServerInfo)
         {
            _loc5_ = param1 as ServerInfo;
            this.url = _loc5_.url;
            this.sessionId = _loc5_.sessionId;
            this.profileBase = _loc5_.profileBase;
            this.purchaseBase = _loc5_.purchaseBase;
         }
         else
         {
            this.url = param1["pf_url"];
            this.sessionId = param1["pf_session_id"];
            this.profileBase = param1["pf_profile_base"];
            this.purchaseBase = param1["pf_purchase_base"];
         }
         debug("RpcClientBase: url=" + url + " session=" + sessionId + " profileBase=" + profileBase + " purchaseBase=" + purchaseBase);
      }
      
      private static function removeSetValue(param1:Array, param2:uint) : void
      {
         var _loc3_:uint = uint(param1.indexOf(param2));
         if(_loc3_ >= 0)
         {
            param1.splice(_loc3_,1);
         }
      }
      
      private static function getTimeTokenResponseHandler(param1:RpcResponseBase, param2:Function) : Function
      {
         var timeToken:ByteArray = null;
         var response:RpcResponseBase = param1;
         var successCallback:Function = param2;
         timeToken = response.readByteArray();
         return function():void
         {
            successCallback(timeToken);
         };
      }
      
      private static function getPurchasableItemsResponseHandler(param1:RpcResponseBase, param2:Function) : Function
      {
         var purchasableItems:Array = null;
         var response:RpcResponseBase = param1;
         var successCallback:Function = param2;
         purchasableItems = response.readArray(response.readPurchasableItem);
         return function():void
         {
            successCallback(purchasableItems);
         };
      }
      
      private static function getPricepointsResponseHandler(param1:RpcResponseBase, param2:Function) : Function
      {
         var isMaintenance:Boolean = false;
         var pricepoints:Array = null;
         var response:RpcResponseBase = param1;
         var successCallback:Function = param2;
         isMaintenance = response.readBoolean();
         pricepoints = response.readArray(response.readPricepoint);
         return function():void
         {
            successCallback(isMaintenance,pricepoints);
         };
      }
      
      public static function emptyResponseHandler(param1:RpcResponseBase, param2:Function) : Function
      {
         return param2;
      }
      
      private static function getServerTimeResponseHandler(param1:RpcResponseBase, param2:Function) : Function
      {
         var time:Date = null;
         var response:RpcResponseBase = param1;
         var successCallback:Function = param2;
         time = response.readDate();
         return function():void
         {
            successCallback(time);
         };
      }
      
      private static function getCashBalanceResponseHandler(param1:RpcResponseBase, param2:Function) : Function
      {
         var credit:uint = 0;
         var response:RpcResponseBase = param1;
         var successCallback:Function = param2;
         credit = response.readUintvar31();
         return function():void
         {
            successCallback(credit);
         };
      }
      
      private static function addSetValue(param1:Array, param2:uint) : void
      {
         if(param1.indexOf(param2) < 0)
         {
            param1.push(param2);
         }
      }
      
      private function warningEvent(param1:String) : Function
      {
         var msg:String = param1;
         var warningHandler:Function = eventHandlers[WARNING_EVENT];
         if(warningHandler != null)
         {
            return function():void
            {
               warningHandler(msg);
            };
         }
         return function():void
         {
            debug("event warning: " + msg);
         };
      }
      
      public function getCashBalance(param1:Function, param2:Function) : void
      {
         var _loc3_:RpcRequestBase = newRpcRequest(CALL_TYPE_getCashBalance,getCashBalanceResponseHandler,param1,param2);
         _loc3_.perform();
      }
      
      private function readEventBody(param1:RpcResponseBase, param2:uint) : Function
      {
         var eventHandler:Function;
         var result:Function = null;
         var subResponse:RpcResponseBase = param1;
         var eventType:uint = param2;
         var eventResponseHandler:Function = eventTypeResponseHandlers[eventType];
         if(eventResponseHandler == null)
         {
            return warningEvent("unknown event type " + eventType);
         }
         eventHandler = eventHandlers[eventType];
         if(eventHandler == null)
         {
            return warningEvent("no handler set for event type " + eventType);
         }
         try
         {
            result = eventResponseHandler(subResponse,eventHandler);
         }
         catch(e:Error)
         {
            return warningEvent("malformed event of type " + eventType + " received: " + e);
         }
         if(!subResponse.isDone())
         {
            return warningEvent("malformed event of type " + eventType + " received: spurious data in event body");
         }
         return result;
      }
      
      public function isEventDeliveryRunning() : Boolean
      {
         return asyncEventTimer != null;
      }
      
      public function init(param1:Function, param2:Function) : void
      {
         var _loc4_:String = null;
         var _loc5_:RpcRequestBase = null;
         var _loc3_:URLVariables = new URLVariables();
         for(_loc4_ in loaderParameters)
         {
            if(_loc4_.match(/^fb_sig(_.*)?$/))
            {
               _loc3_[_loc4_] = loaderParameters[_loc4_];
            }
         }
         _loc5_ = newRpcRequest(CALL_TYPE_init,initResponseHandler,param1,param2);
         _loc5_.writeString(Capabilities.serverString);
         _loc5_.writeString(String(_loc3_));
         _loc5_.perform();
      }
      
      public function registerEventType(param1:uint, param2:Function) : void
      {
         if(param1 < GAME_SPECIFIC_EVENT_TYPE_MIN || param1 > GAME_SPECIFIC_EVENT_TYPE_MAX)
         {
            throw new Error("invalid event type " + param1);
         }
         if(eventInitDone)
         {
            throw new Error("can\'t register events now");
         }
         eventTypeResponseHandlers[param1] = param2;
      }
      
      private function handleEventDelivery(param1:Array, param2:Array) : void
      {
         var id:uint = 0;
         var event:AsyncEvent = null;
         var events:Array = param1;
         var ackEvents:Array = param2;
         for each(id in ackEvents)
         {
            removeSetValue(mustAckEventIds,id);
         }
         for each(event in events)
         {
            addSetValue(mustAckEventIds,event.id);
         }
         for each(event in events)
         {
            try
            {
               event.deliveryCallback();
            }
            catch(e:Error)
            {
               debug("caught exception delivering event: id=" + event.id + " type=" + event.type + ": " + e);
            }
         }
      }
      
      protected function get timingData() : Array
      {
         return _timingData;
      }
      
      private function pollEventsInternal(param1:Boolean, param2:Function, param3:Function) : void
      {
         var ackEventsCopy:Array = null;
         var synchronous:Boolean = param1;
         var successCallback:Function = param2;
         var errorCallback:Function = param3;
         var partOfBatch:Boolean = synchronous && batchMode != BATCHMODE_NONE;
         ackEventsCopy = mustAckEventIds.concat();
         var request:RpcRequestBase = createRequest();
         request.init(this,partOfBatch,0,CALL_TYPE_pollEvents,pollEventsResponseHandler,function(param1:uint, param2:uint, param3:Array):void
         {
            successCallback(param1,param2,param3,ackEventsCopy);
         },errorCallback);
         request.triedGet = true;
         if(!synchronous)
         {
            request.responseInitialTimeoutMillis = asyncPollResponseInitialTimeoutMillis;
         }
         request.writeBoolean(synchronous);
         request.writeUintvar31(request.responseInitialTimeoutMillis);
         request.writeArray(ackEventsCopy,request.writeUintvar31);
         if(partOfBatch)
         {
            subRequests.push(request);
         }
         request.perform();
      }
      
      public function getPurchasableItems(param1:Function, param2:Function) : void
      {
         var _loc3_:RpcRequestBase = newRpcRequest(CALL_TYPE_getPurchasableItems,getPurchasableItemsResponseHandler,param1,param2);
         _loc3_.perform();
      }
      
      private function initResponseHandler(param1:RpcResponseBase, param2:Function) : Function
      {
         var _loc3_:String = param1.readString();
         if(_loc3_ != "")
         {
            sessionId = _loc3_;
         }
         initResponseTime = getTimer();
         return param2;
      }
      
      private function asyncPollErrorHandler() : void
      {
         if(asyncEventTimer == null)
         {
            return;
         }
         asyncEventTimer.reset();
         ++asyncPollErrorCount;
         if(asyncPollErrorCount > asyncPollErrorMaxRetryCount)
         {
            asyncEventTimer = null;
            asyncEventErrorCallback();
            asyncEventErrorCallback = null;
            return;
         }
         asyncEventTimer.delay = asyncPollErrorRetryInterval;
         asyncEventTimer.start();
      }
      
      public function endBatch() : void
      {
         var batch:RpcRequestBase;
         var subRequests:Array = null;
         var subRequest:RpcRequestBase = null;
         var batchResponseHandler:Function = null;
         var batchErrorCallback:Function = null;
         batchResponseHandler = function(param1:RpcResponseBase, param2:Function):Function
         {
            var i:uint;
            var responseCount:uint;
            var subCallbacks:Array = null;
            var subRequest:RpcRequestBase = null;
            var subResponseMsgType:uint = 0;
            var subResponseLength:uint = 0;
            var subResponse:RpcResponseBase = null;
            var subSuccessCallback:Function = null;
            var response:RpcResponseBase = param1;
            var successCallback:Function = param2;
            debug("batch response: subRequests.length=" + subRequests.length);
            responseCount = response.readUintvar32();
            if(responseCount != subRequests.length)
            {
               debug("batch response: response count " + responseCount + " mismatch with request count " + subRequests.length);
               throw new Error();
            }
            subCallbacks = new Array(responseCount);
            i = 0;
            while(i < responseCount)
            {
               subCallbacks[i] = subRequests[i].errorCallback;
               i++;
            }
            i = 0;
            while(i < responseCount)
            {
               subRequest = subRequests[i];
               subResponseMsgType = response.readUint8();
               subResponseLength = response.readUintvar32();
               debug("batch response: sub response: msgType=" + subResponseMsgType + " length=" + subResponseLength);
               if(subResponseMsgType == ERROR_RESPONSE)
               {
                  debug("batch response: got error response to sub-operation " + i);
                  if(subResponseLength != 0)
                  {
                     debug("batch response: error response has length " + subResponseLength + " != 0");
                     throw new Error();
                  }
               }
               else
               {
                  if(subResponseMsgType != subRequest.msgType && subResponseMsgType != ERROR_RESPONSE)
                  {
                     debug("batch response: sub response message type " + subResponseMsgType + " mismatch with sub request type " + subRequest.msgType);
                     throw new Error();
                  }
                  subResponse = createResponse();
                  subResponse.initAsSubResponse(response,subResponseLength,subRequest.numResourceCopies);
                  subSuccessCallback = subRequest.responseHandler(subResponse,subRequest.successCallback);
                  if(!subResponse.isDone())
                  {
                     debug("batch response: sub response handler returned, but isDone() is false");
                     throw new Error();
                  }
                  subCallbacks[i] = subSuccessCallback;
               }
               i++;
            }
            return function():void
            {
               var callback:* = undefined;
               for each(callback in subCallbacks)
               {
                  try
                  {
                     callback();
                  }
                  catch(e:Error)
                  {
                     debug("batch response: sub response handler threw error: " + e);
                  }
               }
            };
         };
         batchErrorCallback = function():void
         {
            var subRequest:RpcRequestBase = null;
            for each(subRequest in subRequests)
            {
               try
               {
                  subRequest.errorCallback();
               }
               catch(e:Error)
               {
               }
            }
         };
         var batchMode:uint = this.batchMode;
         subRequests = this.subRequests;
         this.batchMode = BATCHMODE_NONE;
         this.subRequests = null;
         if(subRequests.length == 0)
         {
            debug("endBatch: batch is empty!");
            return;
         }
         batch = createRequest();
         batch.init(this,false,0,CALL_TYPE_batchOperation,batchResponseHandler,null,batchErrorCallback);
         batch.writeUint8(batchMode);
         batch.writeUintvar32(subRequests.length);
         for each(subRequest in subRequests)
         {
            batch.writeSubRequest(subRequest);
         }
         batch.perform();
      }
      
      public function getServerTime(param1:Function, param2:Function) : void
      {
         var _loc3_:RpcRequestBase = newRpcRequest(CALL_TYPE_getServerTime,getServerTimeResponseHandler,param1,param2);
         _loc3_.perform();
      }
      
      public function get numResourceCopies() : uint
      {
         return _numResourceCopies;
      }
      
      protected function newRpcRequest(param1:uint, param2:Function, param3:Function, param4:Function) : RpcRequestBase
      {
         var _loc5_:Boolean = batchMode != BATCHMODE_NONE;
         var _loc6_:RpcRequestBase = createRequest();
         _loc6_.init(this,_loc5_,_numResourceCopies,param1,param2,param3,param4);
         if(_loc5_)
         {
            subRequests.push(_loc6_);
         }
         _numResourceCopies = defaultNumResourceCopies;
         return _loc6_;
      }
      
      private function asyncPollSuccessHandler(param1:uint, param2:uint, param3:Array, param4:Array) : void
      {
         if(asyncEventTimer == null)
         {
            return;
         }
         asyncEventTimer.reset();
         asyncPollErrorCount = 0;
         asyncPollResponseInitialTimeoutMillis = param2;
         handleEventDelivery(param3,param4);
         if(param1 == 0)
         {
            pollEventsInternal(false,asyncPollSuccessHandler,asyncPollErrorHandler);
         }
         else
         {
            asyncEventTimer.delay = param1;
            asyncEventTimer.start();
         }
      }
      
      public function getPricepoints(param1:String, param2:Function, param3:Function) : void
      {
         var _loc4_:RpcRequestBase = newRpcRequest(CALL_TYPE_getPricepoints,getPricepointsResponseHandler,param2,param3);
         _loc4_.writeString(param1 == null ? "" : param1);
         _loc4_.perform();
      }
      
      public function resetTimes(param1:Function) : void
      {
         this.timeCallback = param1;
         this.epoch = param1();
         this._timingData = new Array();
      }
      
      public function pollEvents(param1:Function, param2:Function) : void
      {
         var successCallback:Function = param1;
         var errorCallback:Function = param2;
         eventInitDone = true;
         pollEventsInternal(true,function(param1:uint, param2:uint, param3:Array, param4:Array):void
         {
            handleEventDelivery(param3,param4);
            successCallback();
         },errorCallback);
      }
      
      public function beginBatch(param1:uint = 1) : void
      {
         if(param1 < BATCHMODE_ASYNC || param1 > BATCHMODE_CONDITIONAL || this.batchMode != BATCHMODE_NONE)
         {
            throw new Error();
         }
         this.batchMode = param1;
         this.subRequests = new Array();
      }
      
      public function getEventHandler(param1:uint) : Function
      {
         if(eventTypeResponseHandlers[param1] == null && param1 != WARNING_EVENT)
         {
            throw new Error("invalid event type " + param1);
         }
         return eventHandlers[param1];
      }
      
      public function setEventHandler(param1:uint, param2:Function) : Function
      {
         if(eventTypeResponseHandlers[param1] == null && param1 != WARNING_EVENT)
         {
            throw new Error("invalid event type " + param1);
         }
         var _loc3_:Function = eventHandlers[param1];
         eventHandlers[param1] = param2;
         return _loc3_;
      }
      
      public function stopEventDelivery() : Boolean
      {
         eventInitDone = true;
         if(asyncEventTimer != null)
         {
            asyncEventTimer.reset();
            asyncEventTimer = null;
            asyncEventErrorCallback = null;
            asyncPollErrorCount = 0;
            return true;
         }
         return false;
      }
      
      public function set numResourceCopies(param1:uint) : void
      {
         _numResourceCopies = param1;
      }
      
      public function noteTime() : void
      {
         var attemptsRemaining:uint = 0;
         var sendTime:uint = 0;
         var client:RpcClientBase = null;
         var noteTimeSuccess:Function = null;
         var noteTimeError:Function = null;
         var noteTimeSendRequest:Function = function():void
         {
            if(attemptsRemaining == 0)
            {
               debug("noteTime: no attempts remaining");
               return;
            }
            --attemptsRemaining;
            sendTime = timeCallback() - epoch;
            debug("noteTime: about to send; attempt " + (NOTE_TIME_MAX_ATTEMPTS - attemptsRemaining) + "/" + NOTE_TIME_MAX_ATTEMPTS + "; sendTime=" + sendTime + " (abs=" + (sendTime + epoch) + ")");
            var _loc1_:RpcRequestBase = createRequest();
            _loc1_.init(client,false,0,CALL_TYPE_getTimeToken0,getTimeTokenResponseHandler,noteTimeSuccess,noteTimeError);
            _loc1_.writeUintvar32(sendTime);
            _loc1_.perform();
         };
         noteTimeSuccess = function(param1:ByteArray):void
         {
            var _loc2_:uint = timeCallback() - epoch - sendTime;
            debug("noteTime: success callback; attempt " + (NOTE_TIME_MAX_ATTEMPTS - attemptsRemaining) + "/" + NOTE_TIME_MAX_ATTEMPTS + "; rtt=" + _loc2_ + " (abs=" + (_loc2_ + sendTime + epoch) + ") token.length=" + param1.length);
            _timingData.push(new TimingData(param1,Math.min(_loc2_,2147483647)));
            if(_loc2_ > NOTE_TIME_MAX_RTT)
            {
               debug("noteTime: excessive RTT; attempt " + (NOTE_TIME_MAX_ATTEMPTS - attemptsRemaining) + "/" + NOTE_TIME_MAX_ATTEMPTS);
               noteTimeSendRequest();
            }
         };
         noteTimeError = function():void
         {
            debug("noteTime: error callback; attempt " + (NOTE_TIME_MAX_ATTEMPTS - attemptsRemaining) + "/" + NOTE_TIME_MAX_ATTEMPTS);
            noteTimeSendRequest();
         };
         attemptsRemaining = NOTE_TIME_MAX_ATTEMPTS;
         client = this;
         noteTimeSendRequest();
      }
      
      private function pollEventsResponseHandler(param1:RpcResponseBase, param2:Function) : Function
      {
         var minPollInterval:uint = 0;
         var newClientRequestTimeout:uint = 0;
         var events:Array = null;
         var readEvent:Function = null;
         var response:RpcResponseBase = param1;
         var successCallback:Function = param2;
         readEvent = function():AsyncEvent
         {
            var _loc1_:AsyncEvent = new AsyncEvent();
            _loc1_.id = response.readUintvar31();
            _loc1_.type = response.readUint8();
            var _loc2_:uint = response.readUintvar31();
            var _loc3_:RpcResponseBase = createResponse();
            _loc3_.initAsSubResponse(response,_loc2_,0);
            _loc1_.deliveryCallback = readEventBody(_loc3_,_loc1_.type);
            _loc3_.skipToEnd();
            return _loc1_;
         };
         minPollInterval = response.readUintvar31();
         newClientRequestTimeout = response.readUintvar31();
         events = response.readArray(readEvent);
         return function():void
         {
            successCallback(minPollInterval,newClientRequestTimeout,events);
         };
      }
      
      public function recordGameEvent(param1:uint, param2:String, param3:Function, param4:Function) : void
      {
         if(param2 == null)
         {
            param2 = "";
         }
         var _loc5_:RpcRequestBase = newRpcRequest(CALL_TYPE_recordGameEvent,emptyResponseHandler,param3,param4);
         _loc5_.writeUint8(param1);
         _loc5_.writeUintvar32(getTimer() - initResponseTime);
         _loc5_.writeString(param2);
         _loc5_.perform();
      }
      
      public function startEventDelivery(param1:Function) : Boolean
      {
         var errorCallback:Function = param1;
         eventInitDone = true;
         if(asyncEventTimer == null)
         {
            asyncEventTimer = new Timer(asyncPollErrorRetryInterval,1);
            asyncEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function(param1:TimerEvent):void
            {
               debug("async event timer fired: " + param1);
               pollEventsInternal(false,asyncPollSuccessHandler,asyncPollErrorHandler);
            });
            asyncEventErrorCallback = errorCallback;
            asyncPollErrorCount = 0;
            pollEventsInternal(false,asyncPollSuccessHandler,asyncPollErrorHandler);
            return true;
         }
         return false;
      }
   }
}


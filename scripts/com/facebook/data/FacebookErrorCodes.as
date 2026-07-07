package com.facebook.data
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class FacebookErrorCodes implements IEventDispatcher
   {
      
      public static const SERVER_ERROR:Number = -1;
      
      public static const API_EC_SUCCESS:Number = 0;
      
      public static const API_EC_UNKNOWN:Number = 1;
      
      public static const API_EC_SERVICE:Number = 2;
      
      public static const API_EC_METHOD:Number = 3;
      
      public static const API_EC_TOO_MANY_CALLS:Number = 4;
      
      public static const API_EC_BAD_IP:Number = 5;
      
      public static const API_EC_HOST_API:Number = 6;
      
      public static const API_EC_HOST_UP:Number = 7;
      
      public static const API_EC_SECURE:Number = 8;
      
      public static const API_EC_RATE:Number = 9;
      
      public static const API_EC_PERMISSION_DENIED:Number = 10;
      
      public static const API_EC_DEPRECATED:Number = 11;
      
      public static const API_EC_VERSION:Number = 12;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function FacebookErrorCodes()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}


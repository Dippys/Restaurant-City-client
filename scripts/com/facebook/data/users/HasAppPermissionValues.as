package com.facebook.data.users
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class HasAppPermissionValues implements IEventDispatcher
   {
      
      public static const EMAIL:String = "email";
      
      public static const OFFLINE_ACCESS:String = "offline_access";
      
      public static const STATUS_UPDATE:String = "status_update";
      
      public static const PHOTO_UPLOAD:String = "photo_upload";
      
      public static const CREATE_LISTING:String = "create_listing";
      
      public static const CREATE_EVENT:String = "create_event";
      
      public static const RSVP_EVENT:String = "rsvp_event";
      
      public static const SMS:String = "sms";
      
      public static const SHARE_ITEM:String = "share_item";
      
      public static const PUBLISH_STREAM:String = "publish_stream";
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function HasAppPermissionValues()
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


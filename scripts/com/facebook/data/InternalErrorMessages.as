package com.facebook.data
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class InternalErrorMessages implements IEventDispatcher
   {
      
      private static var _945560686USER_PREFERENCE_ID_RANGE_ERROR:String = "pref_id must be less then 200.";
      
      private static var _170259480USER_PREFERENCE_VALUE_RANGE_ERROR:String = "";
      
      private static var _225423023DATA_INVALID_NAME_ERROR:String = "";
      
      private static var _1285196109BATCH_RUN_RANGE_ERROR:String = "";
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function InternalErrorMessages()
      {
         super();
      }
      
      public static function set USER_PREFERENCE_ID_RANGE_ERROR(param1:String) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = InternalErrorMessages._945560686USER_PREFERENCE_ID_RANGE_ERROR;
         if(_loc2_ !== param1)
         {
            InternalErrorMessages._945560686USER_PREFERENCE_ID_RANGE_ERROR = param1;
            _loc3_ = InternalErrorMessages.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(InternalErrorMessages,"USER_PREFERENCE_ID_RANGE_ERROR",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public static function get USER_PREFERENCE_VALUE_RANGE_ERROR() : String
      {
         return InternalErrorMessages._170259480USER_PREFERENCE_VALUE_RANGE_ERROR;
      }
      
      public static function set DATA_INVALID_NAME_ERROR(param1:String) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = InternalErrorMessages._225423023DATA_INVALID_NAME_ERROR;
         if(_loc2_ !== param1)
         {
            InternalErrorMessages._225423023DATA_INVALID_NAME_ERROR = param1;
            _loc3_ = InternalErrorMessages.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(InternalErrorMessages,"DATA_INVALID_NAME_ERROR",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public static function get BATCH_RUN_RANGE_ERROR() : String
      {
         return InternalErrorMessages._1285196109BATCH_RUN_RANGE_ERROR;
      }
      
      public static function set USER_PREFERENCE_VALUE_RANGE_ERROR(param1:String) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = InternalErrorMessages._170259480USER_PREFERENCE_VALUE_RANGE_ERROR;
         if(_loc2_ !== param1)
         {
            InternalErrorMessages._170259480USER_PREFERENCE_VALUE_RANGE_ERROR = param1;
            _loc3_ = InternalErrorMessages.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(InternalErrorMessages,"USER_PREFERENCE_VALUE_RANGE_ERROR",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public static function get DATA_INVALID_NAME_ERROR() : String
      {
         return InternalErrorMessages._225423023DATA_INVALID_NAME_ERROR;
      }
      
      [Bindable(event="propertyChange")]
      public static function get USER_PREFERENCE_ID_RANGE_ERROR() : String
      {
         return InternalErrorMessages._945560686USER_PREFERENCE_ID_RANGE_ERROR;
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      public static function set BATCH_RUN_RANGE_ERROR(param1:String) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = InternalErrorMessages._1285196109BATCH_RUN_RANGE_ERROR;
         if(_loc2_ !== param1)
         {
            InternalErrorMessages._1285196109BATCH_RUN_RANGE_ERROR = param1;
            _loc3_ = InternalErrorMessages.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(InternalErrorMessages,"BATCH_RUN_RANGE_ERROR",_loc2_,param1));
            }
         }
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


package com.facebook.data.notifications
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class NotificationPokeData implements IEventDispatcher
   {
      
      private var _1739890327most_recent:Number;
      
      private var _840272977unread:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function NotificationPokeData()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set most_recent(param1:Number) : void
      {
         var _loc2_:Object = this._1739890327most_recent;
         if(_loc2_ !== param1)
         {
            this._1739890327most_recent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"most_recent",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get unread() : Number
      {
         return this._840272977unread;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get most_recent() : Number
      {
         return this._1739890327most_recent;
      }
      
      public function set unread(param1:Number) : void
      {
         var _loc2_:Object = this._840272977unread;
         if(_loc2_ !== param1)
         {
            this._840272977unread = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unread",_loc2_,param1));
         }
      }
   }
}


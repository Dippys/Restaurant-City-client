package com.facebook.data
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class FacebookNetwork implements IEventDispatcher
   {
      
      private var _892481550status:String;
      
      private var _3575610type:String;
      
      private var _3373707name:String;
      
      private var _3704893year:String;
      
      private var _109065nid:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function FacebookNetwork()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get nid() : int
      {
         return this._109065nid;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set nid(param1:int) : void
      {
         var _loc2_:Object = this._109065nid;
         if(_loc2_ !== param1)
         {
            this._109065nid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nid",_loc2_,param1));
         }
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      public function set status(param1:String) : void
      {
         var _loc2_:Object = this._892481550status;
         if(_loc2_ !== param1)
         {
            this._892481550status = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get status() : String
      {
         return this._892481550status;
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
         }
      }
      
      public function set year(param1:String) : void
      {
         var _loc2_:Object = this._3704893year;
         if(_loc2_ !== param1)
         {
            this._3704893year = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"year",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get year() : String
      {
         return this._3704893year;
      }
   }
}


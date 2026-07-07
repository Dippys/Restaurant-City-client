package com.facebook.data
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class FacebookWorkInfo implements IEventDispatcher
   {
      
      private var _1901043637location:FacebookLocation;
      
      private var _1725067410end_date:Date;
      
      private var _1724546052description:String;
      
      private var _1573629589start_date:Date;
      
      private var _747804969position:String;
      
      private var _1429880077company_name:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function FacebookWorkInfo()
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
      
      [Bindable(event="propertyChange")]
      public function get company_name() : String
      {
         return this._1429880077company_name;
      }
      
      public function set end_date(param1:Date) : void
      {
         var _loc2_:Object = this._1725067410end_date;
         if(_loc2_ !== param1)
         {
            this._1725067410end_date = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"end_date",_loc2_,param1));
         }
      }
      
      public function set position(param1:String) : void
      {
         var _loc2_:Object = this._747804969position;
         if(_loc2_ !== param1)
         {
            this._747804969position = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"position",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set start_date(param1:Date) : void
      {
         var _loc2_:Object = this._1573629589start_date;
         if(_loc2_ !== param1)
         {
            this._1573629589start_date = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"start_date",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get end_date() : Date
      {
         return this._1725067410end_date;
      }
      
      public function set company_name(param1:String) : void
      {
         var _loc2_:Object = this._1429880077company_name;
         if(_loc2_ !== param1)
         {
            this._1429880077company_name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"company_name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get position() : String
      {
         return this._747804969position;
      }
      
      public function set location(param1:FacebookLocation) : void
      {
         var _loc2_:Object = this._1901043637location;
         if(_loc2_ !== param1)
         {
            this._1901043637location = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"location",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get start_date() : Date
      {
         return this._1573629589start_date;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get location() : FacebookLocation
      {
         return this._1901043637location;
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
   }
}


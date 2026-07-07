package com.facebook.data
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class FacebookEducationInfo implements IEventDispatcher
   {
      
      private var _3373707name:String;
      
      private var _1335595316degree:String;
      
      private var _3704893year:String;
      
      private var _157624742concentrations:Array;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function FacebookEducationInfo()
      {
         super();
         this.concentrations = [];
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
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
      
      public function set concentrations(param1:Array) : void
      {
         var _loc2_:Object = this._157624742concentrations;
         if(_loc2_ !== param1)
         {
            this._157624742concentrations = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"concentrations",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get degree() : String
      {
         return this._1335595316degree;
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
      
      public function set degree(param1:String) : void
      {
         var _loc2_:Object = this._1335595316degree;
         if(_loc2_ !== param1)
         {
            this._1335595316degree = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"degree",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get concentrations() : Array
      {
         return this._157624742concentrations;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
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


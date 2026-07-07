package com.facebook.data.users
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class UserData implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _160985414first_name:String;
      
      private var _3373707name:String;
      
      private var _2013122196last_name:String;
      
      private var _2076227591timezone:Number;
      
      private var _115792uid:String;
      
      private var _1700293062affiations:AffiliationCollection;
      
      public function UserData()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set timezone(param1:Number) : void
      {
         var _loc2_:Object = this._2076227591timezone;
         if(_loc2_ !== param1)
         {
            this._2076227591timezone = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timezone",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get affiations() : AffiliationCollection
      {
         return this._1700293062affiations;
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
      
      public function set affiations(param1:AffiliationCollection) : void
      {
         var _loc2_:Object = this._1700293062affiations;
         if(_loc2_ !== param1)
         {
            this._1700293062affiations = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"affiations",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get uid() : String
      {
         return this._115792uid;
      }
      
      [Bindable(event="propertyChange")]
      public function get last_name() : String
      {
         return this._2013122196last_name;
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
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set uid(param1:String) : void
      {
         var _loc2_:Object = this._115792uid;
         if(_loc2_ !== param1)
         {
            this._115792uid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"uid",_loc2_,param1));
         }
      }
      
      public function set last_name(param1:String) : void
      {
         var _loc2_:Object = this._2013122196last_name;
         if(_loc2_ !== param1)
         {
            this._2013122196last_name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"last_name",_loc2_,param1));
         }
      }
      
      public function set first_name(param1:String) : void
      {
         var _loc2_:Object = this._160985414first_name;
         if(_loc2_ !== param1)
         {
            this._160985414first_name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"first_name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get timezone() : Number
      {
         return this._2076227591timezone;
      }
      
      [Bindable(event="propertyChange")]
      public function get first_name() : String
      {
         return this._160985414first_name;
      }
      
      public function toString() : String
      {
         return "[ UserData uid: " + this.uid + " affiation:" + this.affiations + " first_name:" + this.first_name + " last_name:" + this.last_name + " name:" + this.name + " timezone: " + this.timezone + "]";
      }
   }
}


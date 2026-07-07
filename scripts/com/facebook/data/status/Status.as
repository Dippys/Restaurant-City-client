package com.facebook.data.status
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class Status implements IEventDispatcher
   {
      
      private var _954925063message:String;
      
      private var _115792uid:String;
      
      private var _2070199160status_id:String;
      
      private var _3560141time:Date;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _896505829source:String;
      
      public function Status()
      {
         super();
      }
      
      public function set source(param1:String) : void
      {
         var _loc2_:Object = this._896505829source;
         if(_loc2_ !== param1)
         {
            this._896505829source = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"source",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get message() : String
      {
         return this._954925063message;
      }
      
      [Bindable(event="propertyChange")]
      public function get status_id() : String
      {
         return this._2070199160status_id;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get time() : Date
      {
         return this._3560141time;
      }
      
      public function set message(param1:String) : void
      {
         var _loc2_:Object = this._954925063message;
         if(_loc2_ !== param1)
         {
            this._954925063message = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get uid() : String
      {
         return this._115792uid;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set status_id(param1:String) : void
      {
         var _loc2_:Object = this._2070199160status_id;
         if(_loc2_ !== param1)
         {
            this._2070199160status_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status_id",_loc2_,param1));
         }
      }
      
      public function set time(param1:Date) : void
      {
         var _loc2_:Object = this._3560141time;
         if(_loc2_ !== param1)
         {
            this._3560141time = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"time",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get source() : String
      {
         return this._896505829source;
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
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}


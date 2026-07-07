package com.facebook.data.stream
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class LikesData implements IEventDispatcher
   {
      
      private var _600094315friends:Array;
      
      private var _3211051href:String;
      
      private var _126661978can_like:Boolean;
      
      private var _909675094sample:Array;
      
      private var _94851343count:uint;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1928023624user_likes:Boolean;
      
      public function LikesData()
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
      
      public function set can_like(param1:Boolean) : void
      {
         var _loc2_:Object = this._126661978can_like;
         if(_loc2_ !== param1)
         {
            this._126661978can_like = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"can_like",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get count() : uint
      {
         return this._94851343count;
      }
      
      public function set user_likes(param1:Boolean) : void
      {
         var _loc2_:Object = this._1928023624user_likes;
         if(_loc2_ !== param1)
         {
            this._1928023624user_likes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"user_likes",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set sample(param1:Array) : void
      {
         var _loc2_:Object = this._909675094sample;
         if(_loc2_ !== param1)
         {
            this._909675094sample = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sample",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get friends() : Array
      {
         return this._600094315friends;
      }
      
      public function set href(param1:String) : void
      {
         var _loc2_:Object = this._3211051href;
         if(_loc2_ !== param1)
         {
            this._3211051href = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"href",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get user_likes() : Boolean
      {
         return this._1928023624user_likes;
      }
      
      public function set count(param1:uint) : void
      {
         var _loc2_:Object = this._94851343count;
         if(_loc2_ !== param1)
         {
            this._94851343count = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"count",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get can_like() : Boolean
      {
         return this._126661978can_like;
      }
      
      [Bindable(event="propertyChange")]
      public function get sample() : Array
      {
         return this._909675094sample;
      }
      
      public function set friends(param1:Array) : void
      {
         var _loc2_:Object = this._600094315friends;
         if(_loc2_ !== param1)
         {
            this._600094315friends = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friends",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get href() : String
      {
         return this._3211051href;
      }
   }
}


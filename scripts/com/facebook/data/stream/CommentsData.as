package com.facebook.data.stream
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class CommentsData implements IEventDispatcher
   {
      
      private var _126536785can_post:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1294922797can_remove:Boolean;
      
      private var _94851343count:uint;
      
      private var _106855379posts:Array;
      
      public function CommentsData()
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
      
      [Bindable(event="propertyChange")]
      public function get count() : uint
      {
         return this._94851343count;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get posts() : Array
      {
         return this._106855379posts;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get can_remove() : Boolean
      {
         return this._1294922797can_remove;
      }
      
      public function set can_post(param1:Boolean) : void
      {
         var _loc2_:Object = this._126536785can_post;
         if(_loc2_ !== param1)
         {
            this._126536785can_post = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"can_post",_loc2_,param1));
         }
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
      
      public function set can_remove(param1:Boolean) : void
      {
         var _loc2_:Object = this._1294922797can_remove;
         if(_loc2_ !== param1)
         {
            this._1294922797can_remove = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"can_remove",_loc2_,param1));
         }
      }
      
      public function set posts(param1:Array) : void
      {
         var _loc2_:Object = this._106855379posts;
         if(_loc2_ !== param1)
         {
            this._106855379posts = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"posts",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get can_post() : Boolean
      {
         return this._126536785can_post;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}


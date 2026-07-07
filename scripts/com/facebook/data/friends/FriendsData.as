package com.facebook.data.friends
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class FriendsData implements IEventDispatcher
   {
      
      private var _3589601uid1:Number;
      
      private var _455530154are_friends:Boolean;
      
      private var _3589602uid2:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function FriendsData()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get uid1() : Number
      {
         return this._3589601uid1;
      }
      
      public function set uid1(param1:Number) : void
      {
         var _loc2_:Object = this._3589601uid1;
         if(_loc2_ !== param1)
         {
            this._3589601uid1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"uid1",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set uid2(param1:Number) : void
      {
         var _loc2_:Object = this._3589602uid2;
         if(_loc2_ !== param1)
         {
            this._3589602uid2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"uid2",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get uid2() : Number
      {
         return this._3589602uid2;
      }
      
      [Bindable(event="propertyChange")]
      public function get are_friends() : Boolean
      {
         return this._455530154are_friends;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set are_friends(param1:Boolean) : void
      {
         var _loc2_:Object = this._455530154are_friends;
         if(_loc2_ !== param1)
         {
            this._455530154are_friends = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"are_friends",_loc2_,param1));
         }
      }
   }
}


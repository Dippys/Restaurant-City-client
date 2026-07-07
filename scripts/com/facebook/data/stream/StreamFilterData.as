package com.facebook.data.stream
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class StreamFilterData implements IEventDispatcher
   {
      
      private var _737588055icon_url:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3373707name:String;
      
      private var _1967053405is_visible:Boolean;
      
      private var _3575610type:String;
      
      private var _115792uid:String;
      
      private var _1552737000filter_key:String;
      
      private var _3492908rank:uint;
      
      private var _111972721value:String;
      
      public function StreamFilterData()
      {
         super();
      }
      
      public function set is_visible(param1:Boolean) : void
      {
         var _loc2_:Object = this._1967053405is_visible;
         if(_loc2_ !== param1)
         {
            this._1967053405is_visible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"is_visible",_loc2_,param1));
         }
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
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
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
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set icon_url(param1:String) : void
      {
         var _loc2_:Object = this._737588055icon_url;
         if(_loc2_ !== param1)
         {
            this._737588055icon_url = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon_url",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      public function get filter_key() : String
      {
         return this._1552737000filter_key;
      }
      
      public function set rank(param1:uint) : void
      {
         var _loc2_:Object = this._3492908rank;
         if(_loc2_ !== param1)
         {
            this._3492908rank = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rank",_loc2_,param1));
         }
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
      
      public function set value(param1:String) : void
      {
         var _loc2_:Object = this._111972721value;
         if(_loc2_ !== param1)
         {
            this._111972721value = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"value",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get is_visible() : Boolean
      {
         return this._1967053405is_visible;
      }
      
      [Bindable(event="propertyChange")]
      public function get icon_url() : String
      {
         return this._737588055icon_url;
      }
      
      public function set filter_key(param1:String) : void
      {
         var _loc2_:Object = this._1552737000filter_key;
         if(_loc2_ !== param1)
         {
            this._1552737000filter_key = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filter_key",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : String
      {
         return this._111972721value;
      }
      
      [Bindable(event="propertyChange")]
      public function get uid() : String
      {
         return this._115792uid;
      }
      
      [Bindable(event="propertyChange")]
      public function get rank() : uint
      {
         return this._3492908rank;
      }
   }
}


package com.facebook.data.stream
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class PhotoMedia implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _110987pid:String;
      
      private var _100346066index:uint;
      
      private var _96572aid:String;
      
      private var _106164915owner:String;
      
      public function PhotoMedia()
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
      public function get pid() : String
      {
         return this._110987pid;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get index() : uint
      {
         return this._100346066index;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set pid(param1:String) : void
      {
         var _loc2_:Object = this._110987pid;
         if(_loc2_ !== param1)
         {
            this._110987pid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pid",_loc2_,param1));
         }
      }
      
      public function set owner(param1:String) : void
      {
         var _loc2_:Object = this._106164915owner;
         if(_loc2_ !== param1)
         {
            this._106164915owner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"owner",_loc2_,param1));
         }
      }
      
      public function set index(param1:uint) : void
      {
         var _loc2_:Object = this._100346066index;
         if(_loc2_ !== param1)
         {
            this._100346066index = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"index",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get owner() : String
      {
         return this._106164915owner;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set aid(param1:String) : void
      {
         var _loc2_:Object = this._96572aid;
         if(_loc2_ !== param1)
         {
            this._96572aid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"aid",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get aid() : String
      {
         return this._96572aid;
      }
   }
}


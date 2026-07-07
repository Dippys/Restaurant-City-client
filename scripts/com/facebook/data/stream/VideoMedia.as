package com.facebook.data.stream
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class VideoMedia implements IEventDispatcher
   {
      
      private var _1714674802display_url:String;
      
      private var _1111107765source_url:String;
      
      private var _106164915owner:String;
      
      private var _668433131permalink:String;
      
      private var _1290893620preview_img:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function VideoMedia()
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
      public function get source_url() : String
      {
         return this._1111107765source_url;
      }
      
      [Bindable(event="propertyChange")]
      public function get preview_img() : String
      {
         return this._1290893620preview_img;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set source_url(param1:String) : void
      {
         var _loc2_:Object = this._1111107765source_url;
         if(_loc2_ !== param1)
         {
            this._1111107765source_url = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"source_url",_loc2_,param1));
         }
      }
      
      public function set preview_img(param1:String) : void
      {
         var _loc2_:Object = this._1290893620preview_img;
         if(_loc2_ !== param1)
         {
            this._1290893620preview_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"preview_img",_loc2_,param1));
         }
      }
      
      public function set permalink(param1:String) : void
      {
         var _loc2_:Object = this._668433131permalink;
         if(_loc2_ !== param1)
         {
            this._668433131permalink = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"permalink",_loc2_,param1));
         }
      }
      
      public function set display_url(param1:String) : void
      {
         var _loc2_:Object = this._1714674802display_url;
         if(_loc2_ !== param1)
         {
            this._1714674802display_url = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"display_url",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get permalink() : String
      {
         return this._668433131permalink;
      }
      
      [Bindable(event="propertyChange")]
      public function get display_url() : String
      {
         return this._1714674802display_url;
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
      
      public function set owner(param1:String) : void
      {
         var _loc2_:Object = this._106164915owner;
         if(_loc2_ !== param1)
         {
            this._106164915owner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"owner",_loc2_,param1));
         }
      }
   }
}


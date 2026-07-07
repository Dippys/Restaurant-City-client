package com.facebook.data.stream
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class StreamMediaData implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3575610type:String;
      
      private var _96681alt:String;
      
      private var _3211051href:String;
      
      private var _106642994photo:PhotoMedia;
      
      private var _114148src:String;
      
      private var _112202875video:VideoMedia;
      
      public function StreamMediaData()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get video() : VideoMedia
      {
         return this._112202875video;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function toString() : String
      {
         return ["type: " + this.type,"href: " + this.href,"src: " + this.src,"alt: " + this.alt,"photo: " + this.photo,"video: " + this.video].join(": ");
      }
      
      [Bindable(event="propertyChange")]
      public function get src() : String
      {
         return this._114148src;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set src(param1:String) : void
      {
         var _loc2_:Object = this._114148src;
         if(_loc2_ !== param1)
         {
            this._114148src = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"src",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set alt(param1:String) : void
      {
         var _loc2_:Object = this._96681alt;
         if(_loc2_ !== param1)
         {
            this._96681alt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alt",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
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
      public function get alt() : String
      {
         return this._96681alt;
      }
      
      [Bindable(event="propertyChange")]
      public function get href() : String
      {
         return this._3211051href;
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
      
      public function set video(param1:VideoMedia) : void
      {
         var _loc2_:Object = this._112202875video;
         if(_loc2_ !== param1)
         {
            this._112202875video = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"video",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get photo() : PhotoMedia
      {
         return this._106642994photo;
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function set photo(param1:PhotoMedia) : void
      {
         var _loc2_:Object = this._106642994photo;
         if(_loc2_ !== param1)
         {
            this._106642994photo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"photo",_loc2_,param1));
         }
      }
   }
}


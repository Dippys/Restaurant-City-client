package com.facebook.data.stream
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AttachmentData implements IEventDispatcher
   {
      
      private var _3373707name:String;
      
      private var _103772132media:Array;
      
      private var _3211051href:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _102727412label:String;
      
      private var _3029410body:String;
      
      private var _552573414caption:String;
      
      private var _926053069properties:Array;
      
      private var _1724546052description:String;
      
      private var _3556653text:String;
      
      private var _3226745icon:String;
      
      private var _110371416title:String;
      
      public function AttachmentData()
      {
         super();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
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
      public function get body() : String
      {
         return this._3029410body;
      }
      
      [Bindable(event="propertyChange")]
      public function get href() : String
      {
         return this._3211051href;
      }
      
      [Bindable(event="propertyChange")]
      public function get text() : String
      {
         return this._3556653text;
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get properties() : Array
      {
         return this._926053069properties;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set body(param1:String) : void
      {
         var _loc2_:Object = this._3029410body;
         if(_loc2_ !== param1)
         {
            this._3029410body = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"body",_loc2_,param1));
         }
      }
      
      public function set media(param1:Array) : void
      {
         var _loc2_:Object = this._103772132media;
         if(_loc2_ !== param1)
         {
            this._103772132media = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"media",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set caption(param1:String) : void
      {
         var _loc2_:Object = this._552573414caption;
         if(_loc2_ !== param1)
         {
            this._552573414caption = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"caption",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._110371416title;
      }
      
      public function set text(param1:String) : void
      {
         var _loc2_:Object = this._3556653text;
         if(_loc2_ !== param1)
         {
            this._3556653text = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"text",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
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
      public function get media() : Array
      {
         return this._103772132media;
      }
      
      public function set properties(param1:Array) : void
      {
         var _loc2_:Object = this._926053069properties;
         if(_loc2_ !== param1)
         {
            this._926053069properties = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"properties",_loc2_,param1));
         }
      }
      
      public function set label(param1:String) : void
      {
         var _loc2_:Object = this._102727412label;
         if(_loc2_ !== param1)
         {
            this._102727412label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get caption() : String
      {
         return this._552573414caption;
      }
      
      public function set icon(param1:String) : void
      {
         var _loc2_:Object = this._3226745icon;
         if(_loc2_ !== param1)
         {
            this._3226745icon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get label() : String
      {
         return this._102727412label;
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon() : String
      {
         return this._3226745icon;
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
   }
}


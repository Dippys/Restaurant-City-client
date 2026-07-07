package com.facebook.data.fbml
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AbstractTagData implements IEventDispatcher
   {
      
      private var _513384674is_public:String;
      
      private var _1183728077header_fbml:String;
      
      private var _3373707name:String;
      
      private var _3575610type:String;
      
      private var _1098131327footer_fbml:String;
      
      private var _405645655attributes:AttributeCollection;
      
      private var _1724546052description:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function AbstractTagData(param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:String = "", param7:AttributeCollection = null)
      {
         super();
         this.name = param1;
         this.type = param4;
         this.description = param5;
         this.is_public = param6;
         this.header_fbml = param2;
         this.footer_fbml = param3;
         this.attributes = param7;
      }
      
      public function set is_public(param1:String) : void
      {
         var _loc2_:Object = this._513384674is_public;
         if(_loc2_ !== param1)
         {
            this._513384674is_public = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"is_public",_loc2_,param1));
         }
      }
      
      public function set footer_fbml(param1:String) : void
      {
         var _loc2_:Object = this._1098131327footer_fbml;
         if(_loc2_ !== param1)
         {
            this._1098131327footer_fbml = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"footer_fbml",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
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
      
      [Bindable(event="propertyChange")]
      public function get header_fbml() : String
      {
         return this._1183728077header_fbml;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
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
      public function get attributes() : AttributeCollection
      {
         return this._405645655attributes;
      }
      
      public function set header_fbml(param1:String) : void
      {
         var _loc2_:Object = this._1183728077header_fbml;
         if(_loc2_ !== param1)
         {
            this._1183728077header_fbml = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_fbml",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get is_public() : String
      {
         return this._513384674is_public;
      }
      
      public function set attributes(param1:AttributeCollection) : void
      {
         var _loc2_:Object = this._405645655attributes;
         if(_loc2_ !== param1)
         {
            this._405645655attributes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attributes",_loc2_,param1));
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
      public function get type() : String
      {
         return this._3575610type;
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
      
      [Bindable(event="propertyChange")]
      public function get footer_fbml() : String
      {
         return this._1098131327footer_fbml;
      }
   }
}


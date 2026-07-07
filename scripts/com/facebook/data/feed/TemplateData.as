package com.facebook.data.feed
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class TemplateData implements IEventDispatcher
   {
      
      private var _1285910957template_title:String;
      
      private var _180559289template_body:String;
      
      private var _3575610type:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function TemplateData()
      {
         super();
      }
      
      public function set template_title(param1:String) : void
      {
         var _loc2_:Object = this._1285910957template_title;
         if(_loc2_ !== param1)
         {
            this._1285910957template_title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"template_title",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get template_body() : String
      {
         return this._180559289template_body;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get template_title() : String
      {
         return this._1285910957template_title;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set template_body(param1:String) : void
      {
         var _loc2_:Object = this._180559289template_body;
         if(_loc2_ !== param1)
         {
            this._180559289template_body = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"template_body",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
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
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}


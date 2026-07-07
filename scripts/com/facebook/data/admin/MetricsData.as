package com.facebook.data.admin
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class MetricsData implements IEventDispatcher
   {
      
      private var _1725551537end_time:Date;
      
      private var _1769771919active_users:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _652996091canvas_page_views:Number;
      
      public function MetricsData()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get canvas_page_views() : Number
      {
         return this._652996091canvas_page_views;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set end_time(param1:Date) : void
      {
         var _loc2_:Object = this._1725551537end_time;
         if(_loc2_ !== param1)
         {
            this._1725551537end_time = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"end_time",_loc2_,param1));
         }
      }
      
      public function set canvas_page_views(param1:Number) : void
      {
         var _loc2_:Object = this._652996091canvas_page_views;
         if(_loc2_ !== param1)
         {
            this._652996091canvas_page_views = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"canvas_page_views",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get active_users() : Number
      {
         return this._1769771919active_users;
      }
      
      [Bindable(event="propertyChange")]
      public function get end_time() : Date
      {
         return this._1725551537end_time;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set active_users(param1:Number) : void
      {
         var _loc2_:Object = this._1769771919active_users;
         if(_loc2_ !== param1)
         {
            this._1769771919active_users = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"active_users",_loc2_,param1));
         }
      }
   }
}


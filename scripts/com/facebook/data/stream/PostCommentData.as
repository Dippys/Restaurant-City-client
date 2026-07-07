package com.facebook.data.stream
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class PostCommentData implements IEventDispatcher
   {
      
      private var _1266097595fromid:String;
      
      private var _3556653text:String;
      
      private var _3560141time:Date;
      
      private var _3355id:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function PostCommentData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get fromid() : String
      {
         return this._1266097595fromid;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set fromid(param1:String) : void
      {
         var _loc2_:Object = this._1266097595fromid;
         if(_loc2_ !== param1)
         {
            this._1266097595fromid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fromid",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get time() : Date
      {
         return this._3560141time;
      }
      
      public function set time(param1:Date) : void
      {
         var _loc2_:Object = this._3560141time;
         if(_loc2_ !== param1)
         {
            this._3560141time = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"time",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : String
      {
         return this._3355id;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
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
      
      [Bindable(event="propertyChange")]
      public function get text() : String
      {
         return this._3556653text;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set id(param1:String) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
      }
   }
}


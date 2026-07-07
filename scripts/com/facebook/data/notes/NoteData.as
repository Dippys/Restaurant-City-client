package com.facebook.data.notes
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class NoteData implements IEventDispatcher
   {
      
      private var _2129224840note_id:String;
      
      private var _2003148228created_time:Date;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _115792uid:String;
      
      private var _951530617content:String;
      
      private var _472881199updated_time:Date;
      
      private var _110371416title:String;
      
      public function NoteData()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get created_time() : Date
      {
         return this._2003148228created_time;
      }
      
      [Bindable(event="propertyChange")]
      public function get note_id() : String
      {
         return this._2129224840note_id;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set created_time(param1:Date) : void
      {
         var _loc2_:Object = this._2003148228created_time;
         if(_loc2_ !== param1)
         {
            this._2003148228created_time = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"created_time",_loc2_,param1));
         }
      }
      
      public function set note_id(param1:String) : void
      {
         var _loc2_:Object = this._2129224840note_id;
         if(_loc2_ !== param1)
         {
            this._2129224840note_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"note_id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get updated_time() : Date
      {
         return this._472881199updated_time;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get uid() : String
      {
         return this._115792uid;
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._110371416title;
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
      
      public function set updated_time(param1:Date) : void
      {
         var _loc2_:Object = this._472881199updated_time;
         if(_loc2_ !== param1)
         {
            this._472881199updated_time = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"updated_time",_loc2_,param1));
         }
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
      
      public function set content(param1:String) : void
      {
         var _loc2_:Object = this._951530617content;
         if(_loc2_ !== param1)
         {
            this._951530617content = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get content() : String
      {
         return this._951530617content;
      }
   }
}


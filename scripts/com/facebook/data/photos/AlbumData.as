package com.facebook.data.photos
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AlbumData implements IEventDispatcher
   {
      
      private var _1028554472created:Date;
      
      private var _3373707name:String;
      
      private var _3321850link:String;
      
      private var _466743410visible:String;
      
      private var _96572aid:String;
      
      private var _106164915owner:String;
      
      private var _3530753size:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _615513399modified:Date;
      
      private var _1980072195cover_pid:String;
      
      private var _1901043637location:String;
      
      private var _1724546052description:String;
      
      public function AlbumData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get size() : Number
      {
         return this._3530753size;
      }
      
      public function set size(param1:Number) : void
      {
         var _loc2_:Object = this._3530753size;
         if(_loc2_ !== param1)
         {
            this._3530753size = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"size",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cover_pid() : String
      {
         return this._1980072195cover_pid;
      }
      
      public function set cover_pid(param1:String) : void
      {
         var _loc2_:Object = this._1980072195cover_pid;
         if(_loc2_ !== param1)
         {
            this._1980072195cover_pid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cover_pid",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
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
      
      public function set modified(param1:Date) : void
      {
         var _loc2_:Object = this._615513399modified;
         if(_loc2_ !== param1)
         {
            this._615513399modified = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modified",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get location() : String
      {
         return this._1901043637location;
      }
      
      [Bindable(event="propertyChange")]
      public function get owner() : String
      {
         return this._106164915owner;
      }
      
      [Bindable(event="propertyChange")]
      public function get aid() : String
      {
         return this._96572aid;
      }
      
      [Bindable(event="propertyChange")]
      public function get modified() : Date
      {
         return this._615513399modified;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set created(param1:Date) : void
      {
         var _loc2_:Object = this._1028554472created;
         if(_loc2_ !== param1)
         {
            this._1028554472created = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"created",_loc2_,param1));
         }
      }
      
      public function set visible(param1:String) : void
      {
         var _loc2_:Object = this._466743410visible;
         if(_loc2_ !== param1)
         {
            this._466743410visible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"visible",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      public function get created() : Date
      {
         return this._1028554472created;
      }
      
      public function set location(param1:String) : void
      {
         var _loc2_:Object = this._1901043637location;
         if(_loc2_ !== param1)
         {
            this._1901043637location = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"location",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get visible() : String
      {
         return this._466743410visible;
      }
      
      public function set link(param1:String) : void
      {
         var _loc2_:Object = this._3321850link;
         if(_loc2_ !== param1)
         {
            this._3321850link = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"link",_loc2_,param1));
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
      public function get link() : String
      {
         return this._3321850link;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
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
   }
}


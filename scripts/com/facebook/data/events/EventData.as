package com.facebook.data.events
{
   import com.facebook.data.FacebookLocation;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class EventData implements IEventDispatcher
   {
      
      private var _984376767event_type:String;
      
      private var _3373707name:String;
      
      private var _1725551537end_time:Date;
      
      private var _112093807venue:FacebookLocation;
      
      private var _1028554796creator:Number;
      
      private var _1573145462start_time:Date;
      
      private var _109065nid:Number;
      
      private var _1762076142pic_small:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3208616host:String;
      
      private var _110986pic:String;
      
      private var _578385717pic_big:String;
      
      private var _1901043637location:String;
      
      private var _573446013update_time:Date;
      
      private var _1724546052description:String;
      
      private var _1482814251event_subtype:String;
      
      private var _1548283250tagline:String;
      
      private var _100416eid:String;
      
      public function EventData()
      {
         super();
      }
      
      public function set eid(param1:String) : void
      {
         var _loc2_:Object = this._100416eid;
         if(_loc2_ !== param1)
         {
            this._100416eid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eid",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get update_time() : Date
      {
         return this._573446013update_time;
      }
      
      public function set update_time(param1:Date) : void
      {
         var _loc2_:Object = this._573446013update_time;
         if(_loc2_ !== param1)
         {
            this._573446013update_time = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"update_time",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get nid() : Number
      {
         return this._109065nid;
      }
      
      [Bindable(event="propertyChange")]
      public function get pic() : String
      {
         return this._110986pic;
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
      
      [Bindable(event="propertyChange")]
      public function get tagline() : String
      {
         return this._1548283250tagline;
      }
      
      [Bindable(event="propertyChange")]
      public function get start_time() : Date
      {
         return this._1573145462start_time;
      }
      
      public function set nid(param1:Number) : void
      {
         var _loc2_:Object = this._109065nid;
         if(_loc2_ !== param1)
         {
            this._109065nid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nid",_loc2_,param1));
         }
      }
      
      public function set pic(param1:String) : void
      {
         var _loc2_:Object = this._110986pic;
         if(_loc2_ !== param1)
         {
            this._110986pic = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pic",_loc2_,param1));
         }
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
      public function get pic_small() : String
      {
         return this._1762076142pic_small;
      }
      
      public function set tagline(param1:String) : void
      {
         var _loc2_:Object = this._1548283250tagline;
         if(_loc2_ !== param1)
         {
            this._1548283250tagline = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tagline",_loc2_,param1));
         }
      }
      
      public function set pic_small(param1:String) : void
      {
         var _loc2_:Object = this._1762076142pic_small;
         if(_loc2_ !== param1)
         {
            this._1762076142pic_small = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pic_small",_loc2_,param1));
         }
      }
      
      public function set pic_big(param1:String) : void
      {
         var _loc2_:Object = this._578385717pic_big;
         if(_loc2_ !== param1)
         {
            this._578385717pic_big = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pic_big",_loc2_,param1));
         }
      }
      
      public function set event_subtype(param1:String) : void
      {
         var _loc2_:Object = this._1482814251event_subtype;
         if(_loc2_ !== param1)
         {
            this._1482814251event_subtype = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"event_subtype",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get creator() : Number
      {
         return this._1028554796creator;
      }
      
      [Bindable(event="propertyChange")]
      public function get host() : String
      {
         return this._3208616host;
      }
      
      [Bindable(event="propertyChange")]
      public function get location() : String
      {
         return this._1901043637location;
      }
      
      [Bindable(event="propertyChange")]
      public function get event_type() : String
      {
         return this._984376767event_type;
      }
      
      [Bindable(event="propertyChange")]
      public function get eid() : String
      {
         return this._100416eid;
      }
      
      public function set start_time(param1:Date) : void
      {
         var _loc2_:Object = this._1573145462start_time;
         if(_loc2_ !== param1)
         {
            this._1573145462start_time = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"start_time",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get end_time() : Date
      {
         return this._1725551537end_time;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get pic_big() : String
      {
         return this._578385717pic_big;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set host(param1:String) : void
      {
         var _loc2_:Object = this._3208616host;
         if(_loc2_ !== param1)
         {
            this._3208616host = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"host",_loc2_,param1));
         }
      }
      
      public function set creator(param1:Number) : void
      {
         var _loc2_:Object = this._1028554796creator;
         if(_loc2_ !== param1)
         {
            this._1028554796creator = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"creator",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get event_subtype() : String
      {
         return this._1482814251event_subtype;
      }
      
      public function set venue(param1:FacebookLocation) : void
      {
         var _loc2_:Object = this._112093807venue;
         if(_loc2_ !== param1)
         {
            this._112093807venue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"venue",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get venue() : FacebookLocation
      {
         return this._112093807venue;
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
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
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
      public function get description() : String
      {
         return this._1724546052description;
      }
      
      public function set event_type(param1:String) : void
      {
         var _loc2_:Object = this._984376767event_type;
         if(_loc2_ !== param1)
         {
            this._984376767event_type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"event_type",_loc2_,param1));
         }
      }
   }
}


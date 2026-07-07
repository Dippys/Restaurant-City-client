package com.facebook.data.events
{
   import com.facebook.facebook_internal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   use namespace facebook_internal;
   
   public class CreateEventData implements IEventDispatcher
   {
      
      private var _96619420email:String;
      
      private var _3373707name:String;
      
      private var _106642798phone:String;
      
      private var _1725551537end_time:Date;
      
      private var _1573145462start_time:Date;
      
      facebook_internal var schema:Array;
      
      private var _3208616host:String;
      
      private var _1901043637location:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1300380478subcategory:String;
      
      private var _803548981page_id:Number;
      
      private var _891990013street:String;
      
      private var _1724546052description:String;
      
      private var _629073519privacy_type:String;
      
      private var _1548283250tagline:String;
      
      private var _3053931city:String;
      
      private var _50511102category:String;
      
      public function CreateEventData(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:Date, param8:Date, param9:String = null, param10:String = null, param11:String = null, param12:Number = NaN, param13:String = null, param14:String = null, param15:String = null)
      {
         super();
         this.schema = ["name","category","subcategory","host","location","city","start_time","end_time","street","phone","email","page_id","description","privacy_type","tagline"];
         this.name = param1;
         this.category = param2;
         this.subcategory = param3;
         this.host = param4;
         this.location = param5;
         this.city = param6;
         this.start_time = param7;
         this.end_time = param8;
         this.street = param9;
         this.phone = param10;
         this.email = param11;
         this.page_id = param12;
         this.description = param13;
         this.privacy_type = param14;
         this.tagline = param15;
      }
      
      [Bindable(event="propertyChange")]
      public function get street() : String
      {
         return this._891990013street;
      }
      
      public function set street(param1:String) : void
      {
         var _loc2_:Object = this._891990013street;
         if(_loc2_ !== param1)
         {
            this._891990013street = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"street",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get start_time() : Date
      {
         return this._1573145462start_time;
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
      public function get privacy_type() : String
      {
         return this._629073519privacy_type;
      }
      
      [Bindable(event="propertyChange")]
      public function get tagline() : String
      {
         return this._1548283250tagline;
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
      
      public function set start_time(param1:Date) : void
      {
         var _loc2_:Object = this._1573145462start_time;
         if(_loc2_ !== param1)
         {
            this._1573145462start_time = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"start_time",_loc2_,param1));
         }
      }
      
      public function set page_id(param1:Number) : void
      {
         var _loc2_:Object = this._803548981page_id;
         if(_loc2_ !== param1)
         {
            this._803548981page_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"page_id",_loc2_,param1));
         }
      }
      
      public function set category(param1:String) : void
      {
         var _loc2_:Object = this._50511102category;
         if(_loc2_ !== param1)
         {
            this._50511102category = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"category",_loc2_,param1));
         }
      }
      
      public function set privacy_type(param1:String) : void
      {
         var _loc2_:Object = this._629073519privacy_type;
         if(_loc2_ !== param1)
         {
            this._629073519privacy_type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"privacy_type",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get email() : String
      {
         return this._96619420email;
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
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
      
      [Bindable(event="propertyChange")]
      public function get host() : String
      {
         return this._3208616host;
      }
      
      [Bindable(event="propertyChange")]
      public function get end_time() : Date
      {
         return this._1725551537end_time;
      }
      
      [Bindable(event="propertyChange")]
      public function get location() : String
      {
         return this._1901043637location;
      }
      
      public function set email(param1:String) : void
      {
         var _loc2_:Object = this._96619420email;
         if(_loc2_ !== param1)
         {
            this._96619420email = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"email",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subcategory() : String
      {
         return this._1300380478subcategory;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get page_id() : Number
      {
         return this._803548981page_id;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
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
      
      public function set phone(param1:String) : void
      {
         var _loc2_:Object = this._106642798phone;
         if(_loc2_ !== param1)
         {
            this._106642798phone = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"phone",_loc2_,param1));
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
      
      public function set city(param1:String) : void
      {
         var _loc2_:Object = this._3053931city;
         if(_loc2_ !== param1)
         {
            this._3053931city = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"city",_loc2_,param1));
         }
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
      public function get city() : String
      {
         return this._3053931city;
      }
      
      [Bindable(event="propertyChange")]
      public function get phone() : String
      {
         return this._106642798phone;
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
      
      public function set subcategory(param1:String) : void
      {
         var _loc2_:Object = this._1300380478subcategory;
         if(_loc2_ !== param1)
         {
            this._1300380478subcategory = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subcategory",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get category() : String
      {
         return this._50511102category;
      }
   }
}


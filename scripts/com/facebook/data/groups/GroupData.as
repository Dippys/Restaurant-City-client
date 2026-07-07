package com.facebook.data.groups
{
   import com.facebook.data.FacebookLocation;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class GroupData implements IEventDispatcher
   {
      
      private var _1282509050group_type:String;
      
      private var _1019789636office:String;
      
      private var _3373707name:String;
      
      private var _314498168privacy:String;
      
      private var _102338gid:String;
      
      private var _2022916553recent_news:String;
      
      private var _112093807venue:FacebookLocation;
      
      private var _1028554796creator:String;
      
      private var _1816339526group_subtype:String;
      
      private var _1762076142pic_small:String;
      
      private var _1224335515website:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _109065nid:Number;
      
      private var _110986pic:String;
      
      private var _578385717pic_big:String;
      
      private var _573446013update_time:Date;
      
      private var _1724546052description:String;
      
      public function GroupData()
      {
         super();
      }
      
      public function set gid(param1:String) : void
      {
         var _loc2_:Object = this._102338gid;
         if(_loc2_ !== param1)
         {
            this._102338gid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gid",_loc2_,param1));
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
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
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
      public function get privacy() : String
      {
         return this._314498168privacy;
      }
      
      public function set privacy(param1:String) : void
      {
         var _loc2_:Object = this._314498168privacy;
         if(_loc2_ !== param1)
         {
            this._314498168privacy = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"privacy",_loc2_,param1));
         }
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
      
      public function set pic_big(param1:String) : void
      {
         var _loc2_:Object = this._578385717pic_big;
         if(_loc2_ !== param1)
         {
            this._578385717pic_big = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pic_big",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pic_small() : String
      {
         return this._1762076142pic_small;
      }
      
      [Bindable(event="propertyChange")]
      public function get update_time() : Date
      {
         return this._573446013update_time;
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
      
      public function set pic_small(param1:String) : void
      {
         var _loc2_:Object = this._1762076142pic_small;
         if(_loc2_ !== param1)
         {
            this._1762076142pic_small = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pic_small",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get creator() : String
      {
         return this._1028554796creator;
      }
      
      public function set website(param1:String) : void
      {
         var _loc2_:Object = this._1224335515website;
         if(_loc2_ !== param1)
         {
            this._1224335515website = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"website",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get recent_news() : String
      {
         return this._2022916553recent_news;
      }
      
      [Bindable(event="propertyChange")]
      public function get group_subtype() : String
      {
         return this._1816339526group_subtype;
      }
      
      [Bindable(event="propertyChange")]
      public function get website() : String
      {
         return this._1224335515website;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get gid() : String
      {
         return this._102338gid;
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
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get office() : String
      {
         return this._1019789636office;
      }
      
      public function set creator(param1:String) : void
      {
         var _loc2_:Object = this._1028554796creator;
         if(_loc2_ !== param1)
         {
            this._1028554796creator = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"creator",_loc2_,param1));
         }
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
      
      public function set recent_news(param1:String) : void
      {
         var _loc2_:Object = this._2022916553recent_news;
         if(_loc2_ !== param1)
         {
            this._2022916553recent_news = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"recent_news",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get venue() : FacebookLocation
      {
         return this._112093807venue;
      }
      
      public function set group_type(param1:String) : void
      {
         var _loc2_:Object = this._1282509050group_type;
         if(_loc2_ !== param1)
         {
            this._1282509050group_type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"group_type",_loc2_,param1));
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
      public function get group_type() : String
      {
         return this._1282509050group_type;
      }
      
      public function set group_subtype(param1:String) : void
      {
         var _loc2_:Object = this._1816339526group_subtype;
         if(_loc2_ !== param1)
         {
            this._1816339526group_subtype = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"group_subtype",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
      
      public function set office(param1:String) : void
      {
         var _loc2_:Object = this._1019789636office;
         if(_loc2_ !== param1)
         {
            this._1019789636office = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"office",_loc2_,param1));
         }
      }
   }
}


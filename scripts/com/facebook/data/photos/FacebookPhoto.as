package com.facebook.data.photos
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class FacebookPhoto extends FacebookData
   {
      
      private var _1028554472created:Date;
      
      private var _552573414caption:String;
      
      private var _89081108src_small:String;
      
      private var _1953179611src_big:String;
      
      private var _3321850link:String;
      
      private var _110987pid:String;
      
      private var _3552281tags:Array;
      
      private var _96572aid:String;
      
      private var _114148src:String;
      
      private var _106164915owner:Number;
      
      public function FacebookPhoto()
      {
         this.tags = [];
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get link() : String
      {
         return this._3321850link;
      }
      
      [Bindable(event="propertyChange")]
      public function get owner() : Number
      {
         return this._106164915owner;
      }
      
      [Bindable(event="propertyChange")]
      public function get src() : String
      {
         return this._114148src;
      }
      
      public function set src_big(param1:String) : void
      {
         var _loc2_:Object = this._1953179611src_big;
         if(_loc2_ !== param1)
         {
            this._1953179611src_big = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"src_big",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pid() : String
      {
         return this._110987pid;
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
      
      public function set pid(param1:String) : void
      {
         var _loc2_:Object = this._110987pid;
         if(_loc2_ !== param1)
         {
            this._110987pid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pid",_loc2_,param1));
         }
      }
      
      public function set src(param1:String) : void
      {
         var _loc2_:Object = this._114148src;
         if(_loc2_ !== param1)
         {
            this._114148src = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"src",_loc2_,param1));
         }
      }
      
      public function set src_small(param1:String) : void
      {
         var _loc2_:Object = this._89081108src_small;
         if(_loc2_ !== param1)
         {
            this._89081108src_small = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"src_small",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tags() : Array
      {
         return this._3552281tags;
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
      
      [Bindable(event="propertyChange")]
      public function get src_big() : String
      {
         return this._1953179611src_big;
      }
      
      [Bindable(event="propertyChange")]
      public function get created() : Date
      {
         return this._1028554472created;
      }
      
      public function set tags(param1:Array) : void
      {
         var _loc2_:Object = this._3552281tags;
         if(_loc2_ !== param1)
         {
            this._3552281tags = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tags",_loc2_,param1));
         }
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
      
      public function set owner(param1:Number) : void
      {
         var _loc2_:Object = this._106164915owner;
         if(_loc2_ !== param1)
         {
            this._106164915owner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"owner",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get src_small() : String
      {
         return this._89081108src_small;
      }
      
      [Bindable(event="propertyChange")]
      public function get aid() : String
      {
         return this._96572aid;
      }
      
      [Bindable(event="propertyChange")]
      public function get caption() : String
      {
         return this._552573414caption;
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


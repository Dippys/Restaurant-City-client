package com.facebook.data.photos
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class TagData implements IEventDispatcher
   {
      
      protected var _actualText:String;
      
      private var _1867885268subject:String;
      
      private var _1028554472created:Date;
      
      private var _110987pid:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      protected var _actualX:Number;
      
      protected var _actualY:Number;
      
      private var _1548659157tag_uid:String;
      
      public function TagData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get pid() : String
      {
         return this._110987pid;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      private function set _120x(param1:Number) : void
      {
         this._actualX = param1;
      }
      
      public function get ycoord() : Number
      {
         return this._actualY;
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
      
      private function set _735994340ycoord(param1:Number) : void
      {
         this._actualY = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get tag_uid() : String
      {
         return this._1548659157tag_uid;
      }
      
      [Bindable(event="propertyChange")]
      public function get subject() : String
      {
         return this._1867885268subject;
      }
      
      public function get text() : String
      {
         return this._actualText;
      }
      
      public function get tag_text() : String
      {
         return this._actualText;
      }
      
      [Bindable(event="propertyChange")]
      public function set ycoord(param1:Number) : void
      {
         var _loc2_:Object = this.ycoord;
         if(_loc2_ !== param1)
         {
            this._735994340ycoord = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ycoord",_loc2_,param1));
         }
      }
      
      private function set _3556653text(param1:String) : void
      {
         this._actualText = param1;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function set _764623491xcoord(param1:Number) : void
      {
         this._actualX = param1;
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
      
      public function set subject(param1:String) : void
      {
         var _loc2_:Object = this._1867885268subject;
         if(_loc2_ !== param1)
         {
            this._1867885268subject = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subject",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set text(param1:String) : void
      {
         var _loc2_:Object = this.text;
         if(_loc2_ !== param1)
         {
            this._3556653text = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"text",_loc2_,param1));
         }
      }
      
      public function set tag_uid(param1:String) : void
      {
         var _loc2_:Object = this._1548659157tag_uid;
         if(_loc2_ !== param1)
         {
            this._1548659157tag_uid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tag_uid",_loc2_,param1));
         }
      }
      
      private function set _121y(param1:Number) : void
      {
         this._actualY = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set tag_text(param1:String) : void
      {
         var _loc2_:Object = this.tag_text;
         if(_loc2_ !== param1)
         {
            this._763826510tag_text = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tag_text",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get created() : Date
      {
         return this._1028554472created;
      }
      
      [Bindable(event="propertyChange")]
      public function set x(param1:Number) : void
      {
         var _loc2_:Object = this.x;
         if(_loc2_ !== param1)
         {
            this._120x = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"x",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set y(param1:Number) : void
      {
         var _loc2_:Object = this.y;
         if(_loc2_ !== param1)
         {
            this._121y = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"y",_loc2_,param1));
         }
      }
      
      public function get x() : Number
      {
         return this._actualX;
      }
      
      public function get y() : Number
      {
         return this._actualY;
      }
      
      [Bindable(event="propertyChange")]
      public function set xcoord(param1:Number) : void
      {
         var _loc2_:Object = this.xcoord;
         if(_loc2_ !== param1)
         {
            this._764623491xcoord = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xcoord",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function get xcoord() : Number
      {
         return this._actualX;
      }
      
      private function set _763826510tag_text(param1:String) : void
      {
         this._actualText = param1;
      }
   }
}


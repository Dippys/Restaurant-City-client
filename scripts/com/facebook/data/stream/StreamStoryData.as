package com.facebook.data.stream
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class StreamStoryData implements IEventDispatcher
   {
      
      private var _1650554971actor_id:String;
      
      private var _954925063message:String;
      
      private var _3575610type:uint;
      
      private var _314498168privacy:String;
      
      private var _1698410561source_id:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1963501277attachment:AttachmentData;
      
      private var _815576439target_id:String;
      
      private var _2003148228created_time:Date;
      
      private var _1698418180sourceXML:XML;
      
      private var _1411074055app_id:String;
      
      private var _391211750post_id:String;
      
      private var _602415628comments:CommentsData;
      
      private var _102974396likes:LikesData;
      
      private var _450004177metadata:Object;
      
      private var _309882753attribution:String;
      
      private var _472881199updated_time:Date;
      
      private var _1552737000filter_key:String;
      
      private var _1567543704viewer_id:String;
      
      public function StreamStoryData()
      {
         super();
      }
      
      public function set attribution(param1:String) : void
      {
         var _loc2_:Object = this._309882753attribution;
         if(_loc2_ !== param1)
         {
            this._309882753attribution = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attribution",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get message() : String
      {
         return this._954925063message;
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
      
      [Bindable(event="propertyChange")]
      public function get target_id() : String
      {
         return this._815576439target_id;
      }
      
      [Bindable(event="propertyChange")]
      public function get sourceXML() : XML
      {
         return this._1698418180sourceXML;
      }
      
      public function set message(param1:String) : void
      {
         var _loc2_:Object = this._954925063message;
         if(_loc2_ !== param1)
         {
            this._954925063message = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get privacy() : String
      {
         return this._314498168privacy;
      }
      
      public function set target_id(param1:String) : void
      {
         var _loc2_:Object = this._815576439target_id;
         if(_loc2_ !== param1)
         {
            this._815576439target_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"target_id",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get filter_key() : String
      {
         return this._1552737000filter_key;
      }
      
      [Bindable(event="propertyChange")]
      public function get post_id() : String
      {
         return this._391211750post_id;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get actor_id() : String
      {
         return this._1650554971actor_id;
      }
      
      [Bindable(event="propertyChange")]
      public function get attachment() : AttachmentData
      {
         return this._1963501277attachment;
      }
      
      [Bindable(event="propertyChange")]
      public function get metadata() : Object
      {
         return this._450004177metadata;
      }
      
      public function set filter_key(param1:String) : void
      {
         var _loc2_:Object = this._1552737000filter_key;
         if(_loc2_ !== param1)
         {
            this._1552737000filter_key = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filter_key",_loc2_,param1));
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
      
      public function set post_id(param1:String) : void
      {
         var _loc2_:Object = this._391211750post_id;
         if(_loc2_ !== param1)
         {
            this._391211750post_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"post_id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : uint
      {
         return this._3575610type;
      }
      
      [Bindable(event="propertyChange")]
      public function get likes() : LikesData
      {
         return this._102974396likes;
      }
      
      [Bindable(event="propertyChange")]
      public function get source_id() : String
      {
         return this._1698410561source_id;
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
      
      public function set actor_id(param1:String) : void
      {
         var _loc2_:Object = this._1650554971actor_id;
         if(_loc2_ !== param1)
         {
            this._1650554971actor_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"actor_id",_loc2_,param1));
         }
      }
      
      public function set sourceXML(param1:XML) : void
      {
         var _loc2_:Object = this._1698418180sourceXML;
         if(_loc2_ !== param1)
         {
            this._1698418180sourceXML = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sourceXML",_loc2_,param1));
         }
      }
      
      public function set viewer_id(param1:String) : void
      {
         var _loc2_:Object = this._1567543704viewer_id;
         if(_loc2_ !== param1)
         {
            this._1567543704viewer_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"viewer_id",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get updated_time() : Date
      {
         return this._472881199updated_time;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set attachment(param1:AttachmentData) : void
      {
         var _loc2_:Object = this._1963501277attachment;
         if(_loc2_ !== param1)
         {
            this._1963501277attachment = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attachment",_loc2_,param1));
         }
      }
      
      public function set metadata(param1:Object) : void
      {
         var _loc2_:Object = this._450004177metadata;
         if(_loc2_ !== param1)
         {
            this._450004177metadata = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"metadata",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get viewer_id() : String
      {
         return this._1567543704viewer_id;
      }
      
      public function set comments(param1:CommentsData) : void
      {
         var _loc2_:Object = this._602415628comments;
         if(_loc2_ !== param1)
         {
            this._602415628comments = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"comments",_loc2_,param1));
         }
      }
      
      public function set app_id(param1:String) : void
      {
         var _loc2_:Object = this._1411074055app_id;
         if(_loc2_ !== param1)
         {
            this._1411074055app_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"app_id",_loc2_,param1));
         }
      }
      
      public function set type(param1:uint) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
         }
      }
      
      public function set likes(param1:LikesData) : void
      {
         var _loc2_:Object = this._102974396likes;
         if(_loc2_ !== param1)
         {
            this._102974396likes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"likes",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get app_id() : String
      {
         return this._1411074055app_id;
      }
      
      [Bindable(event="propertyChange")]
      public function get comments() : CommentsData
      {
         return this._602415628comments;
      }
      
      public function set source_id(param1:String) : void
      {
         var _loc2_:Object = this._1698410561source_id;
         if(_loc2_ !== param1)
         {
            this._1698410561source_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"source_id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get attribution() : String
      {
         return this._309882753attribution;
      }
   }
}


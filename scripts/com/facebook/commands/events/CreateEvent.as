package com.facebook.commands.events
{
   import com.adobe.serialization.json.JSON;
   import com.facebook.data.events.CreateEventData;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.net.IUploadPhoto;
   import com.facebook.utils.FacebookDataUtils;
   
   use namespace facebook_internal;
   
   public class CreateEvent extends FacebookCall implements IUploadPhoto
   {
      
      public static const METHOD_NAME:String = "events.create";
      
      public static const SCHEMA:Array = ["event_info","data"];
      
      protected var _data:Object;
      
      public var event_info:CreateEventData;
      
      protected var _uploadType:String = "png";
      
      protected var _uploadQuality:uint = 80;
      
      public function CreateEvent(param1:CreateEventData, param2:Object)
      {
         super(METHOD_NAME);
         this.event_info = param1;
         this.data = param2;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get uploadQuality() : uint
      {
         return this._uploadQuality;
      }
      
      override facebook_internal function initialize() : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc1_:Object = {};
         for each(_loc2_ in this.event_info.schema)
         {
            _loc3_ = this.event_info[_loc2_];
            if(_loc3_ is Date)
            {
               _loc3_ = FacebookDataUtils.toDateString(_loc3_ as Date);
            }
            _loc1_[_loc2_] = _loc3_;
         }
         applySchema(SCHEMA,com.adobe.serialization.json.JSON.encode(_loc1_),this.data);
         super.facebook_internal::initialize();
      }
      
      public function set uploadType(param1:String) : void
      {
         this._uploadType = param1;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function set uploadQuality(param1:uint) : void
      {
         this._uploadQuality = param1;
      }
      
      public function get uploadType() : String
      {
         return this._uploadType;
      }
   }
}


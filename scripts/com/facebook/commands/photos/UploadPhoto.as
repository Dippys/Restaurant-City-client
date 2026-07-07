package com.facebook.commands.photos
{
   import com.facebook.data.photos.FacebookPhoto;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.net.IUploadPhoto;
   
   use namespace facebook_internal;
   
   public class UploadPhoto extends FacebookCall implements IUploadPhoto
   {
      
      public static const METHOD_NAME:String = "photos.upload";
      
      public static const SCHEMA:Array = ["data","aid","caption","uid"];
      
      public var aid:String;
      
      protected var _data:Object;
      
      public var uid:String;
      
      public var caption:String;
      
      public var uploadedPhoto:FacebookPhoto;
      
      protected var _uploadType:String = "png";
      
      protected var _uploadQuality:uint = 80;
      
      public function UploadPhoto(param1:Object = null, param2:String = null, param3:String = null, param4:String = null)
      {
         super(METHOD_NAME);
         this.data = param1;
         this.aid = param2;
         this.caption = param3;
         this.uid = param4;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,this.data,this.aid,this.caption,this.uid);
         super.facebook_internal::initialize();
      }
      
      public function get uploadType() : String
      {
         return this._uploadType;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set uploadType(param1:String) : void
      {
         this._uploadType = param1;
      }
      
      public function set uploadQuality(param1:uint) : void
      {
         this._uploadQuality = param1;
      }
      
      public function get uploadQuality() : uint
      {
         return this._uploadQuality;
      }
   }
}


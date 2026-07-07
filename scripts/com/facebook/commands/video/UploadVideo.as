package com.facebook.commands.video
{
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.net.IUploadVideo;
   
   use namespace facebook_internal;
   
   public class UploadVideo extends FacebookCall implements IUploadVideo
   {
      
      public static const METHOD_NAME:String = "video.upload";
      
      public static const SCHEMA:Array = ["data","title","description"];
      
      public static const TIMEOUT:Number = 300000;
      
      protected var _title:String;
      
      protected var _ext:String;
      
      protected var _data:Object;
      
      protected var _description:String;
      
      public function UploadVideo(param1:String, param2:Object, param3:String = null, param4:String = null)
      {
         super(METHOD_NAME);
         connectTimeout = TIMEOUT;
         this.ext = param1;
         this.data = param2;
         this.title = param3;
         this.description = param4;
      }
      
      public function get ext() : String
      {
         return this._ext;
      }
      
      public function set description(param1:String) : void
      {
         this._description = param1;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
      
      public function set ext(param1:String) : void
      {
         this._ext = param1;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,this.data,this.title,this.description);
         super.facebook_internal::initialize();
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function get description() : String
      {
         return this._description;
      }
   }
}


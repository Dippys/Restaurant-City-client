package com.playfish.coretech.platform.natural.facebook
{
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   
   use namespace facebook_internal;
   
   public class FBGetPublicInfo extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "application.getPublicInfo";
      
      public static const SCHEMA:Array = ["application_id","application_api_key","application_canvas_name"];
      
      public var application_canvas_name:String;
      
      public var application_id:String;
      
      public var application_api_key:String;
      
      public function FBGetPublicInfo(param1:String = null, param2:String = null, param3:String = null)
      {
         super(METHOD_NAME);
         var _loc4_:int = 0;
         if(param1 != null)
         {
            _loc4_++;
         }
         if(param2 != null)
         {
            _loc4_++;
         }
         if(param3 != null)
         {
            _loc4_++;
         }
         if(_loc4_ > 1)
         {
            throw new Error("You must specify exactly one of application_id, application_api_key or application_canvas_name.");
         }
         this.application_id = param1;
         this.application_api_key = param2;
         this.application_canvas_name = param3;
      }
      
      override facebook_internal function initialize() : void
      {
         this.applySchema(SCHEMA,application_id,application_api_key,application_canvas_name);
         super.facebook_internal::initialize();
      }
   }
}


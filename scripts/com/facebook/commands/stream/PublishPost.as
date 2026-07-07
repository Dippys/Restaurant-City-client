package com.facebook.commands.stream
{
   import com.adobe.serialization.json.JSON;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   
   use namespace facebook_internal;
   
   public class PublishPost extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "stream.publish";
      
      public static const SCHEMA:Array = ["message","attachment","action_links","target_id"];
      
      public var action_links:Array;
      
      public var attachment:Object;
      
      public var target_id:String;
      
      public var message:String;
      
      public function PublishPost(param1:String = null, param2:Object = null, param3:Array = null, param4:String = null)
      {
         super(METHOD_NAME);
         this.message = param1;
         this.attachment = param2;
         this.action_links = param3;
         this.target_id = param4;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,this.message,com.adobe.serialization.json.JSON.encode(this.attachment),com.adobe.serialization.json.JSON.encode(this.action_links),this.target_id);
         super.facebook_internal::initialize();
      }
   }
}


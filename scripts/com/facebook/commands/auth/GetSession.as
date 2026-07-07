package com.facebook.commands.auth
{
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   
   use namespace facebook_internal;
   
   public class GetSession extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "auth.getSession";
      
      public static const SCHEMA:Array = ["auth_token"];
      
      public var auth_token:String;
      
      public function GetSession(param1:String)
      {
         super(METHOD_NAME);
         this.auth_token = param1;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,this.auth_token);
         super.facebook_internal::initialize();
      }
   }
}


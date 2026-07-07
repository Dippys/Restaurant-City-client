package com.facebook.commands.auth
{
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   
   use namespace facebook_internal;
   
   public class RevokeAuthorization extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "auth.revokeAuthorization";
      
      public static const SCHEMA:Array = ["user"];
      
      public var user:String;
      
      public function RevokeAuthorization(param1:String = null)
      {
         super(METHOD_NAME);
         this.user = param1;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,this.user);
         super.facebook_internal::initialize();
      }
   }
}


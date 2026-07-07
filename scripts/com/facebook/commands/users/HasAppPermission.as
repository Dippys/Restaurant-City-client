package com.facebook.commands.users
{
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   
   use namespace facebook_internal;
   
   public class HasAppPermission extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "users.hasAppPermission";
      
      public static const SCHEMA:Array = ["ext_perm","uid"];
      
      public var uid:String;
      
      public var ext_perm:String;
      
      public function HasAppPermission(param1:String, param2:String = null)
      {
         super(METHOD_NAME);
         this.ext_perm = param1;
         this.uid = param2;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,this.ext_perm,this.uid);
         super.facebook_internal::initialize();
      }
   }
}


package com.facebook.commands.fql
{
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   
   use namespace facebook_internal;
   
   public class FqlQuery extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "fql.query";
      
      public static const SCHEMA:Array = ["query"];
      
      public var query:String;
      
      public function FqlQuery(param1:String)
      {
         super(METHOD_NAME);
         this.query = param1;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,this.query);
         super.facebook_internal::initialize();
      }
   }
}


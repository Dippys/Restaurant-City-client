package com.facebook.commands.auth
{
   import com.facebook.net.FacebookCall;
   
   public class ExpireSession extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "auth.expireSession";
      
      public static const SCHEMA:Array = [];
      
      public function ExpireSession()
      {
         super(METHOD_NAME);
      }
   }
}


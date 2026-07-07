package com.facebook.commands.auth
{
   import com.facebook.net.FacebookCall;
   
   public class CreateToken extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "auth.createToken";
      
      public static const SCHEMA:Array = [];
      
      public function CreateToken()
      {
         super(METHOD_NAME);
      }
   }
}


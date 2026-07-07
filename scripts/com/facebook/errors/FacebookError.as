package com.facebook.errors
{
   import com.facebook.data.FacebookData;
   import flash.events.ErrorEvent;
   import flash.net.URLVariables;
   
   public class FacebookError extends FacebookData
   {
      
      public var errorMsg:String;
      
      public var reason:String;
      
      public var error:Error;
      
      public var requestArgs:URLVariables;
      
      public var errorCode:Number;
      
      public var errorEvent:ErrorEvent;
      
      public function FacebookError()
      {
         super();
      }
   }
}


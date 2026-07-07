package com.facebook.commands.notifications
{
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.utils.FacebookDataUtils;
   
   use namespace facebook_internal;
   
   public class SendNotification extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "notifications.send";
      
      public static const SCHEMA:Array = ["to_ids","notification","type"];
      
      public var to_ids:Array;
      
      public var type:String;
      
      public var notification:String;
      
      public function SendNotification(param1:Array, param2:String, param3:String = null)
      {
         super(METHOD_NAME);
         this.to_ids = param1;
         this.notification = param2;
         this.type = param3;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,FacebookDataUtils.toArrayString(this.to_ids),this.notification,this.type);
         super.facebook_internal::initialize();
      }
   }
}


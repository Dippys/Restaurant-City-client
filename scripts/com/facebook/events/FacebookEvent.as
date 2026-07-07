package com.facebook.events
{
   import com.facebook.data.FacebookData;
   import com.facebook.errors.FacebookError;
   import flash.events.Event;
   
   public class FacebookEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
      
      public static const WAITING_FOR_LOGIN:String = "waitingForLogin";
      
      public static const VERIFYING_SESSION:String = "verifyingSession";
      
      public static const CONNECT:String = "connect";
      
      public static const LOGOUT:String = "logout";
      
      public static const LOGIN_SUCCESS:String = "loginSuccess";
      
      public static const LOGIN_FAILURE:String = "loginFailure";
      
      public static const PERMISSIONS_LOADED:String = "permissionsLoaded";
      
      public static const PERMISSION_STATUS:String = "permissionStatus";
      
      public static const PERMISSION_CHANGE:String = "permissionChanged";
      
      public static const LOGIN_WINDOW_SHOW:String = "loginWindoShow";
      
      public static const PERMISSIONS_WINDOW_SHOW:String = "permissionsWindowShow";
      
      public static const ERROR:String = "facebookEventError";
      
      public var success:Boolean;
      
      public var error:FacebookError;
      
      public var hasPermission:Boolean;
      
      public var data:FacebookData;
      
      public var permission:String;
      
      public function FacebookEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:FacebookData = null, param6:FacebookError = null, param7:String = "", param8:Boolean = false)
      {
         this.success = param4;
         this.data = param5;
         this.error = param6;
         this.permission = param7;
         this.hasPermission = param8;
         super(param1,param2,param3);
      }
      
      override public function toString() : String
      {
         return formatToString("FacebookEvent","type","success","data","error");
      }
      
      override public function clone() : Event
      {
         return new FacebookEvent(type,bubbles,cancelable,this.success,this.data,this.error);
      }
   }
}


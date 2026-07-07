package com.playfish.coretech.platform.socialplatform
{
   import com.playfish.coretech.engine.core.*;
   import com.playfish.coretech.platform.socialnetwork.SocialNetwork;
   import com.playfish.coretech.platform.socialstats.FriendshipMetric;
   
   public class SocialPlatformApp extends SocialPlatformModule
   {
      
      public static const PERMISSION_BOOKMARKED:uint = 0;
      
      public static const PERMISSION_STATUS_UPDATE:uint = 1;
      
      public static const PERMISSION_PHOTOS_UPLOAD:uint = 2;
      
      public static const PERMISSION_EVENTS_CREATE:uint = 3;
      
      public static const PERMISSION_EVENTS_UPDATE:uint = 4;
      
      public static const PERMISSION_EVENTS_DELETE:uint = 5;
      
      public static const PERMISSION_EMAIL_ACCESS:uint = 6;
      
      public static const PERMISSION_LAST:uint = PERMISSION_EMAIL_ACCESS;
      
      protected var friendshipMetric:int;
      
      protected var permissionsSet:Array;
      
      public function SocialPlatformApp(param1:SocialPlatformAppSettings)
      {
         super();
         PREPARATION_MASK = SocialPlatform.PREPARE_MASK_APPLICATION;
         permissionsSet = new Array();
         friendshipMetric = FriendshipMetric.DEFAULT;
      }
      
      public function getFriendshipMetric() : uint
      {
         return friendshipMetric;
      }
      
      public function isPermissionGranted(param1:int) : Boolean
      {
         if(!isPermissionAvailable(param1))
         {
            return false;
         }
         return permissionsSet[param1] == "1" ? true : false;
      }
      
      override public function toString() : String
      {
         var _loc1_:String = "Permissions:";
         _loc1_ += " Bookmark:" + permissionsSet[PERMISSION_BOOKMARKED];
         _loc1_ += " Status updates:" + permissionsSet[PERMISSION_STATUS_UPDATE];
         return "App: " + _loc1_;
      }
      
      public function getPermission(param1:int) : String
      {
         return null;
      }
      
      public function getGameURL() : String
      {
         return SocialNetwork.current.getAppURL(SocialPlatform.gameID);
      }
      
      public function isPermissionSet(param1:int) : Boolean
      {
         return isPermissionGranted(param1);
      }
      
      public function grantPermission(param1:String, param2:Function = null) : Boolean
      {
         return false;
      }
      
      public function revokePermissionTag(param1:int) : Boolean
      {
         var _loc2_:String = SocialPlatform.instance.application.getPermission(param1);
         return revokePermission(_loc2_);
      }
      
      public function grantPermissionTag(param1:int, param2:Function = null) : Boolean
      {
         var _loc3_:String = SocialPlatform.instance.application.getPermission(param1);
         return grantPermission(_loc3_,param2);
      }
      
      public function isPermissionAvailable(param1:int) : Boolean
      {
         if(!available)
         {
            return false;
         }
         return param1 > PERMISSION_LAST ? false : true;
      }
      
      override public function getFeatureHandler(param1:String) : SocialPlatformFeature
      {
         if(param1 == "bookmark")
         {
            return getFeatureBookmark();
         }
         return null;
      }
      
      public function revokePermission(param1:String, param2:Function = null) : Boolean
      {
         return false;
      }
      
      public function getFeatureBookmark() : SocialPlatformFeatureBookmark
      {
         return new SocialPlatformFeatureBookmark(this);
      }
      
      public function sendDashboardGameStatus(param1:String) : Boolean
      {
         return false;
      }
      
      public function sendDashboardUserStatus(param1:String, param2:String, param3:String) : Boolean
      {
         return false;
      }
      
      public function setFriendshipMetric(param1:uint) : uint
      {
         var _loc2_:uint = uint(friendshipMetric);
         friendshipMetric = param1;
         return _loc2_;
      }
   }
}


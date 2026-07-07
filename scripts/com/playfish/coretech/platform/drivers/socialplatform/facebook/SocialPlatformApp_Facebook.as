package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.commands.auth.RevokeAuthorization;
   import com.facebook.events.FacebookEvent;
   import com.playfish.coretech.engine.core.PFTimer;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformApp;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformAppSettings;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFeatureBookmark;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformModuleSettings;
   import com.playfish.external.*;
   
   public class SocialPlatformApp_Facebook extends SocialPlatformApp
   {
      
      private var firstPrepareAttempt:Boolean;
      
      public function SocialPlatformApp_Facebook(param1:SocialPlatformAppSettings)
      {
         super(param1);
         firstPrepareAttempt = true;
      }
      
      override public function isSupported() : Boolean
      {
         return true;
      }
      
      override public function getPermission(param1:int) : String
      {
         switch(param1)
         {
            case PERMISSION_PHOTOS_UPLOAD:
               return "photo_upload";
            case PERMISSION_EVENTS_CREATE:
            case PERMISSION_EVENTS_UPDATE:
            case PERMISSION_EVENTS_DELETE:
               return "create_event";
            case PERMISSION_EMAIL_ACCESS:
               return "email";
            default:
               return null;
         }
      }
      
      override public function prepare(param1:SocialPlatform, param2:SocialPlatformModuleSettings) : Boolean
      {
         super.prepare(param1,param2);
         if(platformBackRef.isPreparing(PREPARATION_MASK) || !param2.enable || isAvailable())
         {
            return true;
         }
         platformBackRef.onPrepareBegin(PREPARATION_MASK);
         return triggerRequest();
      }
      
      override public function sendDashboardUserStatus(param1:String, param2:String, param3:String) : Boolean
      {
         return false;
      }
      
      override public function grantPermission(param1:String, param2:Function = null) : Boolean
      {
         var _loc3_:ExternalPage = null;
         if(param1 == "email")
         {
            _loc3_ = new ExternalPage("permissions");
            _loc3_.show();
         }
         else
         {
            SocialPlatform_Facebook.facebook.grantExtendedPermission(param1);
         }
         PFTimer.startAlarm(20000,recheckPermissions);
         return true;
      }
      
      private function recheckPermissions(param1:Object = null) : Boolean
      {
         triggerRequest();
         return false;
      }
      
      override public function revokePermission(param1:String, param2:Function = null) : Boolean
      {
         var _loc3_:RevokeAuthorization = new RevokeAuthorization(SocialPlatform.instance.user.getID());
         SocialPlatform_Facebook.facebook.post(_loc3_);
         recheckPermissions();
         return true;
      }
      
      private function triggerRequest() : Boolean
      {
         var _loc1_:String = SocialPlatform.current.user.getID();
         var _loc2_:String = "SELECT bookmarked,status_update,photo_upload,create_event,email FROM permissions WHERE uid=" + _loc1_;
         return SocialPlatform_Facebook.makeQuery(_loc2_,onGetAppPermissions);
      }
      
      private function onGetAppPermissions(param1:FacebookEvent) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Namespace = null;
         var _loc2_:Boolean = available;
         if(SocialPlatform_Facebook.isValidEventSuccess(param1))
         {
            _loc3_ = new XML(param1.data.rawResult);
            if(_loc3_ != null)
            {
               _loc4_ = SocialPlatform_Facebook.fb_namespace;
               permissionsSet[PERMISSION_BOOKMARKED] = _loc3_.._loc4_::bookmarked.toString();
               permissionsSet[PERMISSION_STATUS_UPDATE] = _loc3_.._loc4_::status_update.toString();
               permissionsSet[PERMISSION_PHOTOS_UPLOAD] = _loc3_.._loc4_::photo_upload.toString();
               permissionsSet[PERMISSION_EVENTS_CREATE] = _loc3_.._loc4_::create_event.toString();
               permissionsSet[PERMISSION_EMAIL_ACCESS] = _loc3_.._loc4_::email.toString();
               available = true;
            }
         }
         if(!available && firstPrepareAttempt)
         {
            triggerRequest();
            firstPrepareAttempt = false;
         }
         else
         {
            platformBackRef.onPrepareComplete(PREPARATION_MASK,this);
         }
      }
      
      override public function getFeatureBookmark() : SocialPlatformFeatureBookmark
      {
         return new SocialPlatformFeatureBookmark_Facebook(this);
      }
   }
}


package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.events.FacebookEvent;
   import com.playfish.coretech.platform.drivers.socialstats.*;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFeatureCounter;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFeatureStatus;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformModuleSettings;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformUser;
   import com.playfish.coretech.platform.socialstats.*;
   
   public class SocialPlatformUser_Facebook extends SocialPlatformUser
   {
      
      public function SocialPlatformUser_Facebook(param1:String = null)
      {
         super(param1);
      }
      
      override public function getFeatureStatus() : SocialPlatformFeatureStatus
      {
         return new SocialPlatformFeatureStatus_Facebook(this);
      }
      
      override public function isSupported() : Boolean
      {
         return true;
      }
      
      override public function prepare(param1:SocialPlatform, param2:SocialPlatformModuleSettings) : Boolean
      {
         super.prepare(param1,param2);
         if(!param2.enable || isAvailable())
         {
            return true;
         }
         platformBackRef.onPrepareBegin(PREPARATION_MASK);
         platformBackRef.onPrepareComplete(PREPARATION_MASK,this);
         available = true;
         SocialPlatform_Facebook.makeQuery("SELECT uid,page_id FROM page_fan WHERE uid = " + getID(),onGetFanStatus);
         return true;
      }
      
      public function setFromXML(param1:XML) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Namespace = SocialPlatform_Facebook.fb_namespace;
         firstName = param1.._loc2_::first_name.toString();
         lastName = param1.._loc2_::last_name.toString();
         fullName = param1.._loc2_::name.toString();
         var _loc3_:String = param1.._loc2_::birthday_date.toString();
         setProfileEntry(SocialPlatformUser.PROFILE_BIRTHDAY,_loc3_.toString());
         var _loc4_:String = param1.._loc2_::pic_square.toString();
         setProfileEntry(SocialPlatformUser.PROFILE_SMALL_PORTRAIT_URL,_loc4_.toString());
         var _loc5_:String = param1.._loc2_::pic_big.toString();
         setProfileEntry(SocialPlatformUser.PROFILE_LARGE_PORTRAIT_URL,_loc5_.toString());
         var _loc6_:String = param1.._loc2_::online_presence.toString();
         setProfileEntry(SocialPlatformUser.PROFILE_LOGGED_IN,(_loc6_ == "active" || _loc6_ == "idle").toString());
         var _loc7_:String = param1.._loc2_::is_app_user.toString();
         setProfileEntry(SocialPlatformUser.PROFILE_APPLICATION_USER,_loc7_);
      }
      
      override public function getFeatureCounter() : SocialPlatformFeatureCounter
      {
         return new SocialPlatformFeatureCounter_Facebook(this);
      }
      
      public function onGetFanStatus(param1:FacebookEvent) : void
      {
         var _loc3_:Namespace = null;
         var _loc4_:XML = null;
         var _loc5_:* = undefined;
         if(SocialPlatform_Facebook.isValidEventSuccess(param1))
         {
            _loc3_ = SocialPlatform_Facebook.fb_namespace;
            _loc4_ = new XML(param1.data.rawResult);
            if(_loc4_ != null)
            {
               for each(_loc5_ in _loc4_.._loc3_::page_id)
               {
                  fanpageList.push(_loc5_.toString());
               }
               fanpageListAvailable = true;
            }
         }
         var _loc2_:String = SocialPlatform.current.user.getID();
         SocialPlatform.current.preparePlayer(_loc2_);
      }
   }
}


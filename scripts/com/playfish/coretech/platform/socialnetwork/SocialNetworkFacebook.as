package com.playfish.coretech.platform.socialnetwork
{
   import com.playfish.coretech.engine.utils.core.PFTextHandler;
   import com.playfish.coretech.platform.drivers.socialplatform.facebook.SocialPlatform_Facebook;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformSettings;
   
   public class SocialNetworkFacebook extends SocialNetwork
   {
      
      public function SocialNetworkFacebook()
      {
         super();
      }
      
      override public function getID() : String
      {
         return "facebook";
      }
      
      override public function getName() : String
      {
         return "Facebook";
      }
      
      override public function getAppURL(param1:String, param2:String = "") : String
      {
         return "http://apps.facebook.com/" + param1 + "/gameinfo?pf_ria=1&pf_ref=fp&lang=" + PFTextHandler.langCode + param2;
      }
      
      override public function getURL() : String
      {
         return "facebook.com";
      }
      
      override public function createPlatform(param1:String, param2:Function, param3:Object, param4:SocialPlatformSettings) : SocialPlatform
      {
         return new SocialPlatform_Facebook(param1,param2,param3,param4);
      }
   }
}


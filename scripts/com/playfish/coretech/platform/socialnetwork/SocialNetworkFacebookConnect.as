package com.playfish.coretech.platform.socialnetwork
{
   import com.playfish.coretech.platform.drivers.socialplatform.facebook.SocialPlatform_FacebookConnect;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformSettings;
   
   public class SocialNetworkFacebookConnect extends SocialNetworkFacebook
   {
      
      public function SocialNetworkFacebookConnect()
      {
         super();
      }
      
      override public function getName() : String
      {
         return "Facebook Connect";
      }
      
      override public function createPlatform(param1:String, param2:Function, param3:Object, param4:SocialPlatformSettings) : SocialPlatform
      {
         return new SocialPlatform_FacebookConnect(param1,param2,param3,param4);
      }
   }
}


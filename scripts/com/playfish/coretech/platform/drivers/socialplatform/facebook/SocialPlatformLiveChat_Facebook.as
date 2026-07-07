package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatformLiveChat;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformModuleSettings;
   
   public class SocialPlatformLiveChat_Facebook extends SocialPlatformLiveChat
   {
      
      public function SocialPlatformLiveChat_Facebook(param1:SocialPlatformModuleSettings)
      {
         super(param1);
      }
      
      override public function isSupported() : Boolean
      {
         return false;
      }
   }
}


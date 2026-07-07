package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFeatureStatus;
   
   public class SocialPlatformFeatureStatus_Facebook extends SocialPlatformFeatureStatus
   {
      
      public function SocialPlatformFeatureStatus_Facebook(param1:Object)
      {
         super(param1);
      }
      
      override public function setStatus(param1:String) : Boolean
      {
         return false;
      }
   }
}


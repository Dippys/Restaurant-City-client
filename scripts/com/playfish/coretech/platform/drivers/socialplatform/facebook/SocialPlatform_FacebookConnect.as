package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.playfish.coretech.engine.PFEngine;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformSettings;
   
   public class SocialPlatform_FacebookConnect extends SocialPlatform_Facebook
   {
      
      public function SocialPlatform_FacebookConnect(param1:String, param2:Function, param3:Object, param4:SocialPlatformSettings)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function getRetryURL() : String
      {
         return PFEngine.instance.getParameter("pf_facebook_connect_retry_url") as String;
      }
   }
}


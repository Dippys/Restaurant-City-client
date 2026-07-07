package com.playfish.coretech.platform.socialplatform
{
   public class SocialPlatformFansSettings extends SocialPlatformModuleSettings
   {
      
      public var onlyLoadCurrentGameFans:Boolean;
      
      public function SocialPlatformFansSettings(param1:Boolean = true, param2:Boolean = false)
      {
         super(param2);
         onlyLoadCurrentGameFans = param1;
      }
   }
}


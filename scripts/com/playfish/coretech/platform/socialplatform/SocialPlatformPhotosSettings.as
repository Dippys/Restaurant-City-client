package com.playfish.coretech.platform.socialplatform
{
   public class SocialPlatformPhotosSettings extends SocialPlatformModuleSettings
   {
      
      public var albumName:String;
      
      public function SocialPlatformPhotosSettings(param1:String, param2:Boolean = true)
      {
         super(param2);
         albumName = param1;
      }
   }
}


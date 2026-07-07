package com.playfish.coretech.platform.socialplatform
{
   public class SocialPlatformEvents extends SocialPlatformModule
   {
      
      public function SocialPlatformEvents(param1:SocialPlatformModuleSettings)
      {
         super();
      }
      
      public function createEvent(param1:String, param2:String, param3:String = "", param4:String = "") : SocialPlatformEvent
      {
         return new SocialPlatformEvent(param1,param2,param3,param4);
      }
   }
}


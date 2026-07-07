package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatformEvent;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformEvents;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformEventsSettings;
   
   public class SocialPlatformEvents_Facebook extends SocialPlatformEvents
   {
      
      public function SocialPlatformEvents_Facebook(param1:SocialPlatformEventsSettings)
      {
         super(param1);
         available = true;
      }
      
      override public function isSupported() : Boolean
      {
         return true;
      }
      
      override public function createEvent(param1:String, param2:String, param3:String = "", param4:String = "") : SocialPlatformEvent
      {
         return new SocialPlatformEvent_Facebook(param1,param2,param3,param4);
      }
   }
}


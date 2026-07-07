package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.commands.events.CreateEvent;
   import com.facebook.data.events.CreateEventData;
   import com.facebook.net.FacebookCall;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformEvent;
   
   public class SocialPlatformEvent_Facebook extends SocialPlatformEvent
   {
      
      public function SocialPlatformEvent_Facebook(param1:String, param2:String, param3:String, param4:String)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function publish() : Boolean
      {
         var _loc1_:CreateEventData = new CreateEventData(name,category,subcategory,host,location,city,startTime,endTime);
         _loc1_.description = description;
         var _loc2_:CreateEvent = new CreateEvent(_loc1_,null);
         var _loc3_:FacebookCall = SocialPlatform_Facebook.facebook.post(_loc2_);
         return true;
      }
   }
}


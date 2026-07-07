package com.playfish.coretech.platform.socialplatform
{
   public class SocialPlatformEvent
   {
      
      protected var description:String;
      
      protected var subcategory:String;
      
      protected var host:String;
      
      protected var name:String;
      
      protected var startTime:Date;
      
      protected var city:String;
      
      protected var location:String;
      
      protected var endTime:Date;
      
      protected var category:String;
      
      public function SocialPlatformEvent(param1:String, param2:String, param3:String, param4:String)
      {
         super();
         name = param1;
         category = "";
         subcategory = "";
         host = param2;
         location = param3;
         city = "";
         description = param4;
         setStartTime(null);
      }
      
      public function setDescription(param1:String) : void
      {
         description = param1;
      }
      
      public function setEndTime(param1:Date) : void
      {
         endTime = param1;
      }
      
      public function publish() : Boolean
      {
         return false;
      }
      
      public function setStartTime(param1:Date) : void
      {
         startTime = new Date(param1);
         endTime = new Date(param1);
      }
   }
}


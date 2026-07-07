package com.playfish.external
{
   import flash.events.Event;
   
   public class ExternalPageEvent extends Event
   {
      
      public static const COMPLETE:String = "external_page_event_complete";
      
      private var poData:*;
      
      private var psTypePage:String;
      
      public function ExternalPageEvent(param1:String, param2:*, param3:String, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         poData = param2;
         psTypePage = param3;
      }
      
      public function get typePage() : String
      {
         return psTypePage;
      }
      
      public function get data() : *
      {
         return poData;
      }
      
      override public function toString() : String
      {
         return formatToString("ExternalPageEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new ExternalPageEvent(type,poData,psTypePage,bubbles,cancelable);
      }
   }
}


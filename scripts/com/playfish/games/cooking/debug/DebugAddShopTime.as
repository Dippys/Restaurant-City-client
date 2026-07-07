package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.utils.LocalStorage;
   import flash.events.MouseEvent;
   
   public class DebugAddShopTime extends DebugEntryButton
   {
      
      public static var dayAdded:int = 0;
      
      public static var storage:LocalStorage = new LocalStorage("debug_addservertime");
      
      dayAdded = int(storage.load("daysAdded"));
      
      public function DebugAddShopTime()
      {
         super(dayAdded + " shop days added","Click to cycle through days added. After 14 days it\'ll go back to 0. Restart the game after setting the days.");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         dayAdded = (dayAdded + 1) % 15;
         button.tf_text.text = dayAdded + " shop days added";
         storage.save("daysAdded",dayAdded);
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


package com.playfish.games.cooking.debug
{
   import flash.events.MouseEvent;
   
   public class DebugDailyBonus extends DebugEntryButton
   {
      
      public static var daysLoggedInARow:int = 0;
      
      public static const spoofedGlobalItemIds:Array = [4000008,4000009,4000010];
      
      public function DebugDailyBonus()
      {
         super(daysLoggedInARow + "consecutive days logged in","Click to increment the number of consecutive days logged in");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         daysLoggedInARow = (daysLoggedInARow + 1) % 5;
         button.tf_text.text = daysLoggedInARow + " consecutive days logged in";
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


package com.playfish.games.cooking.debug
{
   import flash.events.MouseEvent;
   
   public class DebugAddBlackSheep extends DebugEntryButton
   {
      
      public static var alwaysAppear:Boolean = false;
      
      public function DebugAddBlackSheep()
      {
         super("Set Foodking to \'Appear Always\'","Only takes effect upon leaving or entering current restaurant/street");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         if(alwaysAppear)
         {
            alwaysAppear = false;
            button.tf_text.text = "Set Foodking to \'Appear Always\'";
         }
         else
         {
            button.tf_text.text = "Set Foodking to \'Appear Randomly\'";
            alwaysAppear = true;
         }
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.GameWorld;
   import flash.events.MouseEvent;
   
   public class DebugAddPlayfishCash extends DebugEntryButton
   {
      
      private var cash:int;
      
      public function DebugAddPlayfishCash(param1:int)
      {
         this.cash = param1;
         super("Add " + param1 + " Playfish Cash","Note that after adding playfish cash your save will fail if you use it to buy items you can\'t afford originally");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         GameWorld.cashPanel.addPlayfishCash(cash);
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


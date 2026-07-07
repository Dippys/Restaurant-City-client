package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.GameWorld;
   import flash.events.MouseEvent;
   
   public class DebugAddCoins extends DebugEntryButton
   {
      
      private var coins:int;
      
      public function DebugAddCoins(param1:int)
      {
         this.coins = param1;
         super("Add " + param1 + " coins","Note that after adding coins your save will fail if you use it to buy items you can\'t afford originally");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         GameWorld.cashPanel.addCoins(coins);
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


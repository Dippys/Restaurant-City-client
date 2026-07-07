package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.*;
   import flash.events.MouseEvent;
   
   public class DebugResetOutsideArea extends DebugEntryButton
   {
      
      public function DebugResetOutsideArea()
      {
         super("Reset outside area size",null);
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < GameWorld.gameUser.outsideAreaSizeItems.length)
         {
            GameWorld.saveProfileHandler.sellItem(GameWorld.gameUser.outsideAreaSizeItems[_loc2_],1,false);
            GameWorld.cashPanel.addCoins(GameWorld.getItemSellPrice(GameWorld.gameUser.outsideAreaSizeItems[_loc2_].itemConfig));
            _loc2_++;
         }
         GameWorld.gameUser.outsideAreaSizeItems = new Array();
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


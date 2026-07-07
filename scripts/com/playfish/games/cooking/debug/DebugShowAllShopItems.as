package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.WorldRestaurantEditor;
   import flash.events.MouseEvent;
   
   public class DebugShowAllShopItems extends DebugEntryButton
   {
      
      public static var on:Boolean = false;
      
      public function DebugShowAllShopItems()
      {
         super("Show all shop items","Shows all the shop items including the invisible ones.");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         on = !on;
      }
      
      override public function isAvailable() : Boolean
      {
         return Engine.curWorld is WorldRestaurantEditor;
      }
   }
}


package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import flash.events.MouseEvent;
   
   public class DebugAddAwardValue extends DebugEntryButton
   {
      
      private var valueToAdd:int;
      
      private var award:int;
      
      public function DebugAddAwardValue(param1:int, param2:int)
      {
         this.award = param1;
         this.valueToAdd = param2;
         super("Add " + param2 + " to award " + param1,null);
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         GameWorld.addAwardValue(award,valueToAdd);
      }
      
      override public function isAvailable() : Boolean
      {
         return WorldRestaurantPlay.instance != null;
      }
   }
}


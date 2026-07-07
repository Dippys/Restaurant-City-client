package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import flash.events.MouseEvent;
   
   public class DebugAddTrash extends DebugEntryButton
   {
      
      private var trash:int;
      
      public function DebugAddTrash(param1:int)
      {
         this.trash = param1;
         super("Add " + param1 + " trash",null);
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         GameWorld.gameUser.trashCount.value += trash;
      }
      
      override public function isAvailable() : Boolean
      {
         return WorldRestaurantPlay.instance != null;
      }
   }
}


package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   
   public class SeaShellTrash extends RoomItemFunction
   {
      
      private static const SEA_SHELL_TRASH_ITEMS:Array = ["Starfish","SeaShell01","SeaShell02"];
      
      public function SeaShellTrash(param1:RoomItem)
      {
         super(param1);
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         param1.trashItems = param1.trashItems.concat(SEA_SHELL_TRASH_ITEMS);
      }
   }
}


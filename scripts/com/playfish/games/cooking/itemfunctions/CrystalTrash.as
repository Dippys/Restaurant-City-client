package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   
   public class CrystalTrash extends RoomItemFunction
   {
      
      private static const CRYSTAL_TRASH_ITEMS:Array = ["Gem01","Gem02","Gem03","Gem04"];
      
      public function CrystalTrash(param1:RoomItem)
      {
         super(param1);
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         param1.trashItems = param1.trashItems.concat(CRYSTAL_TRASH_ITEMS);
         param1.maxTrashCoins = 2;
      }
   }
}


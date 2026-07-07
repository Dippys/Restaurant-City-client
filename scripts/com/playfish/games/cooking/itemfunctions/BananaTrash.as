package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   
   public class BananaTrash extends RoomItemFunction
   {
      
      private static const BANANA_TRASH_ITEMS:Array = ["BananaPeel"];
      
      public function BananaTrash(param1:RoomItem)
      {
         super(param1);
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         param1.trashItems = param1.trashItems.concat(BANANA_TRASH_ITEMS);
      }
   }
}


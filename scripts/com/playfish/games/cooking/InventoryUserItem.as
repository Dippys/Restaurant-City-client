package com.playfish.games.cooking
{
   import com.playfish.rpc.cooking.OwnedItem;
   
   public class InventoryUserItem extends UserItem
   {
      
      public function InventoryUserItem(param1:Object, param2:OwnedItem = null)
      {
         super(param1,param2);
      }
      
      override public function getOwnedItem() : OwnedItem
      {
         return null;
      }
   }
}


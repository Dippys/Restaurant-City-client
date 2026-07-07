package com.playfish.rpc.cooking
{
   public class InventoryItem
   {
      
      public var globalItemId:Number;
      
      public var isSelected:Boolean;
      
      public var number:Number;
      
      public function InventoryItem()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[Inventory id=" + globalItemId + " number=" + number + " isSelected=" + isSelected + "]";
      }
   }
}


package com.playfish.games.cooking
{
   public class InventoryUserItemGroup
   {
      
      private var itemServerIds:Array = new Array();
      
      public var itemConfig:Object;
      
      public function InventoryUserItemGroup(param1:InventoryUserItem)
      {
         super();
         this.itemConfig = param1.itemConfig;
         addInventoryUserItem(param1);
      }
      
      public function getLength() : int
      {
         return itemServerIds.length;
      }
      
      public function removeInventoryUserItem(param1:InventoryUserItem) : Boolean
      {
         var _loc2_:int = param1.serverUid;
         var _loc3_:Number = 0;
         while(_loc3_ < itemServerIds.length)
         {
            if(itemServerIds[_loc3_] == _loc2_)
            {
               itemServerIds.splice(_loc3_,1);
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function addInventoryUserItem(param1:InventoryUserItem) : void
      {
         itemServerIds.push(param1.serverUid);
      }
      
      public function getInventoryUserItem() : InventoryUserItem
      {
         var _loc1_:InventoryUserItem = null;
         if(itemServerIds.length > 0)
         {
            _loc1_ = new InventoryUserItem(itemConfig);
            _loc1_.serverUid = itemServerIds[itemServerIds.length - 1];
            return _loc1_;
         }
         return null;
      }
      
      public function getAllInventoryUserItems() : Array
      {
         var _loc3_:InventoryUserItem = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < itemServerIds.length)
         {
            _loc3_ = new InventoryUserItem(itemConfig);
            _loc3_.serverUid = itemServerIds[_loc2_];
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function removeItems(param1:int) : void
      {
         itemServerIds.splice(0,param1);
      }
   }
}


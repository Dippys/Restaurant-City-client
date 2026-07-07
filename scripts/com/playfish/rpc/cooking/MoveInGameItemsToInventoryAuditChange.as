package com.playfish.rpc.cooking
{
   public class MoveInGameItemsToInventoryAuditChange extends AuditChange
   {
      
      public var itemTypeId:uint;
      
      public var floorIndex:uint;
      
      public function MoveInGameItemsToInventoryAuditChange(param1:uint, param2:uint)
      {
         super();
         this.action = AuditChangeAction.moveInGameItemsToInventory;
         this.floorIndex = param1;
         this.itemTypeId = param2;
      }
   }
}


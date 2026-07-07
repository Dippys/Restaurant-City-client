package com.playfish.rpc.cooking
{
   import com.playfish.rpc.share.RpcRequestBase;
   
   internal class RpcRequest extends RpcRequestBase
   {
      
      public function RpcRequest()
      {
         super();
      }
      
      internal function writeInventoryItem(param1:InventoryItem) : void
      {
         writeUintvar31(param1.globalItemId);
         writeUintvar31(param1.number);
         writeBoolean(param1.isSelected);
      }
      
      internal function writeAuditChangeAction(param1:AuditChangeAction) : void
      {
         writeUint8(param1.code);
      }
      
      internal function writeEmployee(param1:Employee) : void
      {
         writeNetworkUid(param1.id);
         writeUintvar31(param1.happiness);
         writeUint8(param1.task);
         writeBoolean(param1.notify);
      }
      
      internal function writeMail(param1:Mail) : void
      {
         writeNetworkUid(param1.recipientId);
         writeArray(param1.globalItemIds,writeUintvar31);
         writeIntvar32(param1.itemId);
         writeString(param1.message);
         writeUint8(param1.type);
      }
      
      internal function writeOwnedItem(param1:OwnedItem) : void
      {
         writeIntvar32(param1.id);
         writeUintvar31(param1.globalItemId);
         writeIntvar32(param1.positionX);
         writeIntvar32(param1.positionY);
         writeUint8(param1.data);
         writeNetworkUid(param1.employeeId);
         writeUint8(param1.roomIndex);
      }
      
      internal function writeProfile(param1:UserInfo) : void
      {
         writeNetworkUid(param1.id);
         writeString(param1.restaurantName);
         writeUintvar32(param1.gourmetPoint);
         writeUintvar31(param1.trashPoint);
         writeUintvar31(param1.demandPoint);
         writeUintvar31(param1.musicPlay);
         writeBoolean(param1.isInStreet);
         writeBoolean(param1.awards == null ? false : true);
         if(param1.awards != null)
         {
            writeByteArray(param1.awards);
         }
         writeUint8(param1.userLevel);
         writeUint8(param1.activeFloorIndex);
      }
      
      internal function writeAuditChange(param1:AuditChange) : void
      {
         writeUint8(param1.action);
         writeUintvar31(param1.newCredits);
         writeIntvar32(param1.creditsDelta);
         switch(param1.action)
         {
            case AuditChangeAction.fromGameToInventory:
            case AuditChangeAction.fromInventoryToGame:
            case AuditChangeAction.saveOwnedItem:
               writeOwnedItem(param1.ownedItem);
               break;
            case AuditChangeAction.fireEmployee:
            case AuditChangeAction.hireEmployee:
            case AuditChangeAction.updateEmployee:
               writeArray(param1.employees,writeEmployee);
               break;
            case AuditChangeAction.lockIngredient:
               writeArray(param1.ingredients,writeUintvar31);
               writeBoolean(param1.flag);
               break;
            case AuditChangeAction.saveFloor:
               writeArray(param1.floor,writeUintvar31);
               break;
            case AuditChangeAction.saveFloors:
               writeArray(param1.floors,writeFloor);
               break;
            case AuditChangeAction.purchaseInventoryItem:
            case AuditChangeAction.purchasePerks:
               writeString(param1.itemToken);
               writeUintvar31(param1.qty);
               break;
            case AuditChangeAction.purchaseOwnedItem:
               writeString(param1.itemToken);
               writeOwnedItem(param1.ownedItem);
               break;
            case AuditChangeAction.sellInventoryItem:
               writeString(param1.itemToken);
               writeInventoryItem(param1.inventoryItem);
               break;
            case AuditChangeAction.sellOwnedItem:
               writeOwnedItem(param1.ownedItem);
               writeString(param1.itemToken);
               break;
            case AuditChangeAction.openMail:
            case AuditChangeAction.deleteMail:
               writeArray(param1.mailId,writeUintvar32);
               break;
            case AuditChangeAction.addRecipe:
               writeString(param1.itemToken);
               break;
            case AuditChangeAction.lvlUpdate:
               writeUintvar31(param1.qty);
               break;
            case AuditChangeAction.purchaseIngredient:
               writeUintvar31(param1.itemId);
               writeUintvar31(param1.qty);
               break;
            case AuditChangeAction.selectRecipe:
               writeUintvar31(param1.itemId);
               writeBoolean(param1.flag);
               break;
            case AuditChangeAction.seedPlant:
            case AuditChangeAction.waterPlant:
            case AuditChangeAction.harvestPlant:
               writeUintvar31(param1.itemId);
               break;
            case AuditChangeAction.consumeItem:
               writeUintvar31(param1.itemId);
               break;
            case AuditChangeAction.creditVisitFriend:
               writeNetworkUid(param1.uid);
               break;
            case AuditChangeAction.moveInGameItemsToInventory:
               writeUintvar31(MoveInGameItemsToInventoryAuditChange(param1).floorIndex);
               writeUintvar31(MoveInGameItemsToInventoryAuditChange(param1).itemTypeId);
         }
      }
      
      internal function writeFloor(param1:Floor) : void
      {
         writeUintvar31(param1.floorIndex);
         writeArray(param1.tiles,writeUintvar31);
      }
      
      internal function writeAuditChangeBatch(param1:AuditChangeBatch) : void
      {
         writeUintvar31(param1.saveVersion);
         writeUintvar32(param1.timeOnClient);
         writeArray(param1.auditChanges,writeAuditChange);
      }
   }
}


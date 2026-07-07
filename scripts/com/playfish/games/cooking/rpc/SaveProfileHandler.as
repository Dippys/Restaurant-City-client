package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.GameEvent;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   
   public class SaveProfileHandler extends RpcBase
   {
      
      private static var maintenanceInfoPopUp:WorldInfoPopUp;
      
      private static var saveVersion:int = 1;
      
      private var recipesToAdd:Array = new Array();
      
      private var levelUpLevels:Array = new Array();
      
      private var itemAuditChanges:Array = new Array();
      
      private var paidMeals:Array = new Array();
      
      private var mailsOpened:Array = new Array();
      
      private var selectRecipeAuditChanges:Array = new Array();
      
      private var purchaseIngredientAuditChanges:Array = new Array();
      
      private var gardenAuditChanges:Array = new Array();
      
      private var visitBonuses:Array = new Array();
      
      private var ingredientsUnlocked:Array = new Array();
      
      private var shakenTrees:int = 0;
      
      private var itemsConsumed:Array = new Array();
      
      public var harvestedIngredients:Array = new Array();
      
      private var mailsDeleted:Array = new Array();
      
      private var trashPicked:int = 0;
      
      private var employeesFired:Array = new Array();
      
      private var employeesHired:Array = new Array();
      
      private var ingredientsLocked:Array = new Array();
      
      public var displayMaintenance:Boolean = true;
      
      private var perkItems:Array = new Array();
      
      private var paidFunctionals:Array = new Array();
      
      private var employeesUpdated:Array = new Array();
      
      private var offLineMoney:int;
      
      private var saveRoomFloors:Array = new Array();
      
      public function SaveProfileHandler()
      {
         super();
         priority = 1;
      }
      
      public function sellItem(param1:UserItem, param2:int, param3:Boolean) : void
      {
         var _loc4_:AuditChange = new AuditChange();
         if(param3)
         {
            Debug.out("AuditChangeAction.sellInventoryItem");
            _loc4_.action = AuditChangeAction.sellInventoryItem;
            _loc4_.inventoryItem = new InventoryItem();
            _loc4_.inventoryItem.globalItemId = param1.itemConfig.id;
            _loc4_.inventoryItem.number = param2;
         }
         else
         {
            Debug.out("AuditChangeAction.sellOwnedItem " + param1.getOwnedItem());
            _loc4_.action = AuditChangeAction.sellOwnedItem;
            _loc4_.ownedItem = param1.getOwnedItem();
         }
         _loc4_.itemToken = param1.itemConfig.hash;
         itemAuditChanges.push(_loc4_);
      }
      
      private function getAuditChangeForItem(param1:UserItem, param2:int) : AuditChange
      {
         var _loc4_:AuditChange = null;
         var _loc3_:int = 0;
         while(_loc3_ < itemAuditChanges.length)
         {
            _loc4_ = itemAuditChanges[_loc3_];
            if(Boolean(_loc4_.ownedItem) && Boolean(_loc4_.ownedItem.id == param1.serverUid) && _loc4_.action == param2)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function moveItem(param1:UserItem, param2:Boolean) : void
      {
         var _loc3_:OwnedItem = param1.getOwnedItem();
         var _loc4_:AuditChange = null;
         var _loc5_:AuditChange = null;
         if(!param2)
         {
            Debug.out("item.fromInventory=" + param2);
            if(_loc3_ != null)
            {
               Debug.out("AuditChangeAction.saveOwnedItem");
               _loc4_ = getAuditChangeForItem(param1,AuditChangeAction.saveOwnedItem);
               if(_loc4_)
               {
                  _loc4_.ownedItem = _loc3_;
               }
               else
               {
                  _loc4_ = getAuditChangeForItem(param1,AuditChangeAction.fromInventoryToGame);
                  if(_loc4_)
                  {
                     _loc4_.ownedItem = _loc3_;
                  }
                  else
                  {
                     _loc5_ = new AuditChange();
                     _loc5_.action = AuditChangeAction.saveOwnedItem;
                     _loc5_.ownedItem = _loc3_;
                  }
               }
            }
            else
            {
               Debug.out("AuditChangeAction.fromGameToInventory");
               _loc4_ = getAuditChangeForItem(param1,AuditChangeAction.saveOwnedItem);
               if(_loc4_)
               {
                  _loc4_.action = AuditChangeAction.fromGameToInventory;
                  _loc4_.ownedItem = new OwnedItem();
                  _loc4_.ownedItem.globalItemId = param1.itemConfig.id;
                  _loc4_.ownedItem.id = param1.serverUid;
               }
               else
               {
                  _loc4_ = getAuditChangeForItem(param1,AuditChangeAction.fromInventoryToGame);
                  if(_loc4_)
                  {
                     itemAuditChanges.splice(itemAuditChanges.indexOf(_loc4_),1);
                  }
                  else
                  {
                     _loc5_ = new AuditChange();
                     _loc5_.action = AuditChangeAction.fromGameToInventory;
                     _loc5_.ownedItem = new OwnedItem();
                     _loc5_.ownedItem.globalItemId = param1.itemConfig.id;
                     _loc5_.ownedItem.id = param1.serverUid;
                  }
               }
            }
         }
         else
         {
            Debug.out("fromInventory=" + param2);
            if(_loc3_)
            {
               Debug.out("AuditChangeAction.fromInventoryToGame");
               _loc4_ = getAuditChangeForItem(param1,AuditChangeAction.fromGameToInventory);
               if(_loc4_)
               {
                  _loc4_.action = AuditChangeAction.saveOwnedItem;
                  _loc4_.ownedItem = _loc3_;
               }
               else
               {
                  _loc5_ = new AuditChange();
                  _loc5_.action = AuditChangeAction.fromInventoryToGame;
                  _loc5_.ownedItem = _loc3_;
               }
            }
         }
         if(_loc5_ != null)
         {
            _loc5_.itemToken = param1.itemConfig.hash;
            _loc5_.qty = 1;
            itemAuditChanges.push(_loc5_);
         }
      }
      
      public function addRecipe(param1:Recipe) : void
      {
         recipesToAdd.push(param1);
      }
      
      public function harvestPlant(param1:int, param2:Object) : void
      {
         var _loc3_:AuditChange = new AuditChange();
         _loc3_.action = AuditChangeAction.harvestPlant;
         _loc3_.itemId = param1;
         gardenAuditChanges.push(_loc3_);
         harvestedIngredients.push(param2);
      }
      
      public function saveRestaurantFloor(param1:int) : void
      {
         var _loc2_:Floor = GameWorld.gameUser.floors[param1];
         if(saveRoomFloors.indexOf(_loc2_) == -1)
         {
            saveRoomFloors.push(_loc2_);
         }
      }
      
      public function waterPlantForFriend(param1:NetworkUid, param2:int) : void
      {
         var _loc3_:AuditChange = null;
      }
      
      public function waterPlant(param1:int) : void
      {
         var _loc4_:AuditChange = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < gardenAuditChanges.length)
         {
            _loc4_ = gardenAuditChanges[_loc3_];
            if(_loc4_.action == AuditChangeAction.waterPlant && _loc4_.itemId == param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         if(_loc2_ < 3)
         {
            _loc4_ = new AuditChange();
            _loc4_.action = AuditChangeAction.waterPlant;
            _loc4_.itemId = param1;
            gardenAuditChanges.push(_loc4_);
         }
      }
      
      public function hasItemsChanged() : Boolean
      {
         return itemAuditChanges.length > 0 || saveRoomFloors.length > 0;
      }
      
      public function addDeletedMail(param1:MailItem) : void
      {
         mailsDeleted.push(param1.mailObject.id);
      }
      
      public function addTrash() : void
      {
         ++trashPicked;
      }
      
      public function addHiredEmployees(param1:GameUserEmployee, param2:Boolean) : void
      {
         param1.notification = param2;
         employeesHired.push(param1);
      }
      
      public function selectRecipe(param1:int, param2:Boolean) : void
      {
         var _loc4_:AuditChange = null;
         var _loc3_:int = 0;
         while(_loc3_ < selectRecipeAuditChanges.length)
         {
            _loc4_ = selectRecipeAuditChanges[_loc3_];
            if(_loc4_.itemId == param1)
            {
               if(_loc4_.flag != param2)
               {
                  selectRecipeAuditChanges.splice(_loc3_,1);
               }
               return;
            }
            _loc3_++;
         }
         _loc4_ = new AuditChange();
         _loc4_.action = AuditChangeAction.selectRecipe;
         _loc4_.itemId = param1;
         _loc4_.flag = param2;
         selectRecipeAuditChanges.push(_loc4_);
      }
      
      public function addUnlockedIngredient(param1:IngredientItem) : void
      {
         var _loc2_:int = ingredientsLocked.indexOf(param1.itemConfig.id);
         if(_loc2_ != -1)
         {
            ingredientsLocked.splice(_loc2_,1);
         }
         else
         {
            ingredientsUnlocked.push(param1.itemConfig.id);
         }
      }
      
      public function consumeItem(param1:int) : void
      {
         itemsConsumed.push(param1);
      }
      
      private function onSavePlayerProfileFail() : void
      {
         var _loc1_:RpcEvent = null;
         Debug.out("onSavePlayerProfileFail");
         if(Debug.NETWORK_ONLY)
         {
            if(hasEventListener(RpcEvent.FAIL))
            {
               dispatchEvent(new RpcEvent(RpcEvent.FAIL));
            }
         }
         else if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc1_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc1_.successCode = 0;
            dispatchEvent(_loc1_);
         }
      }
      
      override public function commit() : Boolean
      {
         var _loc5_:AuditChange = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc1_:Array = new Array();
         Debug.out("shakenTrees=" + shakenTrees);
         var _loc2_:int = 0;
         while(_loc2_ < shakenTrees)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.creditShakeTree;
            _loc5_.creditsDelta = GameWorld.SHAKE_TREE_COIN;
            _loc1_.push(_loc5_);
            _loc2_++;
         }
         Debug.out("trashPicked=" + trashPicked);
         _loc2_ = 0;
         while(_loc2_ < trashPicked)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.pickUpTrash;
            _loc5_.creditsDelta = GameWorld.SHAKE_TREE_COIN;
            _loc1_.push(_loc5_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < visitBonuses.length)
         {
            Debug.out("visitBonuses.length=" + visitBonuses.length);
            _loc1_.push(visitBonuses[_loc2_]);
            _loc2_++;
         }
         Debug.out("paidMeals=" + paidMeals);
         _loc2_ = 0;
         while(_loc2_ < paidMeals.length)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.creditChangeBuyMeal;
            _loc5_.creditsDelta = paidMeals[_loc2_];
            Debug.out("auditChange.creditsDelta=" + _loc5_.creditsDelta);
            _loc1_.push(_loc5_);
            _loc2_++;
         }
         Debug.out("paidFunctionals=" + paidFunctionals);
         _loc2_ = 0;
         while(_loc2_ < paidFunctionals.length)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.creditFunctionalItem;
            _loc5_.creditsDelta = paidFunctionals[_loc2_];
            Debug.out("auditChange.creditsDelta=" + _loc5_.creditsDelta);
            _loc1_.push(_loc5_);
            _loc2_++;
         }
         Debug.out("purchaseIngredientAuditChanges=" + purchaseIngredientAuditChanges);
         _loc1_ = _loc1_.concat(purchaseIngredientAuditChanges);
         if(ingredientsLocked.length > 0)
         {
            Debug.out("ingredientsLocked=" + ingredientsLocked);
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.lockIngredient;
            _loc5_.ingredients = ingredientsLocked;
            _loc5_.flag = true;
            _loc1_.push(_loc5_);
         }
         if(ingredientsUnlocked.length > 0)
         {
            Debug.out("ingredientsUnlocked=" + ingredientsUnlocked);
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.lockIngredient;
            _loc5_.ingredients = ingredientsUnlocked;
            _loc5_.flag = false;
            _loc1_.push(_loc5_);
         }
         Debug.out("mailsOpened=" + mailsOpened);
         if(mailsOpened.length > 0)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.openMail;
            _loc5_.mailId = mailsOpened;
            _loc1_.push(_loc5_);
         }
         Debug.out("mailsDeleted=" + mailsDeleted);
         if(mailsDeleted.length > 0)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.deleteMail;
            _loc5_.mailId = mailsDeleted;
            _loc1_.push(_loc5_);
         }
         Debug.out("employeesHired=" + employeesHired);
         if(employeesHired.length > 0)
         {
            _loc6_ = getEmployees(employeesHired);
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.hireEmployee;
            _loc5_.employees = _loc6_;
            _loc1_.push(_loc5_);
         }
         Debug.out("employeesUpdated=" + employeesUpdated);
         if(employeesUpdated.length > 0)
         {
            _loc6_ = getEmployees(employeesUpdated);
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.updateEmployee;
            _loc5_.employees = _loc6_;
            _loc1_.push(_loc5_);
         }
         Debug.out("employeesFired=" + employeesFired);
         if(employeesFired.length > 0)
         {
            _loc6_ = getEmployees(employeesFired);
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.fireEmployee;
            _loc5_.employees = _loc6_;
            _loc1_.push(_loc5_);
         }
         Debug.out("levelUpLevels=" + levelUpLevels);
         _loc2_ = 0;
         while(_loc2_ < levelUpLevels.length)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.lvlUpdate;
            _loc5_.creditsDelta = GameWorld.LEVEL_THRESHOLDS[levelUpLevels[_loc2_]].coinReward;
            _loc5_.qty = levelUpLevels[_loc2_];
            _loc1_.push(_loc5_);
            _loc2_++;
         }
         if(saveVersion == 1 && offLineMoney > 0)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.creditChangeOffLine;
            _loc5_.creditsDelta = offLineMoney;
            _loc1_.push(_loc5_);
         }
         Debug.out("perkItems=" + perkItems);
         _loc2_ = 0;
         while(_loc2_ < perkItems.length)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.purchasePerks;
            _loc5_.itemToken = perkItems[_loc2_].itemConfig.hash;
            _loc1_.push(_loc5_);
            _loc2_++;
         }
         Debug.out("itemsConsumed=" + itemsConsumed);
         _loc2_ = 0;
         while(_loc2_ < itemsConsumed.length)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.consumeItem;
            _loc5_.itemId = itemsConsumed[_loc2_];
            _loc1_.push(_loc5_);
            _loc2_++;
         }
         Debug.out("itemAuditChanges=" + itemAuditChanges);
         if(itemAuditChanges)
         {
            _loc1_ = _loc1_.concat(itemAuditChanges);
         }
         Debug.out("saveRoomFloors=" + saveRoomFloors);
         if(saveRoomFloors.length > 0)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.saveFloors;
            _loc5_.floors = saveRoomFloors;
            _loc1_.push(_loc5_);
            _loc7_ = 0;
            while(_loc7_ < saveRoomFloors.length)
            {
               Debug.out("save floor roomIndex=" + saveRoomFloors[_loc7_].floorIndex + " tiles.lenght=" + saveRoomFloors[_loc7_].tiles.length);
               _loc7_++;
            }
         }
         Debug.out("gardenAuditChanges=" + gardenAuditChanges.length);
         _loc1_ = _loc1_.concat(gardenAuditChanges);
         Debug.out("recipesToAdd=" + recipesToAdd);
         _loc2_ = 0;
         while(_loc2_ < recipesToAdd.length)
         {
            _loc5_ = new AuditChange();
            _loc5_.action = AuditChangeAction.addRecipe;
            _loc5_.itemToken = recipesToAdd[_loc2_].config.hash;
            Debug.out("auditChange.itemToken=" + _loc5_.itemToken);
            _loc1_.push(_loc5_);
            _loc2_++;
         }
         Debug.out("selectRecipeAuditChanges=" + selectRecipeAuditChanges.length);
         _loc1_ = _loc1_.concat(selectRecipeAuditChanges);
         var _loc3_:AuditChangeBatch = new AuditChangeBatch();
         _loc3_.auditChanges = _loc1_;
         _loc3_.saveVersion = saveVersion;
         var _loc4_:UserInfo = GameWorld.gameUser.getProfile();
         Debug.out("save demandPoints " + _loc4_.demandPoint);
         Debug.out("save trashPoints " + _loc4_.trashPoint);
         Debug.out("save musicPlay " + _loc4_.musicPlay);
         GameWorld.rpcClient.savePlayerProfile(_loc4_,_loc3_,onSavePlayerProfileOk,onSavePlayerProfileFail);
         return true;
      }
      
      public function addFiredEmployees(param1:GameUserEmployee, param2:Boolean) : void
      {
         param1.notification = param2;
         employeesFired.push(param1);
         var _loc3_:int = employeesUpdated.indexOf(param1);
         if(_loc3_ != -1)
         {
            employeesUpdated.splice(_loc3_,1);
         }
      }
      
      public function purchaseItem(param1:UserItem) : void
      {
         var _loc2_:OwnedItem = param1.getOwnedItem();
         var _loc3_:AuditChange = new AuditChange();
         if(_loc2_ == null)
         {
            Debug.out("purchase inventory item");
            _loc3_.action = AuditChangeAction.purchaseInventoryItem;
         }
         else
         {
            Debug.out("purchase owned item");
            _loc3_.action = AuditChangeAction.purchaseOwnedItem;
            _loc3_.ownedItem = _loc2_;
         }
         _loc3_.itemToken = param1.itemConfig.hash;
         _loc3_.qty = 1;
         itemAuditChanges.push(_loc3_);
      }
      
      public function addLockedIngredient(param1:IngredientItem) : void
      {
         var _loc2_:int = ingredientsUnlocked.indexOf(param1.itemConfig.id);
         if(_loc2_ != -1)
         {
            ingredientsUnlocked.splice(_loc2_,1);
         }
         else
         {
            ingredientsLocked.push(param1.itemConfig.id);
         }
      }
      
      public function addOffLineMoney(param1:int) : void
      {
         offLineMoney = param1;
      }
      
      public function levelUp(param1:int) : void
      {
         levelUpLevels.push(param1);
      }
      
      public function purchasePerkItem(param1:UserItem) : void
      {
         perkItems.push(param1);
      }
      
      public function addUpdatedEmployees(param1:GameUserEmployee) : void
      {
         if(employeesHired.indexOf(param1) == -1 && employeesUpdated.indexOf(param1) == -1)
         {
            employeesUpdated.push(param1);
         }
      }
      
      public function addOpenedMail(param1:MailItem) : void
      {
         mailsOpened.push(param1.mailObject.id);
      }
      
      private function getEmployees(param1:Array) : Array
      {
         var _loc4_:Employee = null;
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new Employee();
            _loc4_.id = param1[_loc3_].gameUser.userInfo.id;
            _loc4_.happiness = param1[_loc3_].workTime;
            _loc4_.task = param1[_loc3_].job;
            _loc4_.notify = param1[_loc3_].notification;
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function moveAllInGameItemsToInventory(param1:int, param2:int) : void
      {
         var _loc3_:MoveInGameItemsToInventoryAuditChange = new MoveInGameItemsToInventoryAuditChange(param1,param2);
         itemAuditChanges.push(_loc3_);
      }
      
      public function purchaseIngredientItem(param1:int) : void
      {
         var _loc3_:AuditChange = null;
         var _loc2_:int = 0;
         while(_loc2_ < purchaseIngredientAuditChanges.length)
         {
            _loc3_ = purchaseIngredientAuditChanges[_loc2_];
            if(_loc3_.itemId == param1)
            {
               ++_loc3_.qty;
               return;
            }
            _loc2_++;
         }
         _loc3_ = new AuditChange();
         _loc3_.action = AuditChangeAction.purchaseIngredient;
         _loc3_.itemId = param1;
         _loc3_.qty = 1;
         purchaseIngredientAuditChanges.push(_loc3_);
      }
      
      public function addShakenTree() : void
      {
         ++shakenTrees;
      }
      
      private function onSavePlayerProfileOk(param1:Number, param2:Number, param3:Array, param4:Array, param5:uint, param6:Array) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Mail = null;
         var _loc9_:InventoryUserItem = null;
         var _loc10_:GameEvent = null;
         var _loc11_:Plot = null;
         var _loc12_:RpcEvent = null;
         Debug.out("onSavePlayerProfileOk success=" + param1 + " version=" + param2 + " new mails=" + param3 + " timeToMaintenance=" + param5);
         saveVersion = param2 + 1;
         if((param1 & RpcClient.STATUS_SAVE_FAIL) == 0)
         {
            Debug.out("RpcClient.STATUS_OK");
            if(param3 != null && param3.length > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < param3.length)
               {
                  _loc8_ = param3[_loc7_];
                  GameWorld.addNewMail(_loc8_);
                  if(_loc8_.globalItemIds[0] > 0)
                  {
                     _loc9_ = new InventoryUserItem(GameWorld.getItemConfig(_loc8_.globalItemIds[0]));
                     GameWorld.gameUser.addInventoryItem(_loc9_);
                  }
                  _loc7_++;
               }
               if(WorldRestaurantPlay.instance != null)
               {
                  WorldRestaurantPlay.instance.refreshMails();
               }
            }
            if(param4 != null)
            {
               Debug.out("ingredients changes. prev ingredients " + GameWorld.gameUser.ingredients + " new ingredients " + param4);
               GameWorld.gameUser.setIngredients(param4);
               if(GameWorld.gameEventDispatcher.hasEventListener(GameEvent.INGREDIENT_CHANGED))
               {
                  _loc10_ = new GameEvent(GameEvent.INGREDIENT_CHANGED);
                  GameWorld.gameEventDispatcher.dispatchEvent(_loc10_);
               }
            }
            if(param6)
            {
               _loc7_ = 0;
               while(_loc7_ < param6.length)
               {
                  _loc11_ = param6[_loc7_];
                  GameWorld.gameUser.gardenPlots[_loc11_.id].setPlot(_loc11_);
                  Debug.out("update plot " + _loc11_.id + " ingredient id=" + _loc11_.ingredientId);
                  _loc7_++;
               }
            }
         }
         if((param1 & RpcClient.SAVE_USER_PROFILE_FAIL_MISSED_INGREDIENT) != 0)
         {
            Debug.out("RpcClient.SAVE_USER_PROFILE_FAIL_MISSED_INGREDIENT");
         }
         if((param1 & RpcClient.SAVE_USER_PROFILE_FAIL_ADD_RECIPE) != 0)
         {
            Debug.out("RpcClient.SAVE_USER_PROFILE_FAIL_ADD_RECIPE");
         }
         if(maintenanceInfoPopUp != null && !maintenanceInfoPopUp.isShown())
         {
            maintenanceInfoPopUp = null;
         }
         if(displayMaintenance && param5 > 0 && maintenanceInfoPopUp == null)
         {
            if(param5 <= 1800)
            {
               maintenanceInfoPopUp = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("MaintenanceMessage"));
               maintenanceInfoPopUp.show();
            }
         }
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc12_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc12_.successCode = param1;
            dispatchEvent(_loc12_);
         }
      }
      
      public function isIngredientHarvested(param1:Object) : Boolean
      {
         var _loc2_:int = int(param1.id);
         var _loc3_:int = 0;
         while(_loc3_ < harvestedIngredients.length)
         {
            if(harvestedIngredients[_loc3_].id == _loc2_)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function completedActivityFor(param1:NetworkUid) : void
      {
         var _loc2_:AuditChange = new AuditChange();
         _loc2_.action = AuditChangeAction.creditVisitFriend;
         _loc2_.uid = param1;
         _loc2_.creditsDelta = GameWorld.getVisitRewardAmount();
         visitBonuses.push(_loc2_);
      }
      
      public function addPaidMeal(param1:int) : void
      {
         paidMeals.push(param1);
      }
      
      public function addPaidFunctional(param1:int) : void
      {
         paidFunctionals.push(param1);
      }
      
      public function plantSeed(param1:int) : void
      {
         var _loc2_:AuditChange = new AuditChange();
         _loc2_.action = AuditChangeAction.seedPlant;
         _loc2_.itemId = param1;
         gardenAuditChanges.push(_loc2_);
      }
   }
}


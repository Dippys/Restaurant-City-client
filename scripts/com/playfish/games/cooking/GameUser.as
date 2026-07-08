package com.playfish.games.cooking
{
   import com.playfish.games.cooking.utils.ProtectedInt;
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class GameUser extends EventDispatcher
   {
      
      public static const DEFAULT_MALE_AVATAR_ITEMS:Array = [{
         "name":"Classic",
         "group":"Hair"
      },{
         "name":"Blue Fish Shirt",
         "group":"Shirt"
      },{
         "name":"Classic Pants",
         "group":"Pants"
      },{
         "name":"No Extra",
         "group":"Miscellaneous"
      },{
         "name":"No Beard",
         "group":"Facial Hair"
      }];
      
      public static const DEFAULT_FEMALE_AVATAR_ITEMS:Array = [{
         "name":"Shoulder Long Hair",
         "group":"Hair"
      },{
         "name":"Hot Pink Fish Shirt",
         "group":"Shirt"
      },{
         "name":"Classic Skirt",
         "group":"Skirt"
      },{
         "name":"No Extra",
         "group":"Miscellaneous"
      },{
         "name":"No Beard",
         "group":"Facial Hair"
      }];
      
      public static const GENDER_NEUTRAL:int = 0;
      
      public static const GENDER_MALE:int = 1;
      
      public static const GENDER_FEMALE:int = 2;
      
      public static const ITEM_CONTEXT_AVATAR:int = RpcClient.ITEM_CONTEXT_CLOTHES;
      
      public static const ITEM_CONTEXT_BUILDING:int = RpcClient.ITEM_CONTEXT_RESTAURANT_FACADE;
      
      public static const ITEM_CONTEXT_RESTAURANT:int = RpcClient.ITEM_CONTEXT_RESTAURANT_INSIDE;
      
      public static const ITEM_CONTEXT_INGREDIENT:int = RpcClient.ITEM_CONTEXT_INGREDIENT;
      
      public static const ITEM_TYPE_AVATAR:int = 1;
      
      public static const ITEM_TYPE_BUILDING:int = 2;
      
      public static const ITEM_TYPE_RESTAURANT:int = 3;
      
      public static const ITEM_TYPE_INGREDIENT:int = 4;
      
      public static const ITEM_TYPE_RECIPE:int = 5;
      
      public static const ITEM_TYPE_PERK:int = 6;
      
      public static const RESTAURANT_ITEM_TYPE_MUSIC:int = 360;
      
      public static const RESTAURANT_ITEM_TYPE_OUTSIDE_AREA_SIZE:int = 390;
      
      public static const RESTAURANT_ITEM_TYPE_DELIVERY_BIKE:int = 391;
      
      public static const PERK_ITEM_TYPE_COIN_REWARD:int = 602;
      
      public static const PERK_ITEM_TYPE_DEMAND_REWARD:int = 603;
      
      public var employeeCount:ProtectedInt = new ProtectedInt(0);
      
      public var isoAnimationFrames:Array;
      
      public var usedRestaurantItems:Array = new Array();
      
      public var demandPoints:ProtectedInt = new ProtectedInt(GameWorld.DEFAULT_DEMAND);
      
      public var employeeUsers:Array = new Array();
      
      public var imageUrl:String = "";
      
      public var userInfo:UserInfo;
      
      public var musicId:int = 0;
      
      public var settings:GameSettings = new GameSettings();
      
      public var employerUser:GameUser;
      
      public var loadingItemContext:int = 0;
      
      public var inventoryItemGroups:Array = new Array();
      
      public var mailItems:Array = new Array();
      
      public var hairColour:int;
      
      public var firstName:String = "";
      
      public var bannerText:String;
      
      public var gardenPlots:Array = new Array();
      
      public var level:ProtectedInt = new ProtectedInt(0);
      
      public var outsideAreaSizeItems:Array = new Array();
      
      public var rated:Boolean = false;
      
      public var avatarFrame:Bitmap;
      
      public var musicItems:Array = new Array();
      
      public var skinColour:int;
      
      public var customerAvatarItemsGenerator:Function;
      
      public var usedBuildingItems:Array = new Array();
      
      public var trashCount:ProtectedInt = new ProtectedInt(0);
      
      public var fullName:String = "";
      
      public var awards:GameAwards = new GameAwards();
      
      public var money:ProtectedInt = new ProtectedInt(0);
      
      public var ingredients:Array = new Array();
      
      public var deliveryBikeItems:Array = new Array();
      
      public var activeFloorIndex:int = 0;
      
      public var loadedItemContext:int = 0;
      
      public var playfishCash:ProtectedInt = new ProtectedInt(0);
      
      public var floors:Array = new Array();
      
      public var usedAvatarItems:Array = new Array();
      
      public var ownedRecipeItems:Array = new Array();
      
      public var gourmetPoints:ProtectedInt = new ProtectedInt(0);
      
      public function GameUser(param1:UserInfo)
      {
         super();
         setProfile(param1);
      }
      
      public static function getRandomCustomerAvatarItems() : Array
      {
         Debug.out("getRandomCustomerAvatarItems");
         var _loc1_:Array = new Array();
         var _loc2_:Array = GameWorld.avatarItemDatabase.getItemsAboveCost("Shirt",0);
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Hair");
         var _loc3_:AvatarItem = new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]);
         _loc1_.push(_loc3_);
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Eyes");
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Mouth");
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Eyebrows");
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItemsBelowCost("HairColour",100);
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItemsBelowCost("SkinColour",100);
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         if(Engine.rnd(0,2) == 0)
         {
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Beard","Facial Hair")));
            _loc2_ = GameWorld.avatarItemDatabase.getItems("Skirt");
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         }
         else
         {
            if(Engine.rnd(0,2) == 0)
            {
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Beard","Facial Hair")));
            }
            else
            {
               _loc2_ = GameWorld.avatarItemDatabase.getItems("Facial Hair");
               _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            }
            _loc2_ = GameWorld.avatarItemDatabase.getItemsAboveCost("Pants",0);
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         }
         if(Engine.rnd(0,2) == 0)
         {
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Extra","Miscellaneous")));
         }
         else
         {
            _loc2_ = GameWorld.avatarItemDatabase.getItems("Miscellaneous");
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         }
         if(Engine.rnd(0,2) == 0)
         {
            if(!_loc3_.itemConfig.noHat)
            {
               _loc2_ = GameWorld.avatarItemDatabase.getItems("Hat");
               _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            }
         }
         return _loc1_;
      }
      
      public function setIngredients(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Ingredient = null;
         var _loc4_:Object = null;
         var _loc5_:IngredientItem = null;
         var _loc6_:Number = NaN;
         var _loc7_:Array = null;
         var _loc8_:IngredientItem = null;
         Debug.out("profile.ingredients=" + userInfo.ingredients);
         userInfo.ingredients = param1;
         ingredients.splice(0,ingredients.length);
         if(userInfo.ingredients)
         {
            _loc2_ = 0;
            while(_loc2_ < userInfo.ingredients.length)
            {
               _loc3_ = userInfo.ingredients[_loc2_];
               _loc4_ = GameWorld.getItemConfig(_loc3_.globalItemId);
               Debug.out("ingredient.globalItemId=" + _loc3_.globalItemId);
               if(_loc4_ != null)
               {
                  _loc5_ = new IngredientItem(GameWorld.getItemConfig(_loc3_.globalItemId));
                  _loc5_.count = _loc3_.number;
                  _loc5_.lock = _loc3_.isLocked;
                  _loc6_ = 0;
                  while(_loc6_ < ingredients.length)
                  {
                     if(_loc5_.rarity < ingredients[_loc6_].rarity || _loc5_.rarity == ingredients[_loc6_].rarity && _loc5_.itemConfig.name < ingredients[_loc6_].itemConfig.name)
                     {
                        ingredients.splice(_loc6_,0,_loc5_);
                        break;
                     }
                     _loc6_++;
                  }
                  if(_loc6_ == ingredients.length)
                  {
                     ingredients.push(_loc5_);
                  }
               }
               else
               {
                  Engine.showMessage("Cannot find ingredient with id=" + _loc3_.globalItemId);
               }
               _loc2_++;
            }
         }
         if(Debug.GENERATE_RANDOM_INGREDIENTS)
         {
            _loc7_ = GameWorld.ingredientItemDatabase.getItems("Ingredient");
            _loc2_ = 0;
            while(_loc2_ < _loc7_.length)
            {
               if(Engine.rnd(0,2) == 0)
               {
                  _loc8_ = new IngredientItem(_loc7_[_loc2_]);
                  _loc8_.count = Engine.rnd(1,10);
                  ingredients.push(_loc8_);
               }
               _loc2_++;
            }
         }
      }
      
      public function getIngredient(param1:Object) : IngredientItem
      {
         var _loc2_:Number = 0;
         while(_loc2_ < ingredients.length)
         {
            if(param1.id == ingredients[_loc2_].itemConfig.id)
            {
               return ingredients[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeMailItem(param1:MailItem) : void
      {
         var _loc2_:Number = 0;
         while(_loc2_ < mailItems.length)
         {
            if(mailItems[_loc2_].mailObject.id == param1.mailObject.id)
            {
               mailItems.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function freeCachedAnimationType(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(isoAnimationFrames[param1])
         {
            _loc2_ = 0;
            while(_loc2_ < isoAnimationFrames[param1].length)
            {
               if(isoAnimationFrames[param1][_loc2_])
               {
                  _loc3_ = 0;
                  while(_loc3_ < isoAnimationFrames[param1][_loc2_].length)
                  {
                     isoAnimationFrames[param1][_loc2_][_loc3_].bitmapData.dispose();
                     _loc3_++;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function addUsedBuildingItem(param1:UserItem) : void
      {
         usedBuildingItems.push(param1);
      }
      
      public function requireLoadAnimation(param1:Array) : Boolean
      {
         var _loc2_:* = 0;
         if(isoAnimationFrames != null)
         {
            _loc2_ = int(param1.length - 1);
            while(_loc2_ >= 0)
            {
               if(requireLoadAnimationType(param1[_loc2_]))
               {
                  return true;
               }
               _loc2_--;
            }
            return false;
         }
         return true;
      }
      
      public function destroy() : void
      {
         clearAnimationFrames();
      }
      
      public function refreshBedStatusForRestingEmployees() : void
      {
         var _loc2_:GameUserEmployee = null;
         var _loc3_:UserItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < employeeUsers.length)
         {
            _loc2_ = employeeUsers[_loc1_];
            if(_loc2_.bedItem != null)
            {
               if(_loc2_.job != GameUserEmployee.JOB_REST || getUsedItemFromUid(_loc2_.bedItem.serverUid) == null)
               {
                  _loc2_.bedItem = null;
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < employeeUsers.length)
         {
            _loc2_ = employeeUsers[_loc1_];
            if(_loc2_.bedItem == null && _loc2_.job == GameUserEmployee.JOB_REST)
            {
               _loc3_ = getFirstUnusedBed();
               if(!_loc3_)
               {
                  break;
               }
               _loc2_.bedItem = _loc3_;
            }
            _loc1_++;
         }
      }
      
      public function addVisitedFriendToday(param1:NetworkUid) : void
      {
         var _loc2_:Array = userInfo.visitedFriendsToday;
         _loc2_.push(param1);
      }
      
      public function clearAnimationFrames() : void
      {
         var _loc1_:int = 0;
         if(isoAnimationFrames != null)
         {
            _loc1_ = 0;
            while(_loc1_ < isoAnimationFrames.length)
            {
               freeCachedAnimationType(_loc1_);
               _loc1_++;
            }
            isoAnimationFrames = null;
         }
         IsoCacherQueue.removeQueueItemsForUser(this);
      }
      
      public function getNumberOfCompletedActivities() : int
      {
         var _loc1_:Array = userInfo.visitedFriendsToday;
         if(_loc1_)
         {
            return _loc1_.length;
         }
         return 0;
      }
      
      public function getGourmetPoints() : int
      {
         return Math.floor(gourmetPoints.value / 10);
      }
      
      public function addOutsideAreaSizeItem(param1:OutsideAreaSizeItem) : void
      {
         outsideAreaSizeItems.push(param1);
         outsideAreaSizeItems.sortOn(["unlockLevel","sizeX","sizeY"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC]);
      }
      
      public function getEmployeeCount(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < employeeUsers.length)
         {
            if(employeeUsers[_loc3_].job == param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function removeUsedAvatarItem(param1:int) : void
      {
         var _loc3_:AvatarItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < usedAvatarItems.length)
         {
            _loc3_ = usedAvatarItems[_loc2_];
            if(_loc3_.serverUid == param1)
            {
               usedAvatarItems.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
         Debug.warning("removing used avatar item id=" + param1 + " not found.");
      }
      
      public function isRestaurantClosed() : Boolean
      {
         var _loc4_:GameUserEmployee = null;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < employeeUsers.length)
         {
            _loc4_ = employeeUsers[_loc3_];
            if(_loc4_.workTime > 0 && _loc4_.job != GameUserEmployee.JOB_REST)
            {
               if(_loc4_.job == GameUserEmployee.JOB_COOK)
               {
                  _loc1_ = true;
               }
               else if(_loc4_.job == GameUserEmployee.JOB_WAITOR)
               {
                  _loc2_ = true;
               }
            }
            _loc3_++;
         }
         return !(_loc1_ && _loc2_);
      }
      
      public function getSelectedRecipes(param1:int) : Array
      {
         var _loc2_:Recipe = null;
         var _loc5_:Recipe = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < ownedRecipeItems.length)
         {
            _loc5_ = ownedRecipeItems[_loc4_];
            if(_loc5_.type == param1)
            {
               if(_loc5_.selected)
               {
                  _loc3_.push(_loc5_);
               }
               if(!_loc2_)
               {
                  _loc2_ = _loc5_;
               }
            }
            _loc4_++;
         }
         if(_loc3_.length == 0)
         {
            if(_loc2_)
            {
               _loc3_.push(_loc2_);
            }
            else
            {
               _loc3_.push(new Recipe(GameWorld.recipeItemDatabase.getItems(Recipe.MENU_RECIPE_TYPE_NAMES[param1])[0]));
            }
         }
         return _loc3_;
      }
      
      public function addVisitedFriend(param1:GameUser) : void
      {
         if(!hasVisitedFriend(param1))
         {
            userInfo.visitedFriend.push(param1.userInfo.id);
         }
      }
      
      public function isMenuRecipeSelected(param1:int) : Boolean
      {
         var _loc2_:Recipe = getOwnedRecipe(param1);
         if(_loc2_)
         {
            return _loc2_.selected;
         }
         return false;
      }
      
      public function setEmployeesFromProfile(param1:UserInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Employee = null;
         var _loc4_:GameUserEmployee = null;
         var _loc5_:GameUser = null;
         var _loc6_:UserInfo = null;
         var _loc7_:int = 0;
         Debug.out("setEmployeesFromProfile " + userInfo.employees);
         if(userInfo.employees)
         {
            employeeUsers = new Array();
            _loc2_ = 0;
            while(_loc2_ < userInfo.employees.length)
            {
               _loc3_ = userInfo.employees[_loc2_];
               _loc4_ = new GameUserEmployee();
               _loc4_.workTime = _loc3_.happiness;
               _loc4_.job = _loc3_.task;
               employeeUsers.push(_loc4_);
               employeeCount.value += 1;
               _loc5_ = GameWorld.getGameUserWithId(_loc3_.id);
               if(_loc5_ != null)
               {
                  _loc4_.gameUser = _loc5_;
               }
               else
               {
                  _loc6_ = new UserInfo();
                  _loc6_.id = _loc3_.id;
                  _loc6_.playCount = 1;
                  _loc4_.gameUser = new GameUser(_loc6_);
                  GameWorld.cachedExtraUsers.push(_loc4_.gameUser);
               }
               if(!_loc4_.gameUser.hasItemContextLoaded(ITEM_CONTEXT_AVATAR))
               {
                  _loc4_.gameUser.usedAvatarItems = new Array();
                  _loc7_ = 0;
                  while(_loc7_ < _loc3_.clothes.length)
                  {
                     _loc4_.gameUser.addOwnedItem(_loc3_.clothes[_loc7_]);
                     _loc7_++;
                  }
                  _loc4_.gameUser.loadedItemContext |= ITEM_CONTEXT_AVATAR;
               }
               if(this != _loc4_.gameUser.employerUser)
               {
                  _loc4_.gameUser.employerUser = this;
                  _loc4_.gameUser.clearAnimationFrames();
               }
               _loc2_++;
            }
         }
      }
      
      public function getOwnedRecipe(param1:int) : Recipe
      {
         var _loc2_:Number = 0;
         while(_loc2_ < ownedRecipeItems.length)
         {
            if(param1 == ownedRecipeItems[_loc2_].config.id)
            {
               return ownedRecipeItems[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addIngredient(param1:Object, param2:int) : void
      {
         var _loc3_:Number = 0;
         while(_loc3_ < ingredients.length)
         {
            if(param1.id == ingredients[_loc3_].itemConfig.id)
            {
               ingredients[_loc3_].count += param2;
               return;
            }
            _loc3_++;
         }
         var _loc4_:IngredientItem = new IngredientItem(param1);
         _loc4_.count = param2;
         _loc3_ = 0;
         while(_loc3_ < ingredients.length)
         {
            if(_loc4_.rarity < ingredients[_loc3_].rarity || _loc4_.rarity == ingredients[_loc3_].rarity && _loc4_.itemConfig.name < ingredients[_loc3_].itemConfig.name)
            {
               ingredients.splice(_loc3_,0,_loc4_);
               break;
            }
            _loc3_++;
         }
         if(_loc3_ == ingredients.length)
         {
            ingredients.push(_loc4_);
         }
      }
      
      private function getItemType(param1:int) : int
      {
         return param1 / 1000000;
      }
      
      public function getAvatarFrame() : DisplayObject
      {
         var _loc1_:CacheAvatarPortraitQueueItem = null;
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         if(avatarFrame == null)
         {
            _loc1_ = cacheAvatarFrame();
            _loc2_ = new Sprite();
            _loc2_.addChild(_loc1_.cachedShape);
            return _loc2_;
         }
         _loc3_ = new Bitmap();
         _loc3_.bitmapData = avatarFrame.bitmapData;
         _loc3_.x = avatarFrame.x;
         _loc3_.y = avatarFrame.y;
         _loc3_.smoothing = true;
         return _loc3_;
      }
      
      public function deselectMenuRecipe(param1:int) : void
      {
         var _loc2_:Recipe = getOwnedRecipe(param1);
         if(_loc2_)
         {
            _loc2_.selected = false;
         }
      }
      
      public function removeInventoryItem(param1:InventoryUserItem) : Boolean
      {
         var _loc4_:InventoryUserItemGroup = null;
         var _loc2_:int = int(param1.itemConfig.id);
         var _loc3_:int = 0;
         while(_loc3_ < inventoryItemGroups.length)
         {
            _loc4_ = inventoryItemGroups[_loc3_];
            if(_loc4_.itemConfig.id == _loc2_)
            {
               if(_loc4_.removeInventoryUserItem(param1))
               {
                  if(_loc4_.getLength() <= 0)
                  {
                     inventoryItemGroups.splice(_loc3_,1);
                  }
                  return true;
               }
               return false;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function getAllInventoryItemsWithId(param1:int) : Array
      {
         var _loc3_:InventoryUserItemGroup = null;
         var _loc2_:int = 0;
         while(_loc2_ < inventoryItemGroups.length)
         {
            _loc3_ = inventoryItemGroups[_loc2_];
            if(_loc3_.itemConfig.id == param1)
            {
               return _loc3_.getAllInventoryUserItems();
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeIngredient(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < ingredients.length)
         {
            if(param1.id == ingredients[_loc3_].itemConfig.id)
            {
               ingredients[_loc3_].count -= param2;
               if(Debug.DEBUG)
               {
                  Debug.assert(ingredients[_loc3_].count >= 0,"removing more ingredient than the user owned");
               }
               if(ingredients[_loc3_].count == 0)
               {
                  ingredients.splice(_loc3_,1);
               }
               return;
            }
            _loc3_++;
         }
      }
      
      public function getProfile() : UserInfo
      {
         userInfo.restaurantName = bannerText;
         userInfo.gourmetPoint = gourmetPoints.value;
         userInfo.trashPoint = trashCount.value;
         userInfo.demandPoint = demandPoints.value;
         userInfo.musicPlay = musicId;
         userInfo.userLevel = level.value;
         userInfo.activeFloorIndex = activeFloorIndex;
         userInfo.awards = awards.getSaveBytes();
         var _loc1_:ByteArray = settings.getBytes();
         userInfo.awards.writeBytes(_loc1_,0,_loc1_.length);
         return userInfo;
      }
      
      public function addUsedRestaurantItem(param1:UserItem) : void
      {
         usedRestaurantItems.push(param1);
      }
      
      public function getUsedItemFromUid(param1:int) : UserItem
      {
         var _loc2_:int = 0;
         while(_loc2_ < usedRestaurantItems.length)
         {
            if(usedRestaurantItems[_loc2_].serverUid == param1)
            {
               return usedRestaurantItems[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < usedAvatarItems.length)
         {
            if(usedAvatarItems[_loc2_].serverUid == param1)
            {
               return usedAvatarItems[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < usedBuildingItems.length)
         {
            if(usedBuildingItems[_loc2_].serverUid == param1)
            {
               return usedBuildingItems[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setDemandPoints(param1:int) : void
      {
         demandPoints.value = Math.min(Math.max(param1,GameWorld.getMinDemand(this)),GameWorld.MAX_DEMAND);
      }
      
      public function getAvatarItemsAsEmployee() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:AvatarItem = null;
         var _loc6_:* = 0;
         var _loc7_:AvatarItem = null;
         if(userInfo == null)
         {
            return getAvatarItems(null);
         }
         _loc1_ = new Array();
         _loc2_ = getAvatarItems(userInfo.id);
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_.push(_loc2_[_loc3_]);
            _loc3_++;
         }
         if(employerUser != null && employerUser != this)
         {
            _loc4_ = employerUser.getAvatarItems(userInfo.id);
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               _loc5_ = _loc4_[_loc3_];
               _loc6_ = int(_loc1_.length - 1);
               while(_loc6_ >= 0)
               {
                  _loc7_ = _loc1_[_loc6_];
                  if(_loc7_.groupName == _loc5_.groupName)
                  {
                     _loc1_.splice(_loc6_,1);
                  }
                  _loc6_--;
               }
               _loc1_.push(_loc5_);
               _loc3_++;
            }
         }
         return _loc1_;
      }
      
      public function tick(param1:uint) : void
      {
         var _loc3_:GameUserEmployee = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < employeeUsers.length)
         {
            _loc3_ = employeeUsers[_loc2_];
            _loc4_ = 0;
            switch(_loc3_.job)
            {
               case GameUserEmployee.JOB_COOK:
                  _loc3_.workTime = Math.max(_loc3_.workTime - param1,0);
                  break;
               case GameUserEmployee.JOB_WAITOR:
                  _loc3_.workTime = Math.max(_loc3_.workTime - param1,0);
                  break;
               case GameUserEmployee.JOB_CLEANER:
                  _loc3_.workTime = Math.max(_loc3_.workTime - param1,0);
                  break;
               case GameUserEmployee.JOB_REST:
                  _loc5_ = WorldRestaurantPlay.REST_WORK_TIME_INCREASE_MULTIPLYER.value;
                  if(Boolean(_loc3_.bedItem) && int(_loc3_.bedItem.itemConfig.operateTimePercentage) != 100)
                  {
                     _loc5_ += _loc5_ * (100 - int(_loc3_.bedItem.itemConfig.operateTimePercentage)) / 100;
                  }
                  _loc3_.workTime = Math.min(_loc3_.workTime + param1 * _loc5_,GameUserEmployee.MAX_WORK_TIME);
            }
            _loc2_++;
         }
      }
      
      public function setFloorTile(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Floor = null;
         if(!floors[param1])
         {
            _loc4_ = new Floor();
            _loc4_.floorIndex = param1;
            _loc4_.tiles = new Array(WorldRestaurant.MAX_NUM_TILES_X * WorldRestaurant.MAX_NUM_TILES_Y);
            floors[param1] = _loc4_;
         }
         floors[param1].tiles[param2] = param3;
      }
      
      public function getDemandPoints() : int
      {
         return demandPoints.value;
      }
      
      public function addInventoryItem(param1:InventoryUserItem) : void
      {
         var _loc3_:InventoryUserItemGroup = null;
         var _loc2_:int = 0;
         while(_loc2_ < inventoryItemGroups.length)
         {
            _loc3_ = inventoryItemGroups[_loc2_];
            if(_loc3_.itemConfig.id == param1.itemConfig.id)
            {
               _loc3_.addInventoryUserItem(param1);
               return;
            }
            _loc2_++;
         }
         inventoryItemGroups.push(new InventoryUserItemGroup(param1));
      }
      
      public function getAvatarItems(param1:NetworkUid) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:NetworkUid = null;
         if(usedAvatarItems.length == 0)
         {
            _loc2_ = getDefaultAvatarItems();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               addUsedAvatarItem(_loc2_[_loc3_]);
               _loc3_++;
            }
         }
         if(param1 == null)
         {
            return usedAvatarItems;
         }
         _loc4_ = new Array();
         if(userInfo != null && NetworkUid.areEqual(param1,userInfo.id))
         {
            _loc3_ = 0;
            while(_loc3_ < usedAvatarItems.length)
            {
               _loc5_ = usedAvatarItems[_loc3_].employeeId;
               if(_loc5_ == null || _loc5_.networkUid == "0" || NetworkUid.areEqual(_loc5_,param1))
               {
                  _loc4_.push(usedAvatarItems[_loc3_]);
               }
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < usedAvatarItems.length)
            {
               _loc5_ = usedAvatarItems[_loc3_].employeeId;
               if(_loc5_ != null && NetworkUid.areEqual(_loc5_,param1))
               {
                  _loc4_.push(usedAvatarItems[_loc3_]);
               }
               _loc3_++;
            }
         }
         return _loc4_;
      }
      
      public function cacheAvatarFrame() : CacheAvatarPortraitQueueItem
      {
         return new CacheAvatarPortraitQueueItem(this);
      }
      
      public function requireLoadAnimationType(param1:int) : Boolean
      {
         return isoAnimationFrames[param1] == null;
      }
      
      public function removeUsedRestaurantItem(param1:int) : void
      {
         var _loc3_:UserItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < usedRestaurantItems.length)
         {
            _loc3_ = usedRestaurantItems[_loc2_];
            if(param1 == _loc3_.serverUid)
            {
               usedRestaurantItems.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
         Debug.warning("removing used restaurant item id=" + param1 + " not found.");
      }
      
      public function addUsedAvatarItem(param1:AvatarItem) : void
      {
         if(param1.itemConfig.group.name == "SkinColour")
         {
            this.skinColour = int(param1.itemConfig.name);
         }
         else if(param1.itemConfig.group.name == "HairColour")
         {
            this.hairColour = int(param1.itemConfig.name);
         }
         usedAvatarItems.push(param1);
      }
      
      public function setGardenPlots(param1:Array) : void
      {
         param1 = param1.sortOn("id");
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            gardenPlots.push(new GardenPlot(param1[_loc2_]));
            _loc2_++;
         }
      }
      
      public function getInventoryItemWithId(param1:int) : InventoryUserItem
      {
         var _loc3_:InventoryUserItemGroup = null;
         var _loc2_:int = 0;
         while(_loc2_ < inventoryItemGroups.length)
         {
            _loc3_ = inventoryItemGroups[_loc2_];
            if(_loc3_.itemConfig.id == param1)
            {
               return _loc3_.getInventoryUserItem();
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getInventoryItemCount(param1:Object) : int
      {
         var _loc3_:InventoryUserItemGroup = null;
         var _loc2_:int = 0;
         while(_loc2_ < inventoryItemGroups.length)
         {
            _loc3_ = inventoryItemGroups[_loc2_];
            if(_loc3_.itemConfig.id == param1.id)
            {
               return _loc3_.getLength();
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function getUsedBuildingBannerItem() : UserItem
      {
         var _loc2_:UserItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < usedBuildingItems.length)
         {
            _loc2_ = usedBuildingItems[_loc1_];
            if(_loc2_.itemConfig.banner)
            {
               return _loc2_;
            }
            _loc1_++;
         }
         return null;
      }
      
      public function hasItemContextLoaded(param1:int) : Boolean
      {
         return (loadedItemContext & param1) == param1;
      }
      
      public function loadAnimationFrames(param1:Array) : CacheUserAnimationQueueItem
      {
         return new CacheUserAnimationQueueItem(this,param1);
      }
      
      private function addOwnedItem(param1:OwnedItem) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Object = GameWorld.getItemConfig(param1.globalItemId);
         if(_loc2_ == null)
         {
            Engine.showMessage("trying to add an owned item with id " + param1.globalItemId + " that doesn\'t exist.");
         }
         else
         {
            Debug.out("add owned item " + firstName + " id=" + param1.id + " globalItemId=" + param1.globalItemId);
            _loc3_ = param1.globalItemId / 1000000;
            if(_loc3_ == ITEM_TYPE_RESTAURANT)
            {
               _loc4_ = param1.globalItemId / 10000;
               if(_loc4_ == RESTAURANT_ITEM_TYPE_MUSIC)
               {
                  musicItems.push(new UserItem(_loc2_,param1));
               }
               else if(_loc4_ == RESTAURANT_ITEM_TYPE_OUTSIDE_AREA_SIZE)
               {
                  addOutsideAreaSizeItem(new OutsideAreaSizeItem(_loc2_,param1));
               }
               else if(_loc4_ == RESTAURANT_ITEM_TYPE_DELIVERY_BIKE)
               {
                  deliveryBikeItems.push(new UserItem(_loc2_,param1));
               }
               else
               {
                  addUsedRestaurantItem(new UserItem(_loc2_,param1));
               }
            }
            else if(_loc3_ == ITEM_TYPE_BUILDING)
            {
               addUsedBuildingItem(new UserItem(_loc2_,param1));
            }
            else if(_loc3_ == ITEM_TYPE_AVATAR)
            {
               addUsedAvatarItem(new AvatarItem(_loc2_,param1));
            }
         }
      }
      
      public function getUsedRestaurantItems(param1:int) : Array
      {
         var _loc4_:UserItem = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < usedRestaurantItems.length)
         {
            _loc4_ = usedRestaurantItems[_loc3_];
            if(_loc4_.itemConfig.id == param1)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function removeInventoryItemWithId(param1:int, param2:int = 1) : Boolean
      {
         var _loc4_:InventoryUserItemGroup = null;
         var _loc3_:int = 0;
         while(_loc3_ < inventoryItemGroups.length)
         {
            _loc4_ = inventoryItemGroups[_loc3_];
            if(_loc4_.itemConfig.id == param1)
            {
               _loc4_.removeItems(param2);
               if(_loc4_.getLength() <= 0)
               {
                  inventoryItemGroups.splice(_loc3_,1);
               }
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function hasIngredientsForRecipe(param1:int) : Boolean
      {
         var _loc4_:IngredientItem = null;
         var _loc5_:IngredientItem = null;
         var _loc2_:Recipe = new Recipe(GameWorld.getItemConfig(param1));
         var _loc3_:Number = 0;
         while(_loc3_ < _loc2_.ingredientItems.length)
         {
            _loc4_ = _loc2_.ingredientItems[_loc3_];
            _loc5_ = getIngredient(_loc4_.itemConfig);
            if(_loc5_ == null || _loc5_.count < _loc4_.count)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function getInventoryItem(param1:Object) : InventoryUserItem
      {
         return getInventoryItemWithId(param1.id);
      }
      
      public function getDefaultAvatarItems() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:AvatarItem = null;
         if(userInfo != null)
         {
            _loc1_ = DEFAULT_MALE_AVATAR_ITEMS;
            if(userInfo.gender == GENDER_FEMALE)
            {
               _loc1_ = DEFAULT_FEMALE_AVATAR_ITEMS;
            }
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               _loc10_ = _loc1_[_loc3_];
               _loc11_ = new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup(_loc10_.name,_loc10_.group));
               _loc2_.push(_loc11_);
               _loc3_++;
            }
            _loc4_ = Math.abs(userInfo.id.seed);
            _loc5_ = GameWorld.avatarItemDatabase.getItemsBelowCost("Eyes",0);
            _loc11_ = new AvatarItem(_loc5_[_loc4_ % _loc5_.length]);
            _loc2_.push(_loc11_);
            _loc6_ = GameWorld.avatarItemDatabase.getItemsBelowCost("Eyebrows",0);
            _loc11_ = new AvatarItem(_loc6_[_loc4_ % _loc6_.length]);
            _loc2_.push(_loc11_);
            _loc7_ = GameWorld.avatarItemDatabase.getItemsBelowCost("Mouth",0);
            _loc11_ = new AvatarItem(_loc7_[_loc4_ % _loc7_.length]);
            _loc2_.push(_loc11_);
            _loc8_ = GameWorld.avatarItemDatabase.getItemsBelowCost("SkinColour",100);
            _loc11_ = new AvatarItem(_loc8_[_loc4_ % _loc8_.length]);
            _loc2_.push(_loc11_);
            _loc9_ = GameWorld.avatarItemDatabase.getItemsBelowCost("HairColour",100);
            _loc11_ = new AvatarItem(_loc9_[_loc4_ % _loc9_.length]);
            _loc2_.push(_loc11_);
            return _loc2_;
         }
         if(customerAvatarItemsGenerator != null)
         {
            return customerAvatarItemsGenerator();
         }
         return getRandomCustomerAvatarItems();
      }
      
      public function needLoadItemContext(param1:int) : Boolean
      {
         return !(hasItemContextLoaded(param1) || (loadingItemContext & param1) == param1);
      }
      
      public function addItemsFromProfileObject(param1:UserInfo, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Recipe = null;
         var _loc8_:int = 0;
         var _loc9_:Floor = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         Debug.out("addItemsFromProfileObject=" + param1.firstName);
         loadedItemContext |= param2;
         if(param1.ownedItem)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.ownedItem.length)
            {
               addOwnedItem(param1.ownedItem[_loc3_]);
               _loc3_++;
            }
         }
         Debug.out("profile.inventoryItem=" + param1.inventoryItem);
         if(param1.inventoryItem)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.inventoryItem.length)
            {
               if(param1.inventoryItem[_loc3_].number > 0)
               {
                  _loc4_ = int(param1.inventoryItem[_loc3_].globalItemId);
                  _loc5_ = GameWorld.getItemConfig(_loc4_);
                  if(_loc5_)
                  {
                     _loc6_ = getItemType(_loc4_);
                     if(_loc6_ == ITEM_TYPE_RECIPE)
                     {
                        _loc7_ = new Recipe(_loc5_);
                        _loc7_.level = Math.min(param1.inventoryItem[_loc3_].number,10);
                        _loc7_.selected = param1.inventoryItem[_loc3_].isSelected;
                        ownedRecipeItems.push(_loc7_);
                     }
                     else
                     {
                        _loc8_ = 0;
                        while(_loc8_ < param1.inventoryItem[_loc3_].number)
                        {
                           addInventoryItem(new InventoryUserItem(_loc5_));
                           _loc8_++;
                        }
                     }
                  }
                  else if(Debug.DEBUG)
                  {
                     Engine.showMessage("loading inventory item with id " + _loc4_ + " that doens\'t exist");
                  }
               }
               _loc3_++;
            }
         }
         if((param2 & ITEM_CONTEXT_RESTAURANT) != 0 || (param2 & ITEM_CONTEXT_INGREDIENT) != 0)
         {
            setIngredients(param1.ingredients);
         }
         if((param2 & ITEM_CONTEXT_RESTAURANT) != 0)
         {
            Debug.out("profile.floors=" + param1.floors);
            _loc3_ = 0;
            while(_loc3_ < param1.floors.length)
            {
               _loc9_ = param1.floors[_loc3_];
               _loc10_ = int(_loc9_.floorIndex);
               floors[_loc10_] = _loc9_;
               _loc11_ = _loc9_.tiles;
               _loc8_ = 0;
               while(_loc8_ < _loc11_.length)
               {
                  if(_loc11_[_loc8_] != 0)
                  {
                     if(this == GameWorld.gameUser && !removeInventoryItemWithId(_loc11_[_loc8_]))
                     {
                        _loc11_[_loc8_] = 0;
                     }
                  }
                  _loc8_++;
               }
               _loc3_++;
            }
            if(userInfo.awards != null)
            {
               awards.loadBytes(userInfo.awards);
               if(GameWorld.gameUser == this)
               {
                  settings.loadBytes(userInfo.awards);
               }
            }
            if(userInfo.garden != null)
            {
               setGardenPlots(userInfo.garden);
            }
            this.userInfo.employees = param1.employees;
         }
      }
      
      public function removeUsedBuildingItem(param1:int) : void
      {
         var _loc3_:UserItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < usedBuildingItems.length)
         {
            _loc3_ = usedBuildingItems[_loc2_];
            if(param1 == _loc3_.serverUid)
            {
               usedBuildingItems.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
         Debug.warning("removing used building item id=" + param1 + " not found.");
      }
      
      public function selectMenuRecipe(param1:int) : void
      {
         var _loc2_:Recipe = getOwnedRecipe(param1);
         if(_loc2_)
         {
            _loc2_.selected = true;
         }
      }
      
      public function hasVisitedFriend(param1:GameUser) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < userInfo.visitedFriend.length)
         {
            if(NetworkUid.areEqual(userInfo.visitedFriend[_loc2_],param1.userInfo.id))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function completedActivityFor(param1:GameUser) : void
      {
      }
      
      public function hasVisitedToday(param1:GameUser) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < userInfo.visitedFriendsToday.length)
         {
            if(NetworkUid.areEqual(userInfo.visitedFriendsToday[_loc2_],param1.userInfo.id))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function setProfile(param1:UserInfo) : void
      {
         this.userInfo = param1;
         if(userInfo != null)
         {
            if(Boolean(userInfo.firstName) && userInfo.firstName.length > 0)
            {
               this.firstName = userInfo.firstName;
            }
            if(Boolean(userInfo.fullName) && userInfo.fullName.length > 0)
            {
               this.fullName = userInfo.fullName;
            }
            if(Boolean(userInfo.imageUrl) && userInfo.imageUrl.length > 0)
            {
               this.imageUrl = userInfo.imageUrl;
            }
            activeFloorIndex = userInfo.activeFloorIndex;
            musicId = userInfo.musicPlay;
            money.value = userInfo.credits;
            gourmetPoints.value = userInfo.gourmetPoint;
            level.value = Math.min(userInfo.userLevel,GameWorld.LEVEL_THRESHOLDS.length - 1);
            trashCount.value = Math.min(userInfo.trashPoint,GameWorld.MAX_TRASH);
            setDemandPoints(userInfo.demandPoint);
            if(userInfo.restaurantName == null)
            {
               bannerText = firstName;
            }
            else
            {
               bannerText = userInfo.restaurantName;
            }
            Debug.out("setProfile userInfo.trashPoint=" + userInfo.trashPoint + " userInfo.demandPoint=" + userInfo.demandPoint + " userInfo.visitedFriend=" + userInfo.visitedFriend + " userInfo.firstName=" + userInfo.firstName + " userInfo.musicPlay=" + userInfo.musicPlay + " userInfo.isInStreet=" + userInfo.isInStreet);
         }
      }
      
      public function getFirstUnusedBed() : UserItem
      {
         var _loc2_:UserItem = null;
         var _loc3_:int = 0;
         var _loc4_:GameUserEmployee = null;
         var _loc1_:int = 0;
         while(_loc1_ < usedRestaurantItems.length)
         {
            _loc2_ = usedRestaurantItems[_loc1_];
            if(GameWorld.isItemOfType(_loc2_.itemConfig,"bed"))
            {
               _loc3_ = 0;
               while(_loc3_ < employeeUsers.length)
               {
                  _loc4_ = employeeUsers[_loc3_];
                  if(Boolean(_loc4_.job == GameUserEmployee.JOB_REST) && Boolean(_loc4_.bedItem) && _loc4_.bedItem.serverUid == _loc2_.serverUid)
                  {
                     break;
                  }
                  _loc3_++;
               }
               if(_loc3_ == employeeUsers.length)
               {
                  return _loc2_;
               }
            }
            _loc1_++;
         }
         return null;
      }
      
      public function getOwnedRecipesWithType(param1:int) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < ownedRecipeItems.length)
         {
            if(ownedRecipeItems[_loc3_].type == param1)
            {
               _loc2_.push(ownedRecipeItems[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getNewMailItems() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Number = 0;
         while(_loc2_ < mailItems.length)
         {
            if(!mailItems[_loc2_].mailObject.read)
            {
               _loc1_.push(mailItems[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}


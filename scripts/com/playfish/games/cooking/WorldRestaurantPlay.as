package com.playfish.games.cooking
{
   import com.playfish.games.cooking.actors.*;
   import com.playfish.games.cooking.arcadegame.cave.*;
   import com.playfish.games.cooking.arcadegame.snake.*;
   import com.playfish.games.cooking.debug.DebugDailyBonus;
   import com.playfish.games.cooking.events.FriendListEvent;
   import com.playfish.games.cooking.events.GameEvent;
   import com.playfish.games.cooking.extension.restaurant.TutorialExtension;
   import com.playfish.games.cooking.foodking.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.games.cooking.ui.mail.*;
   import com.playfish.games.cooking.usertask.*;
   import com.playfish.games.cooking.utils.ProtectedInt;
   import com.playfish.games.cooking.utils.RandomBasket;
   import com.playfish.games.cooking.visitactivities.VisitActivity;
   import com.playfish.rpc.cooking.Mail;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.utils.*;
   
   public class WorldRestaurantPlay extends WorldRestaurant
   {
      
      public static var restaurantClosedTimer:int;
      
      public static var instance:WorldRestaurantPlay;
      
      public static var firstVisitIngredientReward:IngredientItem;
      
      public static var dailyIngredientMail:MailItem = null;
      
      public static var specialDayPresentMails:Array = new Array();
      
      public static var showOnSaleCashIngredientsPopUp:Boolean = true;
      
      public static const HAPPINESS_DECREASE_RATE_CHEF:ProtectedInt = new ProtectedInt(3 * 60 * 60 * 1000);
      
      public static const HAPPINESS_DECREASE_RATE_WAITOR:ProtectedInt = new ProtectedInt(3 * 60 * 60 * 1000);
      
      public static const HAPPINESS_DECREASE_RATE_CLEANER:ProtectedInt = new ProtectedInt(3 * 60 * 60 * 1000);
      
      public static const HAPPINESS_INCREASE_RATE_REST:ProtectedInt = new ProtectedInt(1 * 60 * 60 * 1000);
      
      public static const REST_WORK_TIME_INCREASE_MULTIPLYER:ProtectedInt = new ProtectedInt(3);
      
      public static const CUSTOMERS_PER_MINUTE_PER_DEMAND:Number = 0.05;
      
      public static const DEMAND_BONUS_HAPPY_CUSTOMER:Number = 1;
      
      public static const DEMAND_BONUS_UNHAPPY_CUSTOMER:Number = -1;
      
      private static const NUM_CACHED_CUSTOMERS:int = 15;
      
      public static const PEDESTRAIN_CREATE_TIMER:int = 10000;
      
      public static const CAR_CREATE_TIMER:int = 10000;
      
      public static const PEDESTRIAN_START_TILE_POSITION:Array = [[-1,-20],[-1,35]];
      
      public static const PEDESTRIAN_END_TILE_POSITION:Array = [[-1,35],[-1,-20]];
      
      public static const CAR_START_TILE_POSITION:Array = [[-7,-20]];
      
      public static const CAR_END_TILE_POSITION:Array = [[-7,35]];
      
      private static var cachedCustomerUsers:Array = new Array();
      
      private static const DEFAULT_TRASH_ITEMS:Array = ["BananaPeel","PizzaSlice","SodaCan","ChickenLeg","AppleCore"];
      
      public var buttonChangeMenu:MovieClip;
      
      private var customerTimer:int;
      
      private var drinkItems:Array = new Array();
      
      private var beds:Array = new Array();
      
      public var buttonMarket:MovieClip;
      
      private var bgMusicId:int;
      
      public var buttonPhoto:MovieClip;
      
      public var maxTrashCoins:int = 1;
      
      private var sinks:Array = new Array();
      
      public var buttonAward:MovieClip;
      
      private var chairs:Array = new Array();
      
      public var buttonFolder:MovieClip;
      
      public var customers:Array = new Array();
      
      public var buttonDecorate:MovieClip;
      
      private var ingredientShop:MovieClip;
      
      private const DEBUG_PLAYER:Boolean = false;
      
      public var buttonMessage:MovieClip;
      
      public var cleaners:Array = new Array();
      
      public var coinPickUpSound:GameSound = new GameSound("SfxCoinPickUp",GameSound.TYPE_SOUND);
      
      private var doors:Array = new Array();
      
      public var buttonBookmark:MovieClip;
      
      public var uiLevelBar:MovieClip;
      
      private var unreadMailCount:int = 0;
      
      public var trashCount:ProtectedInt = new ProtectedInt(0);
      
      public var trashObjects:Array = new Array();
      
      public var maxDemand:int = 500;
      
      public var customerWaitTimeModifier:int = 0;
      
      public var buttonMusicPlayer:MovieClip;
      
      public var showRestaurantClosedToolTip:Boolean = false;
      
      private var bgMusic:GameSound;
      
      private var achievementItem:RoomItem;
      
      public var orders:Array = new Array();
      
      public var uiButton:MovieClip;
      
      public var uiPopularity:MovieClip;
      
      private var enableRating:Boolean = false;
      
      public var userTaskQueue:UserTaskQueue = new UserTaskQueue();
      
      public var trashMap:Array = new Array();
      
      public var restaurantClosed:Boolean = false;
      
      public var completedOrders:Array = new Array();
      
      private var menuItem:RoomItem;
      
      private var debugPlayer:AvatarActor;
      
      private var foodKing:FoodKing;
      
      public var uiVisitBanner:MovieClip;
      
      public var buttonAvatar:MovieClip;
      
      private var carCreateTimer:int;
      
      private var curCountryIndex:int = 0;
      
      private var kitchens:Array = new Array();
      
      public var waitors:Array = new Array();
      
      public var trashItems:Array = new Array();
      
      private var mailItem:RoomItem;
      
      public var employeeActors:Array = new Array();
      
      public var chefs:Array = new Array();
      
      private var pedestrianCreateTimer:int;
      
      private var curFriendsList:WorldFriendsList = WorldStreet.streetUserList;
      
      private var zoomLever:ZoomLever;
      
      public var waitingChairQueue:Array = new Array();
      
      private var visitActivity:VisitActivity = null;
      
      public var buttonGift:MovieClip;
      
      public var visitMode:Boolean = false;
      
      public var silentTick:Boolean = false;
      
      public var cookingSound:GameSound = new GameSound("SfxCooking",GameSound.TYPE_SOUND);
      
      public var cashSound:GameSound = new GameSound("SfxCash",GameSound.TYPE_SOUND);
      
      public var eatingSound:GameSound = new GameSound("SfxEating",GameSound.TYPE_SOUND);
      
      public var customerAvatarItemsGenerator:Function = GameUser.getRandomCustomerAvatarItems;
      
      public var coinDropSound:GameSound = new GameSound("SfxCoinDrop",GameSound.TYPE_SOUND);
      
      public var emptyPlates:Array = new Array();
      
      public var buttonStreet:MovieClip;
      
      public var folderButtonHandler:FolderButton;
      
      public var levelBar:LevelBar;
      
      private var nextCustomer:Customer;
      
      private var interactiveItems:Array = new Array();
      
      public function WorldRestaurantPlay(param1:GameUser, param2:Boolean = false, param3:Boolean = false)
      {
         this.visitMode = param2;
         this.enableRating = param3;
         super(param1);
      }
      
      public static function setRating(param1:MovieClip, param2:GameUser) : void
      {
         var _loc5_:MovieClip = null;
         var _loc3_:Number = 0;
         if(param2.userInfo.nbVote > 0)
         {
            _loc3_ = param2.userInfo.totalMark / param2.userInfo.nbVote;
         }
         var _loc4_:int = 0;
         while(_loc4_ < 5)
         {
            _loc5_ = param1["mc_star" + _loc4_];
            _loc5_.stop();
            _loc5_.mc_content.mc_mask.scaleX = 1 - Math.min(1,_loc3_ - _loc4_);
            _loc4_++;
         }
         GameWorld.textHandler.setReplaceString("votes",param2.userInfo.nbVote.toString());
         GameWorld.textHandler.setReplaceString("rating",_loc3_.toFixed(2));
         param1.toolTip = new ToolTip(param1,GameWorld.textHandler.getTextFromId("ToolTipVotesAverageRating"));
      }
      
      public function onButtonAwardClick(param1:MouseEvent) : void
      {
         showAwardPopUp();
      }
      
      private function onButtonMarketClick(param1:MouseEvent) : void
      {
         showIngredientShop();
      }
      
      public function activityCompleted() : void
      {
         var _loc1_:int = GameWorld.getVisitRewardAmount();
         GameWorld.cashPanel.addCoins(_loc1_);
         addGourmetPoints(Math.min(_loc1_,GameWorld.MAX_VISIT_ACTIVITY_GP));
         GameWorld.saveProfileHandler.completedActivityFor(gameUser.userInfo.id);
         GameWorld.addVisitedFriendToday(gameUser.userInfo.id);
      }
      
      public function onButtonDecorateClick(param1:MouseEvent) : void
      {
         destroy();
         var _loc2_:WorldRestaurantEditor = new WorldRestaurantEditor(gameUser);
         _loc2_.room.x = room.x;
         _loc2_.room.y = room.y;
         Engine.setActiveWorld(_loc2_);
         param1.stopImmediatePropagation();
      }
      
      public function addChef(param1:GameUserEmployee) : void
      {
         var _loc3_:RoomItem = null;
         var _loc4_:int = 0;
         var _loc5_:ChefActor = null;
         if(kitchens.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < kitchens.length)
            {
               if(!isKitchenOccupied(kitchens[_loc4_]))
               {
                  _loc3_ = kitchens[_loc4_];
                  break;
               }
               _loc4_++;
            }
            if(_loc3_ != null)
            {
               removeActor(param1);
               _loc5_ = new ChefActor(_loc3_,param1,this);
               chefs.push(_loc5_);
               addEmployeeActor(_loc5_);
               calculateServableTables();
               return;
            }
         }
         var _loc2_:EmployeeActor = getEmployeeActor(param1);
         if(_loc2_ == null || !(_loc2_ is IdleEmployee))
         {
            _loc2_ = addIdleActor(param1);
         }
         _loc2_.setEmotion(EmployeeActor.EMOTION_NEED_STOVE);
      }
      
      public function onButtonHireFriendsClick(param1:MouseEvent) : void
      {
         destroy();
         GameWorld.fadeToWorld(new WorldHire());
      }
      
      public function getSortedKitchens(param1:RoomItem) : Array
      {
         var _loc4_:RoomItem = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < kitchens.length)
         {
            _loc4_ = kitchens[_loc3_];
            _loc5_ = 1;
            _loc6_ = getWaitorCountForKitchen(_loc4_);
            _loc7_ = 0;
            while(_loc7_ < _loc2_.length)
            {
               _loc8_ = 1;
               _loc9_ = getWaitorCountForKitchen(_loc2_[_loc7_]);
               if(_loc5_ > _loc8_)
               {
                  _loc2_.splice(_loc7_,0,_loc4_);
                  break;
               }
               if(_loc5_ == _loc8_)
               {
                  if(_loc6_ < _loc9_)
                  {
                     _loc2_.splice(_loc7_,0,_loc4_);
                     break;
                  }
                  if(_loc6_ == _loc9_ && _loc4_ == param1)
                  {
                     _loc2_.splice(_loc7_,0,_loc4_);
                     break;
                  }
               }
               _loc7_++;
            }
            if(_loc7_ == _loc2_.length)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getWaitorCountForKitchen(param1:RoomItem) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < waitors.length)
         {
            if(waitors[_loc3_].kitchen == param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function onFireUser(param1:GameUserEmployee) : void
      {
         if(!visitMode)
         {
            removeActor(param1);
            refreshEmployeeCount();
            calculateServableTables();
            refreshRestaurantClosedState();
         }
      }
      
      public function addWaitor(param1:GameUserEmployee) : void
      {
         var _loc3_:Waitor = null;
         if(kitchens.length > 0)
         {
            removeActor(param1);
            _loc3_ = new Waitor(getSortedKitchens(null)[0],param1,this);
            waitors.push(_loc3_);
            addEmployeeActor(_loc3_);
            calculateServableTables();
            return;
         }
         var _loc2_:EmployeeActor = getEmployeeActor(param1);
         if(!_loc2_ || !(_loc2_ is IdleEmployee))
         {
            _loc2_ = addIdleActor(param1);
         }
         _loc2_.setEmotion(EmployeeActor.EMOTION_NEED_STOVE);
      }
      
      public function enablePlots() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < plots.length)
         {
            plots[_loc1_].enable(visitMode);
            _loc1_++;
         }
      }
      
      private function getEmployeeActor(param1:GameUserEmployee) : EmployeeActor
      {
         var _loc2_:int = 0;
         while(_loc2_ < employeeActors.length)
         {
            if(employeeActors[_loc2_].employeeUser == param1)
            {
               return employeeActors[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function getClosestFreeWaitor(param1:int, param2:int, param3:Customer) : Object
      {
         var _loc7_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Waitor = null;
         var _loc6_:int = 0;
         while(_loc6_ < waitors.length)
         {
            if(Boolean(waitors[_loc6_].isFree()) && (Boolean(param3 == null) || Boolean(waitors[_loc6_].canServe(param3))))
            {
               _loc7_ = waitors[_loc6_].getPathTo(param1,param2,true);
               if(_loc7_)
               {
                  if(_loc4_ == null || _loc7_.length < _loc4_.length)
                  {
                     _loc5_ = waitors[_loc6_];
                     _loc4_ = _loc7_;
                  }
               }
            }
            _loc6_++;
         }
         if(_loc5_ == null)
         {
            return null;
         }
         return {
            "waitor":_loc5_,
            "path":_loc4_
         };
      }
      
      private function onAchievementItemClick(param1:MouseEvent) : void
      {
         if(!moveGesture)
         {
            showAwardPopUp();
         }
      }
      
      public function onButtonPerkClick(param1:MouseEvent) : void
      {
      }
      
      public function addDemand(param1:int) : void
      {
         setDemand(gameUser.getDemandPoints() + param1);
      }
      
      public function createEmployeeActor(param1:GameUserEmployee) : void
      {
         var _loc2_:EmployeeActor = null;
         switch(param1.job)
         {
            case GameUserEmployee.JOB_COOK:
               addChef(param1);
               break;
            case GameUserEmployee.JOB_WAITOR:
               addWaitor(param1);
               break;
            case GameUserEmployee.JOB_CLEANER:
               addCleaner(param1);
               break;
            case GameUserEmployee.JOB_REST:
               addRestingEmployee(param1);
               break;
            case GameUserEmployee.JOB_NONE:
               _loc2_ = addIdleActor(param1);
               _loc2_.setEmotion(EmployeeActor.EMOTION_NEED_JOB);
         }
      }
      
      private function getValidOutsideAreaEntrances() : Array
      {
         var _loc3_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < numOutsideTilesY)
         {
            _loc3_ = numTilesY + _loc2_;
            if(isWalkable(1,_loc3_))
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function alreadyHelpedCurrentFriend() : Boolean
      {
         return GameWorld.gameUser.hasVisitedToday(gameUser);
      }
      
      public function onButtonMessageClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldMail = null;
         if(GameWorld.gameUser.level.value > 0)
         {
            _loc2_ = new WorldMail();
            _loc2_.show();
         }
      }
      
      private function onTrashMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:BaseObject = BaseObject(param1.currentTarget);
         _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,onTrashMouseDown);
         room.removeObject(_loc2_);
         var _loc3_:GameObject = GameObject(_loc2_.trashObject);
         removeTrashObject(_loc3_);
         param1.stopImmediatePropagation();
      }
      
      override public function onLevelUp(param1:GameEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ChefActor = null;
         var _loc2_:int = GameWorld.gameUser.level.value;
         if(GameWorld.LEVEL_THRESHOLDS[_loc2_].roomSizeY > GameWorld.LEVEL_THRESHOLDS[_loc2_ - 1].roomSizeY)
         {
            _loc3_ = 0;
            while(_loc3_ < chefs.length)
            {
               _loc4_ = chefs[_loc3_];
               if(isTileInOutsideArea(_loc4_.tileX,_loc4_.tileY))
               {
                  _loc4_.setPosition(getScreenX(_loc4_.tileX,_loc4_.tileY + 1),getScreenY(_loc4_.tileX,_loc4_.tileY + 1));
               }
               _loc3_++;
            }
         }
         super.onLevelUp(param1);
         refreshEmployeeCount();
         if(levelBar)
         {
            levelBar.refresh();
         }
      }
      
      private function getWaiterForDrinkOrder(param1:DishOrder) : Object
      {
         var _loc7_:Waitor = null;
         var _loc8_:int = 0;
         var _loc9_:RoomItem = null;
         var _loc10_:Object = null;
         var _loc11_:Array = null;
         if(drinkItems.length <= 0)
         {
            return null;
         }
         var _loc2_:Array = null;
         var _loc3_:Waitor = null;
         var _loc4_:RoomItem = null;
         var _loc5_:Customer = param1.customer;
         var _loc6_:int = 0;
         while(_loc6_ < waitors.length)
         {
            _loc7_ = waitors[_loc6_];
            if(_loc7_.isFree() && _loc7_.canServe(_loc5_))
            {
               _loc8_ = 0;
               while(_loc8_ < drinkItems.length)
               {
                  _loc9_ = drinkItems[_loc8_];
                  if(!_loc9_.waiter && _loc7_.canReachDrinkItem(_loc9_))
                  {
                     _loc10_ = getFacingTile(_loc9_.tileX,_loc9_.tileY,_loc9_.getRotationCount());
                     if(isWalkable(_loc10_.x,_loc10_.y))
                     {
                        _loc11_ = _loc7_.getPathTo(_loc10_.x,_loc10_.y,false);
                        if((Boolean(_loc11_)) && (_loc2_ == null || _loc11_.length < _loc2_.length))
                        {
                           _loc3_ = _loc7_;
                           _loc2_ = _loc11_;
                           _loc4_ = _loc9_;
                        }
                     }
                  }
                  _loc8_++;
               }
            }
            _loc6_++;
         }
         if(_loc3_ == null)
         {
            return null;
         }
         return {
            "waitor":_loc3_,
            "path":_loc2_,
            "drinkItem":_loc4_
         };
      }
      
      public function getPlayingMusicForUser(param1:GameUser) : UserItem
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(param1.musicId > 0)
         {
            _loc2_ = GameWorld.interiorItemDatabase.getItemFromGroupWithId(param1.musicId,"Music");
            if(Boolean(_loc2_) && _loc2_.cost > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.musicItems.length)
               {
                  if(param1.musicItems[_loc3_].itemConfig.id == param1.musicId)
                  {
                     break;
                  }
                  _loc3_++;
               }
               if(_loc3_ >= param1.musicItems.length)
               {
                  _loc2_ = null;
               }
            }
         }
         if(_loc2_ == null)
         {
            _loc2_ = GameWorld.interiorItemDatabase.getItems("Music")[1];
         }
         return new UserItem(_loc2_);
      }
      
      public function getPathToCustomer(param1:int, param2:int, param3:Customer) : Array
      {
         var _loc4_:RoomItem = param3.chair;
         var _loc5_:Object = getFacingTile(_loc4_.tileX,_loc4_.tileY,_loc4_.getRotationCount());
         var _loc6_:PathFinder = new PathFinder(param1,param2,_loc5_.x,_loc5_.y,this,true);
         var _loc7_:int = _loc6_.processOpenList(-1);
         if(_loc7_ == PathFinder.PROCESS_STATE_NO_PATH)
         {
            _loc6_ = new PathFinder(param1,param2,_loc4_.tileX,_loc4_.tileY,this,true);
            _loc7_ = _loc6_.processOpenList(-1);
         }
         if(_loc7_ == PathFinder.PROCESS_STATE_FOUND)
         {
            return _loc6_.getFinalPath();
         }
         return null;
      }
      
      private function getNextCustomer(param1:int, param2:int) : Customer
      {
         var _loc3_:Customer = null;
         var _loc4_:GameUser = null;
         var _loc5_:int = 0;
         Debug.out("cachedCustomerUsers=" + cachedCustomerUsers.length + " customers.length=" + customers.length);
         if(Engine.rnd(0,20) == 0)
         {
            _loc4_ = getRandomFreeFriendUser();
            if(_loc4_)
            {
               _loc4_.employerUser = null;
               _loc3_ = new Customer(param1,param2,_loc4_,this);
            }
         }
         if(_loc3_ == null)
         {
            if(cachedCustomerUsers.length > 0 && cachedCustomerUsers.length + customers.length >= NUM_CACHED_CUSTOMERS)
            {
               _loc5_ = Engine.rnd(0,cachedCustomerUsers.length);
               _loc3_ = new Customer(param1,param2,cachedCustomerUsers[_loc5_],this);
               cachedCustomerUsers.splice(_loc5_,1);
            }
            else
            {
               _loc3_ = new Customer(param1,param2,new GameUser(null),this);
            }
         }
         return _loc3_;
      }
      
      private function onButtonGiftInviteClick(param1:MouseEvent) : void
      {
         var _loc2_:GiftInviteFoodPopUp = new GiftInviteFoodPopUp();
         _loc2_.show();
         GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GIFT_INVITE_FOOD);
         if(uiButton.mc_gift)
         {
            uiButton.mc_gift.mc_new.visible = false;
         }
      }
      
      public function removeCustomer(param1:Customer) : void
      {
         param1.hide();
         room.removeObject(param1);
         var _loc2_:int = customers.indexOf(param1);
         if(_loc2_ != -1)
         {
            customers.splice(_loc2_,1);
         }
         if(param1.user.userInfo == null)
         {
            cachedCustomerUsers.push(param1.user);
         }
         else
         {
            param1.destroy();
         }
      }
      
      public function onCustomerPay(param1:DishOrder) : void
      {
         if(gameUser == GameWorld.gameUser)
         {
            GameWorld.cashPanel.addCoins(param1.recipe.cost);
            GameWorld.saveProfileHandler.addPaidMeal(param1.recipe.cost);
            addGourmetPoints(GameWorld.GOURMET_POINTS_PER_DISH + GameWorld.GOURMET_POINTS_PER_DISH_LEVEL * (param1.recipe.level - 1));
         }
      }
      
      public function getPathToRandomRoomItem(param1:RestaurantActor, param2:Array) : Object
      {
         var _loc5_:PathFinder = null;
         var _loc3_:RandomBasket = new RandomBasket();
         _loc3_.addItemArray(param2);
         var _loc4_:RoomItem = null;
         while(true)
         {
            _loc4_ = RoomItem(_loc3_.getNextItem());
            if(!_loc4_)
            {
               break;
            }
            _loc5_ = new PathFinder(param1.tileX,param1.tileY,_loc4_.tileX,_loc4_.tileY,this);
            if(_loc5_.processOpenList(-1) == PathFinder.PROCESS_STATE_FOUND)
            {
               return {
                  "item":_loc4_,
                  "path":_loc5_.getFinalPath()
               };
            }
         }
         return null;
      }
      
      private function moveClosestFreeWaitorToCookedOrder(param1:DishOrder) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc2_:Object = getClosestFreeWaitor(param1.kitchen.tileX,param1.kitchen.tileY,param1.customer);
         if(_loc2_ != null)
         {
            _loc2_.path.pop();
            if(_loc2_.path.length > 0)
            {
               _loc6_ = _loc2_.path[_loc2_.path.length - 1];
               _loc3_ = int(_loc6_[0]);
               _loc4_ = int(_loc6_[1]);
            }
            else
            {
               _loc3_ = int(_loc2_.waitor.tileX);
               _loc4_ = int(_loc2_.waitor.tileY);
            }
            _loc5_ = getPathToCustomer(_loc3_,_loc4_,param1.customer);
            if(_loc5_ != null)
            {
               _loc2_.waitor.getOrderFromKitchen(param1,_loc2_.path,_loc5_);
               return true;
            }
         }
         return false;
      }
      
      public function onButtonStreetClick(param1:MouseEvent) : void
      {
         destroy();
         GameWorld.fadeToWorld(new WorldStreet(gameUser,false,true));
      }
      
      private function showMusicStore() : void
      {
         var _loc1_:WorldMusicShopPopUp = null;
         if(!visitMode)
         {
            GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_MUSIC_PLAYER);
            if(uiButton.buttonMusicPlayer)
            {
               uiButton.buttonMusicPlayer.mc_new.visible = false;
            }
            _loc1_ = new WorldMusicShopPopUp(this);
            _loc1_.show();
         }
      }
      
      private function getPath(param1:int, param2:int, param3:int, param4:int) : Array
      {
         var _loc5_:PathFinder = new PathFinder(param1,param2,param3,param4,this,true);
         if(_loc5_.processOpenList(-1) == PathFinder.PROCESS_STATE_FOUND)
         {
            return null;
         }
         return null;
      }
      
      private function onMailItemClick(param1:MouseEvent) : void
      {
         if(!moveGesture)
         {
            if(visitMode)
            {
               onButtonWriteMessageClick(null);
            }
            else
            {
               onButtonMessageClick(null);
            }
         }
      }
      
      private function onPerksClicked(param1:MouseEvent) : void
      {
      }
      
      public function onMoveDebugPlayer(param1:MouseEvent) : void
      {
         var _loc2_:int = getTileIndexX(room.mouseX,room.mouseY);
         var _loc3_:int = getTileIndexY(room.mouseX,room.mouseY);
         debugPlayer.moveTo(getScreenX(_loc2_,_loc3_),getScreenY(_loc2_,_loc3_));
      }
      
      override public function showNotify() : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:WorldPopUp = null;
         var _loc8_:WorldEarningPopUp = null;
         super.showNotify();
         instance = this;
         if(visitMode)
         {
            curFriendsList.y = Engine.getStageBottom();
            addObject(curFriendsList);
            curFriendsList.addEventListener(FriendListEvent.USER_CLICKED,onFriendListUserClicked,false,0,true);
         }
         else
         {
            GameWorld.hiredFriendsPanel.y = Engine.getStageBottom();
            GameWorld.hiredFriendsPanel.refreshInviteIcons();
            addObject(GameWorld.hiredFriendsPanel);
         }
         addObject(GameWorld.cashPanel);
         playBgMusic(getPlayingMusicForUser(gameUser).itemConfig);
         silentTick = true;
         var _loc1_:int = 40 + Engine.rnd(0,5);
         var _loc2_:int = 1000;
         var _loc3_:Number = 0;
         while(_loc3_ < _loc1_)
         {
            tickBase(_loc2_);
            _loc3_++;
         }
         silentTick = false;
         displayGameStartUpPopUps();
         if(firstVisitIngredientReward != null)
         {
            _loc4_ = Engine.getMovieClip("FirstFriendVisitBonusAnim");
            _loc5_ = _loc4_.mc_content;
            GameWorld.textHandler.setTextFieldWithId(_loc5_.tf_title,"FirstFriendVisitBonus");
            GameWorld.textHandler.setTextFieldWithId(_loc5_.tf_ingredient,"IngredientBonus");
            _loc6_ = Engine.getMovieClip(firstVisitIngredientReward.itemConfig.className);
            _loc6_.stop();
            _loc5_.mc_icon.removeChildAt(0);
            _loc5_.mc_icon.addChild(_loc6_);
            _loc5_.mc_rarity.gotoAndStop(firstVisitIngredientReward.rarity);
            _loc5_.tf_name.text = firstVisitIngredientReward.itemConfig.name;
            setButtonMode(_loc4_.mc_tick,true);
            _loc7_ = new WorldPopUp(_loc4_,_loc5_.mc_tick,null);
            _loc7_.show();
            firstVisitIngredientReward = null;
         }
         if(visitMode && WorldStreet.streetType == WorldStreet.STREET_TYPE_FRIENDS)
         {
            GameWorld.addAwardValue(GameAwards.AWARD_VISIT,1);
         }
         if(!visitMode)
         {
            GameWorld.tickOfflineTime();
            GameWorld.offlineEarningTimer = -1;
            GameWorld.settingOverlay.showSaveButton();
            if(GameWorld.offlineEarning > 0)
            {
               _loc8_ = new WorldEarningPopUp(GameWorld.offlineEarning,GameWorld.offlineGourmetPoints);
               _loc8_.y = canvasHeight / 2;
               _loc8_.queueToShow();
            }
            GameWorld.offlineEarning = 0;
            GameWorld.offlineGourmetPoints = 0;
            GameWorld.checkLevelUp();
         }
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,0,true);
         onFullScreen(null);
         if(FoodKingPopUp.blackSheepItems.length > 0)
         {
            foodKing = new FoodKing(this,null);
            foodKing.addToRestaurant();
         }
      }
      
      public function displayGameStartUpPopUps() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:DailyBonusPopUp = null;
         var _loc6_:int = 0;
         var _loc7_:FoodKingItem = null;
         var _loc8_:WorldPopUp = null;
         var _loc9_:int = 0;
         var _loc10_:Mail = null;
         var _loc11_:MailItem = null;
         var _loc12_:SpecialDayPresentMail = null;
         var _loc13_:GameStartMessageMail = null;
         var _loc14_:MailItem = null;
         var _loc15_:NewspaperMail = null;
         if(!visitMode && gameUser.level.value > 0)
         {
            if(dailyIngredientMail != null || Boolean(DebugDailyBonus.daysLoggedInARow))
            {
               _loc5_ = new DailyBonusPopUp(dailyIngredientMail);
               _loc5_.queueToShow();
               if(!DebugDailyBonus.daysLoggedInARow)
               {
                  GameWorld.saveProfileHandler.addDeletedMail(dailyIngredientMail);
                  dailyIngredientMail = null;
               }
            }
            if(GameWorld.receivedFeedItems != null)
            {
               _loc6_ = 0;
               while(_loc6_ < GameWorld.receivedFeedItems.length)
               {
                  _loc7_ = GameWorld.receivedFeedItems[_loc6_];
                  if(_loc7_.mailType == RpcClient.MAIL_FOOD_KING_ITEM)
                  {
                     _loc1_ = Engine.getMovieClip("BlackSheepRewardPopupAnim");
                  }
                  else
                  {
                     _loc1_ = Engine.getMovieClip("GenericRewardPopupAnim");
                  }
                  _loc2_ = _loc1_.mc_content;
                  _loc8_ = new FoodKingRewardPopUp(_loc7_,_loc1_,_loc2_.mc_skip,null);
                  _loc8_.queueToShow();
                  _loc6_++;
               }
               GameWorld.receivedFeedItems = null;
            }
            if(GameWorld.invalidFeedItems != null)
            {
               _loc9_ = 0;
               while(_loc9_ < GameWorld.invalidFeedItems.length)
               {
                  _loc10_ = GameWorld.invalidFeedItems[_loc9_];
                  if(_loc10_.type == RpcClient.FOOD_KING_FEED_EXCEPTION)
                  {
                     _loc1_ = Engine.getMovieClip("BlackSheepRewardPopupAnim");
                  }
                  else
                  {
                     _loc1_ = Engine.getMovieClip("GenericRewardPopupAnim");
                  }
                  _loc2_ = _loc1_.mc_content;
                  GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_text,_loc10_.message,true);
                  _loc2_.tf_text.mouseEnabled = true;
                  _loc2_.mc_rarity.stop();
                  _loc2_.mc_rarity.visible = false;
                  _loc2_.tf_name.visible = false;
                  _loc2_.mc_share.stop();
                  _loc2_.mc_share.visible = false;
                  _loc2_.mc_item.stop();
                  _loc2_.mc_item.visible = false;
                  _loc2_.mc_share.stop();
                  _loc2_.mc_share.visible = false;
                  _loc2_.tf_shareText.visible = false;
                  _loc2_.mc_skip.stop();
                  _loc2_.mc_skip.visible = false;
                  _loc2_.mc_share.stop();
                  _loc2_.mc_share.visible = false;
                  _loc8_ = new WorldPopUp(_loc1_,_loc2_.mc_tick,null);
                  _loc8_.queueToShow();
                  _loc9_++;
               }
               GameWorld.invalidFeedItems = null;
            }
            if(specialDayPresentMails != null)
            {
               for each(_loc11_ in specialDayPresentMails)
               {
                  if(_loc11_.mailObject.globalItemIds[0] > 0)
                  {
                     _loc12_ = new SpecialDayPresentMail(_loc11_,null);
                     _loc12_.queueToShow();
                  }
                  else
                  {
                     _loc13_ = new GameStartMessageMail(_loc11_);
                     _loc13_.queueToShow();
                  }
                  GameWorld.saveProfileHandler.addDeletedMail(_loc11_);
               }
               specialDayPresentMails = null;
            }
            _loc3_ = gameUser.getNewMailItems();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc14_ = _loc3_[_loc4_];
               if(_loc14_.newsletterId != -1 && !_loc14_.mailObject.read)
               {
                  _loc15_ = new NewspaperMail(_loc14_,null);
                  _loc15_.queueToShow();
               }
               _loc4_++;
            }
         }
      }
      
      public function getModifiedOperateTime(param1:RoomItem, param2:int) : int
      {
         if(param1.operateTimePercentage != 100)
         {
            param2 *= param1.operateTimePercentage / 100;
         }
         return param2;
      }
      
      private function onItemWithInfoTextClick(param1:MouseEvent) : void
      {
         var _loc2_:RoomItem = null;
         var _loc3_:WorldItemInfoPopUp = null;
         if(!moveGesture)
         {
            _loc2_ = RoomItem(param1.currentTarget);
            if(visitMode || !_loc2_.isBroken())
            {
               _loc3_ = new WorldItemInfoPopUp(_loc2_.itemConfig,gameUser);
               _loc3_.show();
            }
         }
      }
      
      private function showIngredientShop() : void
      {
         var _loc1_:WorldIngredientShopPopUp = null;
         if(GameWorld.gameUser.level.value >= GameWorld.INGREDIENT_MARKET_UNLOCK_LEVEL)
         {
            GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_INGRADIANT_SHOP);
            if(uiButton.buttonMarket)
            {
               uiButton.buttonMarket.mc_new.visible = false;
            }
            _loc1_ = new WorldIngredientShopPopUp();
            _loc1_.show();
         }
      }
      
      public function hasTrash() : Boolean
      {
         var _loc1_:int = numTilesX * numTilesY;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(trashMap[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function addEmployeeActor(param1:EmployeeActor) : void
      {
         var employeeActor:EmployeeActor = param1;
         room.addObject(employeeActor);
         employeeActors.push(employeeActor);
         employeeActor.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            onActorClicked(employeeActor);
         });
      }
      
      public function getEmptyChairs(param1:Boolean, param2:Boolean, param3:DishOrder) : Array
      {
         var _loc6_:RoomItem = null;
         var _loc7_:RoomItem = null;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < chairs.length)
         {
            _loc6_ = chairs[_loc5_];
            if(!_loc6_.toilet && _loc6_.customer == null)
            {
               if(!param1)
               {
                  _loc4_.push(_loc6_);
               }
               else if(canChairOrder(_loc6_,param3))
               {
                  _loc7_ = getTableForChair(_loc6_);
                  if(_loc7_ != null)
                  {
                     if(param2)
                     {
                        if(isTableFree(_loc7_))
                        {
                           _loc4_.push(_loc6_);
                        }
                     }
                     else
                     {
                        _loc4_.push(_loc6_);
                     }
                  }
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function createOrderForCustomer(param1:Customer) : void
      {
         var _loc2_:int = 0;
         if(gameUser.level.value >= GameWorld.DRINK_START_LEVEL)
         {
            _loc2_ = Engine.rnd(0,Recipe.NUM_MENU_RECIPE_TYPE);
         }
         else
         {
            _loc2_ = Engine.rnd(0,Recipe.NUM_MENU_RECIPE_TYPE - 1);
         }
         var _loc3_:Array = gameUser.getSelectedRecipes(_loc2_);
         var _loc4_:int = Engine.rnd(0,_loc3_.length);
         var _loc5_:DishOrder = new DishOrder(_loc3_[_loc4_]);
         _loc5_.customer = param1;
         param1.order = _loc5_;
      }
      
      public function addCoin(param1:Number, param2:Number, param3:int) : void
      {
         var _loc5_:Coin = null;
         GameWorld.cashPanel.addCoins(param3);
         var _loc4_:Number = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = new Coin(param1,param2,this);
            room.addObject(_loc5_);
            _loc4_++;
         }
      }
      
      private function getBestFreeChef(param1:DishOrder) : ChefActor
      {
         var _loc2_:ChefActor = null;
         var _loc5_:ChefActor = null;
         var _loc3_:int = -1;
         var _loc4_:int = 0;
         while(_loc4_ < chefs.length)
         {
            _loc5_ = chefs[_loc4_];
            if(_loc5_.isFree() && _loc5_.canServe(param1.customer) && _loc5_.employeeUser.workTime > _loc3_)
            {
               _loc2_ = _loc5_;
               _loc3_ = _loc5_.employeeUser.workTime;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function addCleaner(param1:GameUserEmployee) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:RoomItem = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:RoomItem = null;
         var _loc12_:Array = null;
         var _loc13_:RoomItem = null;
         var _loc14_:Array = null;
         removeActor(param1);
         var _loc4_:RandomBasket = new RandomBasket();
         _loc4_.addItemArray(getToiletSeats());
         while(true)
         {
            _loc5_ = RoomItem(_loc4_.getNextItem());
            if(!_loc5_)
            {
               _loc8_ = getEmployeeActorFreeTiles();
               if(_loc8_.length > 0)
               {
                  _loc9_ = int(_loc8_[Engine.rnd(0,_loc8_.length)]);
                  _loc2_ = getTileXFromTileIndex(_loc9_);
                  _loc3_ = getTileYFromTileIndex(_loc9_);
               }
               else
               {
                  _loc2_ = Engine.rnd(-4,-1);
                  _loc3_ = Engine.rnd(1,numTilesY);
               }
               break;
            }
            _loc7_ = getFacingTile(_loc5_.tileX,_loc5_.tileY,_loc5_.getRotationCount());
            if(isWalkable(_loc7_.x,_loc7_.y))
            {
               _loc2_ = int(_loc7_.x);
               _loc3_ = int(_loc7_.y);
               break;
            }
         }
         var _loc6_:CleanerEmployee = new CleanerEmployee(_loc2_,_loc3_,param1,this);
         cleaners.push(_loc6_);
         addEmployeeActor(_loc6_);
         if(_loc2_ > 0 && _loc3_ > 0)
         {
            _loc10_ = 0;
            while(_loc10_ < chairs.length)
            {
               _loc11_ = chairs[_loc10_];
               if(_loc11_.toilet)
               {
                  _loc12_ = _loc6_.getPathTo(_loc11_.tileX,_loc11_.tileY,false);
                  if(_loc12_ != null)
                  {
                     _loc6_.reachableToiletSeats.push(_loc11_);
                  }
               }
               _loc10_++;
            }
            _loc10_ = 0;
            while(_loc10_ < interactiveItems.length)
            {
               _loc13_ = interactiveItems[_loc10_];
               _loc14_ = _loc6_.getPathTo(_loc13_.tileX,_loc13_.tileY,false);
               if(_loc14_ != null)
               {
                  _loc6_.reachableFunctionalItems.push(_loc13_);
               }
               _loc10_++;
            }
         }
      }
      
      override public function addGourmetPoints(param1:Number) : void
      {
         super.addGourmetPoints(param1);
         var _loc2_:GameObject = new GameObject("GourmetPointAdded");
         var _loc3_:int = Math.floor(param1 * 10) % 10;
         var _loc4_:String = "+" + Math.floor(param1);
         if(_loc3_ != 0)
         {
            _loc4_ += "." + _loc3_;
         }
         _loc2_.getChildMovieClipInstance("mc_content").tf_amount.text = _loc4_;
         _loc2_.y += Engine.getStageY();
         _loc2_.drawPriority = SCORE_POPUP_PRIORITY;
         _loc2_.numLoops = 1;
         _loc2_.removeWhenComplete = true;
         Engine.worldContainer.addObject(_loc2_);
         if(levelBar)
         {
            levelBar.refresh();
         }
      }
      
      public function addRandomTrash() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:RandomBasket = new RandomBasket();
         var _loc2_:int = 0;
         while(_loc2_ < numTilesY)
         {
            _loc3_ = 0;
            while(_loc3_ < numTilesX)
            {
               _loc4_ = getTileIndex(_loc3_,_loc2_);
               if(!trashMap[_loc4_] && isWalkable(_loc3_,_loc2_) && !wallMap[_loc4_])
               {
                  _loc1_.addItems(_loc4_);
               }
               _loc3_++;
            }
            _loc2_++;
         }
         _loc2_ = numTilesY;
         while(_loc2_ < numTilesY + numOutsideTilesY)
         {
            _loc3_ = 1;
            while(_loc3_ < numTilesX)
            {
               _loc4_ = getTileIndex(_loc3_,_loc2_);
               if(!trashMap[_loc4_] && isWalkable(_loc3_,_loc2_))
               {
                  _loc1_.addItems(_loc4_);
               }
               _loc3_++;
            }
            _loc2_++;
         }
         if(_loc1_.length() > 0)
         {
            _loc5_ = int(_loc1_.getNextItem());
            _loc6_ = getTileXFromTileIndex(_loc5_);
            _loc7_ = getTileYFromTileIndex(_loc5_);
            if(trashItems.length == 0)
            {
               trashItems = DEFAULT_TRASH_ITEMS;
            }
            addTrashObject(trashItems[Engine.rnd(0,trashItems.length)],_loc6_,_loc7_);
         }
      }
      
      private function addIdleActor(param1:GameUserEmployee) : EmployeeActor
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc8_:int = 0;
         removeActor(param1);
         var _loc4_:Array = getEmployeeActorFreeTiles();
         if(_loc4_.length > 0)
         {
            _loc8_ = int(_loc4_[Engine.rnd(0,_loc4_.length)]);
            _loc2_ = getTileXFromTileIndex(_loc8_);
            _loc3_ = getTileYFromTileIndex(_loc8_);
         }
         else
         {
            _loc2_ = Engine.rnd(-4,-1);
            _loc3_ = Engine.rnd(1,numTilesY);
         }
         var _loc5_:int = getScreenX(_loc2_,_loc3_);
         var _loc6_:int = getScreenY(_loc2_,_loc3_);
         var _loc7_:IdleEmployee = new IdleEmployee(_loc5_,_loc6_,param1,this);
         addEmployeeActor(_loc7_);
         return _loc7_;
      }
      
      public function onCustomerPayForFunctional(param1:RoomItem) : void
      {
         var _loc2_:GameObject = null;
         if(gameUser == GameWorld.gameUser)
         {
            GameWorld.cashPanel.addCoins(GameWorld.COINS_PAYOUT_FUNCTIONAL_ITEMS);
            GameWorld.saveProfileHandler.addPaidFunctional(GameWorld.COINS_PAYOUT_FUNCTIONAL_ITEMS);
            addGourmetPoints(GameWorld.GOURMET_POINTS_PER_FUNCTIONAL_ITEM_PAYOUT);
            _loc2_ = new GameObject("MoneyFunctional");
            _loc2_.getChildMovieClipInstance("mc_money").tf_money.text = "$" + GameWorld.GOURMET_POINTS_PER_FUNCTIONAL_ITEM_PAYOUT;
            _loc2_.x = param1.x;
            _loc2_.y = param1.y;
            _loc2_.drawPriority = SCORE_POPUP_PRIORITY;
            _loc2_.numLoops = 1;
            _loc2_.removeWhenComplete = true;
            room.addObject(_loc2_);
            if(!silentTick)
            {
               cashSound.play(1);
            }
         }
      }
      
      public function refreshRestaurantClosedState() : void
      {
         var _loc1_:Boolean = restaurantClosed;
         restaurantClosed = gameUser.isRestaurantClosed();
         if(!visitMode)
         {
            uiPopularity.mc_closed.visible = restaurantClosed;
            if(!restaurantClosed)
            {
               showRestaurantClosedToolTip = false;
            }
            else if(gameUser.level.value > 0 && !_loc1_)
            {
               showRestaurantClosedToolTip = true;
            }
         }
         Debug.out("restaurantClosed=" + restaurantClosed);
      }
      
      public function getDoorState(param1:RoomItem) : String
      {
         var _loc2_:MovieClip = param1.getChildMovieClipInstance("mc_content");
         if(_loc2_)
         {
            return _loc2_.currentLabel;
         }
         return null;
      }
      
      public function getEmptySinks() : Array
      {
         var _loc3_:RoomItem = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < sinks.length)
         {
            _loc3_ = sinks[_loc2_];
            if(_loc3_.customer == null)
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getEmptyToiletSeats() : Array
      {
         var _loc3_:RoomItem = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < chairs.length)
         {
            _loc3_ = chairs[_loc2_];
            if(_loc3_.customer == null && _loc3_.toilet && !_loc3_.isBroken())
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function onChefFinishOrder(param1:ChefActor) : void
      {
         completedOrders.push(param1.cookingOrder);
         param1.cookingOrder = null;
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         zoomLever.setZoomLevel(ZoomLever.zoomLevel - param1.delta / Math.abs(param1.delta),false);
      }
      
      public function onButtonAvatarClick(param1:MouseEvent) : void
      {
         destroy();
         GameWorld.fadeToWorld(new WorldCustomiseAvatar(GameWorld.gameUser,GameWorld.gameUser));
      }
      
      private function onIngredientShopClick(param1:MouseEvent) : void
      {
         if(!moveGesture)
         {
            showIngredientShop();
         }
      }
      
      public function getPathToRandomInteractiveItem(param1:RestaurantActor, param2:Array) : Object
      {
         var _loc5_:Object = null;
         var _loc6_:PathFinder = null;
         var _loc3_:RandomBasket = new RandomBasket();
         _loc3_.addItemArray(param2);
         var _loc4_:RoomItem = null;
         while(true)
         {
            _loc4_ = RoomItem(_loc3_.getNextItem());
            if(!_loc4_)
            {
               break;
            }
            _loc5_ = getInteractiveItemUserTile(_loc4_);
            if(isWalkable(_loc5_.x,_loc5_.y))
            {
               _loc6_ = new PathFinder(param1.tileX,param1.tileY,_loc5_.x,_loc5_.y,this);
               if(_loc6_.processOpenList(-1) == PathFinder.PROCESS_STATE_FOUND)
               {
                  return {
                     "item":_loc4_,
                     "path":_loc6_.getFinalPath()
                  };
               }
            }
         }
         return null;
      }
      
      public function hasPathToCustomerChair(param1:int, param2:int, param3:RoomItem) : Boolean
      {
         var _loc4_:Object = getFacingTile(param3.tileX,param3.tileY,param3.getRotationCount());
         var _loc5_:PathFinder = new PathFinder(param1,param2,_loc4_.x,_loc4_.y,this,true);
         var _loc6_:int = _loc5_.processOpenList(-1);
         if(_loc6_ == PathFinder.PROCESS_STATE_NO_PATH)
         {
            _loc5_ = new PathFinder(param1,param2,param3.tileX,param3.tileY,this,true);
            _loc6_ = _loc5_.processOpenList(-1);
         }
         return _loc6_ == PathFinder.PROCESS_STATE_FOUND;
      }
      
      public function refreshDemand() : void
      {
         if(uiPopularity)
         {
            uiPopularity.mc_popularity.tf_demand.text = (gameUser.getDemandPoints() / 10).toFixed(1) + " / " + maxDemand / 10;
         }
      }
      
      public function playBgMusic(param1:Object) : void
      {
         if(param1.id != bgMusicId)
         {
            if(bgMusic != null)
            {
               bgMusic.stop();
               bgMusic = null;
            }
            if(Boolean(param1.className) && param1.className.length > 0)
            {
               bgMusic = new GameSound(param1.className,GameSound.TYPE_MUSIC);
               bgMusic.play(-1);
            }
            bgMusicId = param1.id;
         }
      }
      
      public function openDoor(param1:RoomItem) : void
      {
         var _loc3_:String = null;
         var _loc2_:MovieClip = param1.getChildMovieClipInstance("mc_content");
         if(_loc2_)
         {
            _loc3_ = getDoorState(param1);
            if(_loc3_ == "closing" || _loc3_ == "closed")
            {
               setRoomItemState(param1,"opening");
            }
            param1.doorTimer = 1500;
         }
      }
      
      private function onFullScreen(param1:Event) : void
      {
         if(visitMode)
         {
            curFriendsList.y = Engine.getStageBottom();
            uiVisitBanner.x = Engine.getStageRight();
            uiVisitBanner.y = Engine.getStageY();
         }
         else
         {
            GameWorld.hiredFriendsPanel.y = Engine.getStageBottom();
            uiPopularity.x = Engine.getStageRight();
            uiPopularity.y = Engine.getStageY();
         }
         uiButton.y = Engine.getStageBottom();
         uiButton.mc_zoom.x = Engine.getStageRight() - 16;
         uiLevelBar.y = Engine.getStageY();
         buttonGift.x = Engine.getStageX() + buttonGift.width / 2;
         if(buttonBookmark != null)
         {
            buttonBookmark.x = Engine.getStageX() + buttonBookmark.width / 2;
         }
      }
      
      public function hideRateButton() : void
      {
         uiButton.buttonRate.visible = false;
      }
      
      public function setRoomItemUsageCount(param1:RoomItem, param2:int) : void
      {
         param1.usageCount = param2;
         if(param1.toilet)
         {
            if(param1.isBroken())
            {
               param2 = int(param1.itemConfig.breakCount);
               if(param1.toiletWater == null)
               {
                  param1.toiletWater = new BaseObject("ToiletWater");
                  param1.toiletWater.x = param1.x;
                  param1.toiletWater.y = param1.y;
                  param1.toiletWater.drawPriority = WorldRestaurant.SHADOW_DRAW_PRIORITY - 1;
                  room.addObject(param1.toiletWater);
                  param1.toiletStatus = new BaseObject("CleanerNeeded");
                  param1.toiletStatus.x = param1.x;
                  param1.toiletStatus.y = param1.y - tileHeight;
                  param1.toiletStatus.drawPriority = param1.drawPriority;
                  room.addObject(param1.toiletStatus);
                  if(!visitMode)
                  {
                     FixToiletTask.addUserTaskListener(param1);
                  }
               }
            }
            else
            {
               if(param1.toiletWater != null)
               {
                  room.removeObject(param1.toiletWater);
                  room.removeObject(param1.toiletStatus);
                  param1.toiletWater = null;
                  param1.toiletStatus = null;
               }
               if(!visitMode)
               {
                  FixToiletTask.removeUserTaskListener(param1);
               }
            }
         }
         else if(param1.interactive)
         {
            if(param1.isBroken())
            {
               param2 = int(param1.itemConfig.breakCount);
               setRoomItemState(param1,"broken");
               if(!visitMode)
               {
                  FixFunctionalItemTask.addUserTaskListener(param1);
               }
            }
            else
            {
               setRoomItemState(param1,"off");
               if(!visitMode)
               {
                  FixFunctionalItemTask.removeUserTaskListener(param1);
               }
            }
         }
         param1.usageCount = param2;
      }
      
      override public function init() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:UserItem = null;
         var _loc4_:MovieClip = null;
         var _loc5_:RoomItem = null;
         var _loc6_:String = null;
         var _loc7_:GameUserEmployee = null;
         var _loc8_:RandomBasket = null;
         var _loc9_:Boolean = false;
         var _loc10_:GameUserEmployee = null;
         super.init();
         if(!visitMode)
         {
            canvasHeight = Engine.STAGE_HEIGHT - GameWorld.hiredFriendsPanel.getSceneHeight();
            uiButton = Engine.getMovieClip("RoomUiButton");
            uiPopularity = Engine.getMovieClip("RoomUiPopularity");
            uiLevelBar = Engine.getMovieClip("RoomUiLevelBar");
            buttonStreet = uiButton.buttonStreet;
            buttonDecorate = uiButton.buttonDecorate;
            buttonChangeMenu = uiButton.buttonChangeMenu;
            buttonMessage = uiButton.buttonMessage;
            buttonMarket = uiButton.buttonMarket;
            buttonPhoto = uiButton.buttonPhoto;
            buttonGift = uiButton.mc_gift;
            buttonBookmark = uiButton.mc_bookmark;
            buttonFolder = uiButton.mc_folder;
            buttonAvatar = buttonFolder.mc_content.buttonAvatar;
            buttonAward = buttonFolder.mc_content.buttonAward;
            buttonMusicPlayer = buttonFolder.mc_content.buttonMusicPlayer;
            buttonStreet.toolTip = new ToolTip(buttonStreet,GameWorld.textHandler.getTextFromId("ToolTipStreet"));
            buttonAvatar.toolTip = new ToolTip(buttonAvatar,GameWorld.textHandler.getTextFromId("ToolTipDressYourself"),true);
            buttonDecorate.toolTip = new ToolTip(buttonDecorate,GameWorld.textHandler.getTextFromId("ToolTipRedecorate"));
            buttonChangeMenu.toolTip = new ToolTip(buttonChangeMenu,GameWorld.textHandler.getTextFromId("ToolTipChangeMenu"));
            buttonMessage.toolTip = new ToolTip(buttonMessage,GameWorld.textHandler.getTextFromId("ToolTipMailBox"));
            buttonAward.toolTip = new ToolTip(buttonAward,GameWorld.textHandler.getTextFromId("ToolTipAwards"),true);
            buttonMarket.toolTip = new ToolTip(buttonMarket,GameWorld.textHandler.getTextFromId("ToolTipIngredientMarket"));
            buttonMusicPlayer.toolTip = new ToolTip(buttonMusicPlayer,GameWorld.textHandler.getTextFromId("ToolTipMusicPlayer"),true);
            buttonBookmark.toolTip = new ToolTip(buttonBookmark,GameWorld.textHandler.getTextFromId("ToolTipBookmark"));
            uiLevelBar.mc_level.toolTip = new ToolTip(uiLevelBar.mc_level,GameWorld.textHandler.getTextFromId("ToolTipGourmetPointsAndLevel"));
            uiPopularity.mc_popularity.buttonMode = true;
            setHandCursor(uiPopularity.mc_popularity,true);
            uiPopularity.mc_popularity.toolTip = new ToolTip(uiPopularity.mc_popularity,GameWorld.textHandler.getTextFromId("ToolTipPopularity"));
            uiPopularity.mc_popularity.addEventListener(MouseEvent.CLICK,onPopularityClick,false,0,true);
            uiPopularity.mc_closed.buttonMode = true;
            setHandCursor(uiPopularity.mc_closed,true);
            uiPopularity.mc_closed.toolTip = new ToolTip(uiPopularity.mc_closed,GameWorld.textHandler.getTextFromId("ToolTipRestaurantClosed"));
            setButtonMode(buttonStreet,true);
            setButtonMode(buttonAvatar,true);
            setButtonMode(buttonDecorate,true);
            setButtonMode(buttonChangeMenu,true);
            setButtonMode(buttonMessage,true);
            setButtonMode(buttonAward,true);
            setButtonMode(buttonMarket,true);
            setButtonMode(buttonMusicPlayer,true);
            setButtonMode(buttonBookmark,true);
            buttonStreet.addEventListener(MouseEvent.CLICK,onButtonStreetClick,false,0,true);
            buttonAvatar.addEventListener(MouseEvent.CLICK,onButtonAvatarClick,false,0,true);
            buttonDecorate.addEventListener(MouseEvent.CLICK,onButtonDecorateClick,false,0,true);
            buttonChangeMenu.addEventListener(MouseEvent.CLICK,onButtonChangeMenuClick,false,0,true);
            buttonMessage.addEventListener(MouseEvent.CLICK,onButtonMessageClick,false,0,true);
            buttonAward.addEventListener(MouseEvent.CLICK,onButtonAwardClick,false,0,true);
            buttonMarket.addEventListener(MouseEvent.CLICK,onButtonMarketClick,false,0,true);
            buttonMusicPlayer.addEventListener(MouseEvent.CLICK,onButtonMusicPlayerClick,false,0,true);
            buttonBookmark.addEventListener(MouseEvent.CLICK,onButtonBookmarkClick,false,0,true);
            buttonMarket.mc_new.mouseChildren = false;
            buttonMarket.tf_sale.mouseEnabled = false;
            if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_INGRADIANT_SHOP))
            {
               buttonMarket.mc_new.visible = false;
            }
            else
            {
               buttonMarket.tf_sale.visible = false;
            }
            buttonMusicPlayer.mc_new.mouseChildren = false;
            if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_MUSIC_PLAYER))
            {
               buttonMusicPlayer.mc_new.visible = false;
            }
            if(GameWorld.lastBookmarkPopUpTime == -1 || GameWorld.serverTime.time / 1000 - GameWorld.lastBookmarkPopUpTime < 12 * 60 * 60)
            {
               buttonBookmark.visible = false;
            }
            else if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_BOOKMARK))
            {
               buttonBookmark.mc_new.visible = false;
            }
            buttonFolder.mc_new.visible = false;
            folderButtonHandler = new FolderButton(buttonFolder);
            buttonLayer.addChild(uiPopularity);
         }
         else
         {
            canvasHeight = Engine.STAGE_HEIGHT - curFriendsList.getSceneHeight();
            uiButton = Engine.getMovieClip("RoomVisitUiButton");
            uiVisitBanner = Engine.getMovieClip("RoomVisitUiBanner");
            uiLevelBar = Engine.getMovieClip("RoomUiLevelBar");
            buttonGift = uiButton.mc_gift;
            buttonBookmark = uiButton.mc_bookmark;
            setButtonMode(uiButton.buttonStreet,true);
            setButtonMode(uiButton.buttonWriteMessage,true);
            setButtonMode(uiButton.buttonTrade,true);
            setButtonMode(uiButton.buttonRate,true);
            uiButton.buttonStreet.addEventListener(MouseEvent.CLICK,onButtonStreetClick);
            uiButton.buttonStreet.toolTip = new ToolTip(uiButton.buttonStreet,GameWorld.textHandler.getTextFromId("ToolTipStreet"));
            if(WorldStreet.streetType == WorldStreet.STREET_TYPE_FRIENDS)
            {
               uiButton.buttonWriteMessage.addEventListener(MouseEvent.CLICK,onButtonWriteMessageClick);
               uiButton.buttonTrade.addEventListener(MouseEvent.CLICK,onButtonTradeClick);
               uiButton.buttonRate.visible = false;
               uiButton.buttonWriteMessage.toolTip = new ToolTip(uiButton.buttonWriteMessage,GameWorld.textHandler.getTextFromId("ToolTipLeaveAMessage"));
               uiButton.buttonTrade.toolTip = new ToolTip(uiButton.buttonTrade,GameWorld.textHandler.getTextFromId("ToolTipTradeIngredients"));
            }
            else
            {
               if(enableRating)
               {
                  uiButton.buttonRate.addEventListener(MouseEvent.CLICK,onButtonRateClick);
                  uiButton.buttonRate.toolTip = new ToolTip(uiButton.buttonRate,GameWorld.textHandler.getTextFromId("ToolTipRateThisRestaurant"));
               }
               else
               {
                  uiButton.buttonRate.visible = false;
               }
               uiButton.buttonWriteMessage.visible = false;
               uiButton.buttonTrade.visible = false;
               if(gameUser.rated)
               {
                  uiButton.buttonRate.visible = false;
               }
            }
            _loc2_ = GameWorld.getUserFaceImage(gameUser);
            if(_loc2_ != null)
            {
               uiVisitBanner.mc_frame.mc_face.addChild(_loc2_);
            }
            _loc3_ = gameUser.getUsedBuildingBannerItem();
            if(_loc3_ != null)
            {
               _loc4_ = Engine.getMovieClip(_loc3_.itemConfig.className);
               _loc4_.tf_name.text = gameUser.bannerText;
               _loc4_.x = uiVisitBanner.mc_banner.x;
               _loc4_.y = uiVisitBanner.mc_banner.y;
               _loc4_.scaleX = uiVisitBanner.mc_banner.scaleX;
               _loc4_.scaleY = uiVisitBanner.mc_banner.scaleY;
               uiVisitBanner.addChildAt(_loc4_,uiVisitBanner.getChildIndex(uiVisitBanner.mc_banner));
               uiVisitBanner.mc_banner.visible = false;
            }
            else
            {
               uiVisitBanner.mc_banner.tf_name.text = gameUser.bannerText;
            }
            setRating(uiVisitBanner.mc_userStars,gameUser);
            if(!gameUser.userInfo.isInStreet)
            {
               uiVisitBanner.mc_userStars.visible = false;
            }
            buttonLayer.addChild(uiVisitBanner);
         }
         enablePlots();
         setButtonMode(uiButton.buttonPhoto,true);
         uiButton.buttonPhoto.toolTip = new ToolTip(uiButton.buttonPhoto,GameWorld.textHandler.getTextFromId("ToolTipPhoto"));
         uiButton.buttonPhoto.addEventListener(MouseEvent.CLICK,onButtonPhotoClick,false,0,true);
         uiButton.buttonPhoto.mc_new.mouseEnabled = false;
         if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_PHOTO))
         {
            uiButton.buttonPhoto.mc_new.visible = false;
         }
         setButtonMode(buttonGift,true);
         buttonGift.toolTip = new ToolTip(buttonGift,GameWorld.textHandler.getTextFromId("SendFreeFoodToFriends"));
         buttonGift.addEventListener(MouseEvent.CLICK,onButtonGiftInviteClick,false,0,true);
         buttonGift.mc_new.mouseEnabled = false;
         if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GIFT_INVITE_FOOD))
         {
            buttonGift.mc_new.visible = false;
         }
         setRating(uiLevelBar.mc_stars,GameWorld.gameUser);
         if(!GameWorld.gameUser.userInfo.isInStreet)
         {
            uiLevelBar.mc_stars.visible = false;
         }
         zoomLever = new ZoomLever(uiButton.mc_zoom,this);
         buttonLayer.addChild(uiButton);
         buttonLayer.addChild(uiLevelBar);
         var _loc1_:int = 0;
         while(_loc1_ < placedItems.length)
         {
            _loc5_ = placedItems[_loc1_];
            if(_loc5_.chairItem)
            {
               chairs.push(_loc5_);
            }
            else if(_loc5_.doorItem)
            {
               doors.push(_loc5_);
            }
            else if(_loc5_.kitchen)
            {
               kitchens.push(_loc5_);
            }
            else if(_loc5_.interactive)
            {
               interactiveItems.push(_loc5_);
            }
            else if(_loc5_.sink)
            {
               sinks.push(_loc5_);
            }
            else if(_loc5_.drink)
            {
               drinkItems.push(_loc5_);
            }
            else if(_loc5_.bed)
            {
               beds.push(_loc5_);
            }
            if(_loc5_.menuItem)
            {
               menuItem = _loc5_;
            }
            else if(_loc5_.achievementItem)
            {
               achievementItem = _loc5_;
            }
            else if(_loc5_.mailItem)
            {
               mailItem = _loc5_;
            }
            else if(_loc5_.musicPlayer)
            {
               _loc5_.buttonMode = true;
               _loc5_.toolTip = new ToolTip(_loc5_,GameWorld.textHandler.getTextFromId("ToolTipMusicPlayer"));
               _loc5_.addEventListener(MouseEvent.CLICK,onMusicPlayerClick,false,0,true);
            }
            if(_loc5_.itemConfig.breakCount)
            {
               setRoomItemUsageCount(_loc5_,Engine.rnd(0,int(_loc5_.itemConfig.breakCount) + 1));
            }
            if(_loc5_.itemConfig.infoText)
            {
               _loc5_.buttonMode = true;
               _loc6_ = _loc5_.itemConfig.name;
               if(_loc5_.itemConfig.arcadeGame)
               {
                  _loc6_ += "\n\n" + GameWorld.textHandler.getTextFromId("ClickToPlay");
               }
               _loc5_.toolTip = new ToolTip(_loc5_,_loc6_);
               _loc5_.addEventListener(MouseEvent.CLICK,onItemWithInfoTextClick,false,0,true);
            }
            _loc5_.initFunctions(this);
            _loc1_++;
         }
         ingredientShop = roadLayer.mc_ingredientShop;
         ingredientShop.buttonMode = true;
         ingredientShop.toolTip = new ToolTip(ingredientShop,GameWorld.textHandler.getTextFromId("ToolTipIngredientMarket"));
         ingredientShop.addEventListener(MouseEvent.CLICK,onIngredientShopClick,false,0,true);
         _loc1_ = 0;
         while(_loc1_ < gameUser.employeeUsers.length)
         {
            _loc7_ = gameUser.employeeUsers[_loc1_];
            if(_loc7_.gameUser.employerUser != gameUser)
            {
               _loc7_.gameUser.employerUser = gameUser;
               _loc7_.gameUser.clearAnimationFrames();
            }
            _loc1_++;
         }
         if(DEBUG_PLAYER)
         {
            debugPlayer = new AvatarActor(0,0,new GameUser(null),this,[Avatar3D.ANIMATION_IDLE,Avatar3D.ANIMATION_WALK]);
            debugPlayer.setAnimation(Avatar3D.ANIMATION_IDLE);
            room.addObject(debugPlayer);
            room.addEventListener(MouseEvent.MOUSE_DOWN,onMoveDebugPlayer);
         }
         levelBar = new LevelBar(uiLevelBar.mc_level,GameWorld.gameUser);
         uiLevelBar.mc_level.buttonMode = true;
         uiLevelBar.mc_level.addEventListener(MouseEvent.CLICK,onLevelBarClick,false,0,true);
         uiLevelBar.cacheAsBitmap = true;
         if(achievementItem)
         {
            achievementItem.toolTip = new ToolTip(achievementItem,GameWorld.textHandler.getTextFromId("ToolTipAwards"));
            achievementItem.addEventListener(MouseEvent.CLICK,onAchievementItemClick);
            achievementItem.buttonMode = true;
         }
         if(menuItem)
         {
            menuItem.toolTip = new ToolTip(menuItem,GameWorld.textHandler.getTextFromId("ToolTipRestaurantMenu"));
            menuItem.addEventListener(MouseEvent.CLICK,onMenuItemClick);
            menuItem.buttonMode = true;
         }
         if(mailItem)
         {
            mailItem.toolTip = new ToolTip(mailItem,GameWorld.textHandler.getTextFromId("ToolTipMailBox"));
            mailItem.addEventListener(MouseEvent.CLICK,onMailItemClick);
            mailItem.buttonMode = true;
         }
         refreshDemand();
         _loc1_ = 0;
         while(_loc1_ < gameUser.trashCount.value)
         {
            addRandomTrash();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < trees.length)
         {
            if(trees[_loc1_].canBeShaken())
            {
               trees[_loc1_].buttonMode = true;
               trees[_loc1_].addEventListener(MouseEvent.MOUSE_DOWN,onTreeMouseDown,false,0,true);
            }
            _loc1_++;
         }
         if(!visitMode)
         {
            refreshEmployeeCount();
            refreshMails();
         }
         if(visitMode && WorldStreet.streetType == WorldStreet.STREET_TYPE_FRIENDS)
         {
            if(!alreadyHelpedCurrentFriend() && !maxActivitesForTodayReached())
            {
               _loc8_ = new RandomBasket(0,VisitActivity.ACTIVITY_STRINGS.length);
               _loc9_ = false;
               while(!_loc9_ && _loc8_.length() > 0)
               {
                  visitActivity = VisitActivity.create(int(_loc8_.getNextItem()));
                  visitActivity.init(this);
                  _loc9_ = visitActivity.run();
               }
               if(!_loc9_)
               {
                  Debug.out("Error -- No activity selected for user!");
               }
            }
         }
         gameUser.refreshBedStatusForRestingEmployees();
         _loc1_ = 0;
         while(_loc1_ < gameUser.employeeUsers.length)
         {
            _loc10_ = gameUser.employeeUsers[_loc1_];
            createEmployeeActor(_loc10_);
            _loc1_++;
         }
         refreshRestaurantClosedState();
         if(!visitMode)
         {
            addRestaurantExtension(new TutorialExtension(this));
         }
      }
      
      private function hasValidEntrances() : Boolean
      {
         var _loc2_:RoomItem = null;
         var _loc3_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < doors.length)
         {
            _loc2_ = doors[_loc1_];
            _loc3_ = getFacingTile(_loc2_.tileX,_loc2_.tileY,_loc2_.getRotationCount());
            if(isWalkable(_loc3_.x,_loc3_.y))
            {
               return true;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < numOutsideTilesY)
         {
            if(isWalkable(1,numTilesY + _loc1_))
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function getChefCountForKitchen(param1:RoomItem) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < chefs.length)
         {
            if(chefs[_loc3_].kitchen == param1)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function hideNotify() : void
      {
         super.hideNotify();
         if(visitMode)
         {
            curFriendsList.removeEventListener(FriendListEvent.USER_CLICKED,onFriendListUserClicked);
            removeObject(curFriendsList);
         }
         else
         {
            removeObject(GameWorld.hiredFriendsPanel);
            GameWorld.offlineEarningTimer = getTimer();
         }
         removeObject(GameWorld.cashPanel);
         GameWorld.settingOverlay.hideSaveButton();
         if(bgMusic != null)
         {
            bgMusic.stop();
         }
         instance = null;
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onFullScreen);
      }
      
      public function addTrashObject(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:int = getTileIndex(param2,param3);
         trashMap[_loc4_] = true;
         var _loc5_:GameObject = new GameObject(param1);
         _loc5_.tileIndex = _loc4_;
         _loc5_.tileX = param2;
         _loc5_.tileY = param3;
         _loc5_.className = param1;
         _loc5_.x = getScreenX(param2,param3);
         _loc5_.y = getScreenY(param2,param3) + tileHeightHalf;
         _loc5_.drawPriority = getTileDrawPriority(param2,param3);
         _loc5_.buttonMode = true;
         room.addObject(_loc5_);
         trashObjects.push(_loc5_);
         ++trashCount.value;
      }
      
      private function onLevelBarClick(param1:MouseEvent) : void
      {
         GameWorld.showNextLevelPopUp(GameWorld.gameUser.level.value);
      }
      
      private function getRandomFreeFriendUser() : GameUser
      {
         var _loc1_:Array = GameWorld.cachedGameUsers[RpcClient.USER_CONTEXT_FRIENDS | RpcClient.TIME_CONTEXT_ALL];
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_[_loc3_] = _loc1_[_loc3_];
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < customers.length)
         {
            if(customers[_loc3_].user.userInfo)
            {
               _loc2_.splice(_loc2_.indexOf(customers[_loc3_].user),1);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < gameUser.employeeUsers.length)
         {
            _loc2_.splice(_loc2_.indexOf(gameUser.employeeUsers[_loc3_].gameUser),1);
            _loc3_++;
         }
         if(_loc2_.length > 0)
         {
            return _loc2_[Engine.rnd(0,_loc2_.length)];
         }
         return null;
      }
      
      private function onFriendListUserClicked(param1:FriendListEvent) : void
      {
         destroy();
         GameWorld.fadeToWorld(new WorldStreet(param1.user,false,false));
      }
      
      private function onButtonPhotoClick(param1:MouseEvent) : void
      {
         uiButton.buttonPhoto.mc_new.visible = false;
         var _loc2_:BitmapData = GameWorld.convertToBitmapData(room,1,new Rectangle(-(numTilesY + numOutsideTilesY) * tileWidthHalf + tileWidthHalf / 2,-100,floorLayer.width,floorLayer.height + 110),WorldPhotoPreviewPopUp.MAX_PHOTO_WIDTH,WorldPhotoPreviewPopUp.MAX_PHOTO_HEIGHT);
         var _loc3_:BitmapData = GameWorld.convertToBitmapData(room,room.scaleX,new Rectangle(-room.x + Engine.getStageX(),-room.y + Engine.getStageY(),Engine.getStageWidth(),Engine.getStageHeight() - GameWorld.hiredFriendsPanel.height),WorldPhotoPreviewPopUp.MAX_PHOTO_WIDTH,WorldPhotoPreviewPopUp.MAX_PHOTO_HEIGHT);
         var _loc4_:WorldPhotoPreviewPopUp = new WorldPhotoPreviewPopUp([_loc2_,_loc3_]);
         _loc4_.show();
      }
      
      private function getEmployeeActorFreeTiles() : Array
      {
         var _loc3_:Number = NaN;
         var _loc1_:Array = new Array();
         var _loc2_:Number = 1;
         while(_loc2_ < numTilesX)
         {
            _loc3_ = 1;
            while(_loc3_ < numTilesY)
            {
               if(isWalkable(_loc2_,_loc3_) && !isOccupiedByEmployeeActor(_loc2_,_loc3_))
               {
                  _loc1_.push(getTileIndex(_loc2_,_loc3_));
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function showAwardPopUp() : void
      {
         var _loc1_:WorldAwards = null;
         if(GameWorld.gameUser.level.value > 0)
         {
            _loc1_ = new WorldAwards(gameUser.awards);
            _loc1_.show();
         }
      }
      
      public function setDemand(param1:int) : void
      {
         gameUser.setDemandPoints(Math.min(param1,maxDemand));
         refreshDemand();
      }
      
      private function onTreeMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:RestaurantTreeObject = RestaurantTreeObject(param1.currentTarget);
         if(_loc2_.shake())
         {
            addCoin(param1.currentTarget.x,param1.currentTarget.y + 40,GameWorld.SHAKE_TREE_COIN);
            GameWorld.saveProfileHandler.addShakenTree();
         }
      }
      
      public function onButtonTradeClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldTradePanel = new WorldTradePanel(gameUser,false);
         _loc2_.show();
      }
      
      public function onButtonWriteMessageClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldWriteMessage = new WorldWriteMessage(null,this.gameUser,null);
         _loc2_.show();
      }
      
      public function removeVisitActivity() : void
      {
         visitActivity = null;
      }
      
      public function setRoomItemState(param1:RoomItem, param2:String) : void
      {
         var _loc5_:int = 0;
         var _loc3_:MovieClip = param1.getChildMovieClipInstance("mc_content");
         if(_loc3_)
         {
            _loc3_.gotoAndPlay(param2);
            if(param1.subItemAutoSplit)
            {
               _loc5_ = 0;
               while(_loc5_ < param1.subItems.length)
               {
                  setRoomItemState(param1.subItems[_loc5_],param2);
                  _loc5_++;
               }
            }
         }
         _loc3_ = param1.getChildMovieClipInstance("mc_contentReverse");
         var _loc4_:int = 1;
         while(_loc3_)
         {
            _loc3_.gotoAndPlay(param2);
            _loc3_ = param1.getChildMovieClipInstance("mc_content" + _loc4_);
            _loc4_++;
         }
      }
      
      public function onButtonChangeMenuClick(param1:MouseEvent) : void
      {
         if(GameWorld.gameUser.level.value > 0)
         {
            destroy();
            GameWorld.fadeToWorld(new WorldRecipeMenu(gameUser));
         }
      }
      
      private function onPopularityClick(param1:MouseEvent) : void
      {
      }
      
      public function addRestingEmployee(param1:GameUserEmployee) : void
      {
         var _loc2_:RoomItem = null;
         var _loc3_:int = 0;
         var _loc4_:RoomItem = null;
         var _loc5_:SleepingEmployee = null;
         removeActor(param1);
         if(param1.bedItem != null)
         {
            _loc3_ = 0;
            while(_loc3_ < beds.length)
            {
               _loc4_ = beds[_loc3_];
               if(_loc4_.serverUid == param1.bedItem.serverUid)
               {
                  _loc2_ = _loc4_;
                  break;
               }
               _loc3_++;
            }
            if(_loc2_)
            {
               param1.bedItem = _loc2_.getUserItem();
               _loc5_ = new SleepingEmployee(param1,_loc2_,this);
               addEmployeeActor(_loc5_);
            }
         }
      }
      
      public function addOrderFromCustomer(param1:Customer) : void
      {
         param1.order.chair = param1.chair;
         orders.push(param1.order);
      }
      
      public function fixBreakableItem(param1:RoomItem) : void
      {
         setRoomItemUsageCount(param1,0);
         var _loc2_:GameObject = new GameObject("Clean");
         _loc2_.removeWhenComplete = true;
         _loc2_.numLoops = 1;
         _loc2_.drawPriority = param1.drawPriority;
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         room.addObject(_loc2_);
         param1.cleaner = null;
      }
      
      private function canChairOrder(param1:RoomItem, param2:DishOrder) : Boolean
      {
         if(param2)
         {
            if(param2.recipe.type == Recipe.MENU_RECIPE_DRINK)
            {
               return param1.canOrderDrink;
            }
            return param1.canOrderFood;
         }
         return true;
      }
      
      private function onButtonBookmarkClick(param1:MouseEvent) : void
      {
         GameWorld.showBookmarkOverlay();
         buttonBookmark.visible = false;
         GameWorld.lastBookmarkPopUpTime = GameWorld.serverTime.time / 1000;
         GameWorld.globalRpcs.writeBookmarkCount(GameWorld.lastBookmarkPopUpTime);
         GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_BOOKMARK);
         buttonBookmark.mc_new.visible = false;
      }
      
      public function refreshMails() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MailItem = null;
         var _loc6_:WorldMailCoinBagPopUp = null;
         if(!visitMode)
         {
            _loc1_ = gameUser.getNewMailItems();
            unreadMailCount = _loc1_.length;
            buttonMessage.tf_count.mouseEnabled = false;
            buttonMessage.tf_count.text = Math.min(_loc1_.length,99);
            if(mailItem)
            {
               _loc3_ = mailItem.getChildMovieClipInstance("mc_letterBox");
               _loc4_ = mailItem.getChildMovieClipInstance("mc_letterBoxReverse");
               if(unreadMailCount == 0)
               {
                  _loc3_.gotoAndStop("off");
                  _loc4_.gotoAndStop("off");
               }
               else
               {
                  _loc3_.gotoAndPlay("on");
                  _loc4_.gotoAndPlay("on");
               }
            }
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc5_ = _loc1_[_loc2_];
               if(_loc5_.type == RpcClient.MAIL_TYPE_CASH)
               {
                  _loc6_ = new WorldMailCoinBagPopUp(_loc5_,null);
                  _loc6_.queueToShow();
                  GameWorld.gameUser.removeMailItem(_loc5_);
               }
               _loc2_++;
            }
         }
      }
      
      public function removeTrashObject(param1:GameObject) : void
      {
         trashMap[param1.tileIndex] = false;
         gameUser.trashCount.value = Math.max(gameUser.trashCount.value - 1,0);
         trashCount.value = Math.max(trashCount.value - 1,0);
         trashObjects.splice(trashObjects.indexOf(param1),1);
         room.removeObject(param1);
         GameWorld.addAwardValue(GameAwards.AWARD_REMOVE_TRASH,1);
         var _loc2_:GameObject = new GameObject("Trash");
         var _loc3_:MovieClip = _loc2_.getChildMovieClipInstance("mc_content");
         _loc3_.getChildAt(0).visible = false;
         _loc3_.addChild(Engine.getMovieClip(param1.className));
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.setSequence("remove");
         _loc2_.numLoops = 1;
         _loc2_.removeWhenComplete = true;
         _loc2_.drawPriority = int.MAX_VALUE / 2;
         room.addObject(_loc2_);
         var _loc4_:int = Engine.rnd(0,maxTrashCoins) + 1;
         addCoin(param1.x,param1.y,GameWorld.SHAKE_TREE_COIN * _loc4_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            GameWorld.saveProfileHandler.addTrash();
            _loc5_++;
         }
         addGourmetPoints(GameWorld.GOURMET_POINTS_TRASH);
      }
      
      public function onButtonRateClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldRatePopUp = new WorldRatePopUp(gameUser,this);
         _loc2_.show();
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:RoomItem = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Customer = null;
         var _loc12_:* = 0;
         var _loc13_:DishOrder = null;
         var _loc14_:DishOrder = null;
         var _loc15_:Object = null;
         var _loc16_:Waitor = null;
         var _loc17_:Object = null;
         var _loc18_:ChefActor = null;
         var _loc19_:GameObject = null;
         var _loc20_:BaseObject = null;
         var _loc21_:ToolTip = null;
         super.tick(param1);
         if(restaurantClosed)
         {
            if(visitMode)
            {
            }
         }
         else if(nextCustomer == null)
         {
            if(gameUser.level.value > 0)
            {
               customerTimer = 60000 / (Math.min(gameUser.getDemandPoints(),GameWorld.MAX_DEMAND) * CUSTOMERS_PER_MINUTE_PER_DEMAND) + Engine.rnd(-3000,3000);
               if(hasValidEntrances())
               {
                  _loc2_ = Engine.rnd(0,PEDESTRIAN_START_TILE_POSITION.length);
                  _loc3_ = int(PEDESTRIAN_START_TILE_POSITION[_loc2_][0]);
                  _loc4_ = int(PEDESTRIAN_START_TILE_POSITION[_loc2_][1]);
                  nextCustomer = getNextCustomer(getScreenX(_loc3_,_loc4_),getScreenY(_loc3_,_loc4_));
                  nextCustomer.hide();
                  customers.push(nextCustomer);
               }
            }
         }
         else
         {
            customerTimer -= param1;
            if(customerTimer <= 0)
            {
               _loc5_ = getValidDoors();
               _loc6_ = getValidOutsideAreaEntrances();
               if(_loc5_.length > 0 && (Engine.rnd(0,2) == 0 || _loc6_.length == 0))
               {
                  _loc7_ = _loc5_[Engine.rnd(0,_loc5_.length)];
                  nextCustomer.walkToEntrance(_loc7_.tileX,_loc7_.tileY,_loc7_);
               }
               else
               {
                  _loc8_ = int(_loc6_[Engine.rnd(0,_loc6_.length)]);
                  nextCustomer.walkToEntrance(0,_loc8_,null);
               }
               nextCustomer.show();
               room.addObject(nextCustomer);
               nextCustomer = null;
            }
         }
         if(customers.length < NUM_CACHED_CUSTOMERS)
         {
            pedestrianCreateTimer -= param1;
            if(pedestrianCreateTimer <= 0)
            {
               _loc2_ = Engine.rnd(0,PEDESTRIAN_START_TILE_POSITION.length);
               _loc3_ = int(PEDESTRIAN_START_TILE_POSITION[_loc2_][0]);
               _loc4_ = int(PEDESTRIAN_START_TILE_POSITION[_loc2_][1]);
               _loc9_ = int(PEDESTRIAN_END_TILE_POSITION[_loc2_][0]);
               _loc10_ = int(PEDESTRIAN_END_TILE_POSITION[_loc2_][1]);
               _loc11_ = getNextCustomer(getScreenX(_loc3_,_loc4_),getScreenY(_loc3_,_loc4_));
               _loc11_.setPedestrian(_loc9_,_loc10_);
               customers.push(_loc11_);
               room.addObject(_loc11_);
               pedestrianCreateTimer = PEDESTRAIN_CREATE_TIMER;
            }
         }
         if(completedOrders.length > 0)
         {
            _loc12_ = int(completedOrders.length - 1);
            while(_loc12_ >= 0)
            {
               _loc13_ = completedOrders[_loc12_];
               if(moveClosestFreeWaitorToCookedOrder(_loc13_))
               {
                  completedOrders.splice(_loc12_,1);
               }
               _loc12_--;
            }
         }
         if(orders.length > 0)
         {
            _loc12_ = int(orders.length - 1);
            while(_loc12_ >= 0)
            {
               _loc14_ = orders[_loc12_];
               if(_loc14_.recipe.type == Recipe.MENU_RECIPE_DRINK)
               {
                  _loc15_ = getWaiterForDrinkOrder(_loc14_);
                  if(_loc15_ != null)
                  {
                     _loc16_ = _loc15_.waitor;
                     _loc16_.getOrderFromDrinkItem(_loc14_,_loc15_.path,_loc15_.drinkItem);
                     orders.splice(_loc12_,1);
                  }
               }
               _loc12_--;
            }
         }
         if(emptyPlates.length > 0)
         {
            _loc12_ = 0;
            while(_loc12_ < emptyPlates.length)
            {
               _loc13_ = emptyPlates[_loc12_];
               _loc17_ = getClosestFreeWaitor(_loc13_.tileX,_loc13_.tileY,null);
               if(_loc17_ == null)
               {
                  _loc17_ = getClosestFreeWaitor(_loc13_.chair.tileX,_loc13_.chair.tileY,null);
               }
               if(_loc17_)
               {
                  emptyPlates.splice(_loc12_,1);
                  _loc17_.path.pop();
                  _loc17_.waitor.doGetEmptyPlate(_loc13_,_loc17_.path);
               }
               else
               {
                  _loc12_++;
               }
            }
         }
         if(orders.length > 0)
         {
            _loc12_ = int(orders.length - 1);
            while(_loc12_ >= 0)
            {
               _loc13_ = orders[_loc12_];
               if(_loc13_.recipe.type != Recipe.MENU_RECIPE_DRINK)
               {
                  _loc18_ = getBestFreeChef(_loc13_);
                  if(_loc18_ != null)
                  {
                     _loc18_.cook(_loc13_);
                     orders.splice(_loc12_,1);
                  }
               }
               _loc12_--;
            }
         }
         _loc12_ = 0;
         while(_loc12_ < doors.length)
         {
            if(getDoorState(doors[_loc12_]) == "open")
            {
               if(doors[_loc12_].doorTimer)
               {
                  doors[_loc12_].doorTimer -= param1;
                  if(doors[_loc12_].doorTimer <= 0)
                  {
                     setRoomItemState(doors[_loc12_],"closing");
                  }
               }
            }
            _loc12_++;
         }
         _loc12_ = 0;
         while(_loc12_ < trashObjects.length)
         {
            _loc19_ = trashObjects[_loc12_];
            if(_loc19_.trashOutline != null)
            {
               if(!_loc19_.hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY,false))
               {
                  room.removeObject(_loc19_.trashOutline);
                  _loc19_.trashOutline = null;
               }
            }
            else if(_loc19_.hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY,false))
            {
               _loc20_ = new BaseObject(_loc19_.className + "Outline");
               _loc20_.drawPriority = int.MAX_VALUE / 2;
               _loc20_.x = _loc19_.x;
               _loc20_.y = _loc19_.y;
               _loc20_.trashObject = _loc19_;
               _loc20_.buttonMode = true;
               _loc20_.addEventListener(MouseEvent.MOUSE_DOWN,onTrashMouseDown,false,0,true);
               _loc19_.trashOutline = _loc20_;
               room.addObject(_loc20_);
            }
            _loc12_++;
         }
         if(!visitMode && !silentTick)
         {
            GameWorld.trashTimer -= param1;
            if(GameWorld.trashTimer <= 0)
            {
               gameUser.trashCount.value = Math.min(gameUser.trashCount.value + 1,GameWorld.MAX_TRASH);
               GameWorld.trashTimer = GameWorld.TRASH_APPEAR_RATE.value + Engine.rnd(-GameWorld.TRASH_APPEAR_RATE_RANDOM_DELTA,GameWorld.TRASH_APPEAR_RATE_RANDOM_DELTA);
            }
            if(trashCount.value < gameUser.trashCount.value)
            {
               addRandomTrash();
            }
            gameUser.tick(param1);
            userTaskQueue.tick(param1);
         }
         if(visitMode && visitActivity != null)
         {
            userTaskQueue.tick(param1);
            visitActivity.tick(param1);
         }
         if(!silentTick)
         {
            if(foodKing)
            {
               foodKing.tick(param1);
            }
            if(showRestaurantClosedToolTip)
            {
               if(WorldPopUp.activePopUp.length == 0)
               {
                  showRestaurantClosedToolTip = false;
                  _loc21_ = uiPopularity.mc_closed.toolTip;
                  _loc21_.show(5000);
               }
            }
         }
      }
      
      override public function keyDown(param1:int, param2:int) : void
      {
      }
      
      public function getEmptyInteractiveItems() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < interactiveItems.length)
         {
            if(interactiveItems[_loc2_].customer == null && !interactiveItems[_loc2_].isBroken())
            {
               _loc1_.push(interactiveItems[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function isStoveAvailable(param1:RoomItem) : Boolean
      {
         var _loc2_:MovieClip = param1.getChildMovieClipInstance("mc_content");
         return _loc2_.currentLabel == "idle";
      }
      
      private function addRestaurantClosedTime(param1:int) : void
      {
         var _loc3_:int = 0;
         restaurantClosedTimer += param1;
         var _loc2_:Number = GameWorld.RESTAURANT_CLOSED_DEMAND_DECREASE_RATE_PER_HOUR * restaurantClosedTimer / GameWorld.HOUR_MILLIS;
         if(_loc2_ >= 1)
         {
            _loc3_ = Math.floor(_loc2_);
            addDemand(-_loc3_);
            restaurantClosedTimer -= _loc3_ / GameWorld.RESTAURANT_CLOSED_DEMAND_DECREASE_RATE_PER_HOUR * GameWorld.HOUR_MILLIS;
         }
      }
      
      public function disablePlots() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < plots.length)
         {
            plots[_loc1_].disableClicks();
            _loc1_++;
         }
      }
      
      private function onMusicPlayerClick(param1:MouseEvent) : void
      {
         if(!moveGesture)
         {
            showMusicStore();
         }
      }
      
      private function maxActivitesForTodayReached() : Boolean
      {
         var _loc1_:int = GameWorld.getVisitRewardAmount();
         if(_loc1_)
         {
            return false;
         }
         return true;
      }
      
      public function isOccupiedByEmployeeActor(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < employeeActors.length)
         {
            if(employeeActors[_loc3_].tileX == param1 && employeeActors[_loc3_].tileY == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function getToiletSeats() : Array
      {
         var _loc3_:RoomItem = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < chairs.length)
         {
            _loc3_ = chairs[_loc2_];
            if(_loc3_.toilet)
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function onButtonMusicPlayerClick(param1:MouseEvent) : void
      {
         showMusicStore();
      }
      
      private function isKitchenOccupied(param1:RoomItem) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < chefs.length)
         {
            if(chefs[_loc2_].kitchen == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function onCustomerLeave(param1:Customer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1.chair != null)
         {
            param1.chair.customer = null;
            param1.chair = null;
         }
         if(param1.order != null)
         {
            _loc2_ = orders.indexOf(param1.order);
            if(_loc2_ != -1)
            {
               orders.splice(_loc2_,1);
            }
            _loc3_ = completedOrders.indexOf(param1.order);
            if(_loc3_ != -1)
            {
               completedOrders.splice(_loc3_,1);
            }
            if(param1.order.kitchen)
            {
               setRoomItemState(param1.order.kitchen,"idle");
            }
            _loc4_ = 0;
            while(_loc4_ < chefs.length)
            {
               if(chefs[_loc4_].cookingOrder == param1.order)
               {
                  chefs[_loc4_].discardCurrentOrder();
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < waitors.length)
            {
               if(waitors[_loc4_].order == param1.order)
               {
                  waitors[_loc4_].order = null;
               }
               _loc4_++;
            }
            if(param1.order.table)
            {
               param1.order.table.tableTopOrder = null;
            }
            param1.order = null;
         }
      }
      
      private function getValidDoors() : Array
      {
         var _loc3_:RoomItem = null;
         var _loc4_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:Number = 0;
         while(_loc2_ < doors.length)
         {
            _loc3_ = doors[_loc2_];
            _loc4_ = getFacingTile(_loc3_.tileX,_loc3_.tileY,_loc3_.getRotationCount());
            if(isWalkable(_loc4_.x,_loc4_.y))
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function removeActor(param1:GameUserEmployee) : void
      {
         var _loc2_:EmployeeActor = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:GameUserEmployee = null;
         var _loc3_:int = 0;
         while(_loc3_ < employeeActors.length)
         {
            if(employeeActors[_loc3_].employeeUser == param1)
            {
               _loc2_ = employeeActors[_loc3_];
               employeeActors.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            _loc2_.destroy();
            room.removeObject(_loc2_);
            _loc4_ = chefs.indexOf(_loc2_);
            if(_loc4_ != -1)
            {
               chefs.splice(_loc4_,1);
               _loc3_ = 0;
               while(_loc3_ < employeeActors.length)
               {
                  if(employeeActors[_loc3_].emotionType == EmployeeActor.EMOTION_NEED_STOVE)
                  {
                     addChef(employeeActors[_loc3_].employeeUser);
                     break;
                  }
                  _loc3_++;
               }
            }
            _loc5_ = waitors.indexOf(_loc2_);
            if(_loc5_ != -1)
            {
               waitors.splice(_loc5_,1);
            }
            _loc6_ = cleaners.indexOf(_loc2_);
            if(_loc6_ != -1)
            {
               cleaners.splice(_loc6_,1);
            }
            if(_loc2_ is SleepingEmployee)
            {
               _loc3_ = 0;
               while(_loc3_ < gameUser.employeeUsers.length)
               {
                  _loc7_ = gameUser.employeeUsers[_loc3_];
                  if(_loc7_.job == GameUserEmployee.JOB_REST && getEmployeeActor(_loc7_) == null)
                  {
                     addRestingEmployee(_loc7_);
                     break;
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      public function onHireUser(param1:GameUserEmployee) : void
      {
         if(!visitMode)
         {
            createEmployeeActor(param1);
            refreshRestaurantClosedState();
         }
      }
      
      public function refreshEmployeeCount() : void
      {
         if(uiButton.buttonHireFriends)
         {
            if(!visitMode)
            {
               uiButton.buttonHireFriends.tf_count.mouseEnabled = false;
               uiButton.buttonHireFriends.tf_count.text = gameUser.employeeUsers.length + "/" + GameWorld.maxEmployees;
               if(gameUser.employeeUsers.length < GameWorld.maxEmployees)
               {
                  uiButton.buttonHireFriends.glowEffect = new GlowEffect(uiButton.buttonHireFriends,16777215,0.1,0.8);
               }
               else if(uiButton.buttonHireFriends.glowEffect)
               {
                  uiButton.buttonHireFriends.glowEffect.remove();
               }
            }
            else if(uiButton.buttonHireFriends.glowEffect)
            {
               uiButton.buttonHireFriends.glowEffect.remove();
            }
         }
      }
      
      public function clearEmptyPlate(param1:DishOrder) : void
      {
         var _loc2_:GameObject = null;
         room.removeObject(param1);
         onCustomerPay(param1);
         if(param1.recipe.type == Recipe.MENU_RECIPE_DRINK)
         {
            _loc2_ = new GameObject("MoneyDrink");
         }
         else
         {
            _loc2_ = new GameObject("Money");
         }
         if(gameUser == GameWorld.gameUser)
         {
            _loc2_.getChildMovieClipInstance("mc_money").tf_money.text = "$" + param1.recipe.cost;
         }
         else
         {
            _loc2_.getChildMovieClipInstance("mc_money").tf_money.visible = false;
         }
         var _loc3_:MovieClip = _loc2_.getChildMovieClipInstance("mc_plate");
         if(_loc3_)
         {
            _loc3_.gotoAndStop(param1.recipe.level);
         }
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.drawPriority = param1.drawPriority;
         _loc2_.numLoops = 1;
         _loc2_.removeWhenComplete = true;
         room.addObject(_loc2_);
         param1.table.tableTopOrder = null;
         param1 = null;
         if(!silentTick)
         {
            cashSound.play(1);
         }
      }
      
      private function onMenuItemClick(param1:MouseEvent) : void
      {
         if(!moveGesture)
         {
            onButtonChangeMenuClick(null);
         }
      }
      
      private function onActorClicked(param1:EmployeeActor) : void
      {
         if(!moveGesture)
         {
            if(!visitMode)
            {
               GameWorld.hiredFriendsPanel.showJobPanel(param1.employeeUser);
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         var _loc1_:* = int(customers.length - 1);
         while(_loc1_ >= 0)
         {
            removeCustomer(customers[_loc1_]);
            _loc1_--;
         }
         IsoCacherQueue.clearQueue();
      }
      
      private function calculateServableTables() : void
      {
         var _loc2_:ChefActor = null;
         var _loc3_:Number = NaN;
         var _loc4_:Waitor = null;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:RoomItem = null;
         var _loc1_:Number = 0;
         while(_loc1_ < chefs.length)
         {
            chefs[_loc1_].clearServableChairs();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < waitors.length)
         {
            waitors[_loc1_].clearServableChairs();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < chairs.length)
         {
            chairs[_loc1_].canOrderDrink = false;
            chairs[_loc1_].canOrderFood = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < chefs.length)
         {
            _loc2_ = chefs[_loc1_];
            _loc3_ = 0;
            while(_loc3_ < waitors.length)
            {
               _loc4_ = waitors[_loc3_];
               if(_loc4_.tileX > 0 && _loc4_.tileY > 0)
               {
                  _loc5_ = _loc4_.getPathTo(_loc2_.kitchen.tileX,_loc2_.kitchen.tileY,true);
                  if(_loc5_)
                  {
                     _loc4_.addReachableKitchenItems(_loc2_.kitchen);
                  }
                  _loc6_ = 0;
                  while(_loc6_ < chairs.length)
                  {
                     _loc7_ = chairs[_loc6_];
                     if(hasPathToCustomerChair(_loc4_.tileX,_loc4_.tileY,_loc7_))
                     {
                        _loc4_.addServableChair(_loc7_);
                        if(_loc5_)
                        {
                           _loc2_.addServableChair(_loc7_);
                           _loc7_.canOrderFood = true;
                        }
                     }
                     _loc6_++;
                  }
               }
               _loc3_++;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < waitors.length)
         {
            _loc4_ = waitors[_loc1_];
            _loc3_ = 0;
            while(_loc3_ < drinkItems.length)
            {
               if(_loc4_.getPathTo(drinkItems[_loc3_].tileX,drinkItems[_loc3_].tileY,true) != null)
               {
                  _loc4_.addReachableDrinkItems(drinkItems[_loc3_]);
                  _loc6_ = 0;
                  while(_loc6_ < chairs.length)
                  {
                     _loc7_ = chairs[_loc6_];
                     if(!_loc7_.canOrderDrink && hasPathToCustomerChair(_loc4_.tileX,_loc4_.tileY,_loc7_))
                     {
                        _loc7_.canOrderDrink = true;
                     }
                     _loc6_++;
                  }
               }
               _loc3_++;
            }
            _loc1_++;
         }
      }
   }
}


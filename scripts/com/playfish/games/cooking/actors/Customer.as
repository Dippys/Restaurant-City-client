package com.playfish.games.cooking.actors
{
   import com.playfish.external.ExternalPage;
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.usertask.ClearEmptyPlateTask;
   import com.playfish.games.cooking.utils.ProtectedInt;
   import com.playfish.games.cooking.utils.RandomBasket;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class Customer extends AvatarActor
   {
      
      private static const ANIMATION_USED:Array = [Avatar3D.ANIMATION_IDLE,Avatar3D.ANIMATION_WALK,Avatar3D.ANIMATION_SIT,Avatar3D.ANIMATION_COOKING,Avatar3D.ANIMATION_EAT];
      
      public static const STATE_WALKING:int = 0;
      
      public static const STATE_DECIDING:int = 1;
      
      public static const STATE_ORDERING:int = 2;
      
      public static const STATE_WAITING:int = 3;
      
      public static const STATE_WAITING_FOR_FOOD:int = 4;
      
      public static const STATE_EATING:int = 5;
      
      public static const STATE_PAYING:int = 6;
      
      public static const STATE_ANGRY:int = 7;
      
      public static const STATE_LEAVING:int = 8;
      
      public static const STATE_LEFT:int = 9;
      
      public static const STATE_WAITING_TO_SIT:int = 10;
      
      public static const STATE_PEDESTRIAN:int = 11;
      
      public static const STATE_TOO_MUCH_TRASH:int = 12;
      
      public static const STATE_NO_TABLE:int = 13;
      
      public static const STATE_PLAYING_INTERACTIVE_ITEM:int = 14;
      
      public static const STATE_WALKING_TO_TOILET:int = 15;
      
      public static const STATE_ON_TOILET:int = 16;
      
      public static const STATE_NO_CLEAN_TABLE:int = 17;
      
      public static const STATE_WALKING_TO_SINK:int = 18;
      
      public static const STATE_USING_SINK:int = 19;
      
      public static const STATE_WALKING_TO_ENTRANCE:int = 20;
      
      public static const STATE_RESTAURANT_CLOSED:int = 21;
      
      public static const EMOTION_NO_SEAT:int = 0;
      
      public static const EMOTION_DIRTY:int = 1;
      
      public static const EMOTION_WAIT_TOO_LONG:int = 2;
      
      public static const EMOTION_DECOR:int = 3;
      
      public static const EMOTION_NO_TABLE:int = 4;
      
      public static const EMOTION_NO_CLEAN_TABLE:int = 5;
      
      public static const EMOTION_NO_TOILET:int = 6;
      
      public static const EMOTION_WAIT_TOO_LONG_FOR_DRINK:int = 7;
      
      private static const EATING_TIME:ProtectedInt = new ProtectedInt(25000);
      
      private static const PAYING_TIME:ProtectedInt = new ProtectedInt(2000);
      
      private static const INTERACTIVE_ITEM_PLAYING_TIME:ProtectedInt = new ProtectedInt(30000);
      
      private static const WAITING_FOR_ORDER_TIME:ProtectedInt = new ProtectedInt(10000);
      
      private static const WAITING_FOR_TABLE_TIME:ProtectedInt = new ProtectedInt(20000);
      
      private static const WAITING_FOR_FOOD_TIME:ProtectedInt = new ProtectedInt(120000);
      
      private static const WAITING_FOR_CHAIR_TIME:ProtectedInt = new ProtectedInt(5000);
      
      private static const TOILET_TIME:ProtectedInt = new ProtectedInt(10000);
      
      private static const SINK_TIME:ProtectedInt = new ProtectedInt(4000);
      
      public var state:int = -1;
      
      public var interactiveItem:RoomItem;
      
      public var door:RoomItem;
      
      public var effectTimer:int;
      
      private var timer:int;
      
      public var sinkItem:RoomItem;
      
      private var chairOverlay:MovieClip;
      
      public var chair:RoomItem;
      
      public var order:DishOrder;
      
      public var entranceTileX:int;
      
      public var entranceTileY:int;
      
      private var emotion:GameObject;
      
      public function Customer(param1:int, param2:int, param3:GameUser, param4:WorldRestaurantPlay)
      {
         if(param3.customerAvatarItemsGenerator != param4.customerAvatarItemsGenerator)
         {
            param3.usedAvatarItems.splice(0,param3.usedAvatarItems.length);
            param3.clearAnimationFrames();
            param3.customerAvatarItemsGenerator = param4.customerAvatarItemsGenerator;
         }
         super(param1,param2,param3,param4,ANIMATION_USED);
         if(param3.userInfo != null)
         {
            if(param3.userInfo.playCount == 0)
            {
               addInviteFriendBadge();
            }
            else
            {
               addPlayingFriendBadge();
            }
            addSelectionEffect("FriendSelection");
         }
         else
         {
            mouseEnabled = false;
            mouseChildren = false;
         }
         param4.createOrderForCustomer(this);
         show();
      }
      
      public function walkToChair(param1:RoomItem, param2:Array) : void
      {
         leaveCurrentChair();
         setChair(param1);
         state = STATE_WALKING;
         setAnimation(Avatar3D.ANIMATION_WALK);
         setMovePath(param2);
      }
      
      public function setChair(param1:RoomItem) : void
      {
         this.chair = param1;
         param1.customer = this;
      }
      
      public function onRestaurantClosed() : void
      {
         state = STATE_RESTAURANT_CLOSED;
         timer = 2000;
      }
      
      public function waitForFood() : void
      {
         timer = WAITING_FOR_FOOD_TIME.value + restaurantPlay.customerWaitTimeModifier;
         state = STATE_WAITING_FOR_FOOD;
      }
      
      private function addPlayingFriendBadge() : void
      {
         var _loc1_:AnimatedObject = new AnimatedObject("SpeechBubbleAnimPortrait");
         var _loc2_:DisplayObject = GameWorld.getUserFaceImage(user);
         if(_loc2_ != null)
         {
            _loc1_.getChildMovieClipInstance("mc_portrait").mc_face.addChild(_loc2_);
         }
         _loc1_.getChildMovieClipInstance("mc_happiness").visible = false;
         var _loc3_:TextField = _loc1_.getChildMovieClipInstance("mc_name").tf_name;
         _loc3_.mouseEnabled = false;
         _loc3_.text = user.firstName;
         addMouseOverBadge(_loc1_);
      }
      
      private function setEmotion(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         if(param1 == -1)
         {
            if(emotion)
            {
               removeObject(emotion);
               emotion = null;
            }
         }
         else
         {
            _loc2_ = Engine.getMovieClip("Emotions");
            _loc2_.gotoAndStop(param1 + 1);
            emotion = new GameObject("SpeechBubbleAnim");
            emotion.mouseEnabled = false;
            emotion.mouseChildren = false;
            emotion.getChildMovieClipInstance("mc_content").addChild(_loc2_);
            emotion.type = param1;
            emotion.y = -WorldRestaurant.tileHeight - 10;
            emotion.numLoops = 1;
            addObject(emotion);
         }
      }
      
      public function gotoSink() : Boolean
      {
         var _loc2_:RandomBasket = null;
         var _loc3_:RoomItem = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc1_:Array = restaurantPlay.getEmptySinks().sort(compareRoomItemDistance);
         if(_loc1_.length > 0)
         {
            _loc2_ = new RandomBasket();
            _loc2_.addItemArray(_loc1_);
            _loc3_ = null;
            while(true)
            {
               _loc3_ = _loc2_.getNextItem() as RoomItem;
               if(_loc3_ == null)
               {
                  break;
               }
               _loc4_ = WorldRestaurant.getFacingTile(_loc3_.tileX,_loc3_.tileY,_loc3_.getRotationCount());
               _loc5_ = getPathTo(_loc4_.x,_loc4_.y,false);
               if(_loc5_ != null)
               {
                  setMovePath(_loc5_);
                  state = STATE_WALKING_TO_SINK;
                  setAnimation(Avatar3D.ANIMATION_WALK);
                  leaveCurrentChair();
                  sinkItem = _loc3_;
                  sinkItem.customer = this;
                  return true;
               }
            }
         }
         return false;
      }
      
      private function checkForFreeChair(param1:Boolean, param2:Boolean) : Boolean
      {
         var _loc4_:Object = null;
         var _loc3_:Object = getPathToRandomValidEmptyChair(param1,param2);
         if(_loc3_ != null)
         {
            walkToChair(_loc3_.item,_loc3_.path);
            setEmotion(-1);
            return true;
         }
         _loc4_ = restaurantPlay.getPathToRandomInteractiveItem(this,restaurantPlay.getEmptyInteractiveItems());
         if(_loc4_)
         {
            walkToInteractiveItem(_loc4_.item,_loc4_.path);
            setEmotion(-1);
            return true;
         }
         return false;
      }
      
      private function onInviteClick(param1:MouseEvent) : void
      {
         removeEventListener(MouseEvent.CLICK,onInviteClick);
         removeMouseOverBadge();
         addPlayingFriendBadge();
         var _loc2_:ExternalPage = GameWorld.onInviteClicked();
      }
      
      public function leaveCurrentChair() : void
      {
         if(chairOverlay != null)
         {
            removeChild(chairOverlay);
            chairOverlay = null;
         }
         if(chair != null)
         {
            chair.customer = null;
            chair = null;
         }
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:RoomItem = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         super.tick(param1);
         if(state == STATE_WALKING_TO_ENTRANCE)
         {
            if(reachedPathEnd())
            {
               if(restaurantPlay.restaurantClosed)
               {
                  onRestaurantClosed();
               }
               else
               {
                  _loc2_ = restaurantPlay.gameUser.trashCount.value;
                  if(_loc2_ > 0 && Engine.rnd(0,20) < _loc2_)
                  {
                     onTooMuchTrash();
                  }
                  else
                  {
                     if(restaurantPlay.waitingChairQueue.length > 0)
                     {
                        _loc3_ = getPathToRandomValidEmptyChair(true,false);
                     }
                     else
                     {
                        _loc3_ = getPathToRandomValidEmptyChair(false,false);
                     }
                     if(_loc3_)
                     {
                        walkToChair(_loc3_.item,_loc3_.path);
                     }
                     else
                     {
                        _loc4_ = restaurantPlay.getPathToRandomInteractiveItem(this,restaurantPlay.getEmptyInteractiveItems());
                        if(_loc4_)
                        {
                           walkToInteractiveItem(_loc4_.item,_loc4_.path);
                        }
                        else
                        {
                           onNoSeat();
                        }
                     }
                  }
                  if(door)
                  {
                     restaurantPlay.openDoor(door);
                  }
               }
            }
         }
         else if(state == STATE_WAITING_TO_SIT)
         {
            if(timer <= 0)
            {
               leaveUnhappy();
            }
            else
            {
               if(restaurantPlay.waitingChairQueue.length > 0)
               {
                  checkForFreeChair(true,false);
               }
               else
               {
                  checkForFreeChair(false,false);
               }
               if(!emotion && reachedPathEnd())
               {
                  setEmotion(EMOTION_NO_SEAT);
                  setAnimation(Avatar3D.ANIMATION_IDLE);
               }
            }
         }
         else if(state == STATE_TOO_MUCH_TRASH)
         {
            if(timer <= 0)
            {
               leaveUnhappy();
            }
            else if(!emotion && reachedPathEnd())
            {
               setEmotion(EMOTION_DIRTY);
            }
         }
         else if(state == STATE_RESTAURANT_CLOSED)
         {
            if(timer <= 0)
            {
               leave();
            }
         }
         else if(state == STATE_NO_TABLE)
         {
            if(timer <= 0)
            {
               leaveUnhappy();
            }
            else if(restaurantPlay.waitingChairQueue.indexOf(this) == 0)
            {
               if(checkForFreeChair(false,true))
               {
                  restaurantPlay.waitingChairQueue.splice(0,1);
               }
            }
         }
         else if(state == STATE_NO_CLEAN_TABLE)
         {
            if(timer <= 0)
            {
               leaveUnhappy();
            }
            else
            {
               _loc5_ = restaurant.getTableForChair(chair);
               if((Boolean(_loc5_)) && restaurant.isTableFree(_loc5_))
               {
                  setEmotion(-1);
                  restaurantPlay.addOrderFromCustomer(this);
                  this.order.table = _loc5_;
                  _loc5_.tableTopOrder = this.order;
                  state = STATE_WAITING;
               }
            }
         }
         else if(state == STATE_WALKING)
         {
            if(reachedPathEnd())
            {
               if(chair)
               {
                  sitOnChair(chair);
                  timer = 1000;
                  state = STATE_DECIDING;
               }
               else if(interactiveItem)
               {
                  _loc6_ = (interactiveItem.getRotationCount() + 2) % 4;
                  setDirection(WorldRestaurant.getActorDirectionFromItemRotation(_loc6_));
                  restaurantPlay.setRoomItemState(interactiveItem,"on");
                  setAnimation(Avatar3D.ANIMATION_COOKING);
                  timer = INTERACTIVE_ITEM_PLAYING_TIME.value;
                  state = STATE_PLAYING_INTERACTIVE_ITEM;
               }
            }
         }
         else if(state == STATE_PLAYING_INTERACTIVE_ITEM)
         {
            if(timer <= 0)
            {
               restaurantPlay.setRoomItemState(interactiveItem,"off");
               restaurantPlay.setRoomItemUsageCount(interactiveItem,interactiveItem.usageCount + 1);
               restaurantPlay.onCustomerPayForFunctional(interactiveItem);
               interactiveItem.customer = null;
               interactiveItem = null;
               leave();
            }
         }
         else if(state == STATE_DECIDING)
         {
            if(timer <= 0)
            {
               _loc5_ = restaurant.getTableForChair(chair);
               if(_loc5_ == null)
               {
                  setEmotion(EMOTION_NO_TABLE);
                  timer = WAITING_FOR_TABLE_TIME.value + restaurantPlay.customerWaitTimeModifier;
                  state = STATE_NO_TABLE;
                  restaurantPlay.waitingChairQueue.push(this);
               }
               else if(!restaurant.isTableFree(_loc5_))
               {
                  setEmotion(EMOTION_NO_CLEAN_TABLE);
                  timer = WAITING_FOR_ORDER_TIME.value + restaurantPlay.customerWaitTimeModifier;
                  state = STATE_NO_CLEAN_TABLE;
               }
               else
               {
                  restaurantPlay.addOrderFromCustomer(this);
                  this.order.table = _loc5_;
                  _loc5_.tableTopOrder = this.order;
                  timer = WAITING_FOR_ORDER_TIME.value + restaurantPlay.customerWaitTimeModifier;
                  state = STATE_WAITING;
               }
            }
         }
         else if(state == STATE_WAITING || state == STATE_WAITING_FOR_FOOD)
         {
            if(timer <= 0)
            {
               if(order.recipe.type == Recipe.MENU_RECIPE_DRINK)
               {
                  setEmotion(EMOTION_WAIT_TOO_LONG_FOR_DRINK);
               }
               else
               {
                  setEmotion(EMOTION_WAIT_TOO_LONG);
               }
               leaveUnhappy();
            }
         }
         else if(state == STATE_EATING)
         {
            _loc7_ = EATING_TIME.value;
            order.setFrame(1 + (order.getFrameCount() - 1) * (_loc7_ - timer) / _loc7_);
            if(timer <= 0)
            {
               setAnimation(Avatar3D.ANIMATION_SIT);
               restaurantPlay.emptyPlates.push(order);
               if(!restaurantPlay.visitMode)
               {
                  ClearEmptyPlateTask.addUserTaskListener(order);
               }
               order = null;
               timer = PAYING_TIME.value;
               state = STATE_PAYING;
            }
         }
         else if(state == STATE_PAYING)
         {
            if(timer <= 0)
            {
               if(restaurant.gameUser.level.value >= GameWorld.TOILET_START_LEVEL && Engine.rnd(0,3) == 0)
               {
                  gotoToilet();
               }
               else
               {
                  leaveHappy();
               }
            }
         }
         else if(state == STATE_LEAVING)
         {
            if(door)
            {
               if(tileX > 0 && tileY > 0 && Math.abs(door.tileX - tileX) + Math.abs(door.tileY - tileY) <= 1)
               {
                  restaurantPlay.openDoor(door);
               }
            }
            if(reachedPathEnd())
            {
               state = STATE_LEFT;
               if(emotion != null)
               {
                  setEmotion(-1);
               }
               restaurantPlay.removeCustomer(this);
            }
         }
         else if(state == STATE_ANGRY)
         {
            if(timer <= 0)
            {
               leaveUnhappy();
            }
         }
         else if(state == STATE_PEDESTRIAN)
         {
            if(speedX == 0 && speedY == 0)
            {
               restaurantPlay.removeCustomer(this);
            }
         }
         else if(state == STATE_WALKING_TO_TOILET)
         {
            if(reachedPathEnd())
            {
               sitOnChair(this.chair);
               state = STATE_ON_TOILET;
               timer = restaurantPlay.getModifiedOperateTime(chair,TOILET_TIME.value);
               setAnimation(Avatar3D.ANIMATION_SIT);
            }
         }
         else if(state == STATE_ON_TOILET)
         {
            if(timer <= 0)
            {
               restaurantPlay.setRoomItemUsageCount(chair,chair.usageCount + 1);
               if(!gotoSink())
               {
                  leaveHappy();
               }
            }
         }
         else if(state == STATE_WALKING_TO_SINK)
         {
            if(reachedPathEnd())
            {
               _loc6_ = (sinkItem.getRotationCount() + 2) % 4;
               setDirection(WorldRestaurant.getActorDirectionFromItemRotation(_loc6_));
               state = STATE_USING_SINK;
               timer = SINK_TIME.value;
               setAnimation(Avatar3D.ANIMATION_COOKING);
            }
         }
         else if(state == STATE_USING_SINK)
         {
            if(timer <= 0)
            {
               leaveHappy();
            }
         }
         if(timer > 0)
         {
            timer -= param1;
         }
         if(effectTimer > 0)
         {
            effectTimer -= param1;
         }
      }
      
      public function onNoSeat() : void
      {
         timer = WAITING_FOR_CHAIR_TIME.value + restaurantPlay.customerWaitTimeModifier;
         state = STATE_WAITING_TO_SIT;
         moveToFrontOfEntrance();
      }
      
      private function compareRoomItemDistance(param1:RoomItem, param2:RoomItem) : int
      {
         var _loc3_:int = Math.abs(param1.tileX - tileX) + Math.abs(param1.tileY - tileY);
         var _loc4_:int = Math.abs(param2.tileX - tileX) + Math.abs(param2.tileY - tileY);
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ == _loc4_)
         {
            return 0;
         }
         return 1;
      }
      
      public function leaveUnhappy() : void
      {
         var _loc1_:GameObject = null;
         restaurantPlay.addDemand(WorldRestaurantPlay.DEMAND_BONUS_UNHAPPY_CUSTOMER);
         if(restaurant.gameUser == GameWorld.gameUser)
         {
            GameWorld.gameUser.awards.addValue(GameAwards.AWARD_UNHAPPY_CUSTOMERS,1);
         }
         _loc1_ = new GameObject("Popularity");
         _loc1_.getChildMovieClipInstance("mc_icon").gotoAndStop(2);
         _loc1_.x = 0;
         _loc1_.y = -WorldRestaurant.tileHeight;
         _loc1_.drawPriority = 100;
         _loc1_.numLoops = 1;
         _loc1_.removeWhenComplete = true;
         addObject(_loc1_);
         leave();
      }
      
      public function leave() : void
      {
         if(sinkItem != null)
         {
            sinkItem.customer = null;
            sinkItem = null;
         }
         var _loc1_:int = restaurantPlay.waitingChairQueue.indexOf(this);
         if(_loc1_ != -1)
         {
            restaurantPlay.waitingChairQueue.splice(_loc1_,1);
         }
         leaveCurrentChair();
         if(moveToTile(entranceTileX,entranceTileY,false))
         {
            setAnimation(Avatar3D.ANIMATION_WALK);
         }
         state = STATE_LEAVING;
         restaurantPlay.onCustomerLeave(this);
      }
      
      private function addInviteFriendBadge() : void
      {
         var _loc1_:AnimatedObject = new AnimatedObject("SpeechBubbleAnimFriendInvite");
         var _loc2_:MovieClip = _loc1_.getChildMovieClipInstance("mc_content");
         var _loc3_:DisplayObject = GameWorld.getUserFaceImage(user);
         if(_loc3_ != null)
         {
            _loc2_.mc_portrait.mc_face.addChild(_loc3_);
         }
         GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_text,"ClickToInviteMe");
         _loc2_.tf_text.mouseEnabled = false;
         var _loc4_:TextField = _loc1_.getChildMovieClipInstance("mc_name").tf_name;
         _loc4_.mouseEnabled = false;
         _loc4_.text = user.firstName;
         addEventListener(MouseEvent.CLICK,onInviteClick,false,0,true);
         addMouseOverBadge(_loc1_);
      }
      
      public function onTooMuchTrash() : void
      {
         timer = 2000;
         state = STATE_TOO_MUCH_TRASH;
         moveToFrontOfEntrance();
      }
      
      public function setPedestrian(param1:int, param2:int) : void
      {
         state = STATE_PEDESTRIAN;
         moveTo(WorldRestaurant.getScreenX(param1,param2),WorldRestaurant.getScreenY(param1,param2));
         setAnimation(Avatar3D.ANIMATION_WALK);
      }
      
      public function reset(param1:int, param2:int, param3:WorldRestaurantPlay) : void
      {
         this.restaurant = param3;
         setPosition(param1,param2);
         state = -1;
         timer = 0;
      }
      
      public function gotoToilet() : void
      {
         var _loc2_:RandomBasket = null;
         var _loc3_:RoomItem = null;
         var _loc1_:Array = restaurantPlay.getEmptyToiletSeats().sort(compareRoomItemDistance);
         if(_loc1_.length > 0)
         {
            _loc2_ = new RandomBasket();
            _loc2_.addItemArray(_loc1_);
            _loc3_ = null;
            while(true)
            {
               _loc3_ = _loc2_.getNextItem() as RoomItem;
               if(_loc3_ == null)
               {
                  break;
               }
               if(moveToRoomItem(_loc3_,false))
               {
                  state = STATE_WALKING_TO_TOILET;
                  setAnimation(Avatar3D.ANIMATION_WALK);
                  leaveCurrentChair();
                  setChair(_loc3_);
                  return;
               }
            }
         }
         setEmotion(EMOTION_NO_TOILET);
         leave();
      }
      
      public function walkToInteractiveItem(param1:RoomItem, param2:Array) : void
      {
         leaveCurrentChair();
         this.interactiveItem = param1;
         param1.customer = this;
         state = STATE_WALKING;
         setAnimation(Avatar3D.ANIMATION_WALK);
         setMovePath(param2);
      }
      
      public function eatOrder() : void
      {
         if(!restaurantPlay.silentTick)
         {
            restaurantPlay.eatingSound.play(1);
         }
         setAnimation(Avatar3D.ANIMATION_EAT);
         timer = EATING_TIME.value;
         state = STATE_EATING;
      }
      
      public function sitOnChair(param1:RoomItem) : void
      {
         chairOverlay = Engine.getMovieClip(param1.itemConfig.className + "Overlay");
         if(chairOverlay != null)
         {
            chairOverlay.gotoAndStop(param1.getRotationCount() + 1);
            addChild(chairOverlay);
         }
         setDirection(WorldRestaurant.getActorDirectionFromItemRotation(param1.getRotationCount()));
         setAnimation(Avatar3D.ANIMATION_SIT);
      }
      
      public function leaveHappy() : void
      {
         restaurantPlay.addDemand(WorldRestaurantPlay.DEMAND_BONUS_HAPPY_CUSTOMER);
         if(restaurant.gameUser == GameWorld.gameUser)
         {
            GameWorld.gameUser.awards.addValue(GameAwards.AWARD_HAPPY_CUSTOMERS,1);
         }
         var _loc1_:GameObject = new GameObject("Popularity");
         _loc1_.getChildMovieClipInstance("mc_icon").gotoAndStop(1);
         _loc1_.x = 0;
         _loc1_.y = -WorldRestaurant.tileHeight;
         _loc1_.drawPriority = 100;
         _loc1_.numLoops = 1;
         _loc1_.removeWhenComplete = true;
         addObject(_loc1_);
         leave();
      }
      
      private function moveToFrontOfEntrance() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(entranceTileY == 0)
         {
            _loc1_ = entranceTileX;
            _loc2_ = entranceTileY + 1;
         }
         else
         {
            _loc1_ = entranceTileX + 1;
            _loc2_ = entranceTileY;
         }
         setAnimation(Avatar3D.ANIMATION_WALK);
         moveTo(WorldRestaurant.getScreenX(_loc1_,_loc2_),WorldRestaurant.getScreenY(_loc1_,_loc2_));
      }
      
      public function walkToEntrance(param1:int, param2:int, param3:RoomItem) : void
      {
         this.door = param3;
         this.entranceTileX = param1;
         this.entranceTileY = param2;
         state = STATE_WALKING_TO_ENTRANCE;
         if(param2 == 0)
         {
            setMovePath([[-1,-1],[param1,-1],[param1,param2]]);
         }
         else
         {
            setMovePath([[-1,param2],[param1,param2]]);
         }
         setAnimation(Avatar3D.ANIMATION_WALK);
      }
      
      public function getPathToRandomValidEmptyChair(param1:Boolean, param2:Boolean) : Object
      {
         var _loc4_:Array = null;
         var _loc3_:Object = null;
         if(!param1)
         {
            _loc4_ = restaurantPlay.getEmptyChairs(true,true,order);
            if(_loc4_.length > 0)
            {
               _loc3_ = restaurantPlay.getPathToRandomRoomItem(this,_loc4_);
            }
            if(_loc3_ == null)
            {
               _loc4_ = restaurantPlay.getEmptyChairs(true,false,order);
               if(_loc4_.length > 0)
               {
                  _loc3_ = restaurantPlay.getPathToRandomRoomItem(this,_loc4_);
               }
            }
            if(_loc3_ == null)
            {
               _loc4_ = restaurantPlay.getEmptyChairs(true,true,null);
               if(_loc4_.length > 0)
               {
                  _loc3_ = restaurantPlay.getPathToRandomRoomItem(this,_loc4_);
               }
            }
            if(_loc3_ == null)
            {
               _loc4_ = restaurantPlay.getEmptyChairs(true,false,null);
               if(_loc4_.length > 0)
               {
                  _loc3_ = restaurantPlay.getPathToRandomRoomItem(this,_loc4_);
               }
            }
         }
         if(!param2 && _loc3_ == null)
         {
            _loc4_ = restaurantPlay.getEmptyChairs(false,false,null);
            if(_loc4_.length > 0)
            {
               _loc3_ = restaurantPlay.getPathToRandomRoomItem(this,_loc4_);
            }
         }
         return _loc3_;
      }
   }
}


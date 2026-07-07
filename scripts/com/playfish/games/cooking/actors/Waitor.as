package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.usertask.ClearEmptyPlateTask;
   import com.playfish.games.cooking.utils.ProtectedInt;
   
   public class Waitor extends EmployeeActor
   {
      
      private static const ANIMATION_USED:Array = [Avatar3D.ANIMATION_IDLE,Avatar3D.ANIMATION_WALK,Avatar3D.ANIMATION_WAITOR_WALK,Avatar3D.ANIMATION_WAITOR_WORKING,Avatar3D.ANIMATION_DEAD];
      
      private static const MAX_WALK_SPEED_Y:Number = 0.03;
      
      private static const MIN_WALK_SPEED_Y:Number = 0.01;
      
      private static const ACTION_DELAY_MAX:ProtectedInt = new ProtectedInt(6000);
      
      private static const ACTION_DELAY_MIN:ProtectedInt = new ProtectedInt(2000);
      
      private static const DRINK_MAKING_DELAY_MAX:ProtectedInt = new ProtectedInt(24000);
      
      private static const DRINK_MAKING_DELAY_MIN:ProtectedInt = new ProtectedInt(12000);
      
      public static const STATE_IDLE:int = 0;
      
      public static const STATE_SERVING:int = 1;
      
      public static const STATE_MOVING_BACK:int = 2;
      
      public static const STATE_MOVING_TO_GET_ORDER:int = 3;
      
      public static const STATE_MOVING_TO_GET_EMPTY_PLATE:int = 4;
      
      public static const STATE_MOVING_TO_GET_DRINK_ORDER:int = 5;
      
      public static const STATE_DEAD:int = 6;
      
      private var delayTimer:int;
      
      private var emptyPlate:DishOrder;
      
      public var drinkItem:RoomItem;
      
      private var step:int;
      
      public var order:DishOrder;
      
      private var state:int = 0;
      
      private var servableChairs:Array = new Array();
      
      public var kitchen:RoomItem;
      
      private var reachableKitchenItems:Array = new Array();
      
      private var reachableDrinkItems:Array = new Array();
      
      private var pathToCustomer:Array;
      
      public function Waitor(param1:RoomItem, param2:GameUserEmployee, param3:WorldRestaurantPlay)
      {
         this.kitchen = param1;
         this.restaurant = param3;
         this.restaurantPlay = param3;
         setInitialTilePosition();
         super(WorldRestaurant.getScreenX(tileX,tileY),WorldRestaurant.getScreenY(tileX,tileY),param2,param3,ANIMATION_USED);
      }
      
      private function onRemove() : void
      {
         if(Boolean(order) && Boolean(order.customer))
         {
            if(order.recipe.type == Recipe.MENU_RECIPE_DRINK)
            {
               restaurantPlay.orders.push(order);
               order.customer.state = Customer.STATE_WAITING;
            }
            else if(state != STATE_SERVING)
            {
               restaurantPlay.completedOrders.push(order);
            }
            else
            {
               order.customer.state = Customer.STATE_WAITING;
            }
            order = null;
         }
         if(drinkItem)
         {
            restaurantPlay.setRoomItemState(drinkItem,"close");
            drinkItem.waiter = null;
            drinkItem = null;
         }
         if(emptyPlate)
         {
            restaurantPlay.emptyPlates.push(emptyPlate);
            emptyPlate = null;
         }
      }
      
      private function getDelay(param1:int, param2:int) : int
      {
         var _loc3_:Number = employeeUser.workTime / GameUserEmployee.MAX_WORK_TIME * 100;
         if(_loc3_ >= 80)
         {
            return param1;
         }
         if(_loc3_ < 20)
         {
            return param2;
         }
         return param2 - (param2 - param1) * (_loc3_ - 20) / 60;
      }
      
      public function addReachableKitchenItems(param1:RoomItem) : void
      {
         if(reachableKitchenItems.indexOf(param1) == -1)
         {
            reachableKitchenItems.push(param1);
         }
      }
      
      public function setWalkSpeed() : void
      {
         var _loc1_:Number = employeeUser.workTime / GameUserEmployee.MAX_WORK_TIME * 100;
         if(_loc1_ >= 80)
         {
            moveSpeedY = MAX_WALK_SPEED_Y;
         }
         else if(_loc1_ < 20)
         {
            moveSpeedY = MIN_WALK_SPEED_Y;
         }
         else
         {
            moveSpeedY = MIN_WALK_SPEED_Y + (MAX_WALK_SPEED_Y - MIN_WALK_SPEED_Y) * (_loc1_ - 20) / 60;
         }
         moveSpeedX = moveSpeedY * 2;
      }
      
      public function addServableChair(param1:RoomItem) : void
      {
         if(servableChairs.indexOf(param1) == -1)
         {
            servableChairs.push(param1);
         }
      }
      
      public function setNormalWalkSpeed() : void
      {
         moveSpeedY = DEFAULT_MOVE_SPEED_Y;
         moveSpeedX = DEFAULT_MOVE_SPEED_X;
      }
      
      public function canReachDrinkItem(param1:RoomItem) : Boolean
      {
         return reachableDrinkItems.indexOf(param1) != -1;
      }
      
      private function setInitialTilePosition() : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:int = kitchen.tileX;
         var _loc2_:int = kitchen.tileY;
         var _loc3_:Array = new Array();
         _loc3_.push([-1,0]);
         _loc3_.push([-1,-1]);
         _loc3_.push([-1,1]);
         _loc3_.push([0,-1]);
         _loc3_.push([0,1]);
         _loc3_.push([1,-1]);
         _loc3_.push([1,1]);
         rotateOffsets(_loc3_,kitchen.getRotationCount());
         var _loc4_:int = -1;
         var _loc5_:int = -1;
         var _loc6_:Number = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc6_][0] + _loc1_;
            _loc8_ = _loc3_[_loc6_][1] + _loc2_;
            if(restaurant.isWalkable(_loc7_,_loc8_))
            {
               if(_loc4_ == -1)
               {
                  _loc4_ = _loc7_;
                  _loc5_ = _loc8_;
               }
               if(!restaurantPlay.isOccupiedByEmployeeActor(_loc7_,_loc8_))
               {
                  tileX = _loc7_;
                  tileY = _loc8_;
                  return;
               }
            }
            _loc6_++;
         }
         if(_loc4_ == -1 && _loc5_ == -1)
         {
            tileX = Engine.rnd(-4,-1);
            tileY = Engine.rnd(1,restaurant.numTilesY);
         }
         else
         {
            tileX = _loc4_;
            tileY = _loc5_;
         }
      }
      
      public function clearServableChairs() : void
      {
         servableChairs.splice(0,servableChairs.length);
         reachableDrinkItems.splice(0,reachableDrinkItems.length);
         reachableKitchenItems.splice(0,reachableKitchenItems.length);
      }
      
      public function addReachableDrinkItems(param1:RoomItem) : void
      {
         if(reachableDrinkItems.indexOf(param1) == -1)
         {
            reachableDrinkItems.push(param1);
         }
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:RoomItem = null;
         var _loc3_:RoomItem = null;
         super.tick(param1);
         setWalkSpeed();
         if(state != STATE_IDLE)
         {
            if(state == STATE_MOVING_BACK)
            {
               if(reachedPathEnd())
               {
                  state = STATE_IDLE;
                  setAnimation(Avatar3D.ANIMATION_IDLE);
               }
            }
            else if(state == STATE_MOVING_TO_GET_ORDER)
            {
               if(order == null)
               {
                  moveBack();
               }
               else if(step == 0)
               {
                  if(reachedPathEnd())
                  {
                     step = 1;
                     face(WorldRestaurant.getScreenX(order.tileX,order.tileY),WorldRestaurant.getScreenY(order.tileX,order.tileY));
                     setAnimation(Avatar3D.ANIMATION_WAITOR_WORKING);
                  }
               }
               else if(step == 1)
               {
                  delayTimer -= param1;
                  if(delayTimer <= 0)
                  {
                     serveCustomer();
                  }
               }
            }
            else if(state == STATE_MOVING_TO_GET_DRINK_ORDER)
            {
               if(order == null)
               {
                  moveBack();
               }
               else if(step == 0)
               {
                  if(reachedPathEnd())
                  {
                     step = 1;
                     face(WorldRestaurant.getScreenX(drinkItem.tileX,drinkItem.tileY),WorldRestaurant.getScreenY(drinkItem.tileX,drinkItem.tileY));
                     setAnimation(Avatar3D.ANIMATION_WAITOR_WORKING);
                     restaurantPlay.setRoomItemState(drinkItem,"open");
                  }
               }
               else if(step == 1)
               {
                  delayTimer -= param1;
                  if(delayTimer <= 0)
                  {
                     restaurantPlay.setRoomItemState(drinkItem,"close");
                     serveCustomer();
                  }
               }
            }
            else if(state == STATE_MOVING_TO_GET_EMPTY_PLATE)
            {
               if(step == 0)
               {
                  if(emptyPlate.inUserTaskQueue)
                  {
                     moveBack();
                  }
                  else if(reachedPathEnd())
                  {
                     step = 1;
                     if(!restaurantPlay.visitMode)
                     {
                        ClearEmptyPlateTask.removeUserTaskListener(emptyPlate);
                     }
                     face(WorldRestaurant.getScreenX(emptyPlate.tileX,emptyPlate.tileY),WorldRestaurant.getScreenY(emptyPlate.tileX,emptyPlate.tileY));
                     setAnimation(Avatar3D.ANIMATION_WAITOR_WORKING);
                  }
               }
               else if(step == 1)
               {
                  delayTimer -= param1;
                  if(delayTimer <= 0)
                  {
                     restaurantPlay.clearEmptyPlate(emptyPlate);
                     emptyPlate = null;
                     moveBack();
                  }
               }
            }
            else if(state == STATE_SERVING)
            {
               if(order == null)
               {
                  moveBack();
               }
               else if(reachedPathEnd())
               {
                  _loc2_ = order.customer.chair;
                  _loc3_ = restaurant.getTableForChair(_loc2_);
                  if(_loc3_)
                  {
                     face(WorldRestaurant.getScreenX(_loc3_.tileX,_loc3_.tileY),WorldRestaurant.getScreenY(_loc3_.tileX,_loc3_.tileY));
                     order.tileX = _loc3_.tileX;
                     order.tileY = _loc3_.tileY;
                     order.x = WorldRestaurant.getScreenX(_loc3_.tileX,_loc3_.tileY);
                     order.y = WorldRestaurant.getScreenY(_loc3_.tileX,_loc3_.tileY) + WorldRestaurant.tileHeightHalf - restaurant.getTileTopHeight(_loc3_.tileX,_loc3_.tileY);
                     order.drawPriority = _loc3_.drawPriority;
                     restaurant.room.addObject(order);
                     order.customer.eatOrder();
                  }
                  else
                  {
                     Engine.showMessage("order delivered to a place with no table");
                     order.customer.leave();
                  }
                  order = null;
                  moveBack();
               }
            }
            if(state == STATE_DEAD)
            {
               if(employeeUser.workTime > 0)
               {
                  setEmotion(-1);
                  state = STATE_IDLE;
                  setAnimation(Avatar3D.ANIMATION_IDLE);
               }
            }
         }
      }
      
      public function canServe(param1:Customer) : Boolean
      {
         return param1.chair != null && servableChairs.indexOf(param1.chair) != -1;
      }
      
      public function canReachKitchenItem(param1:RoomItem) : Boolean
      {
         return reachableKitchenItems.indexOf(param1) != -1;
      }
      
      private function rotateOffsets(param1:Array, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         param2 %= 4;
         if(param2 != 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param2 == 1)
               {
                  _loc4_ = Number(param1[_loc3_][1]);
                  param1[_loc3_][1] = param1[_loc3_][0];
                  param1[_loc3_][0] = -_loc4_;
               }
               else if(param2 == 2)
               {
                  param1[_loc3_][0] = -param1[_loc3_][0];
                  param1[_loc3_][1] = -param1[_loc3_][1];
               }
               else if(param2 == 3)
               {
                  _loc4_ = Number(param1[_loc3_][1]);
                  param1[_loc3_][1] = -param1[_loc3_][0];
                  param1[_loc3_][0] = _loc4_;
               }
               _loc3_++;
            }
         }
      }
      
      public function canServeChair(param1:RoomItem) : Boolean
      {
         return param1 != null && servableChairs.indexOf(param1) != -1;
      }
      
      public function moveBack() : void
      {
         order = null;
         emptyPlate = null;
         if(drinkItem)
         {
            drinkItem.waiter = null;
            drinkItem = null;
         }
         var _loc1_:Array = restaurantPlay.getSortedKitchens(kitchen);
         var _loc2_:Number = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(moveToRoomItem(_loc1_[_loc2_],true))
            {
               this.kitchen = _loc1_[_loc2_];
               state = STATE_MOVING_BACK;
               setAnimation(Avatar3D.ANIMATION_WALK);
               return;
            }
            _loc2_++;
         }
         setAnimation(Avatar3D.ANIMATION_IDLE);
         state = STATE_IDLE;
      }
      
      public function getOrderFromDrinkItem(param1:DishOrder, param2:Array, param3:RoomItem) : void
      {
         this.drinkItem = param3;
         param3.waiter = this;
         state = STATE_MOVING_TO_GET_DRINK_ORDER;
         setMovePath(param2);
         step = 0;
         delayTimer = restaurantPlay.getModifiedOperateTime(param3,getDelay(DRINK_MAKING_DELAY_MIN.value,DRINK_MAKING_DELAY_MAX.value));
         this.order = param1;
         param1.customer.waitForFood();
         setAnimation(Avatar3D.ANIMATION_WALK);
      }
      
      override public function setDead() : void
      {
         if(state != STATE_DEAD)
         {
            super.setDead();
            setEmotion(EMOTION_NEED_FOOD);
            setAnimation(Avatar3D.ANIMATION_DEAD);
            onRemove();
            state = STATE_DEAD;
         }
      }
      
      public function serveCustomer() : void
      {
         if(order.kitchen)
         {
            restaurantPlay.setRoomItemState(order.kitchen,"idle");
            order.kitchen = null;
         }
         if(drinkItem)
         {
            drinkItem.waiter = null;
            drinkItem = null;
         }
         if(pathToCustomer == null)
         {
            pathToCustomer = restaurantPlay.getPathToCustomer(tileX,tileY,order.customer);
         }
         if(pathToCustomer)
         {
            state = STATE_SERVING;
            pathToCustomer.pop();
            setMovePath(pathToCustomer);
            setAnimation(Avatar3D.ANIMATION_WAITOR_WALK);
            order.customer.waitForFood();
         }
         else
         {
            setAnimation(Avatar3D.ANIMATION_IDLE);
            state = STATE_IDLE;
         }
         pathToCustomer = null;
      }
      
      public function getOrderFromKitchen(param1:DishOrder, param2:Array = null, param3:Array = null) : void
      {
         this.pathToCustomer = param3;
         if(param2 != null)
         {
            setMovePath(param2);
            state = STATE_MOVING_TO_GET_ORDER;
         }
         else if(moveToRoomItem(param1.kitchen,true))
         {
            state = STATE_MOVING_TO_GET_ORDER;
         }
         if(state == STATE_MOVING_TO_GET_ORDER)
         {
            step = 0;
            delayTimer = getDelay(ACTION_DELAY_MIN.value,ACTION_DELAY_MAX.value);
            this.order = param1;
            kitchen = param1.kitchen;
            setAnimation(Avatar3D.ANIMATION_WALK);
         }
      }
      
      public function doGetEmptyPlate(param1:DishOrder, param2:Array) : void
      {
         delayTimer = getDelay(ACTION_DELAY_MIN.value,ACTION_DELAY_MAX.value);
         step = 0;
         state = STATE_MOVING_TO_GET_EMPTY_PLATE;
         this.emptyPlate = param1;
         setMovePath(param2);
         setAnimation(Avatar3D.ANIMATION_WALK);
      }
      
      public function isFree() : Boolean
      {
         return state == STATE_IDLE || state == STATE_MOVING_BACK;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         onRemove();
      }
      
      public function hasReachableDrinkItems() : Boolean
      {
         return reachableDrinkItems.length > 0;
      }
   }
}


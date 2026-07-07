package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.utils.ProtectedInt;
   
   public class ChefActor extends EmployeeActor
   {
      
      private static const ANIMATION_USED:Array = [Avatar3D.ANIMATION_IDLE,Avatar3D.ANIMATION_COOKING,Avatar3D.ANIMATION_DEAD];
      
      public static const STATE_IDLE:int = 0;
      
      public static const STATE_COOKING:int = 1;
      
      public static const STATE_DEAD:int = 2;
      
      private static const COOK_DURATION_MAX:ProtectedInt = new ProtectedInt(32000);
      
      private static const COOK_DURATION_MIN:ProtectedInt = new ProtectedInt(16000);
      
      public var kitchen:RoomItem;
      
      private var state:int = 0;
      
      public var cookingOrder:DishOrder = null;
      
      private var cookTimer:int;
      
      private var servableChairs:Array = new Array();
      
      public function ChefActor(param1:RoomItem, param2:GameUserEmployee, param3:WorldRestaurantPlay)
      {
         this.kitchen = param1;
         var _loc4_:Object = WorldRestaurant.getFacingTile(param1.tileX,param1.tileY,param1.getRotationCount());
         tileX = _loc4_.x;
         tileY = _loc4_.y;
         super(WorldRestaurant.getScreenX(tileX,tileY),WorldRestaurant.getScreenY(tileX,tileY),param2,param3,ANIMATION_USED);
         setDirection((WorldRestaurant.getActorDirectionFromItemRotation(param1.getRotationCount()) + 4) % 8);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         onRemove();
      }
      
      private function onRemove() : void
      {
         if(state == STATE_COOKING)
         {
            if(Boolean(cookingOrder) && Boolean(cookingOrder.customer))
            {
               cookingOrder.customer.state = Customer.STATE_WAITING;
            }
            cookingOrder.kitchen = null;
            restaurantPlay.orders.push(cookingOrder);
            cookingOrder = null;
            restaurantPlay.setRoomItemState(kitchen,"idle");
         }
      }
      
      public function canServeChair(param1:RoomItem) : Boolean
      {
         return param1 != null && servableChairs.indexOf(param1) != -1;
      }
      
      public function clearServableChairs() : void
      {
         servableChairs.splice(0,servableChairs.length);
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
         if(state != STATE_IDLE)
         {
            if(state == STATE_COOKING)
            {
               cookTimer -= param1;
               if(cookTimer <= 0)
               {
                  setAnimation(Avatar3D.ANIMATION_IDLE);
                  restaurantPlay.setRoomItemState(kitchen,"done");
                  restaurantPlay.onChefFinishOrder(this);
                  state = STATE_IDLE;
               }
            }
            else if(state == STATE_DEAD)
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
      
      override public function setDead() : void
      {
         if(state != STATE_DEAD)
         {
            super.setDead();
            setEmotion(EMOTION_NEED_FOOD);
            onRemove();
            state = STATE_DEAD;
            setAnimation(Avatar3D.ANIMATION_DEAD);
         }
      }
      
      private function getCookTime() : int
      {
         var _loc2_:int = 0;
         var _loc1_:Number = employeeUser.workTime / GameUserEmployee.MAX_WORK_TIME * 100;
         if(_loc1_ >= 80)
         {
            _loc2_ = COOK_DURATION_MIN.value;
         }
         else if(_loc1_ < 20)
         {
            _loc2_ = COOK_DURATION_MAX.value;
         }
         else
         {
            _loc2_ = COOK_DURATION_MAX.value - (COOK_DURATION_MAX.value - COOK_DURATION_MIN.value) * (_loc1_ - 20) / 60;
         }
         return restaurantPlay.getModifiedOperateTime(kitchen,_loc2_);
      }
      
      public function discardCurrentOrder() : void
      {
         if(state == STATE_COOKING)
         {
            cookingOrder.kitchen = null;
            cookingOrder = null;
            setAnimation(Avatar3D.ANIMATION_IDLE);
            restaurantPlay.setRoomItemState(kitchen,"idle");
            state = STATE_IDLE;
         }
      }
      
      public function isFree() : Boolean
      {
         return state == STATE_IDLE && restaurantPlay.isStoveAvailable(kitchen);
      }
      
      public function cook(param1:DishOrder) : void
      {
         cookingOrder = param1;
         cookingOrder.kitchen = kitchen;
         cookingOrder.tileX = kitchen.tileX;
         cookingOrder.tileY = kitchen.tileY;
         cookingOrder.customer.waitForFood();
         cookTimer = getCookTime();
         setAnimation(Avatar3D.ANIMATION_COOKING);
         restaurantPlay.setRoomItemState(kitchen,"cooking");
         if(!restaurantPlay.silentTick)
         {
            restaurantPlay.cookingSound.play(1);
         }
         state = STATE_COOKING;
      }
      
      public function addServableChair(param1:RoomItem) : void
      {
         if(servableChairs.indexOf(param1) == -1)
         {
            servableChairs.push(param1);
         }
      }
      
      public function canServe(param1:Customer) : Boolean
      {
         return param1.chair != null && servableChairs.indexOf(param1.chair) != -1;
      }
   }
}


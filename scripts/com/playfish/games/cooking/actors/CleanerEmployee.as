package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.usertask.*;
   import com.playfish.games.cooking.utils.ProtectedInt;
   
   public class CleanerEmployee extends EmployeeActor
   {
      
      private static const ANIMATION_USED:Array = [Avatar3D.ANIMATION_CLEANER_IDLE,Avatar3D.ANIMATION_CLEANER_WALK,Avatar3D.ANIMATION_CLEANER_DEAD,Avatar3D.ANIMATION_CLEAN,Avatar3D.ANIMATION_CLEANER_REPAIR];
      
      private static const MAX_WALK_SPEED_Y:Number = 0.03;
      
      private static const MIN_WALK_SPEED_Y:Number = 0.01;
      
      private static const ACTION_DELAY_MAX:ProtectedInt = new ProtectedInt(12000);
      
      private static const ACTION_DELAY_MIN:ProtectedInt = new ProtectedInt(6000);
      
      public static const STATE_IDLE:int = 0;
      
      public static const STATE_WALKING:int = 1;
      
      public static const STATE_CLEANING:int = 2;
      
      public static const STATE_DEAD:int = 3;
      
      private var reachableTileMap:Array;
      
      private var timer:int = 0;
      
      private var cleaningItem:RoomItem;
      
      private var state:int = 0;
      
      public var reachableToiletSeats:Array = new Array();
      
      public var reachableFunctionalItems:Array = new Array();
      
      private var reachableTiles:Array;
      
      public function CleanerEmployee(param1:int, param2:int, param3:GameUserEmployee, param4:WorldRestaurantPlay)
      {
         this.restaurant = param4;
         super(WorldRestaurant.getScreenX(param1,param2),WorldRestaurant.getScreenY(param1,param2),param3,param4,ANIMATION_USED);
         getReachableTiles(param1,param2);
      }
      
      private function onRemove() : void
      {
         if(cleaningItem != null)
         {
            cleaningItem.cleaner = null;
            cleaningItem = null;
         }
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:GameObject = null;
         var _loc7_:int = 0;
         var _loc8_:GameObject = null;
         var _loc9_:int = 0;
         super.tick(param1);
         setWalkSpeed();
         if(state == STATE_IDLE)
         {
            if(speedX == 0 && speedY == 0 && avatarSprite.animationType == Avatar3D.ANIMATION_CLEANER_WALK)
            {
               setAnimation(Avatar3D.ANIMATION_CLEANER_IDLE);
            }
            if(timer <= 0)
            {
               if(reachableTiles.length > 0)
               {
                  if(restaurantPlay.silentTick || !(cleanNextToiletSeat() || fixNextFunctionalItem()))
                  {
                     _loc2_ = new Array();
                     _loc3_ = 0;
                     while(_loc3_ < restaurantPlay.trashObjects.length)
                     {
                        _loc6_ = restaurantPlay.trashObjects[_loc3_];
                        if(isTileReachable(_loc6_.tileX,_loc6_.tileY))
                        {
                           _loc6_.dist = Math.abs(_loc6_.tileX - tileX) + Math.abs(_loc6_.tileY - tileY);
                           _loc7_ = 0;
                           while(_loc7_ < _loc2_.length)
                           {
                              _loc8_ = _loc2_[_loc7_];
                              if(_loc6_.dist < _loc8_.dist)
                              {
                                 _loc2_.splice(_loc7_,0,_loc6_);
                                 break;
                              }
                              _loc7_++;
                           }
                           if(_loc7_ >= _loc2_.length)
                           {
                              _loc2_.push(_loc6_);
                           }
                        }
                        _loc3_++;
                     }
                     if(_loc2_.length > 0)
                     {
                        _loc4_ = int(_loc2_[0].tileX);
                        _loc5_ = int(_loc2_[0].tileY);
                     }
                     else
                     {
                        _loc9_ = Engine.rnd(0,reachableTiles.length);
                        _loc4_ = WorldRestaurant.getTileXFromTileIndex(reachableTiles[_loc9_]);
                        _loc5_ = WorldRestaurant.getTileYFromTileIndex(reachableTiles[_loc9_]);
                     }
                     setMovePath(getPathTo(_loc4_,_loc5_,false));
                     state = STATE_WALKING;
                     setAnimation(Avatar3D.ANIMATION_CLEANER_WALK);
                  }
               }
            }
         }
         else if(state == STATE_WALKING)
         {
            if(Boolean(cleaningItem) && cleaningItem.inUserTaskQueue)
            {
               cleaningItem.cleaner = null;
               cleaningItem = null;
               clearPath();
               state = STATE_IDLE;
               timer = 2000;
            }
            else if(reachedPathEnd())
            {
               if(cleaningItem != null)
               {
                  face(cleaningItem.x,cleaningItem.y);
                  if(cleaningItem.toilet)
                  {
                     if(!restaurantPlay.visitMode)
                     {
                        FixToiletTask.removeUserTaskListener(cleaningItem);
                     }
                     setAnimation(Avatar3D.ANIMATION_CLEAN);
                  }
                  else if(cleaningItem.interactive)
                  {
                     if(!restaurantPlay.visitMode)
                     {
                        FixFunctionalItemTask.removeUserTaskListener(cleaningItem);
                     }
                     setAnimation(Avatar3D.ANIMATION_CLEANER_REPAIR);
                  }
               }
               else
               {
                  setAnimation(Avatar3D.ANIMATION_CLEAN);
               }
               state = STATE_CLEANING;
               timer = getActionDelay();
            }
         }
         else if(state == STATE_CLEANING)
         {
            if(timer <= 0)
            {
               if(!restaurantPlay.silentTick)
               {
                  if(cleaningItem != null)
                  {
                     restaurantPlay.fixBreakableItem(cleaningItem);
                     cleaningItem.cleaner = null;
                     cleaningItem = null;
                  }
                  else
                  {
                     _loc3_ = 0;
                     while(_loc3_ < restaurantPlay.trashObjects.length)
                     {
                        _loc6_ = restaurantPlay.trashObjects[_loc3_];
                        if(_loc6_.tileX == tileX && _loc6_.tileY == tileY)
                        {
                           restaurantPlay.removeTrashObject(_loc6_);
                           break;
                        }
                        _loc3_++;
                     }
                  }
               }
               state = STATE_IDLE;
               timer = 2000;
               setAnimation(Avatar3D.ANIMATION_CLEANER_IDLE);
            }
         }
         else if(state == STATE_DEAD)
         {
            if(employeeUser.workTime > 0)
            {
               setEmotion(-1);
               state = STATE_IDLE;
               setAnimation(Avatar3D.ANIMATION_CLEANER_IDLE);
            }
         }
         if(timer > 0)
         {
            timer -= param1;
         }
      }
      
      override public function setDead() : void
      {
         if(state != STATE_DEAD)
         {
            super.setDead();
            setEmotion(EMOTION_NEED_FOOD);
            state = STATE_DEAD;
            setAnimation(Avatar3D.ANIMATION_CLEANER_DEAD);
            onRemove();
         }
      }
      
      private function fixNextFunctionalItem() : Boolean
      {
         var _loc2_:RoomItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < reachableFunctionalItems.length)
         {
            _loc2_ = reachableFunctionalItems[_loc1_];
            if(_loc2_.cleaner == null && !_loc2_.inUserTaskQueue && _loc2_.isBroken() && moveToRoomItem(_loc2_,true))
            {
               _loc2_.cleaner = this;
               cleaningItem = _loc2_;
               state = STATE_WALKING;
               setAnimation(Avatar3D.ANIMATION_CLEANER_WALK);
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function getReachableTiles(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         reachableTileMap = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < WorldRestaurant.MAX_NUM_TILES_X)
         {
            reachableTileMap[_loc3_] = new Array();
            _loc4_ = 0;
            while(_loc4_ < WorldRestaurant.MAX_NUM_TILES_Y)
            {
               reachableTileMap[_loc3_][_loc4_] = false;
               _loc4_++;
            }
            _loc3_++;
         }
         if(param1 > 0 && param2 > 0)
         {
            _loc5_ = new Array();
            _loc6_ = param1;
            _loc7_ = param2;
            while(true)
            {
               if(!reachableTileMap[_loc6_][_loc7_])
               {
                  _loc5_.push(_loc6_);
                  _loc5_.push(_loc7_);
                  reachableTileMap[_loc6_][_loc7_] = true;
               }
               if(_loc7_ > 1 && !reachableTileMap[_loc6_][_loc7_ - 1] && restaurant.isWalkableFrom(_loc6_,_loc7_,_loc6_,_loc7_ - 1))
               {
                  _loc7_--;
               }
               else if(_loc7_ < WorldRestaurant.MAX_NUM_TILES_Y - 1 && !reachableTileMap[_loc6_][_loc7_ + 1] && restaurant.isWalkableFrom(_loc6_,_loc7_,_loc6_,_loc7_ + 1))
               {
                  _loc7_++;
               }
               else if(_loc6_ > 1 && !reachableTileMap[_loc6_ - 1][_loc7_] && restaurant.isWalkableFrom(_loc6_,_loc7_,_loc6_ - 1,_loc7_))
               {
                  _loc6_--;
               }
               else if(_loc6_ < WorldRestaurant.MAX_NUM_TILES_X - 1 && !reachableTileMap[_loc6_ + 1][_loc7_] && restaurant.isWalkableFrom(_loc6_,_loc7_,_loc6_ + 1,_loc7_))
               {
                  _loc6_++;
               }
               else
               {
                  _loc5_.pop();
                  _loc5_.pop();
                  if(_loc5_.length <= 0)
                  {
                     break;
                  }
                  _loc6_ = int(_loc5_[_loc5_.length - 2]);
                  _loc7_ = int(_loc5_[_loc5_.length - 1]);
               }
            }
         }
         reachableTiles = new Array();
         _loc3_ = 0;
         while(_loc3_ < WorldRestaurant.MAX_NUM_TILES_X)
         {
            _loc4_ = 0;
            while(_loc4_ < WorldRestaurant.MAX_NUM_TILES_Y)
            {
               if(reachableTileMap[_loc3_][_loc4_])
               {
                  reachableTiles.push(WorldRestaurant.getTileIndex(_loc3_,_loc4_));
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function isTileReachable(param1:int, param2:int) : Boolean
      {
         return reachableTileMap[param1][param2];
      }
      
      override public function destroy() : void
      {
         super.destroy();
         onRemove();
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
      
      private function cleanNextToiletSeat() : Boolean
      {
         var _loc2_:RoomItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < reachableToiletSeats.length)
         {
            _loc2_ = reachableToiletSeats[_loc1_];
            if(_loc2_.cleaner == null && !_loc2_.inUserTaskQueue && _loc2_.isBroken() && moveToRoomItem(_loc2_,true))
            {
               _loc2_.cleaner = this;
               cleaningItem = _loc2_;
               state = STATE_WALKING;
               setAnimation(Avatar3D.ANIMATION_CLEANER_WALK);
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function getActionDelay() : int
      {
         var _loc1_:Number = employeeUser.workTime / GameUserEmployee.MAX_WORK_TIME * 100;
         if(_loc1_ >= 80)
         {
            return ACTION_DELAY_MIN.value;
         }
         if(_loc1_ < 20)
         {
            return ACTION_DELAY_MAX.value;
         }
         return ACTION_DELAY_MAX.value - (ACTION_DELAY_MAX.value - ACTION_DELAY_MIN.value) * (_loc1_ - 20) / 60;
      }
   }
}


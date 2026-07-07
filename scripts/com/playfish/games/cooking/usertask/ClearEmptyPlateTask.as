package com.playfish.games.cooking.usertask
{
   import com.playfish.games.cooking.DishOrder;
   import com.playfish.games.cooking.GameAwards;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ClearEmptyPlateTask extends UserTask
   {
      
      private static const TIME_MILLIS_TO_COMPLETE:int = 5000;
      
      private var emptyPlate:DishOrder;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function ClearEmptyPlateTask(param1:DishOrder, param2:WorldRestaurantPlay)
      {
         super(TIME_MILLIS_TO_COMPLETE);
         this.emptyPlate = param1;
         this.restaurant = param2;
         param1.addEventListener(MouseEvent.CLICK,onEmptyPlateClick,false,0,true);
         param1.buttonMode = true;
         var _loc3_:int = param2.emptyPlates.indexOf(param1);
         if(_loc3_ != -1)
         {
            param2.emptyPlates.splice(_loc3_,1);
         }
         param1.inUserTaskQueue = true;
         var _loc4_:Rectangle = param1.getBounds(param2.room);
         clock.x = _loc4_.left + (_loc4_.right - _loc4_.left) / 2;
         clock.y = _loc4_.top - clock.height / 2;
         param2.room.addChild(clock);
      }
      
      public static function removeUserTaskListener(param1:DishOrder) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,onAddUserTaskClick);
         removeGlowListenersFromItem(param1);
      }
      
      private static function onAddUserTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:DishOrder = DishOrder(param1.currentTarget);
         removeUserTaskListener(_loc2_);
         WorldRestaurantPlay.instance.userTaskQueue.addTask(new ClearEmptyPlateTask(_loc2_,WorldRestaurantPlay.instance));
      }
      
      public static function addUserTaskListener(param1:DishOrder) : void
      {
         param1.addEventListener(MouseEvent.CLICK,onAddUserTaskClick,false,0,true);
         addGlowListenersToItem(param1);
      }
      
      private function onEmptyPlateClick(param1:MouseEvent) : void
      {
         emptyPlate.removeEventListener(MouseEvent.CLICK,onEmptyPlateClick);
         emptyPlate.buttonMode = false;
         restaurant.emptyPlates.push(emptyPlate);
         emptyPlate.inUserTaskQueue = false;
         restaurant.room.removeChild(clock);
         queue.removeTask(this);
         addUserTaskListener(emptyPlate);
      }
      
      override public function start() : void
      {
         super.start();
         emptyPlate.removeEventListener(MouseEvent.CLICK,onEmptyPlateClick);
         emptyPlate.buttonMode = false;
      }
      
      override public function onTaskComplete() : void
      {
         emptyPlate.inUserTaskQueue = false;
         restaurant.room.removeChild(clock);
         restaurant.clearEmptyPlate(emptyPlate);
         GameWorld.addAwardValue(GameAwards.AWARD_TASK_CLEAR_PLATE,1);
      }
   }
}


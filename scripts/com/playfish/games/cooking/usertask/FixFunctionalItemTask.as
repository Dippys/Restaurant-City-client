package com.playfish.games.cooking.usertask
{
   import com.playfish.games.cooking.*;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class FixFunctionalItemTask extends UserTask
   {
      
      private static const TIME_MILLIS_TO_COMPLETE:int = 5000;
      
      private var item:RoomItem;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function FixFunctionalItemTask(param1:RoomItem, param2:WorldRestaurantPlay)
      {
         super(TIME_MILLIS_TO_COMPLETE);
         this.item = param1;
         this.restaurant = param2;
         param1.addEventListener(MouseEvent.CLICK,onItemClick,false,0,true);
         param1.buttonMode = true;
         param1.inUserTaskQueue = true;
         var _loc3_:Rectangle = param1.getBounds(param2.room);
         clock.x = _loc3_.left + (_loc3_.right - _loc3_.left) / 2;
         clock.y = param1.y - param1.itemHeight - clock.height / 2;
         param2.room.addChild(clock);
      }
      
      public static function removeUserTaskListener(param1:RoomItem) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,onAddUserTaskClick);
         removeGlowListenersFromItem(param1);
      }
      
      private static function onAddUserTaskClick(param1:MouseEvent) : void
      {
         var _loc2_:RoomItem = RoomItem(param1.currentTarget);
         removeUserTaskListener(_loc2_);
         WorldRestaurantPlay.instance.userTaskQueue.addTask(new FixFunctionalItemTask(_loc2_,WorldRestaurantPlay.instance));
      }
      
      public static function addUserTaskListener(param1:RoomItem) : void
      {
         param1.addEventListener(MouseEvent.CLICK,onAddUserTaskClick,false,0,true);
         addGlowListenersToItem(param1);
      }
      
      private function onItemClick(param1:MouseEvent) : void
      {
         item.removeEventListener(MouseEvent.CLICK,onItemClick);
         item.inUserTaskQueue = false;
         if(!item.itemConfig.infoText)
         {
            item.buttonMode = false;
         }
         restaurant.room.removeChild(clock);
         queue.removeTask(this);
         addUserTaskListener(item);
      }
      
      override public function start() : void
      {
         super.start();
         item.removeEventListener(MouseEvent.CLICK,onItemClick);
         item.buttonMode = false;
      }
      
      override public function onTaskComplete() : void
      {
         item.inUserTaskQueue = false;
         restaurant.room.removeChild(clock);
         restaurant.fixBreakableItem(item);
         if(item.itemConfig.infoText)
         {
            item.buttonMode = true;
         }
         GameWorld.addAwardValue(GameAwards.AWARD_TASK_REPAIR_ITEM,1);
      }
   }
}


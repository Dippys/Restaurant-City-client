package com.playfish.games.cooking.usertask
{
   import com.playfish.games.cooking.GameAwards;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class FixToiletTask extends UserTask
   {
      
      private static const TIME_MILLIS_TO_COMPLETE:int = 3000;
      
      private var toilet:RoomItem;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function FixToiletTask(param1:RoomItem, param2:WorldRestaurantPlay)
      {
         super(TIME_MILLIS_TO_COMPLETE);
         this.toilet = param1;
         this.restaurant = param2;
         param1.addEventListener(MouseEvent.CLICK,onToiletClick,false,0,true);
         param1.buttonMode = true;
         param1.inUserTaskQueue = true;
         var _loc3_:Rectangle = param1.getBounds(param2.room);
         clock.x = _loc3_.left + (_loc3_.right - _loc3_.left) / 2;
         clock.y = _loc3_.top - clock.height / 2;
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
         WorldRestaurantPlay.instance.userTaskQueue.addTask(new FixToiletTask(_loc2_,WorldRestaurantPlay.instance));
      }
      
      public static function addUserTaskListener(param1:RoomItem) : void
      {
         param1.addEventListener(MouseEvent.CLICK,onAddUserTaskClick,false,0,true);
         addGlowListenersToItem(param1);
      }
      
      override public function start() : void
      {
         super.start();
         toilet.removeEventListener(MouseEvent.CLICK,onToiletClick);
         toilet.buttonMode = false;
      }
      
      private function onToiletClick(param1:MouseEvent) : void
      {
         toilet.removeEventListener(MouseEvent.CLICK,onToiletClick);
         toilet.buttonMode = false;
         toilet.inUserTaskQueue = false;
         restaurant.room.removeChild(clock);
         queue.removeTask(this);
         addUserTaskListener(toilet);
      }
      
      override public function onTaskComplete() : void
      {
         toilet.inUserTaskQueue = false;
         restaurant.room.removeChild(clock);
         restaurant.fixBreakableItem(toilet);
         GameWorld.addAwardValue(GameAwards.AWARD_TASK_FIX_TOILET,1);
      }
   }
}


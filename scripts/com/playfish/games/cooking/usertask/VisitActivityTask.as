package com.playfish.games.cooking.usertask
{
   import com.playfish.games.cooking.GameAwards;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import com.playfish.games.cooking.visitactivities.ActivityItem;
   import com.playfish.games.cooking.visitactivities.VisitActivity;
   import flash.geom.Rectangle;
   
   public class VisitActivityTask extends UserTask
   {
      
      public static const MILLI_SECONDS_TIME_TO_COMPLETE:int = 2000;
      
      public var activityItem:ActivityItem;
      
      public var restaurant:WorldRestaurantPlay;
      
      public var mushroomTask:Boolean = false;
      
      public var activity:VisitActivity;
      
      public function VisitActivityTask(param1:ActivityItem)
      {
         var _loc2_:Rectangle = null;
         super(MILLI_SECONDS_TIME_TO_COMPLETE);
         this.activityItem = param1;
         this.activity = param1.visitActivity;
         this.restaurant = activity.restaurant;
         _loc2_ = param1.getBounds(restaurant.room);
         clock.x = _loc2_.left + (_loc2_.right - _loc2_.left) / 2;
         clock.y = _loc2_.top - clock.height / 2;
         restaurant.room.addChild(clock);
      }
      
      override public function onTaskComplete() : void
      {
         restaurant.room.removeChild(clock);
         activity.onActivityCompleted();
         GameWorld.addAwardValue(GameAwards.AWARD_TASK_HELP_FRIEND,1);
      }
      
      public function onActivityItemClick() : void
      {
         restaurant.userTaskQueue.addTask(this);
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:Rectangle = null;
         super.tick(param1);
         if(activityItem.roomActor)
         {
            _loc2_ = activityItem.getBounds(restaurant.room);
            clock.x = _loc2_.left + (_loc2_.right - _loc2_.left) / 2;
            clock.y = _loc2_.top - clock.height / 2;
         }
      }
   }
}


package com.playfish.games.cooking.usertask
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.utils.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public class UserTask
   {
      
      public var clockArc:Shape;
      
      private var active:Boolean = false;
      
      private var timeMillisToComplete:int;
      
      private var maxTimeMillisToComplete:int;
      
      public var queue:UserTaskQueue;
      
      public var clock:MovieClip;
      
      public function UserTask(param1:int)
      {
         super();
         this.timeMillisToComplete = param1;
         this.maxTimeMillisToComplete = param1;
         clock = Engine.getMovieClip("PieClockIcon");
         clock.scaleX = 0.75;
         clock.scaleY = 0.75;
         clockArc = new Shape();
         clock.mc_arc.visible = false;
         clock.addChildAt(clockArc,clock.getChildIndex(clock.mc_arc) + 1);
         clock.mouseEnabled = false;
         clock.mouseChildren = false;
      }
      
      protected static function removeGlowListenersFromItem(param1:Sprite) : void
      {
         param1.removeEventListener(MouseEvent.ROLL_OVER,onUserTaskItemRollOver);
         param1.removeEventListener(MouseEvent.ROLL_OUT,onUserTaskItemRollOut);
         param1.buttonMode = false;
         param1.filters = null;
      }
      
      private static function onUserTaskItemRollOver(param1:MouseEvent) : void
      {
         param1.currentTarget.filters = [new GlowFilter(16777215,1,6,6,20)];
      }
      
      private static function onUserTaskItemRollOut(param1:MouseEvent) : void
      {
         param1.currentTarget.filters = null;
      }
      
      protected static function addGlowListenersToItem(param1:Sprite) : void
      {
         param1.addEventListener(MouseEvent.ROLL_OVER,onUserTaskItemRollOver,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OUT,onUserTaskItemRollOut,false,0,true);
         param1.buttonMode = true;
      }
      
      public function isCompleted() : Boolean
      {
         return timeMillisToComplete <= 0;
      }
      
      public function start() : void
      {
         active = true;
         clock.scaleX = 1;
         clock.scaleY = 1;
      }
      
      public function refreshClock() : void
      {
         clockArc.graphics.clear();
         Arc.paint(clockArc.graphics,clock.mc_arc.width / 2,360 - 360 * timeMillisToComplete / maxTimeMillisToComplete,16711680);
      }
      
      public function onTaskComplete() : void
      {
      }
      
      public function tick(param1:uint) : void
      {
         if(active)
         {
            timeMillisToComplete = Math.max(0,timeMillisToComplete - param1);
            refreshClock();
            if(isCompleted())
            {
               onTaskComplete();
            }
         }
      }
   }
}


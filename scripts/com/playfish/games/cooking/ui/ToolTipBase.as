package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.Engine;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ToolTipBase
   {
      
      private var removeTimer:Timer;
      
      private var timer:Timer;
      
      protected var parent:DisplayObjectContainer;
      
      public var displayParent:DisplayObjectContainer = Engine.instance;
      
      protected var toolTipMC:MovieClip;
      
      public function ToolTipBase(param1:DisplayObjectContainer, param2:Boolean = true)
      {
         super();
         this.parent = param1;
         if(param2)
         {
            param1.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
            param1.addEventListener(MouseEvent.ROLL_OUT,onRollOut,false,0,true);
         }
         param1.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage,false,0,true);
      }
      
      public function getToolTipMC() : MovieClip
      {
         return null;
      }
      
      public function remove() : void
      {
         if(toolTipMC)
         {
            displayParent.removeChild(toolTipMC);
            toolTipMC = null;
         }
         if(timer)
         {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
            timer = null;
         }
         if(removeTimer)
         {
            removeTimer.stop();
            removeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onRemoveTimerComplete);
            removeTimer = null;
         }
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onFullScreen);
      }
      
      private function onRemoveTimerComplete(param1:Event) : void
      {
         remove();
      }
      
      public function destroy() : void
      {
         remove();
         parent.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
         parent.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
         parent.removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         if(toolTipMC == null)
         {
            remove();
            timer = new Timer(200,1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete,false,0,true);
            timer.start();
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         destroy();
      }
      
      private function onFullScreen(param1:Event) : void
      {
         refresh();
      }
      
      public function refresh() : void
      {
      }
      
      public function show(param1:int = -1) : void
      {
         if(toolTipMC == null)
         {
            toolTipMC = getToolTipMC();
            refresh();
            if(toolTipMC)
            {
               displayParent.addChild(toolTipMC);
            }
         }
         if(param1 > 0)
         {
            if(removeTimer)
            {
               removeTimer.stop();
            }
            removeTimer = new Timer(param1,1);
            removeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onRemoveTimerComplete,false,0,true);
            removeTimer.start();
         }
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,-1,true);
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         if(timer != null)
         {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
            timer = null;
            show();
         }
      }
   }
}


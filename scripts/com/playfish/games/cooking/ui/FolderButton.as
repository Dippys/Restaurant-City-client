package com.playfish.games.cooking.ui
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class FolderButton
   {
      
      private static const CLOSE_DELAY:int = 400;
      
      private var button:MovieClip;
      
      private var timer:Timer;
      
      public function FolderButton(param1:MovieClip)
      {
         super();
         this.button = param1;
         param1.stop();
         param1.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OUT,onRollOut,false,0,true);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         if(timer)
         {
            removeTimer();
         }
         var _loc2_:String = button.mc_content.currentLabel;
         if(_loc2_ != "open" && _loc2_ != "idle")
         {
            button.mc_content.gotoAndPlay("open");
         }
      }
      
      private function removeTimer() : void
      {
         timer.stop();
         timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
         timer = null;
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         var _loc2_:String = button.mc_content.currentLabel;
         if(_loc2_ != "close" && _loc2_ != "closed")
         {
            timer = new Timer(CLOSE_DELAY,1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete,false,0,true);
            timer.start();
         }
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         removeTimer();
         button.mc_content.gotoAndPlay("close");
      }
   }
}


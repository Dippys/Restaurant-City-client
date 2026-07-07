package com.playfish.coretech.engine.core
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PFTimer extends Timer
   {
      
      public var objParam2:Object;
      
      public var objParam:Object;
      
      public function PFTimer(param1:Number, param2:int = 0, param3:Object = null, param4:Object = null)
      {
         super(param1,param2);
         objParam = param3;
         objParam2 = param4;
      }
      
      public static function startTimer(param1:Number, param2:Function, param3:Object = null) : PFTimer
      {
         var _loc4_:PFTimer = new PFTimer(param1,0,param2,param3);
         _loc4_.addEventListener("timer",_loc4_.timerHandler);
         _loc4_.start();
         return _loc4_;
      }
      
      public static function startAlarm(param1:Number, param2:Function, param3:Object = null) : PFTimer
      {
         var _loc4_:PFTimer = new PFTimer(param1,1,param2,param3);
         _loc4_.addEventListener("timer",_loc4_.timerHandler);
         _loc4_.start();
         return _loc4_;
      }
      
      public function timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:PFTimer = param1.target as PFTimer;
         var _loc3_:Function = _loc2_.objParam as Function;
         if(_loc3_ != null)
         {
            if(!_loc3_(objParam2))
            {
               _loc2_.stop();
            }
         }
      }
   }
}


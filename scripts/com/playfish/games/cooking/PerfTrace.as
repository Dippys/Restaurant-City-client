package com.playfish.games.cooking
{
   import flash.external.ExternalInterface;
   import flash.utils.getTimer;
   
   public class PerfTrace
   {
      
      public static const ENABLED:Boolean = true;
      
      private static var startTime:int = -1;
      
      public function PerfTrace()
      {
         super();
      }
      
      public static function mark(param1:String) : void
      {
         var _loc3_:String = null;
         if(!ENABLED)
         {
            return;
         }
         var _loc2_:int = getTimer();
         if(startTime < 0)
         {
            startTime = _loc2_;
         }
         _loc3_ = "[RC-PERF] +" + (_loc2_ - startTime) + "ms " + param1;
         trace(_loc3_);
         try
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("console.log",_loc3_);
            }
         }
         catch(ex:Error)
         {
         }
      }
      
      public static function slow(param1:String, param2:int, param3:int = 25) : void
      {
         var _loc4_:int = getTimer() - param2;
         if(_loc4_ >= param3)
         {
            mark(param1 + " took " + _loc4_ + "ms");
         }
      }
   }
}

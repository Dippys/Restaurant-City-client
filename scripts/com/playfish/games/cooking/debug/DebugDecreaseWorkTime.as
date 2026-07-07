package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.*;
   import flash.events.MouseEvent;
   
   public class DebugDecreaseWorkTime extends DebugEntryButton
   {
      
      private var minutes:int;
      
      public function DebugDecreaseWorkTime(param1:int)
      {
         this.minutes = param1;
         super("Decrease employee work time by " + param1 + " minutes",null);
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         var _loc3_:GameUserEmployee = null;
         var _loc2_:int = 0;
         while(_loc2_ < GameWorld.gameUser.employeeUsers.length)
         {
            _loc3_ = GameWorld.gameUser.employeeUsers[_loc2_];
            _loc3_.workTime -= minutes * GameWorld.MINUTE_MILLIS;
            _loc2_++;
         }
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


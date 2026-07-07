package com.playfish.games.cooking
{
   import com.playfish.games.cooking.utils.ProtectedInt;
   
   public class GameUserEmployee
   {
      
      public static const MAX_WORK_TIME:int = 4 * 60 * 60 * 1000;
      
      public static const JOB_NONE:int = 0;
      
      public static const JOB_COOK:int = 1;
      
      public static const JOB_WAITOR:int = 2;
      
      public static const JOB_REST:int = 3;
      
      public static const JOB_CLEANER:int = 4;
      
      private var _workTime:ProtectedInt = new ProtectedInt(MAX_WORK_TIME);
      
      public var notification:Boolean;
      
      public var outfitItems:Array = new Array();
      
      public var bedItem:UserItem;
      
      public var gameUser:GameUser = null;
      
      private var _job:ProtectedInt = new ProtectedInt(JOB_NONE);
      
      public var activePerks:Array = new Array();
      
      public function GameUserEmployee()
      {
         super();
      }
      
      public function set workTime(param1:int) : void
      {
         _workTime.value = param1;
      }
      
      public function getBonusWaitorPoints() : int
      {
         var _loc3_:PerkItem = null;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         while(_loc2_ < activePerks.length)
         {
            _loc3_ = activePerks[_loc2_];
            _loc1_ += _loc3_.productivity;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getTimeLeft() : String
      {
         var _loc1_:int = workTime + (GameWorld.SECOND_MILLIS - 1);
         var _loc2_:int = Math.floor(_loc1_ / GameWorld.HOUR_MILLIS);
         _loc1_ %= GameWorld.HOUR_MILLIS;
         var _loc3_:int = Math.floor(_loc1_ / GameWorld.MINUTE_MILLIS);
         _loc1_ %= GameWorld.MINUTE_MILLIS;
         var _loc4_:String = _loc3_.toString();
         if(_loc4_.length < 2)
         {
            _loc4_ = "0" + _loc4_;
         }
         var _loc5_:int = Math.floor(_loc1_ / GameWorld.SECOND_MILLIS);
         var _loc6_:String = _loc5_.toString();
         if(_loc6_.length < 2)
         {
            _loc6_ = "0" + _loc6_;
         }
         return _loc2_.toString() + ":" + _loc4_ + ":" + _loc6_;
      }
      
      public function get workTime() : int
      {
         return _workTime.value;
      }
      
      public function addPerk(param1:PerkItem) : void
      {
         if(param1.workTime > 0)
         {
            workTime = Math.min(workTime + param1.workTime * 1000,GameUserEmployee.MAX_WORK_TIME);
         }
         else
         {
            activePerks.push(param1);
         }
      }
      
      public function set job(param1:int) : void
      {
         _job.value = param1;
         bedItem = null;
      }
      
      public function get job() : int
      {
         return _job.value;
      }
      
      public function getBonusChefPoints() : int
      {
         var _loc3_:PerkItem = null;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         while(_loc2_ < activePerks.length)
         {
            _loc3_ = activePerks[_loc2_];
            _loc1_ += _loc3_.productivity;
            _loc2_++;
         }
         return _loc1_;
      }
   }
}


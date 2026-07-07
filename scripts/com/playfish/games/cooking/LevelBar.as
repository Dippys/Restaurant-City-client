package com.playfish.games.cooking
{
   import flash.display.MovieClip;
   
   public class LevelBar
   {
      
      private var scene:MovieClip;
      
      private var gameUser:GameUser;
      
      public function LevelBar(param1:MovieClip, param2:GameUser)
      {
         super();
         this.scene = param1;
         this.gameUser = param2;
         scene.stop();
         refresh();
      }
      
      public function refresh() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = gameUser.level.value;
         var _loc2_:int = gameUser.getGourmetPoints();
         scene.tf_point.text = _loc2_;
         scene.tf_level.text = _loc1_;
         scene.tf_point.mouseEnabled = false;
         scene.tf_level.mouseEnabled = false;
         if(_loc1_ < GameWorld.LEVEL_THRESHOLDS.length - 1)
         {
            _loc3_ = _loc2_ - GameWorld.LEVEL_THRESHOLDS[_loc1_].points;
            _loc4_ = GameWorld.LEVEL_THRESHOLDS[_loc1_ + 1].points - GameWorld.LEVEL_THRESHOLDS[_loc1_].points;
            scene.gotoAndStop(1 + Math.floor(_loc3_ / _loc4_ * 100));
         }
         else
         {
            scene.gotoAndStop(1);
         }
      }
   }
}


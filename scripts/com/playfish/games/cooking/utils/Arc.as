package com.playfish.games.cooking.utils
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class Arc extends Sprite
   {
      
      private static const ANGLE_TO_RADIAN:Number = Math.PI / 180;
      
      public function Arc(param1:Number, param2:Number, param3:int)
      {
         super();
         setParam(param1,param2,param3);
      }
      
      public static function paint(param1:Graphics, param2:Number, param3:Number, param4:int) : void
      {
         param1.beginFill(param4);
         param1.lineTo(0,-param2);
         var _loc5_:int = Math.floor(param3 / 90);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            switch(_loc6_)
            {
               case 0:
                  param1.curveTo(param2,-param2,param2,0);
                  break;
               case 1:
                  param1.curveTo(param2,param2,0,param2);
                  break;
               case 2:
                  param1.curveTo(-param2,param2,-param2,0);
                  break;
               case 3:
                  param1.curveTo(-param2,-param2,0,-param2);
            }
            _loc6_++;
         }
         var _loc7_:Number = param3 * ANGLE_TO_RADIAN;
         var _loc8_:Number = (param3 - _loc5_ * 90) * ANGLE_TO_RADIAN;
         var _loc9_:Number = _loc8_ / 2 + _loc5_ * 90 * ANGLE_TO_RADIAN;
         var _loc10_:Number = param2 / Math.cos(_loc8_ / 2);
         param1.curveTo(_loc10_ * Math.sin(_loc9_),-_loc10_ * Math.cos(_loc9_),param2 * Math.sin(_loc7_),-param2 * Math.cos(_loc7_));
         param1.lineTo(0,0);
         param1.endFill();
      }
      
      public function setParam(param1:Number, param2:Number, param3:int) : void
      {
         graphics.clear();
         paint(graphics,param1,param2,param3);
      }
   }
}


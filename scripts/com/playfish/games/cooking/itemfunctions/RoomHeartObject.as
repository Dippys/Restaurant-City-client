package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.Engine;
   
   public class RoomHeartObject extends EffectObject
   {
      
      public static const MIN_SPEED_Y:Number = -3;
      
      public static const MAX_SPEED_Y:Number = -1.5;
      
      private var curAngle:Number = 0;
      
      private var xOffset:Number = 0;
      
      private const LIFE_SPAN_IN_MSEC:int = 5000;
      
      public function RoomHeartObject(param1:int, param2:int)
      {
         super("HeartAssetAnim",param1,param2,0,Engine.rndFloat(MIN_SPEED_Y,MAX_SPEED_Y),LIFE_SPAN_IN_MSEC + Engine.rnd(-1000,1000));
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
         curAngle += 0.1;
         x -= xOffset;
         xOffset = Math.sin(curAngle) * 10;
         x += xOffset;
      }
   }
}


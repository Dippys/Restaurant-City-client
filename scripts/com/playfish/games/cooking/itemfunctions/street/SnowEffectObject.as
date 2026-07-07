package com.playfish.games.cooking.itemfunctions.street
{
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.itemfunctions.EffectObject;
   
   public class SnowEffectObject extends EffectObject
   {
      
      private var xOffset:Number = 0;
      
      private var curAngle:Number = 0;
      
      public function SnowEffectObject(param1:Number, param2:Number)
      {
         super("SnowFlake0" + Engine.rnd(1,3),param1,param2,Engine.rndFloat(StreetSnowGenerator.MIN_SPEED_X,StreetSnowGenerator.MAX_SPEED_X),Engine.rndFloat(StreetSnowGenerator.MIN_SPEED_Y,StreetSnowGenerator.MAX_SPEED_Y),StreetSnowGenerator.TIME_TO_LIVE + Engine.rnd(-1000,1000));
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


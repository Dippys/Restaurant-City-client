package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.Engine;
   
   public class RoomGeyserBubble extends EffectObject
   {
      
      private const FLOAT_SPEED:Number = 2;
      
      private const LIFE_SPAN_IN_MSEC:int = 5000;
      
      public function RoomGeyserBubble(param1:int, param2:int)
      {
         super("LargeBubble",param1,param2,0,-FLOAT_SPEED,LIFE_SPAN_IN_MSEC + Engine.rnd(-1000,1000));
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
         this.y += Engine.rndFloat(-1,1);
         this.x += Engine.rndFloat(-1,1);
      }
   }
}


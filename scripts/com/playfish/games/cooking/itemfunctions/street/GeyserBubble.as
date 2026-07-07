package com.playfish.games.cooking.itemfunctions.street
{
   import com.playfish.games.cooking.BaseObject;
   import com.playfish.games.cooking.Engine;
   
   public class GeyserBubble extends BaseObject
   {
      
      private const FLOAT_SPEED:Number = 2;
      
      public var timeLeft:int;
      
      private const LIFE_SPAN_IN_MSEC:int = 5000;
      
      public function GeyserBubble(param1:String, param2:Number = 0, param3:Number = 0)
      {
         super(param1);
         this.x = param2;
         this.y = param3;
         this.timeLeft = LIFE_SPAN_IN_MSEC + Engine.rnd(-1000,1000);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public static function createGeyserBubbleForBuilding(param1:String, param2:Number, param3:Number) : GeyserBubble
      {
         return new GeyserBubble(param1,param2,param3);
      }
      
      override public function tick(param1:uint) : void
      {
         this.timeLeft -= param1;
         this.y -= FLOAT_SPEED + Engine.rndFloat(-1,1);
         this.x += Engine.rndFloat(-1,1);
         if(timeLeft <= 1000)
         {
            this.alpha = timeLeft / 1000;
         }
      }
   }
}


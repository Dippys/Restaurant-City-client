package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   
   public class Coin extends BaseObject
   {
      
      private static var GRAVITY:Number = -2;
      
      private static const STATE_MOVING:int = 0;
      
      private static const STATE_DISAPPEARING:int = 1;
      
      private var timer:int;
      
      private var tileX:int;
      
      private var tileY:int;
      
      private var speedX:Number = 0;
      
      private var speedY:Number = 0;
      
      private var speedZ:Number = 0;
      
      private var zValue:Number = 0;
      
      private var state:int = 0;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function Coin(param1:int, param2:int, param3:WorldRestaurantPlay)
      {
         super("MoneyBillAnim");
         this.restaurant = param3;
         this.x = param1;
         this.y = param2;
         speedX = Engine.rnd(-15,15) / 10;
         speedY = Engine.rnd(-15,15) / 10;
         speedZ = Engine.rnd(10,15);
         content.mc_coin.stop();
         mouseEnabled = false;
         mouseChildren = false;
         param3.coinDropSound.play(1);
         update();
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
         if(state == STATE_DISAPPEARING)
         {
            if(content.mc_coin.currentFrame >= content.mc_coin.totalFrames)
            {
               restaurant.coinPickUpSound.play(1);
               BaseObject(parent).removeObject(this);
               return;
            }
         }
         else
         {
            timer += param1;
            if(timer >= 2000)
            {
               state = STATE_DISAPPEARING;
               content.mc_coin.gotoAndPlay("disappear");
            }
         }
         x += speedX;
         y += speedY;
         zValue += speedZ;
         speedZ += GRAVITY;
         if(zValue <= 0)
         {
            zValue = 0;
            if(speedZ >= -8)
            {
               speedZ = 0;
            }
            else
            {
               speedZ = -speedZ / 2;
               restaurant.coinDropSound.play(1);
            }
         }
         update();
      }
      
      private function update() : void
      {
         tileX = WorldRestaurant.getTileIndexX(x,y);
         tileY = WorldRestaurant.getTileIndexY(x,y);
         content.mc_coin.y = -zValue;
         drawPriority = WorldRestaurant.getTileDrawPriority(tileX,tileY);
      }
   }
}


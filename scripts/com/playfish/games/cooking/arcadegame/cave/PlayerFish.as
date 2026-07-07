package com.playfish.games.cooking.arcadegame.cave
{
   public class PlayerFish
   {
      
      public static const FISH_GRAVITY:Number = 0.8;
      
      public static const FISH_SPEED:Number = 8;
      
      public static const FISH_TERMINAL_VELOCITY:Number = 6;
      
      public static const FISH_THRUST:Number = 1.8;
      
      public var dead:Boolean;
      
      private var dropFrame:int;
      
      public var spriteFrame:int;
      
      public var positionY:Number;
      
      private var spriteFrameArray:Array;
      
      public var positionX:Number;
      
      public var velocityY:Number;
      
      public function PlayerFish()
      {
         super();
         resetPosition();
         spriteFrame = 0;
         spriteFrameArray = [0,0,1,1,1,1,0,0,2,2,2,2];
         dropFrame = 0;
      }
      
      public function resetPositionY() : void
      {
         positionY = WorldArcadeCave.WINDOW_HEIGHT / 2;
      }
      
      public function getAnimationFrame() : int
      {
         return spriteFrameArray[spriteFrame];
      }
      
      public function drop() : void
      {
         if(velocityY < FISH_TERMINAL_VELOCITY)
         {
            velocityY = Math.min(velocityY + FISH_GRAVITY,FISH_TERMINAL_VELOCITY);
         }
      }
      
      public function updateFishPosition() : void
      {
         positionY += velocityY;
      }
      
      public function resetVelocity() : void
      {
         velocityY = 0;
      }
      
      public function resetPositionX() : void
      {
         positionX = WorldArcadeCave.WINDOW_WIDTH / 8;
      }
      
      public function resetPosition() : void
      {
         positionX = WorldArcadeCave.WINDOW_WIDTH / 8;
         positionY = WorldArcadeCave.WINDOW_HEIGHT / 2;
      }
      
      public function swimForward() : void
      {
         positionX += FISH_SPEED;
         spriteFrame = (spriteFrame + 1) % spriteFrameArray.length;
      }
      
      public function thrust() : void
      {
         if(velocityY > -FISH_TERMINAL_VELOCITY)
         {
            velocityY = Math.max(velocityY - FISH_THRUST,-FISH_TERMINAL_VELOCITY);
         }
      }
   }
}


package com.playfish.games.cooking.arcadegame.cave
{
   import com.playfish.games.cooking.Engine;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class BackgroundFishes
   {
      
      private var swimHeight:int;
      
      private var firstCall:Boolean;
      
      private var bitmap:BitmapData;
      
      private var positionY:int;
      
      private var speedX:int;
      
      private var speedY:int;
      
      private var screenHeight:int;
      
      private var positionX:int;
      
      private var screenWidth:int;
      
      public function BackgroundFishes(param1:int)
      {
         super();
         speedX = speedY = param1;
         bitmap = Engine.getBitmapData("CaveFarBackgroundFish");
         swimHeight = 0;
         firstCall = true;
      }
      
      private function reset() : void
      {
         positionX = screenWidth;
         positionY = swimHeight ? int(screenHeight / 2) : int(screenHeight / 3);
         swimHeight = (swimHeight + 1) % 2;
      }
      
      public function roam() : void
      {
         positionX -= speedX;
      }
      
      private function fishNoLongerVisible() : Boolean
      {
         return positionX < -bitmap.width - 10;
      }
      
      public function draw(param1:BitmapData) : void
      {
         if(firstCall)
         {
            screenWidth = param1.width;
            screenHeight = param1.height;
            reset();
            firstCall = false;
         }
         if(fishNoLongerVisible())
         {
            reset();
         }
         roam();
         param1.draw(bitmap,new Matrix(2,0,0,2,positionX,positionY));
      }
   }
}


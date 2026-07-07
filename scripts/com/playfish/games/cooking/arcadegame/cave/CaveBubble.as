package com.playfish.games.cooking.arcadegame.cave
{
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.arcadegame.BitmapSprite;
   import flash.display.BitmapData;
   
   public class CaveBubble
   {
      
      private var bitmap:BitmapData;
      
      public var opacity:Number;
      
      private var frame:int;
      
      public var positionX:Number;
      
      public var positionY:Number;
      
      public var bitmapSprite:BitmapSprite;
      
      public var age:Number;
      
      public function CaveBubble(param1:Number, param2:Number, param3:BitmapSprite)
      {
         super();
         this.positionX = param1;
         this.positionY = param2;
         this.bitmapSprite = param3;
         age = 1;
         opacity = 1;
         this.frame = Engine.rnd(0,2);
      }
      
      public function decreaseAge() : void
      {
         age -= 0.1;
      }
      
      public function shift(param1:Number) : void
      {
         this.positionX -= param1;
      }
      
      public function getBitmap() : BitmapData
      {
         bitmap = new BitmapData(bitmapSprite.frameWidth,bitmapSprite.frameHeight,true,0);
         bitmapSprite.paint(bitmap,frame,0,0);
         return bitmap;
      }
      
      public function decreaseOpacity() : void
      {
         opacity -= 0.1;
      }
   }
}


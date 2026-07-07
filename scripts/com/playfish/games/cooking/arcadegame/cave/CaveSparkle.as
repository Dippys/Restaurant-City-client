package com.playfish.games.cooking.arcadegame.cave
{
   import com.playfish.games.cooking.arcadegame.BitmapSprite;
   import flash.display.BitmapData;
   
   public class CaveSparkle
   {
      
      private var frame:int;
      
      private var frameSequence:Array;
      
      public var positionX:int;
      
      public var positionY:int;
      
      private var bitmapSprite:BitmapSprite;
      
      private var bitmapData:BitmapData;
      
      public function CaveSparkle(param1:int, param2:int)
      {
         super();
         frame = 0;
         frameSequence = [0,1,2,3,4,5,4,3,2,1];
         this.bitmapSprite = bitmapSprite;
         this.positionX = param1;
         this.positionY = param2;
      }
      
      public function shift(param1:Number) : void
      {
         this.positionX -= param1;
      }
      
      public function isDead() : Boolean
      {
         return frame == frameSequence.length;
      }
      
      public function getFrame() : int
      {
         return frameSequence[frame];
      }
      
      public function age() : void
      {
         ++frame;
      }
   }
}


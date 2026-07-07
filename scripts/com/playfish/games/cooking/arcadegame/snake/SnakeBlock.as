package com.playfish.games.cooking.arcadegame.snake
{
   import com.playfish.games.cooking.arcadegame.BitmapSprite;
   
   public class SnakeBlock
   {
      
      public static const LEFT:int = 1;
      
      public static const RIGHT:int = 2;
      
      public static const UP:int = 4;
      
      public static const DOWN:int = 8;
      
      private static const FRAME_ROTATION_MAP:Array = [-1,-1,1,BitmapSprite.ROTATE_180,1,0,2,0,1,BitmapSprite.ROTATE_270,3,BitmapSprite.ROTATE_90,3,BitmapSprite.ROTATE_180,-1,-1,1,BitmapSprite.ROTATE_90,3,0,3,BitmapSprite.ROTATE_270,-1,-1,2,BitmapSprite.ROTATE_90];
      
      public var rotation:int;
      
      public var tileX:int;
      
      public var tileY:int;
      
      public var frame:int;
      
      public var direction:int;
      
      public function SnakeBlock()
      {
         super();
      }
      
      public function setDirection(param1:int) : void
      {
         this.direction = param1;
         frame = FRAME_ROTATION_MAP[param1 * 2];
         rotation = FRAME_ROTATION_MAP[param1 * 2 + 1];
      }
   }
}


package com.playfish.games.cooking.arcadegame.cave
{
   import com.playfish.games.cooking.arcadegame.BitmapSprite;
   
   public class CaveFood
   {
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var stripIndex:int = 0;
      
      public var bitmapSprite:BitmapSprite;
      
      public var foodFrame:int = 0;
      
      public function CaveFood(param1:BitmapSprite, param2:int)
      {
         super();
         this.bitmapSprite = param1;
         this.foodFrame = param2;
      }
   }
}


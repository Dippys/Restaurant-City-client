package com.playfish.games.cooking
{
   public class RestaurantTreeObject extends AnimatedObject
   {
      
      public var shaken:Boolean = false;
      
      public function RestaurantTreeObject(param1:String)
      {
         super(param1);
         content.cacheAsBitmap = true;
      }
      
      public function canBeShaken() : Boolean
      {
         return hasSequence("shake");
      }
      
      public function shake() : Boolean
      {
         setSequence("shake");
         numLoops = 1;
         if(!shaken)
         {
            shaken = true;
            if(Engine.rnd(0,5) == 0)
            {
               return true;
            }
         }
         return false;
      }
   }
}


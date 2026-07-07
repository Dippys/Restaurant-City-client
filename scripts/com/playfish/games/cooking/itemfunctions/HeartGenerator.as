package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurant;
   
   public class HeartGenerator extends RoomEffectGenerator
   {
      
      private static const MAX_HEARTS_ON_SCREEN:int = 8;
      
      public function HeartGenerator(param1:RoomItem)
      {
         super(param1,MAX_HEARTS_ON_SCREEN);
      }
      
      override public function createEffectObject(param1:int, param2:int) : EffectObject
      {
         return new RoomHeartObject(WorldRestaurant.getScreenX(param1,param2),WorldRestaurant.getScreenY(param1,param2));
      }
   }
}


package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   
   public class SnowGenerator extends RoomEffectGenerator
   {
      
      private static const MAX_SNOW_ON_SCREEN:int = 6;
      
      public function SnowGenerator(param1:RoomItem)
      {
         super(param1,MAX_SNOW_ON_SCREEN);
      }
      
      override public function createEffectObject(param1:int, param2:int) : EffectObject
      {
         return new RoomSnowEffectObject(param1,param2);
      }
   }
}


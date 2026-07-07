package com.playfish.games.cooking.itemfunctions.street
{
   import com.playfish.games.cooking.BuildingItem;
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.itemfunctions.EffectObject;
   
   public class StreetHeartGenerator extends StreetEffectGenerator
   {
      
      public static const TIME_TO_LIVE:int = 4500;
      
      public static const MIN_SPEED_X:Number = -1;
      
      public static const MAX_SPEED_X:Number = 1;
      
      public static const MIN_SPEED_Y:Number = -3;
      
      public static const MAX_SPEED_Y:Number = -1.5;
      
      public static const MAX_COUNT:int = 5;
      
      public function StreetHeartGenerator(param1:BuildingItem)
      {
         super(param1,MAX_COUNT,1000);
      }
      
      override public function createEffect() : EffectObject
      {
         return new HeartEffectObject(Engine.rndFloat(-200,200),building.y);
      }
   }
}


package com.playfish.games.cooking.itemfunctions.street
{
   import com.playfish.games.cooking.BuildingItem;
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.itemfunctions.EffectObject;
   
   public class StreetLeafGenerator extends StreetEffectGenerator
   {
      
      private static const MAX_LEAF_COUNT:int = 5;
      
      private const LEAF_MIN_SPEED_X:Number = 2;
      
      private const LEAF_MIN_SPEED_Y:Number = 1;
      
      private const LEAF_MAX_SPEED_X:Number = 5;
      
      private const LEAF_MAX_SPEED_Y:Number = 4;
      
      private const LEAF_TIME_TO_LIVE:int = 4000;
      
      public function StreetLeafGenerator(param1:BuildingItem)
      {
         super(param1,MAX_LEAF_COUNT,1000);
      }
      
      override public function createEffect() : EffectObject
      {
         return new EffectObject("Leaf0" + Engine.rnd(1,4),-200 + Engine.rndFloat(-40,40),building.y - 200 - Engine.rnd(0,200),Engine.rndFloat(LEAF_MIN_SPEED_X,LEAF_MAX_SPEED_X),Engine.rndFloat(LEAF_MIN_SPEED_Y,LEAF_MAX_SPEED_Y),LEAF_TIME_TO_LIVE + Engine.rnd(-1000,1000));
      }
   }
}


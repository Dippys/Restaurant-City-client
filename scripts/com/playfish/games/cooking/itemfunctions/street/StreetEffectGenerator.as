package com.playfish.games.cooking.itemfunctions.street
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.itemfunctions.EffectObject;
   
   public class StreetEffectGenerator extends StreetItemFunction
   {
      
      private var effects:Array = new Array();
      
      private var effectTimer:int;
      
      private var nextEffectTime:int;
      
      private var maxEffectCount:int;
      
      protected var building:StreetBuilding;
      
      public function StreetEffectGenerator(param1:BuildingItem, param2:int, param3:int)
      {
         super(param1);
         this.maxEffectCount = param2;
         this.nextEffectTime = param3;
      }
      
      override public function destroy() : void
      {
         var _loc1_:EffectObject = null;
         for each(_loc1_ in effects)
         {
            building.removeObject(_loc1_);
            _loc1_.destroy();
         }
      }
      
      public function createEffect() : EffectObject
      {
         return null;
      }
      
      override public function init(param1:StreetBuilding) : void
      {
         this.building = param1;
      }
      
      private function addEffect(param1:EffectObject) : void
      {
         param1.drawPriority = 1000;
         building.addObject(param1);
         effects.push(param1);
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc3_:EffectObject = null;
         var _loc4_:EffectObject = null;
         super.tick(param1);
         var _loc2_:* = int(effects.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = effects[_loc2_];
            if(_loc3_.timeToLive <= 0)
            {
               effects.splice(_loc2_,1);
            }
            _loc2_--;
         }
         effectTimer -= param1;
         if(effectTimer <= 0 && effects.length < maxEffectCount)
         {
            _loc4_ = createEffect();
            addEffect(_loc4_);
            effectTimer = nextEffectTime;
         }
      }
   }
}


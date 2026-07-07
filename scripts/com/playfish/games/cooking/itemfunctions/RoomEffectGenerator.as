package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.utils.*;
   import flash.utils.*;
   
   public class RoomEffectGenerator extends RoomItemFunction
   {
      
      private static const MAX_NO_BUBBLES_ON_SCREEN:int = 8;
      
      private var effectObjects:Array = new Array();
      
      private var maxEffectsOnScreen:int;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function RoomEffectGenerator(param1:RoomItem, param2:int)
      {
         super(param1);
         this.maxEffectsOnScreen = param2;
      }
      
      override public function destroy() : void
      {
         var _loc1_:EffectObject = null;
         for each(_loc1_ in effectObjects)
         {
            restaurant.room.removeObject(_loc1_);
            _loc1_.destroy();
         }
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc4_:EffectObject = null;
         super.tick(param1);
         var _loc2_:* = int(effectObjects.length - 1);
         while(_loc2_ >= 0)
         {
            _loc4_ = effectObjects[_loc2_];
            if(_loc4_.removed)
            {
               restaurant.room.removeObject(_loc4_);
               effectObjects.splice(_loc2_,1);
            }
            _loc2_--;
         }
         var _loc3_:int = maxEffectsOnScreen - effectObjects.length;
         if(_loc3_ > 0)
         {
            createObjects(_loc3_);
         }
      }
      
      private function createObjectsInArea(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:EffectObject = null;
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:int = param1;
         while(_loc8_ < param3)
         {
            _loc9_ = param2;
            while(_loc9_ < param4)
            {
               if(!hasMultiTileItemInTile(_loc8_,_loc9_))
               {
                  _loc6_.push(_loc8_);
                  _loc7_.push(_loc9_);
               }
               _loc9_++;
            }
            _loc8_++;
         }
         if(_loc6_.length > 0)
         {
            _loc8_ = 0;
            while(_loc8_ < param5)
            {
               _loc10_ = Engine.rnd(0,_loc6_.length);
               _loc11_ = int(_loc6_[_loc10_]);
               _loc12_ = int(_loc7_[_loc10_]);
               _loc13_ = createEffectObject(_loc11_,_loc12_);
               _loc13_.drawPriority = WorldRestaurant.getTileDrawPriority(_loc11_,_loc12_);
               restaurant.room.addObject(_loc13_);
               effectObjects.push(_loc13_);
               _loc8_++;
            }
         }
      }
      
      public function createEffectObject(param1:int, param2:int) : EffectObject
      {
         return null;
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         this.restaurant = param1;
         createObjects(maxEffectsOnScreen);
      }
      
      private function hasMultiTileItemInTile(param1:int, param2:int) : Boolean
      {
         var _loc4_:RoomItem = null;
         var _loc3_:Array = restaurant.itemMap[WorldRestaurant.getTileIndex(param1,param2)];
         if(_loc3_.length == 0)
         {
            return false;
         }
         _loc4_ = _loc3_[0];
         if(!_loc4_.subItems || !_loc4_.subItemAutoSplit)
         {
            return false;
         }
         return true;
      }
      
      private function createObjects(param1:int) : void
      {
         if(restaurant.isTileInOutsideArea(roomItem.tileX,roomItem.tileY))
         {
            createObjectsInArea(1,restaurant.numTilesY,restaurant.numOutsideTilesX,restaurant.numTilesY + restaurant.numOutsideTilesY,param1);
         }
         else
         {
            createObjectsInArea(1,1,restaurant.numTilesX,restaurant.numTilesY,param1);
         }
      }
   }
}


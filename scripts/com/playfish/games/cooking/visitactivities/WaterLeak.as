package com.playfish.games.cooking.visitactivities
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.utils.*;
   
   public class WaterLeak extends VisitActivity
   {
      
      public static const MAX_WATER_LEAK_SPROUTS:int = 3;
      
      public static const MAX_WATER_LEAK_TILES:int = 7;
      
      public var waterLeakPoints:Array = new Array();
      
      public function WaterLeak(param1:int)
      {
         super(param1);
      }
      
      override public function determineActivityItemLocations() : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:ActivityItem = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:ActivityItem = null;
         activityItem = new CompositeActivityItem(this);
         var _loc1_:CompositeActivityItem = activityItem as CompositeActivityItem;
         var _loc2_:RandomBasket = new RandomBasket();
         var _loc3_:int = 0;
         while(_loc3_ < restaurant.numTilesY)
         {
            _loc7_ = 0;
            while(_loc7_ < restaurant.numTilesX)
            {
               _loc8_ = WorldRestaurant.getTileIndex(_loc7_,_loc3_);
               if(restaurant.isWalkable(_loc7_,_loc3_) && !restaurant.wallMap[_loc8_])
               {
                  _loc2_.addItems(_loc8_);
               }
               _loc7_++;
            }
            _loc3_++;
         }
         if(_loc2_.length() < MAX_WATER_LEAK_SPROUTS)
         {
            Debug.out("Not enough room to place sprouts");
            return false;
         }
         var _loc4_:int = Math.min(MAX_WATER_LEAK_SPROUTS,_loc2_.length());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc9_ = int(_loc2_.getNextItem());
            tileX = WorldRestaurant.getTileXFromTileIndex(_loc9_);
            tileY = WorldRestaurant.getTileYFromTileIndex(_loc9_);
            _loc10_ = new ActivityItem(this,"WaterLeak",ActivityItem.BLOCKING);
            _loc10_.tileX = tileX;
            _loc10_.tileY = tileY;
            _loc1_.addItem(_loc10_);
            _loc3_++;
         }
         var _loc5_:Number = Math.min(_loc2_.length(),MAX_WATER_LEAK_TILES);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc11_ = int(_loc2_.getNextItem());
            _loc12_ = WorldRestaurant.getTileXFromTileIndex(_loc11_);
            _loc13_ = WorldRestaurant.getTileYFromTileIndex(_loc11_);
            _loc14_ = new ActivityItem(this,"WaterleakTile",ActivityItem.NON_BLOCKING);
            _loc14_.tileX = _loc12_;
            _loc14_.tileY = _loc13_;
            _loc14_.setScreenPosition();
            _loc1_.addItem(_loc14_);
            _loc6_++;
         }
         return true;
      }
   }
}


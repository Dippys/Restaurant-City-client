package com.playfish.games.cooking.visitactivities
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.utils.*;
   
   public class Skunk extends VisitActivity
   {
      
      public static const MAX_SKUNKS:int = 4;
      
      public function Skunk(param1:int)
      {
         super(param1);
      }
      
      override public function determineActivityItemLocations() : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ActivityItem = null;
         activityItem = new CompositeActivityItem(this);
         var _loc1_:CompositeActivityItem = activityItem as CompositeActivityItem;
         var _loc2_:RandomBasket = new RandomBasket();
         var _loc3_:int = 0;
         while(_loc3_ < restaurant.numTilesY)
         {
            _loc5_ = 0;
            while(_loc5_ < restaurant.numTilesX)
            {
               _loc6_ = WorldRestaurant.getTileIndex(_loc5_,_loc3_);
               if(restaurant.isWalkable(_loc5_,_loc3_) && !restaurant.wallMap[_loc6_])
               {
                  _loc2_.addItems(_loc6_);
               }
               _loc5_++;
            }
            _loc3_++;
         }
         if(_loc2_.length() < MAX_SKUNKS)
         {
            Debug.out("Error: Not enough room to place all skunks.");
            return false;
         }
         var _loc4_:int = Math.min(MAX_SKUNKS,_loc2_.length());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = int(_loc2_.getNextItem());
            tileX = WorldRestaurant.getTileXFromTileIndex(_loc7_);
            tileY = WorldRestaurant.getTileYFromTileIndex(_loc7_);
            _loc8_ = new ActivityItem(this,"Skunk",ActivityItem.BLOCKING);
            _loc8_.tileX = tileX;
            _loc8_.tileY = tileY;
            if(Engine.rnd(0,2))
            {
               _loc8_.rotate();
            }
            _loc1_.addItem(_loc8_);
            _loc3_++;
         }
         return true;
      }
   }
}


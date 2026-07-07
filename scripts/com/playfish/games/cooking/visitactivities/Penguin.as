package com.playfish.games.cooking.visitactivities
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.WorldRestaurant;
   import com.playfish.games.cooking.utils.RandomBasket;
   
   public class Penguin extends VisitActivity
   {
      
      public static const MAX_PENGUINS:int = 5;
      
      public function Penguin(param1:int)
      {
         super(param1);
      }
      
      override public function determineActivityItemLocations() : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ActivityItem = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         activityItem = new CompositeActivityItem(this);
         var _loc1_:CompositeActivityItem = activityItem as CompositeActivityItem;
         var _loc2_:RandomBasket = new RandomBasket();
         var _loc3_:int = 2;
         while(_loc3_ < restaurant.numTilesY)
         {
            _loc5_ = 2;
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
         if(_loc2_.length() < MAX_PENGUINS)
         {
            Debug.out("Error: Not enough space for penguins!");
            return false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < MAX_PENGUINS)
         {
            _loc7_ = new ActivityItem(this,"Pengu",ActivityItem.ACTOR);
            _loc8_ = int(_loc2_.getNextItem());
            _loc9_ = WorldRestaurant.getTileXFromTileIndex(_loc8_);
            _loc10_ = WorldRestaurant.getTileYFromTileIndex(_loc8_);
            _loc7_.tileX = _loc9_;
            _loc7_.tileY = _loc10_;
            _loc1_.addItem(_loc7_);
            _loc4_++;
         }
         return true;
      }
   }
}


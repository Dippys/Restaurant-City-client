package com.playfish.games.cooking.visitactivities
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.utils.*;
   
   public class Bear extends VisitActivity
   {
      
      private static const BEAR_TILE_X:int = 3;
      
      private static const BEAR_TILE_Y:int = 2;
      
      private static const MAX_BEAR_ORIENTATIONS:int = 2;
      
      private var bearRoomItem:RoomItem;
      
      public var itemX:int;
      
      public var itemY:int;
      
      private var bearMap:Array = new Array();
      
      private var bearCount:ProtectedInt = new ProtectedInt();
      
      private var glowEffect:GlowEffect;
      
      public function Bear(param1:int)
      {
         super(param1);
      }
      
      override public function determineActivityItemLocations() : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc1_:RandomBasket = new RandomBasket();
         var _loc2_:int = 0;
         while(_loc2_ < restaurant.numTilesY)
         {
            _loc7_ = 0;
            while(_loc7_ < restaurant.numTilesX)
            {
               _loc8_ = WorldRestaurant.getTileIndex(_loc7_,_loc2_);
               if(restaurant.isWalkable(_loc7_,_loc2_) && !restaurant.wallMap[_loc8_])
               {
                  _loc1_.addItems(_loc8_);
               }
               _loc7_++;
            }
            _loc2_++;
         }
         if(_loc1_.length() < BEAR_TILE_X * BEAR_TILE_Y)
         {
            Debug.out("Error: Not enough space to place bear");
            return false;
         }
         var _loc3_:Array = new Array();
         var _loc4_:int = BEAR_TILE_X;
         var _loc5_:int = BEAR_TILE_Y;
         var _loc6_:int = 0;
         while(_loc6_ < MAX_BEAR_ORIENTATIONS)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc1_.length())
            {
               _loc10_ = int(_loc1_.getItemAt(_loc9_));
               _loc11_ = WorldRestaurant.getTileXFromTileIndex(_loc10_);
               _loc12_ = WorldRestaurant.getTileYFromTileIndex(_loc10_);
               if(hasSpace(_loc11_,_loc12_,_loc1_,_loc4_,_loc5_))
               {
                  _loc3_.push(_loc10_);
               }
               _loc9_++;
            }
            if(_loc3_.length > 0)
            {
               break;
            }
            _loc4_ = BEAR_TILE_Y;
            _loc5_ = BEAR_TILE_X;
            _loc6_++;
         }
         if(_loc3_.length > 0)
         {
            _loc13_ = int(_loc3_[Engine.rnd(0,_loc3_.length)]);
            _loc14_ = WorldRestaurant.getTileXFromTileIndex(_loc13_);
            _loc15_ = WorldRestaurant.getTileYFromTileIndex(_loc13_);
            activityItem = new ActivityItem(this,"VisitBear",ActivityItem.BLOCKING,true);
            activityItem.tileX = _loc14_;
            activityItem.tileY = _loc15_;
            activityItem.setBigItemTilesDelta(1,1);
            if(_loc6_)
            {
               activityItem.rotate();
            }
            return true;
         }
         Debug.out("Error: No possible location to place bear");
         return false;
      }
      
      private function hasSpace(param1:int, param2:int, param3:RandomBasket, param4:int, param5:int) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc9_:int = 0;
         while(_loc9_ < param4)
         {
            _loc10_ = 0;
            while(_loc10_ < param5)
            {
               _loc6_ = param1 + _loc9_;
               _loc7_ = param2 + _loc10_;
               _loc8_ = WorldRestaurant.getTileIndex(_loc6_,_loc7_);
               if(!param3.contains(_loc8_))
               {
                  return false;
               }
               _loc10_++;
            }
            _loc9_++;
         }
         return true;
      }
   }
}


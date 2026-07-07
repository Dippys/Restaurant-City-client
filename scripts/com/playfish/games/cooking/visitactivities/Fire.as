package com.playfish.games.cooking.visitactivities
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.utils.*;
   
   public class Fire extends VisitActivity
   {
      
      private static const FIRE_TILE_X:int = 2;
      
      private static const FIRE_TILE_Y:int = 2;
      
      private static const MAX_FIRES:int = 3;
      
      private var fireRoomItem:RoomItem;
      
      public var itemX:int;
      
      private var fireMap:Array;
      
      public var itemY:int;
      
      private var fireCount:ProtectedInt = new ProtectedInt();
      
      private var glowEffect:GlowEffect;
      
      public function Fire(param1:int)
      {
         super(param1);
      }
      
      override public function determineActivityItemLocations() : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:RandomBasket = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:ActivityItem = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Boolean = false;
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
               if(!fireMap[_loc6_] && restaurant.isWalkable(_loc5_,_loc3_) && !restaurant.wallMap[_loc6_] && restaurant.getItemAtTile(_loc5_,_loc3_) == null)
               {
                  _loc2_.addItems(_loc6_);
               }
               _loc5_++;
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < MAX_FIRES)
         {
            Debug.out("tileBasket.length()=" + _loc2_.length());
            _loc7_ = new RandomBasket();
            if(_loc2_.length() >= MAX_FIRES * FIRE_TILE_X * FIRE_TILE_Y)
            {
               _loc12_ = 0;
               while(_loc12_ < _loc2_.length())
               {
                  _loc13_ = int(_loc2_.getItemAt(_loc12_));
                  _loc14_ = WorldRestaurant.getTileXFromTileIndex(_loc13_);
                  _loc15_ = WorldRestaurant.getTileYFromTileIndex(_loc13_);
                  _loc16_ = hasSpace(_loc14_,_loc15_,_loc2_);
                  if(_loc16_)
                  {
                     _loc7_.addItems(_loc13_);
                  }
                  _loc12_++;
               }
            }
            if(_loc7_.length() < 1)
            {
               Debug.out("Error: Not enough room to place all the fires");
               return false;
            }
            _loc8_ = _loc7_.getNextItem() as int;
            _loc9_ = WorldRestaurant.getTileXFromTileIndex(_loc8_);
            _loc10_ = WorldRestaurant.getTileYFromTileIndex(_loc8_);
            _loc11_ = new ActivityItem(this,"VisitFire",ActivityItem.BLOCKING,true);
            _loc11_.setTightBounds(true);
            _loc11_.tileX = _loc9_;
            _loc11_.tileY = _loc10_;
            removeAssociatedFireTiles(_loc9_,_loc10_,_loc2_);
            _loc11_.setBigItemTilesDelta(0,0);
            _loc1_.addItem(_loc11_);
            _loc4_++;
         }
         return true;
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         super.init(param1);
         fireMap = new Array();
      }
      
      public function removeAssociatedFireTiles(param1:int, param2:int, param3:RandomBasket) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            _loc8_ = 0;
            while(_loc8_ < 2)
            {
               _loc4_ = param1 + _loc7_;
               _loc5_ = param2 + _loc8_;
               _loc6_ = WorldRestaurant.getTileIndex(_loc4_,_loc5_);
               param3.removeItems(_loc6_);
               _loc8_++;
            }
            _loc7_++;
         }
      }
      
      private function hasSpace(param1:int, param2:int, param3:RandomBasket) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            _loc8_ = 0;
            while(_loc8_ < 2)
            {
               _loc4_ = param1 + _loc7_;
               _loc5_ = param2 + _loc8_;
               if(_loc4_ >= restaurant.numTilesX || _loc5_ >= restaurant.numTilesY)
               {
                  return false;
               }
               _loc6_ = WorldRestaurant.getTileIndex(_loc4_,_loc5_);
               if(!param3.contains(_loc6_))
               {
                  return false;
               }
               _loc8_++;
            }
            _loc7_++;
         }
         return true;
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
      }
   }
}


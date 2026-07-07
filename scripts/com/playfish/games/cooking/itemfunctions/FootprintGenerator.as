package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.actors.Customer;
   
   public class FootprintGenerator extends RoomItemFunction
   {
      
      private var footprintTimer:int;
      
      private var footprintName:String;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function FootprintGenerator(param1:RoomItem, param2:String)
      {
         super(param1);
         this.footprintName = param2;
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         this.restaurant = param1;
         this.footprintTimer = Engine.rnd(0,500);
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Customer = null;
         var _loc5_:int = 0;
         var _loc6_:GameObject = null;
         footprintTimer -= param1;
         if(footprintTimer <= 0)
         {
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < restaurant.customers.length)
            {
               _loc4_ = restaurant.customers[_loc3_];
               if((_loc4_.speedX != 0 || _loc4_.speedY != 0) && _loc4_.tileX > 0 && _loc4_.tileY > 0 && _loc4_.effectTimer <= 0)
               {
                  if(restaurant.isTileInOutsideArea(roomItem.tileX,roomItem.tileY) == restaurant.isTileInOutsideArea(_loc4_.tileX,_loc4_.tileY))
                  {
                     _loc2_.push(_loc4_);
                  }
               }
               _loc3_++;
            }
            if(_loc2_.length > 0)
            {
               _loc5_ = Engine.rnd(0,_loc2_.length);
               _loc4_ = _loc2_[_loc5_];
               _loc6_ = new GameObject(footprintName);
               _loc6_.x = _loc4_.x;
               _loc6_.y = _loc4_.y;
               _loc6_.drawPriority = WorldRestaurant.getTileDrawPriority(_loc4_.tileX,_loc4_.tileY);
               _loc6_.numLoops = 1;
               _loc6_.removeWhenComplete = true;
               restaurant.room.addObject(_loc6_);
               _loc4_.effectTimer = 1000;
            }
            footprintTimer += 500;
         }
      }
      
      override public function destroy() : void
      {
      }
   }
}


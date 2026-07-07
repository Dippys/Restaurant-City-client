package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.WorldRestaurant;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   
   public class FoodkingActor extends RestaurantActor
   {
      
      public static const STATE_PICNIC:int = 0;
      
      public static const STATE_WALK:int = 1;
      
      public static const RESOURCE_NAMES:Array = ["GregPicnic","Greg"];
      
      public static const START_POSITIONS:Array = [[[5,-12],[14,-9],[16,-3]],[[-1,-20]]];
      
      public static const END_POSITIONS:Array = [[[5,-12],[14,-9],[16,-3]],[[-1,25]]];
      
      private var state:int;
      
      public function FoodkingActor(param1:WorldRestaurantPlay, param2:int)
      {
         this.state = param2;
         var _loc3_:String = RESOURCE_NAMES[param2];
         super(_loc3_,param1);
         var _loc4_:Array = START_POSITIONS[param2];
         var _loc5_:Array = _loc4_[Engine.rnd(0,_loc4_.length)];
         var _loc6_:int = int(_loc5_[0]);
         var _loc7_:int = int(_loc5_[1]);
         var _loc8_:Array = END_POSITIONS[param2];
         var _loc9_:Array = _loc8_[Engine.rnd(0,_loc8_.length)];
         var _loc10_:int = int(_loc9_[0]);
         var _loc11_:int = int(_loc9_[1]);
         setTilePosition(_loc6_,_loc7_);
         moveSpeedX = 0.02;
         moveSpeedY = 0.01;
         if(param2 != STATE_PICNIC)
         {
            moveTo(WorldRestaurant.getScreenX(_loc10_,_loc11_),WorldRestaurant.getScreenY(_loc10_,_loc11_));
         }
         buttonMode = true;
      }
      
      public static function numberOfStates() : int
      {
         return RESOURCE_NAMES.length;
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
         if(state == STATE_WALK)
         {
            if(speedX == 0 && speedY == 0)
            {
               restaurant.room.removeObject(this);
            }
         }
      }
   }
}


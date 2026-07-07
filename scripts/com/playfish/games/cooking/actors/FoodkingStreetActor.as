package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.BaseObject;
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.StreetBuilding;
   import com.playfish.games.cooking.WorldStreet;
   
   public class FoodkingStreetActor extends BaseObject
   {
      
      private var street:WorldStreet;
      
      private var movieClipName:String = "GregFrontStreet";
      
      public function FoodkingStreetActor(param1:WorldStreet)
      {
         super(movieClipName);
         this.street = param1;
         this.drawPriority = 1000;
         var _loc2_:Array = param1.getBuildings();
         var _loc3_:StreetBuilding = _loc2_[Engine.rnd(0,_loc2_.length)];
         if(!_loc3_)
         {
            return;
         }
         scaleX = 0.25;
         scaleY = 0.25;
         buttonMode = true;
         x = _loc3_.x + Engine.rnd(-200,200);
         y = _loc3_.y + 50;
      }
      
      override public function tick(param1:uint) : void
      {
         if(x < -parent.x - 2 * GameWorld.CANVAS_WIDTH || x >= -parent.x + 2 * GameWorld.CANVAS_WIDTH)
         {
            if(Engine.rnd(0,2))
            {
               this.x = -street.getBuildingLayer().x - Engine.rnd(GameWorld.CANVAS_WIDTH / 2,2 * GameWorld.CANVAS_WIDTH);
            }
            else
            {
               this.x = -street.getBuildingLayer().x + Engine.rnd(GameWorld.CANVAS_WIDTH / 2,2 * GameWorld.CANVAS_WIDTH);
            }
         }
      }
   }
}


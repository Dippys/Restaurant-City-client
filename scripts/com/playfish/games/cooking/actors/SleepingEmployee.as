package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   
   public class SleepingEmployee extends EmployeeActor
   {
      
      private static const ANIMATION_USED:Array = [Avatar3D.ANIMATION_DEAD];
      
      private static const BED_OFFSET_Y:int = -20;
      
      private var bed:RoomItem;
      
      private var bedOverlay:MovieClip;
      
      public function SleepingEmployee(param1:GameUserEmployee, param2:RoomItem, param3:WorldRestaurantPlay)
      {
         this.bed = param2;
         var _loc4_:Number = WorldRestaurant.getScreenX(param2.numTilesX - 1,param2.numTilesY - 1) / 2;
         var _loc5_:Number = WorldRestaurant.getScreenY(param2.numTilesX - 1,param2.numTilesY - 1) / 2 + BED_OFFSET_Y;
         var _loc6_:Number = param2.x + _loc4_;
         var _loc7_:Number = param2.y + _loc5_;
         super(_loc6_,_loc7_,param1,param3,ANIMATION_USED);
         badge.y = 0;
         bedOverlay = Engine.getMovieClip(param2.itemConfig.className + "Overlay");
         if(bedOverlay != null)
         {
            bedOverlay.x -= _loc4_;
            bedOverlay.y -= _loc5_;
            bedOverlay.gotoAndStop(param2.getRotationCount() + 1);
            addChild(bedOverlay);
         }
         setDirection(WorldRestaurant.getActorDirectionFromItemRotation(param2.getRotationCount()));
         setAnimation(Avatar3D.ANIMATION_DEAD);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(bedOverlay)
         {
            removeChild(bedOverlay);
         }
         bed = null;
      }
      
      override public function setPosition(param1:Number, param2:Number) : void
      {
         var _loc4_:int = 0;
         x = param1;
         y = param2;
         tileX = WorldRestaurant.getTileIndexX(x,y);
         tileY = WorldRestaurant.getTileIndexY(x,y);
         var _loc3_:int = bed.drawPriority;
         if(bed.subItems)
         {
            _loc4_ = 0;
            while(_loc4_ < bed.subItems.length)
            {
               if(bed.subItems[_loc4_].drawPriority > _loc3_)
               {
                  _loc3_ = int(bed.subItems[_loc4_].drawPriority);
               }
               _loc4_++;
            }
         }
         drawPriority = _loc3_;
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
      }
   }
}


package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.events.*;
   
   public class RestaurantActor extends BaseObject
   {
      
      protected static const RADIAN_TO_DEGREE:Number = 180 / Math.PI;
      
      protected static const PI_DIV_2:Number = Math.PI / 2;
      
      protected static const PI_DIV_4:Number = Math.PI / 4;
      
      protected static const PI_TIMES_2:Number = Math.PI * 2;
      
      protected static const DEFAULT_MOVE_SPEED_X:Number = 0.06;
      
      protected static const DEFAULT_MOVE_SPEED_Y:Number = 0.03;
      
      private var curPath:Array;
      
      public var moveSpeedX:Number = 0.06;
      
      public var moveSpeedY:Number = 0.03;
      
      public var tileX:int;
      
      public var tileY:int;
      
      public var speedX:Number = 0;
      
      public var speedY:Number = 0;
      
      protected var destX:Number = 0;
      
      protected var destY:Number = 0;
      
      public var restaurant:WorldRestaurant;
      
      public function RestaurantActor(param1:String, param2:WorldRestaurant)
      {
         super(param1);
         this.restaurant = param2;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         x = param1;
         y = param2;
         tileX = WorldRestaurant.getTileIndexX(x,y);
         tileY = WorldRestaurant.getTileIndexY(x,y);
         drawPriority = WorldRestaurant.getTileDrawPriority(tileX,tileY);
      }
      
      override public function destroy() : void
      {
      }
      
      public function reachedPathEnd() : Boolean
      {
         return (curPath == null || curPath.length == 0) && speedX == 0 && speedY == 0;
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function clearPath() : void
      {
         curPath.splice(0,curPath.length);
      }
      
      private function hasReached(param1:Number, param2:Number, param3:Number) : Boolean
      {
         if(param3 > 0)
         {
            if(param1 >= param2)
            {
               return true;
            }
         }
         else if(param3 < 0)
         {
            if(param1 <= param2)
            {
               return true;
            }
         }
         else if(param1 == param2)
         {
            return true;
         }
         return false;
      }
      
      override public function tick(param1:uint) : void
      {
         x += speedX * param1;
         y += speedY * param1;
         var _loc2_:Boolean = false;
         if(speedX != 0)
         {
            _loc2_ = true;
            if(hasReached(x,destX,speedX))
            {
               speedX = 0;
               x = destX;
            }
         }
         if(speedY != 0)
         {
            _loc2_ = true;
            if(hasReached(y,destY,speedY))
            {
               speedY = 0;
               y = destY;
            }
         }
         if(_loc2_)
         {
            setPosition(x,y);
         }
         if(curPath != null && curPath.length > 0)
         {
            if(speedX == 0 && speedY == 0)
            {
               popPath();
            }
         }
      }
      
      public function setMovePath(param1:Array) : void
      {
         this.curPath = param1;
         destX = x;
         destY = y;
         speedX = 0;
         speedY = 0;
         popPath();
      }
      
      public function popPath() : void
      {
         if(curPath.length > 0)
         {
            moveTo(WorldRestaurant.getScreenX(curPath[0][0],curPath[0][1]),WorldRestaurant.getScreenY(curPath[0][0],curPath[0][1]));
            curPath.splice(0,1);
         }
      }
      
      protected function getSign(param1:Number) : Number
      {
         if(param1 < 0)
         {
            return -1;
         }
         if(param1 > 0)
         {
            return 1;
         }
         return 0;
      }
      
      public function setTilePosition(param1:int, param2:int) : void
      {
         this.tileX = param1;
         this.tileY = param2;
         x = WorldRestaurant.getScreenX(param1,param2);
         y = WorldRestaurant.getScreenY(param1,param2);
         drawPriority = WorldRestaurant.getTileDrawPriority(param1,param2);
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         this.destX = param1;
         this.destY = param2;
         if(param1 > x)
         {
            speedX = moveSpeedX;
         }
         else if(param1 < x)
         {
            speedX = -moveSpeedX;
         }
         if(param2 > y)
         {
            speedY = moveSpeedY;
         }
         else if(param2 < y)
         {
            speedY = -moveSpeedY;
         }
      }
   }
}


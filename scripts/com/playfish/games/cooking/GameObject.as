package com.playfish.games.cooking
{
   import flash.display.Sprite;
   
   public dynamic class GameObject extends AnimatedObject
   {
      
      public static const TWEEN_NONE:int = 0;
      
      public static const TWEEN_MOTION_TIME:int = 1;
      
      public static const TWEEN_MOTION_SPEED:int = 2;
      
      public static const TWEEN_ALPHA:int = 3;
      
      public static const TWEEN_SHAPE:int = 4;
      
      public var tweenStartX:Number;
      
      public var tweenStartY:Number;
      
      public var tweenEaseDeccelX:Number;
      
      private var tweenTimer:int;
      
      public var tweenEaseDeccelY:Number;
      
      public var xOffset:Number = 0;
      
      public var tweenEaseMarkX:Number;
      
      public var angleSpeed:Number = 0;
      
      private var _zValue:Number = 0;
      
      public var removeWhenComplete:Boolean = false;
      
      public var debugLayer:Sprite;
      
      public var tweenType:uint;
      
      public var tweenDestX:Number;
      
      public var tweenDestY:Number;
      
      public var gravity:Number = 0;
      
      public var tweenDeccel:Boolean = false;
      
      private var tweenEaseTime:int;
      
      public var speedX:Number = 0;
      
      public var speedY:Number = 0;
      
      public var speedZ:Number = 0;
      
      public var friction:Number = 0;
      
      public var yOffset:Number = 0;
      
      public function GameObject(param1:String, param2:int = 0)
      {
         super(param1);
         this.drawPriority = param2;
      }
      
      public function tween(param1:Number, param2:Number, param3:uint, param4:Boolean) : void
      {
         speedX = (param1 - x) / param3;
         speedY = (param2 - y) / param3;
         tweenDestX = param1;
         tweenDestY = param2;
         tweenType = TWEEN_MOTION_TIME;
      }
      
      public function setSpeed(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = param2 * Math.PI / 180;
         speedX = param1 * Math.sin(_loc3_);
         speedY = -param1 * Math.cos(_loc3_);
      }
      
      public function paintDebug() : void
      {
         debugLayer.rotation = -rotation;
         debugLayer.graphics.clear();
         debugLayer.graphics.lineStyle(1,65280);
         debugLayer.graphics.moveTo(0,0);
         debugLayer.graphics.lineTo(speedX,speedY);
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.tick(param1);
         if(removeWhenComplete)
         {
            if(numLoops == 0)
            {
               BaseObject(parent).removeObject(this);
               return;
            }
         }
         x += speedX;
         y += speedY;
         zValue += speedZ;
         if(friction != 0 && (speedX != 0 || speedY != 0))
         {
            _loc2_ = Engine.getAngle(0,0,speedX,speedY);
            _loc3_ = speedX;
            _loc4_ = speedY;
            speedX -= friction * Math.cos(_loc2_);
            speedY += friction * Math.sin(_loc2_);
            if(_loc3_ < 0 && speedX > 0 || _loc3_ > 0 && speedX < 0)
            {
               speedX = 0;
            }
            if(_loc4_ < 0 && speedY > 0 || _loc4_ > 0 && speedY < 0)
            {
               speedY = 0;
            }
         }
         if(gravity != 0)
         {
            speedZ += gravity;
            if(zValue <= 0)
            {
               zValue = 0;
               speedZ = 0;
            }
         }
         if(debugLayer != null)
         {
            paintDebug();
         }
      }
      
      public function get zValue() : Number
      {
         return _zValue;
      }
      
      public function set zValue(param1:Number) : void
      {
         if(yOffset != 0)
         {
            y -= yOffset;
         }
         if(xOffset != 0)
         {
            x -= xOffset;
         }
         this._zValue = param1;
         if(param1 != 0)
         {
            yOffset = -param1 / 2;
            if(x > 0)
            {
               xOffset = param1 / 16;
            }
            else if(x < 0)
            {
               xOffset = -param1 / 16;
            }
            scaleX = 1 + param1 / 512;
            scaleY = 1 + param1 / 512;
         }
         else
         {
            xOffset = 0;
            yOffset = 0;
            scaleX = 1;
            scaleY = 1;
         }
         if(yOffset != 0)
         {
            y += yOffset;
         }
         if(xOffset != 0)
         {
            x += xOffset;
         }
      }
      
      public function tweenMotionSpeed(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = Engine.getAngle(x,y,param1,param2);
         speedX = param3 * Math.cos(_loc5_) / 1000;
         speedY = -param3 * Math.sin(_loc5_) / 1000;
         tweenStartX = x;
         tweenStartY = y;
         tweenDestX = param1;
         tweenDestY = param2;
         tweenEaseDeccelX = param4 * Math.cos(_loc5_) / 1000;
         tweenEaseDeccelY = -param4 * Math.sin(_loc5_) / 1000;
         var _loc6_:Number = Math.abs(speedX / tweenEaseDeccelX);
         var _loc7_:Number = Math.abs(speedX) * _loc6_ - 0.5 * Math.abs(tweenEaseDeccelX) * _loc6_ * _loc6_;
         if(param4 != 0)
         {
            tweenDeccel = true;
         }
         tweenEaseMarkX = _loc7_;
         tweenType = TWEEN_MOTION_SPEED;
      }
      
      public function isFlipped() : Boolean
      {
         return transform.matrix.a == -1;
      }
   }
}


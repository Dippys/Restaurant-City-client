package com.playfish.games.cooking
{
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class CachedAvatar3D extends Sprite
   {
      
      private var timeMillisToNextFrame:int;
      
      private var animatedSpeedScale:Number = 1;
      
      private var animationFrameIndex:int;
      
      private var user:GameUser;
      
      private var animationFrameCount:int = 0;
      
      private var animationFrameDelay:int = 80;
      
      private var animationDirection:int;
      
      public var animationType:int;
      
      public function CachedAvatar3D(param1:GameUser, param2:Array)
      {
         var _loc3_:CacheUserAnimationQueueItem = null;
         super();
         this.user = param1;
         if(param1.requireLoadAnimation(param2))
         {
            _loc3_ = param1.loadAnimationFrames(param2);
         }
      }
      
      private function getFrameImageObject(param1:int, param2:int, param3:int) : Object
      {
         var _loc4_:Array = user.isoAnimationFrames;
         if(_loc4_ == null || _loc4_[param1] == null || _loc4_[param1][param2] == null || _loc4_[param1][param2][param3] == null)
         {
            _loc4_ = GameWorld.placeholderUser.isoAnimationFrames;
         }
         if(_loc4_ != null)
         {
            return _loc4_[param1][param2][param3];
         }
         return null;
      }
      
      public function tick(param1:uint) : void
      {
         var _loc2_:int = int(param1);
         if(animatedSpeedScale != 1)
         {
            _loc2_ *= animatedSpeedScale;
         }
         timeMillisToNextFrame -= _loc2_;
         var _loc3_:int = animationFrameIndex;
         while(timeMillisToNextFrame <= 0)
         {
            ++animationFrameIndex;
            if(animationFrameIndex >= animationFrameCount)
            {
               animationFrameIndex = 0;
            }
            timeMillisToNextFrame += animationFrameDelay;
         }
         setAnimationFrame(animationFrameIndex);
      }
      
      public function reset() : void
      {
         timeMillisToNextFrame = 0;
      }
      
      public function setAnimation(param1:int) : void
      {
         this.animationType = param1;
         setAnimationFrame(0);
         animationFrameCount = Avatar3D.getAnimationFrameCount(param1);
         animationFrameDelay = Avatar3D.getAnimationDelay(param1);
         timeMillisToNextFrame = animationFrameDelay;
      }
      
      public function setDirection(param1:int) : void
      {
         animationDirection = param1;
      }
      
      public function setAnimationFrame(param1:int) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Matrix = null;
         var _loc4_:Number = NaN;
         animationFrameIndex = param1;
         graphics.clear();
         if(animationDirection >= 5)
         {
            _loc2_ = getFrameImageObject(animationType,8 - animationDirection,animationFrameIndex);
         }
         else
         {
            _loc2_ = getFrameImageObject(animationType,animationDirection,animationFrameIndex);
         }
         if(_loc2_)
         {
            _loc3_ = new Matrix();
            if(animationDirection >= 5)
            {
               _loc3_.a = -1;
               _loc3_.tx = -_loc2_.x;
               _loc4_ = -(_loc2_.bitmapData.width + _loc2_.x);
            }
            else
            {
               _loc3_.tx = _loc2_.x;
               _loc4_ = Number(_loc2_.x);
            }
            _loc3_.ty = _loc2_.y + WorldRestaurant.tileHeight / 2;
            graphics.beginBitmapFill(_loc2_.bitmapData,_loc3_,false,true);
            graphics.drawRect(_loc4_,_loc3_.ty,_loc2_.bitmapData.width,_loc2_.bitmapData.height);
            graphics.endFill();
         }
      }
   }
}


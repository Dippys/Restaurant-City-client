package com.playfish.games.cooking
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class CachedAvatar3D extends Sprite
   {
      
      private var timeMillisToNextFrame:int;
      
      private var animatedSpeedScale:Number = 1;
      
      private var animationFrameIndex:int;
      
      private var user:GameUser;
      
      private var animationFrameCount:int = 0;
      
      private var animationFrameDelay:int = 80;
      
      private var animationDirection:int;
      
      private var frameBitmap:Bitmap;
      
      public var animationType:int;
      
      public function CachedAvatar3D(param1:GameUser, param2:Array)
      {
         var _loc3_:CacheUserAnimationQueueItem = null;
         super();
         this.user = param1;
         frameBitmap = new Bitmap();
         frameBitmap.smoothing = true;
         addChild(frameBitmap);
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
            frameBitmap.visible = true;
            frameBitmap.bitmapData = _loc2_.bitmapData;
            frameBitmap.smoothing = true;
            if(animationDirection >= 5)
            {
               frameBitmap.scaleX = -1;
               frameBitmap.x = -_loc2_.x;
            }
            else
            {
               frameBitmap.scaleX = 1;
               frameBitmap.x = _loc2_.x;
            }
            frameBitmap.y = _loc2_.y + WorldRestaurant.tileHeight / 2;
         }
         else
         {
            frameBitmap.visible = false;
            frameBitmap.bitmapData = null;
         }
      }
   }
}


package com.playfish.games.cooking
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class CacheAvatarPortraitQueueItem extends IsoCacherQueue
   {
      
      public var cachedShape:Sprite;
      
      public function CacheAvatarPortraitQueueItem(param1:GameUser)
      {
         super(param1);
         cachedShape = new Sprite();
         if(param1.avatarFrame)
         {
            param1.avatarFrame.bitmapData.dispose();
            param1.avatarFrame = null;
         }
         addToQueue(true);
      }
      
      override protected function start() : void
      {
         var _loc3_:Bitmap = null;
         super.start();
         var _loc1_:Avatar3D = new Avatar3D(GameWorld.baseModel);
         _loc1_.setAvatarItems(gameUser.getAvatarItemsAsEmployee(),gameUser.hairColour,gameUser.skinColour);
         _loc1_.cacheSingleFrame(Avatar3D.ANIMATION_IDLE);
         var _loc2_:Object = _loc1_.cachedFrameShape;
         _loc1_.destroy();
         _loc1_ = null;
         gameUser.avatarFrame = new Bitmap();
         gameUser.avatarFrame.bitmapData = _loc2_.bitmapData;
         gameUser.avatarFrame.x = _loc2_.x;
         gameUser.avatarFrame.y = _loc2_.y;
         gameUser.avatarFrame.smoothing = true;
         _loc3_ = new Bitmap();
         _loc3_.bitmapData = _loc2_.bitmapData;
         _loc3_.x = _loc2_.x;
         _loc3_.y = _loc2_.y;
         _loc3_.smoothing = true;
         cachedShape.addChild(_loc3_);
         destroy();
         startNextInQueue();
      }
   }
}


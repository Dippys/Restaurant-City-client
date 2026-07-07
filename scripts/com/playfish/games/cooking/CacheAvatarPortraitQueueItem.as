package com.playfish.games.cooking
{
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.geom.Matrix;
   
   public class CacheAvatarPortraitQueueItem extends IsoCacherQueue
   {
      
      public var cachedShape:Shape;
      
      public function CacheAvatarPortraitQueueItem(param1:GameUser)
      {
         super(param1);
         cachedShape = new Shape();
         if(param1.avatarFrame)
         {
            param1.avatarFrame.bitmapData.dispose();
            param1.avatarFrame = null;
         }
         addToQueue(true);
      }
      
      override protected function start() : void
      {
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
         cachedShape.graphics.beginBitmapFill(_loc2_.bitmapData,new Matrix(1,0,0,1,_loc2_.x,_loc2_.y),false,true);
         cachedShape.graphics.drawRect(_loc2_.x,_loc2_.y,_loc2_.bitmapData.width,_loc2_.bitmapData.height);
         cachedShape.graphics.endFill();
         destroy();
         startNextInQueue();
      }
   }
}


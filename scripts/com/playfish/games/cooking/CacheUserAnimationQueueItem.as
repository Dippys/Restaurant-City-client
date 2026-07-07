package com.playfish.games.cooking
{
   import flash.events.Event;
   
   public class CacheUserAnimationQueueItem extends IsoCacherQueue
   {
      
      private var animationTypesToCache:Array;
      
      private var avatar3d:Avatar3D;
      
      public function CacheUserAnimationQueueItem(param1:GameUser, param2:Array)
      {
         super(param1);
         animationTypesToCache = new Array(param2.length);
         var _loc3_:Number = 0;
         while(_loc3_ < param2.length)
         {
            animationTypesToCache[_loc3_] = param2[_loc3_];
            _loc3_++;
         }
         if(param1.requireLoadAnimation(animationTypesToCache))
         {
            if(param1.isoAnimationFrames != null)
            {
               _loc3_ = animationTypesToCache.length - 1;
               while(_loc3_ >= 0)
               {
                  if(!param1.requireLoadAnimationType(animationTypesToCache[_loc3_]))
                  {
                     animationTypesToCache.splice(_loc3_,1);
                  }
                  _loc3_--;
               }
            }
            if(animationTypesToCache.length > 0)
            {
               if(param1.userInfo)
               {
                  addToQueue(true);
               }
               else
               {
                  addToQueue(false);
               }
            }
         }
      }
      
      override protected function destroy() : void
      {
         Debug.out("destroy caching user");
         super.destroy();
         if(avatar3d)
         {
            avatar3d.removeEventListener("cache_complete",onCacheComplete);
            avatar3d.destroy();
            avatar3d = null;
         }
         animationTypesToCache = null;
      }
      
      override protected function start() : void
      {
         Debug.out("start caching user name=" + gameUser.firstName);
         super.start();
         avatar3d = new Avatar3D(GameWorld.baseModel,false);
         avatar3d.setAvatarItems(gameUser.getAvatarItemsAsEmployee(),gameUser.hairColour,gameUser.skinColour);
         avatar3d.addEventListener("cache_complete",onCacheComplete,false,0,true);
         avatar3d.cacheIsoAnimation(animationTypesToCache);
      }
      
      private function onCacheComplete(param1:Event) : void
      {
         var _loc2_:int = 0;
         Debug.out("onCacheComplete");
         if(gameUser.isoAnimationFrames == null)
         {
            gameUser.isoAnimationFrames = avatar3d.cachedIsoShapes;
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < avatar3d.cachedIsoShapes.length)
            {
               if(avatar3d.cachedIsoShapes[_loc2_])
               {
                  gameUser.freeCachedAnimationType(_loc2_);
                  gameUser.isoAnimationFrames[_loc2_] = avatar3d.cachedIsoShapes[_loc2_];
               }
               _loc2_++;
            }
         }
         dispatchEvent(param1);
         destroy();
         startNextInQueue();
      }
   }
}


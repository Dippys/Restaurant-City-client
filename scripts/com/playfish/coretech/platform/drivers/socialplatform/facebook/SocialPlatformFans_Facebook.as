package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.events.FacebookEvent;
   import com.playfish.coretech.engine.core.PFArray;
   import com.playfish.coretech.platform.marina.MarinaGames;
   import com.playfish.coretech.platform.socialplatform.FanPage;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFans;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFansSettings;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformModuleSettings;
   
   public class SocialPlatformFans_Facebook extends SocialPlatformFans
   {
      
      private var gameListIndex:uint;
      
      private var gameListCache:Array;
      
      public function SocialPlatformFans_Facebook(param1:SocialPlatformFansSettings)
      {
         super(param1);
      }
      
      public function onGetFanFriends(param1:FacebookEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Namespace = null;
         var _loc4_:XML = null;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:FanPage = null;
         if(SocialPlatform_Facebook.isValidEventSuccess(param1))
         {
            _loc2_ = MarinaGames.getGameFanPage(gameListCache[gameListIndex]);
            _loc3_ = SocialPlatform_Facebook.fb_namespace;
            _loc4_ = new XML(param1.data.rawResult);
            if(_loc4_ != null)
            {
               _loc5_ = new Array();
               for each(_loc6_ in _loc4_.._loc3_::uid)
               {
                  _loc5_.push(_loc6_.toString());
               }
               _loc7_ = getFanPage(_loc2_);
               _loc7_.addFans(_loc5_);
            }
         }
         ++gameListIndex;
         if(prepareGameFanSearch() == false)
         {
            available = true;
            platformBackRef.onPrepareComplete(PREPARATION_MASK,this);
         }
      }
      
      private function prepareGameFanSearch() : Boolean
      {
         if(gameListCache == null || gameListIndex >= gameListCache.length)
         {
            return false;
         }
         var _loc1_:String = SocialPlatform.current.user.getID();
         var _loc2_:String = MarinaGames.getGameFanPage(gameListCache[gameListIndex]);
         var _loc3_:String = "SELECT uid FROM page_fan WHERE page_id = " + _loc2_ + " AND (uid == " + _loc1_ + " OR (uid IN (SELECT uid2 FROM friend WHERE uid1 = " + _loc1_ + ") ) )";
         return SocialPlatform_Facebook.makeQuery(_loc3_,onGetFanFriends);
      }
      
      override public function prepare(param1:SocialPlatform, param2:SocialPlatformModuleSettings) : Boolean
      {
         super.prepare(param1,param2);
         if(platformBackRef.isPreparing(PREPARATION_MASK) || !param2.enable || isAvailable())
         {
            return true;
         }
         gameListIndex = 0;
         gameListCache = new Array();
         if(onlyLoadCurrentGameFans)
         {
            gameListCache.push(SocialPlatform.getGameID());
         }
         else
         {
            PFArray.addToArray(gameListCache,MarinaGames.getGameList());
         }
         if(prepareGameFanSearch())
         {
            platformBackRef.onPrepareBegin(PREPARATION_MASK);
         }
         return true;
      }
      
      override public function isSupported() : Boolean
      {
         return true;
      }
   }
}


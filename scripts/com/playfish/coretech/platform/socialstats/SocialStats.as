package com.playfish.coretech.platform.socialstats
{
   import com.playfish.coretech.engine.core.PFArray;
   import com.playfish.coretech.engine.core.PFLogic;
   import com.playfish.coretech.platform.socialplatform.FanPage;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformUser;
   
   public class SocialStats
   {
      
      public static const WHO_ARE_LOGGED_IN:int = 16;
      
      public static const WHO_ARE_NOT_LOGGED_IN:int = 17;
      
      public static const WHO_HAVE_APP_INSTALLED:int = 32;
      
      public static const WHO_HAVE_NOT_APP_INSTALLED:int = 33;
      
      public static const WHO_ARE_FANS_OF_APP:int = 48;
      
      public static const WHO_ARE_NOT_FANS_OF_APP:int = 49;
      
      private static var nullArray:Array = new Array();
      
      public function SocialStats()
      {
         super();
      }
      
      public static function randomFriend(param1:Array) : String
      {
         if(param1 == null || param1.length == 0)
         {
            return null;
         }
         return PFArray.getRandomEntry(param1).toString();
      }
      
      public static function getFriend(param1:Function, param2:Array = null, param3:Array = null) : String
      {
         var _loc4_:Array = null;
         if(param2 == null)
         {
            _loc4_ = SocialPlatform.current.friends.getFriendList();
         }
         else
         {
            _loc4_ = param2;
         }
         if(param3 != null)
         {
            _loc4_ = PFArray.remove(_loc4_,param3);
         }
         return param1(_loc4_) as String;
      }
      
      public static function bestFriend(param1:Array = null) : String
      {
         var _loc2_:Array = null;
         if(param1 == null)
         {
            _loc2_ = getBestFriendList();
            return _loc2_[0]["uid"];
         }
         return param1[0]["uid"];
      }
      
      public static function getFriendsWhoAreFansOf(param1:String = null) : Array
      {
         var _loc6_:String = null;
         var _loc2_:FanPage = SocialPlatform.current.fans.getFanPage(param1);
         if(_loc2_ == null)
         {
            return nullArray;
         }
         var _loc3_:Array = _loc2_.getFanList();
         var _loc4_:Array = SocialPlatform.current.friends.getFriendList();
         var _loc5_:Array = new Array();
         for each(_loc6_ in _loc3_)
         {
            if(_loc4_.indexOf(_loc6_) != -1)
            {
               _loc5_.push(_loc6_);
            }
         }
         return _loc5_;
      }
      
      public static function getUnenquiredFriendList() : Array
      {
         var _loc3_:String = null;
         var _loc1_:Array = SocialPlatform.current.friends.getFriendList();
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_)
         {
            if(SocialPlatform.current.user.getFriendScore(_loc3_) == 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function getFriendsWhoAreNotFansOf(param1:String = null) : Array
      {
         var _loc6_:String = null;
         var _loc2_:FanPage = SocialPlatform.current.fans.getFanPage(param1);
         if(_loc2_ == null)
         {
            return nullArray;
         }
         var _loc3_:Array = _loc2_.getFanList();
         var _loc4_:Array = SocialPlatform.current.friends.getFriendList();
         var _loc5_:Array = new Array();
         for each(_loc6_ in _loc4_)
         {
            if(_loc3_.indexOf(_loc6_) == -1)
            {
               _loc5_.push(_loc6_);
            }
         }
         return _loc5_;
      }
      
      public static function getBestFriendList() : Array
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc1_:Array = SocialPlatform.current.friends.getFriendList();
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = new Object();
            _loc4_["uid"] = _loc3_;
            _loc4_["score"] = SocialPlatform.current.user.getFriendScore(_loc3_);
            _loc2_.push(_loc4_);
         }
         return _loc2_.sortOn("score",Array.NUMERIC | Array.DESCENDING);
      }
      
      public static function getFriendsWho(param1:int) : Array
      {
         var _loc2_:String = null;
         var _loc5_:SocialPlatformUser = null;
         var _loc6_:String = null;
         switch(param1)
         {
            case WHO_ARE_FANS_OF_APP:
               return getFriendsWhoAreFansOf();
            case WHO_ARE_NOT_FANS_OF_APP:
               return getFriendsWhoAreNotFansOf();
            case WHO_ARE_LOGGED_IN:
            case WHO_ARE_NOT_LOGGED_IN:
               _loc2_ = SocialPlatformUser.PROFILE_LOGGED_IN;
               break;
            case WHO_HAVE_APP_INSTALLED:
            case WHO_HAVE_NOT_APP_INSTALLED:
               _loc2_ = SocialPlatformUser.PROFILE_APPLICATION_USER;
         }
         var _loc3_:Array = SocialPlatform.current.user.getFriendUserList();
         var _loc4_:Array = new Array();
         for each(_loc5_ in _loc3_)
         {
            _loc6_ = _loc5_.getProfileEntry(_loc2_);
            if(PFLogic.isFalse(_loc6_) && (param1 & 0x0F) == 1)
            {
               _loc4_.push(_loc5_);
            }
            else if(PFLogic.isTrue(_loc6_) && (param1 & 0x0F) == 0)
            {
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_;
      }
   }
}


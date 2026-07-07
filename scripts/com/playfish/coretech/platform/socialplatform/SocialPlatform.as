package com.playfish.coretech.platform.socialplatform
{
   import com.playfish.coretech.engine.PFEngine;
   import com.playfish.coretech.engine.core.PFDebug;
   import com.playfish.coretech.platform.drivers.socialplatform.facebook.*;
   import com.playfish.coretech.platform.drivers.socialplatform.offline.*;
   import com.playfish.coretech.platform.marina.MarinaGames;
   import com.playfish.coretech.platform.socialnetwork.SocialNetwork;
   import com.playfish.coretech.platform.socialstats.*;
   import com.playfish.rpc.share.NetworkUid;
   import flash.utils.*;
   
   public class SocialPlatform
   {
      
      public static var gameID:String;
      
      public static var current:SocialPlatform = null;
      
      public static const PREPARE_MASK_FEEDS:uint = 1;
      
      public static const PREPARE_MASK_FRIENDS:uint = 2;
      
      public static const PREPARE_MASK_FANS:uint = 4;
      
      public static const PREPARE_MASK_USER:uint = 8;
      
      public static const PREPARE_MASK_APPLICATION:uint = 16;
      
      public static const PREPARE_MASK_PHOTO_ALBUM:uint = 32;
      
      public static const PREPARE_MASK_EVENTS:uint = 64;
      
      public static const PREPARE_MASK_SOCIAL_PLATFORM:uint = 134217728;
      
      private static var nextFriendshipMetric:uint = FriendshipMetric.USER_DEFINED;
      
      public var photos:SocialPlatformPhotos;
      
      protected var pendingPreparationMask:uint;
      
      public var friends:SocialPlatformFriends;
      
      public var events:SocialPlatformEvents;
      
      public var feeds:SocialPlatformFeeds;
      
      protected var friendshipEvaluators:Array;
      
      protected var settings:SocialPlatformSettings;
      
      protected var prepareCompletionCallback:Function;
      
      public var retryTimeout:int;
      
      public var fans:SocialPlatformFans;
      
      public var livechat:SocialPlatformLiveChat;
      
      public var players:Array;
      
      public var user:SocialPlatformUser;
      
      public var application:SocialPlatformApp;
      
      public function SocialPlatform(param1:Function, param2:SocialPlatformSettings)
      {
         super();
         settings = param2;
         friendshipEvaluators = new Array();
         retryTimeout = 30;
         if(players == null)
         {
            players = new Array();
         }
         if(application == null)
         {
            application = new SocialPlatformApp(settings.application);
         }
         if(photos == null)
         {
            photos = new SocialPlatformPhotos(settings.photos);
         }
         if(feeds == null)
         {
            feeds = new SocialPlatformFeeds(settings.feeds);
         }
         if(friends == null)
         {
            friends = new SocialPlatformFriends(settings.friends);
         }
         if(fans == null)
         {
            fans = new SocialPlatformFans(settings.fans);
         }
         if(events == null)
         {
            events = new SocialPlatformEvents(settings.events);
         }
         if(livechat == null)
         {
            livechat = new SocialPlatformLiveChat(settings.livechat);
         }
         if(user == null)
         {
            user = createUser("0");
         }
         prepareCompletionCallback = param1;
      }
      
      public static function getInstance() : SocialPlatform
      {
         if(current == null)
         {
            PFDebug.warning("Attempting to getInstance on the \'SocialPlatform\' singleton without first creating it. Be warned that this object may have been created out of sequence");
            current = new SocialPlatform(null,new SocialPlatformSettings());
         }
         return current;
      }
      
      public static function initialize() : void
      {
         if(current == null)
         {
            current = new SocialPlatform(null,new SocialPlatformSettings());
         }
         else
         {
            PFDebug.error("Attempting to re-initialize the \'SocialPlatform\' singleton");
         }
      }
      
      public static function getGameID() : String
      {
         return gameID;
      }
      
      public static function getGameName() : String
      {
         return MarinaGames.getGameName(gameID);
      }
      
      public static function get instance() : SocialPlatform
      {
         return current;
      }
      
      public static function createSocialPlatform(param1:String, param2:Function, param3:Object, param4:SocialPlatformSettings = null) : SocialPlatform
      {
         var _loc5_:SocialPlatform = null;
         gameID = MarinaGames.getGameIDFromReference(param1);
         if(param4 == null)
         {
            param4 = new SocialPlatformSettings();
         }
         _loc5_ = SocialNetwork.current.createPlatform(param1,param2,param3,param4);
         _loc5_.prepare();
         return _loc5_;
      }
      
      public static function createOfflinePlatform(param1:String, param2:Function, param3:SocialPlatformSettings) : SocialPlatform_Offline
      {
         gameID = MarinaGames.getGameIDFromReference(param1);
         var _loc4_:SocialPlatform_Offline = new SocialPlatform_Offline(param2,param3);
         _loc4_.prepare();
         return _loc4_;
      }
      
      public static function toString() : String
      {
         var _loc1_:String = "";
         if(current == null)
         {
            return "No social platform exists. Please call SocialPlatform.initialize(); to initialize the NULL driver";
         }
         _loc1_ += "Network: " + SocialNetwork.current.getName();
         _loc1_ += "  Feeds : " + (current.feeds.isSupported() ? "Supported" : "Not supported") + "(" + (current.feeds.isAvailable() ? "Available" : "Not available") + ")";
         _loc1_ += "  Fans : " + (current.fans.isSupported() ? "Supported" : "Not supported") + "(" + (current.fans.isAvailable() ? "Available" : "Not available") + ")";
         _loc1_ += "  Friends : " + (current.friends.isSupported() ? "Supported" : "Not supported") + "(" + (current.friends.isAvailable() ? "Available" : "Not available") + ")";
         _loc1_ += "  User : " + (current.user.isSupported() ? "Supported" : "Not supported") + "(" + (current.user.isAvailable() ? "Available" : "Not available") + ")";
         _loc1_ += "Status: ";
         _loc1_ += current.feeds.toString();
         _loc1_ += current.friends.toString();
         _loc1_ += current.user.toString();
         _loc1_ += current.fans.toString();
         _loc1_ += current.application.toString();
         return _loc1_ + current.photos.toString();
      }
      
      public static function getGameURL() : String
      {
         return SocialNetwork.current.getAppURL(gameID);
      }
      
      public static function setCurrent(param1:SocialPlatform) : void
      {
         current = param1;
      }
      
      public function prepare() : void
      {
         onPrepareBegin(PREPARE_MASK_SOCIAL_PLATFORM);
         user.prepare(this,settings.user);
         application.prepare(this,settings.application);
         feeds.prepare(this,settings.feeds);
         friends.prepare(this,settings.friends);
         fans.prepare(this,settings.fans);
         photos.prepare(this,settings.photos);
         events.prepare(this,settings.events);
         onPrepareComplete(PREPARE_MASK_SOCIAL_PLATFORM,null);
      }
      
      public function isPrepared() : Boolean
      {
         return pendingPreparationMask == 0 ? true : false;
      }
      
      public function onPrepareComplete(param1:uint, param2:SocialPlatformModule) : void
      {
         pendingPreparationMask &= ~param1;
         switch(param1)
         {
            case PREPARE_MASK_FEEDS:
               current.feeds = param2 as SocialPlatformFeeds;
               break;
            case PREPARE_MASK_FRIENDS:
               current.friends = param2 as SocialPlatformFriends;
               break;
            case PREPARE_MASK_FANS:
               current.fans = param2 as SocialPlatformFans;
               break;
            case PREPARE_MASK_USER:
               current.user = param2 as SocialPlatformUser;
               break;
            case PREPARE_MASK_APPLICATION:
               current.application = param2 as SocialPlatformApp;
               break;
            case PREPARE_MASK_PHOTO_ALBUM:
               current.photos = param2 as SocialPlatformPhotos;
         }
         if(isPrepared())
         {
            if(prepareCompletionCallback != null)
            {
               if(prepareCompletionCallback())
               {
                  prepareCompletionCallback = null;
               }
               else
               {
                  prepare();
               }
            }
         }
      }
      
      public function getNetworkID(param1:String) : NetworkUid
      {
         var _loc2_:SocialPlatformUser = null;
         for each(_loc2_ in players)
         {
            if(_loc2_.getID() == param1)
            {
               return _loc2_.getNetworkID();
            }
         }
         return null;
      }
      
      public function setRetryTimeout(param1:int) : void
      {
         retryTimeout = param1;
      }
      
      protected function registerUser(param1:SocialPlatformUser) : SocialPlatformUser
      {
         var _loc2_:int = players.indexOf(param1);
         if(_loc2_ == -1)
         {
            players.push(param1);
            return param1;
         }
         return players[_loc2_];
      }
      
      public function disableRetryTimeout() : void
      {
         retryTimeout = -1;
      }
      
      public function getRetryURL() : String
      {
         return PFEngine.instance.getParameter("pf_retry_url") as String;
      }
      
      public function isSessionActive() : Boolean
      {
         return false;
      }
      
      public function preparePlayer(param1:String, param2:Function = null) : Boolean
      {
         var _loc3_:SocialPlatformUser = null;
         if(PFDebug.DEBUG)
         {
            for each(_loc3_ in players)
            {
               if(_loc3_.getID() == param1)
               {
                  PFDebug.warning("Do not prepare a player that has already been made available. getPlayer should sort out your needs");
                  if(param2 != null)
                  {
                     param2(param1);
                  }
                  return false;
               }
            }
         }
         return true;
      }
      
      public function getNativeSession() : Object
      {
         return null;
      }
      
      public function isStartupComplete(param1:uint = 4294967295) : Boolean
      {
         var _loc2_:Boolean = true;
         if((param1 & PREPARE_MASK_FEEDS) != 0)
         {
            _loc2_ &&= feeds.isStartupComplete();
         }
         if((param1 & PREPARE_MASK_FRIENDS) != 0)
         {
            _loc2_ &&= friends.isStartupComplete();
         }
         if((param1 & PREPARE_MASK_FANS) != 0)
         {
            _loc2_ &&= fans.isStartupComplete();
         }
         if((param1 & PREPARE_MASK_USER) != 0)
         {
            _loc2_ &&= user.isStartupComplete();
         }
         if((param1 & PREPARE_MASK_APPLICATION) != 0)
         {
            _loc2_ &&= application.isStartupComplete();
         }
         if((param1 & PREPARE_MASK_PHOTO_ALBUM) != 0)
         {
            _loc2_ &&= photos.isStartupComplete();
         }
         if((param1 & PREPARE_MASK_EVENTS) != 0)
         {
            _loc2_ &&= events.isStartupComplete();
         }
         return _loc2_;
      }
      
      protected function registerInternalFriendshipEvaluationFunction(param1:Array, param2:uint) : uint
      {
         friendshipEvaluators[param2] = param1;
         return param2;
      }
      
      public function getNetworkIDList(param1:Array) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_.push(getNetworkID(_loc3_));
         }
         return _loc2_;
      }
      
      public function evaluateFriendship(param1:String, param2:*, param3:Function = null) : Boolean
      {
         var _loc4_:Array = null;
         var _loc6_:SocialPlatformUser = null;
         var _loc7_:RequestProcessor = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:FriendshipEvaluator = null;
         var _loc11_:String = null;
         if(param2 is Array)
         {
            _loc4_ = param2;
         }
         else
         {
            if(param2 == null)
            {
               PFDebug.message("friend id is null, returning");
               return false;
            }
            _loc4_ = new Array();
            _loc4_[0] = param2;
         }
         var _loc5_:uint = SocialPlatform.current.application.getFriendshipMetric();
         if(friendshipEvaluators[_loc5_] == null)
         {
            _loc5_ = FriendshipMetric.DEFAULT;
         }
         if(friendshipEvaluators[_loc5_] == null)
         {
            PFDebug.error("There isn\'t even a default friendship metric.");
         }
         else
         {
            _loc6_ = SocialPlatform.current.getPlayer(param1);
            PFDebug.assert(_loc6_ != null,"Trying to find friends for an un-prepared player. How/why is this being done?");
            _loc7_ = RequestProcessor.begin(param3);
            _loc8_ = uint(friendshipEvaluators[_loc5_].length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc10_ = friendshipEvaluators[_loc5_][_loc9_];
               for each(_loc11_ in _loc4_)
               {
                  if(_loc6_.getFriendScore(_loc11_) == 0)
                  {
                     _loc7_.addRequest(_loc10_,param1,_loc11_,friendshipEvaluators[_loc5_][_loc9_ + 1]);
                  }
               }
               _loc9_ += 2;
            }
            _loc7_.end();
            _loc7_.process();
         }
         return true;
      }
      
      public function getRPCNetworkID() : uint
      {
         return NetworkUid.INTERNAL_USER;
      }
      
      public function getPlayer(param1:String, param2:Function = null) : SocialPlatformUser
      {
         var _loc3_:SocialPlatformUser = null;
         for each(_loc3_ in players)
         {
            if(_loc3_.getID() == param1)
            {
               return _loc3_;
            }
         }
         preparePlayer(param1,param2);
         return null;
      }
      
      public function getSession() : Object
      {
         return null;
      }
      
      public function onPrepareBegin(param1:uint) : void
      {
         pendingPreparationMask |= param1;
      }
      
      public function resetFriendshipMetricData() : void
      {
         var _loc1_:Array = null;
         for each(_loc1_ in friendshipEvaluators)
         {
            _loc1_[0].reset();
         }
      }
      
      public function createUser(param1:String) : SocialPlatformUser
      {
         return registerUser(new SocialPlatformUser(param1));
      }
      
      public function registerFriendshipEvaluationFunction(param1:Array) : uint
      {
         ++nextFriendshipMetric;
         return registerInternalFriendshipEvaluationFunction(param1,nextFriendshipMetric);
      }
      
      public function isPreparing(param1:uint) : Boolean
      {
         return (pendingPreparationMask & param1) != 0 ? true : false;
      }
   }
}


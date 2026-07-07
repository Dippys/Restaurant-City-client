package com.playfish.coretech.platform.socialplatform
{
   import com.playfish.coretech.engine.core.PFDebug;
   import com.playfish.coretech.engine.core.PFLogic;
   import com.playfish.coretech.platform.marina.MarinaGames;
   import com.playfish.coretech.platform.socialstats.*;
   import com.playfish.rpc.share.NetworkUid;
   
   public class SocialPlatformUser extends SocialPlatformModule
   {
      
      public static const PROFILE_BIRTHDAY:String = "birthday";
      
      public static const PROFILE_SMALL_PORTRAIT_URL:String = "portraitSmall";
      
      public static const PROFILE_LARGE_PORTRAIT_URL:String = "portraitLarge";
      
      public static const PROFILE_LOGGED_IN:String = "loggedin";
      
      public static const PROFILE_ONLINE:String = "loggedin";
      
      public static const PROFILE_APPLICATION_USER:String = "appUser";
      
      protected var fullName:String;
      
      protected var lastName:String;
      
      protected var networkUID:NetworkUid;
      
      public var friendUserList:Array;
      
      public var fanpageListAvailable:Boolean;
      
      protected var uid:String;
      
      protected var friendScoreList:Object;
      
      protected var firstName:String;
      
      protected var fanpageList:Array;
      
      protected var profileData:Array;
      
      public var friendIDList:Array;
      
      public function SocialPlatformUser(param1:String = "0")
      {
         super();
         this.uid = param1;
         networkUID = null;
         PREPARATION_MASK = SocialPlatform.PREPARE_MASK_USER;
         fanpageList = new Array();
         fanpageListAvailable = false;
         profileData = new Array();
         friendScoreList = new Object();
         friendUserList = new Array();
         friendIDList = new Array();
         firstName = "";
         fullName = "";
         lastName = "";
      }
      
      public function getFanPlayfishCount() : uint
      {
         var _loc1_:Array = getFanPlayfishList();
         return _loc1_.length;
      }
      
      public function getNetworkID() : NetworkUid
      {
         if(networkUID == null)
         {
            networkUID = NetworkUid.create(SocialPlatform.instance.getRPCNetworkID(),getID());
         }
         return networkUID;
      }
      
      public function updateFriendStats(param1:String, param2:int) : Boolean
      {
         if(friendScoreList[param1] == null)
         {
            if(friendIDList.indexOf(param1) == -1)
            {
               return false;
            }
            applyFriendStats(param1);
         }
         friendScoreList[param1]["utc"] = new Date();
         friendScoreList[param1]["score"] += param2;
         return true;
      }
      
      public function getFeatureCounter() : SocialPlatformFeatureCounter
      {
         return new SocialPlatformFeatureCounter(this);
      }
      
      public function isOnline() : Boolean
      {
         if(this == SocialPlatform.current.user)
         {
            return true;
         }
         return PFLogic.isTrue(getProfileEntry(PROFILE_LOGGED_IN));
      }
      
      public function addFriend(param1:SocialPlatformUser) : void
      {
         friendUserList.push(param1);
         friendIDList.push(param1.getID());
      }
      
      public function getFirstName() : String
      {
         return firstName;
      }
      
      public function getFanGameList() : Array
      {
         return fanpageList;
      }
      
      public function getFullName() : String
      {
         return fullName;
      }
      
      public function getLastName() : String
      {
         return lastName;
      }
      
      public function getFriendUserList() : Array
      {
         if(this == SocialPlatform.current.user)
         {
            return friendUserList;
         }
         PFDebug.warning("You can\'t query friends of friends.");
         return new Array();
      }
      
      public function getProfileEntry(param1:String) : String
      {
         var _loc2_:Object = null;
         for each(_loc2_ in profileData)
         {
            if(_loc2_[param1] != null)
            {
               return _loc2_[param1];
            }
         }
         return null;
      }
      
      public function isFanDataAvailable() : Boolean
      {
         return fanpageListAvailable;
      }
      
      public function setProfileEntry(param1:String, param2:String) : void
      {
         var _loc3_:Object = new Object();
         _loc3_[param1] = param2;
         profileData.push(_loc3_);
      }
      
      public function getFanPlayfishList() : Array
      {
         var _loc4_:String = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = MarinaGames.getGameList();
         var _loc3_:uint = 0;
         for each(_loc4_ in _loc2_)
         {
            if(isFanOfGame(_loc4_))
            {
               _loc1_.push(_loc4_);
            }
         }
         return _loc1_;
      }
      
      public function evaluateFriendship(param1:*, param2:Function = null) : Boolean
      {
         return SocialPlatform.current.evaluateFriendship(getID(),param1,param2);
      }
      
      public function isFanOfGame(param1:String) : Boolean
      {
         if(fanpageListAvailable)
         {
            if(fanpageList.indexOf(param1) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function applyFriendStats(param1:String) : Boolean
      {
         if(friendScoreList[param1] == null)
         {
            friendScoreList[param1] = new Object();
            friendScoreList[param1]["uid"] = param1;
            friendScoreList[param1]["utc"] = new Date();
            friendScoreList[param1]["score"] = 0;
            friendScoreList[param1]["metric"] = 0;
            return true;
         }
         return false;
      }
      
      public function getFriendScore(param1:String) : int
      {
         if(friendScoreList[param1] == null)
         {
            applyFriendStats(param1);
         }
         return friendScoreList[param1]["score"];
      }
      
      public function getFeatureStatus() : SocialPlatformFeatureStatus
      {
         return null;
      }
      
      public function resetFriendshipMetricData() : void
      {
         var _loc1_:Object = null;
         SocialPlatform.current.resetFriendshipMetricData();
         for each(_loc1_ in friendScoreList)
         {
            _loc1_["score"] = 0;
         }
      }
      
      public function getFanTotalCount() : uint
      {
         return getFanGameList().length;
      }
      
      override public function getFeatureHandler(param1:String) : SocialPlatformFeature
      {
         if(param1 == "dashboard" || param1 == "counter")
         {
            return getFeatureCounter();
         }
         if(param1 == "status")
         {
            return getFeatureStatus();
         }
         return null;
      }
      
      override public function toString() : String
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc1_:String = "I am ID " + getID() + ". FN=" + getFirstName() + " LN=" + getLastName() + "  FN=" + getFullName();
         if(fanpageListAvailable)
         {
            _loc1_ += "Fan list:" + fanpageList.toString();
         }
         else
         {
            _loc1_ += " (no fan data available)";
         }
         _loc1_ += "\n";
         _loc1_ += "[all:" + getFanPlayfishCount() + " in " + getFanTotalCount() + "] ";
         _loc1_ += "[PF:" + getFanPlayfishCount() + " of " + MarinaGames.getGameCount() + "] " + getFanPlayfishPercent() + "%";
         _loc1_ += "[PROPS::";
         for each(_loc2_ in profileData)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc1_ += "[" + _loc3_ + "]";
            }
         }
         return _loc1_ + "]\n";
      }
      
      public function getFriendIDList() : Array
      {
         if(this == SocialPlatform.current.user)
         {
            return friendIDList;
         }
         PFDebug.warning("You can\'t query friends of friends.");
         return new Array();
      }
      
      public function getID() : String
      {
         return uid;
      }
      
      public function getFanPlayfishPercent() : uint
      {
         return 100 * getFanPlayfishCount() / MarinaGames.getGameCount();
      }
      
      public function isFanOfUs() : Boolean
      {
         return isFanOfGame(SocialPlatform.gameID);
      }
      
      public function getFriendUser(param1:String) : SocialPlatformUser
      {
         var _loc2_:SocialPlatformUser = null;
         for each(_loc2_ in friendUserList)
         {
            if(_loc2_.getID() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}


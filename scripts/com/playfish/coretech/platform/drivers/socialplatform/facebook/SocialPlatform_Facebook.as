package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.Facebook;
   import com.facebook.events.FacebookEvent;
   import com.facebook.net.FacebookCall;
   import com.facebook.session.IFacebookSession;
   import com.facebook.utils.FacebookSessionUtil;
   import com.playfish.coretech.engine.core.*;
   import com.playfish.coretech.platform.drivers.socialstats.*;
   import com.playfish.coretech.platform.natural.facebook.*;
   import com.playfish.coretech.platform.socialplatform.*;
   import com.playfish.coretech.platform.socialstats.*;
   import com.playfish.rpc.share.NetworkUid;
   import flash.events.TimerEvent;
   import flash.utils.*;
   
   public class SocialPlatform_Facebook extends SocialPlatform
   {
      
      public static var facebook:Facebook;
      
      public static var runningQueue:Boolean;
      
      public static var queueQueryList:Array;
      
      public static var session:IFacebookSession;
      
      public static var fb_namespace:Namespace;
      
      public static const FQL_DEFAULT_PRIORITY:int = 16;
      
      public function SocialPlatform_Facebook(param1:String, param2:Function, param3:Object, param4:SocialPlatformSettings)
      {
         var _loc5_:FacebookSessionUtil = null;
         if(param3 is IFacebookSession)
         {
            session = param3 as IFacebookSession;
            facebook = new Facebook();
            facebook.startSession(session);
         }
         else if(param3 is FacebookSessionUtil)
         {
            _loc5_ = param3 as FacebookSessionUtil;
            session = _loc5_.activeSession;
            facebook = _loc5_.facebook;
         }
         runningQueue = false;
         queueQueryList = new Array();
         players = new Array();
         fb_namespace = new Namespace("http://api.facebook.com/1.0/");
         application = new SocialPlatformApp_Facebook(param4.application);
         user = createUser(facebook == null || facebook.uid == null ? "0" : facebook.uid);
         feeds = new SocialPlatformFeeds_Facebook(param4.feeds);
         fans = new SocialPlatformFans_Facebook(param4.fans);
         friends = new SocialPlatformFriends_Facebook(param4.friends);
         photos = new SocialPlatformPhotos_Facebook(param4.photos);
         events = new SocialPlatformEvents_Facebook(param4.events);
         livechat = new SocialPlatformLiveChat_Facebook(param4.livechat);
         super(param2,param4);
         registerInternalFriendshipEvaluationFunction([new FriendshipEvaluatorRandomize(),100],FriendshipMetric.DEFAULT);
         registerInternalFriendshipEvaluationFunction([new FriendshipEvaluatorPhotographicSubjects(),100],FriendshipMetric.PHOTOGRAPHIC_SUBJECT);
         registerInternalFriendshipEvaluationFunction([new FriendshipEvaluatorPhotographicCaptions(),100],FriendshipMetric.PHOTOGRAPHIC_CAPTION);
         registerInternalFriendshipEvaluationFunction([new FriendshipEvaluatorPhotographicSubjects(),30,new FriendshipEvaluatorRandomize(),60],FriendshipMetric.META_TEST_1);
      }
      
      private static function retryQueryTimeout(param1:TimerEvent) : void
      {
         var _loc2_:PFTimer = param1.target as PFTimer;
         var _loc3_:Object = _loc2_.objParam;
         var _loc4_:int = queueQueryList.indexOf(_loc3_);
         if(_loc4_ != -1)
         {
            _loc3_["active"] = false;
            PFDebug.warning("Re-sending query: " + _loc3_["fql"]);
            queueQuery(_loc3_["fql"],_loc3_["cbfn"],_loc3_["prm"],_loc3_["prm2"]);
         }
      }
      
      private static function onFQLQueueComplete(param1:FacebookEvent) : void
      {
         var _loc2_:FBFqlQuery = param1.target as FBFqlQuery;
         var _loc3_:Object = _loc2_.queuedObjectRef;
         PFArray.removeFromArray(queueQueryList,_loc3_);
         if(_loc3_["active"])
         {
            _loc3_["cbfn"](param1,_loc3_["prm"],_loc3_["prm2"]);
         }
         runningQueue = false;
         triggerQueuedQueryIfPossible();
      }
      
      public static function triggerQueuedQueryIfPossible() : Boolean
      {
         var _loc1_:PFTimer = null;
         if(runningQueue)
         {
            return false;
         }
         if(queueQueryList.length > 0)
         {
            if(makeQuery(queueQueryList[0]["fql"],onFQLQueueComplete,queueQueryList[0]))
            {
               if(current.retryTimeout != -1)
               {
                  _loc1_ = new PFTimer(current.retryTimeout * 1000,1,queueQueryList[0]);
                  _loc1_.addEventListener(TimerEvent.TIMER_COMPLETE,retryQueryTimeout);
                  _loc1_.start();
               }
               runningQueue = true;
               return true;
            }
         }
         return false;
      }
      
      public static function endQuery(param1:Function, param2:Object = null) : Boolean
      {
         return false;
      }
      
      public static function addQuery(param1:Function, param2:Object = null) : Boolean
      {
         return false;
      }
      
      public static function isValidEvent(param1:FacebookEvent) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.data == null)
         {
            return false;
         }
         return true;
      }
      
      public static function queueQuery(param1:String, param2:Function, param3:Object, param4:Object, param5:int = 16) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc6_:Object = new Object();
         _loc6_["fql"] = param1;
         _loc6_["prm"] = param3;
         _loc6_["prm2"] = param4;
         _loc6_["cbfn"] = param2;
         _loc6_["active"] = true;
         queueQueryList.push(_loc6_);
         triggerQueuedQueryIfPossible();
         return true;
      }
      
      public static function toString() : String
      {
         return getQueueString();
      }
      
      public static function makeQuery(param1:String, param2:Function, param3:Object = null) : Boolean
      {
         var _loc7_:FacebookEvent = null;
         var _loc4_:IFacebookSession = SocialPlatform_Facebook.session;
         if(_loc4_ == null || facebook == null)
         {
            _loc7_ = new FacebookEvent("null",false,false,false);
            param2(_loc7_);
            return false;
         }
         var _loc5_:FBFqlQuery = new FBFqlQuery(param1,param3);
         var _loc6_:FacebookCall = facebook.post(_loc5_);
         _loc6_.addEventListener(FacebookEvent.COMPLETE,param2);
         return true;
      }
      
      public static function getQueueString() : String
      {
         var _loc2_:Object = null;
         var _loc1_:String = "";
         _loc1_ += runningQueue ? "Queue is awaiting return\n" : "Nothing waiting";
         for each(_loc2_ in queueQueryList)
         {
            _loc1_ += "Q:" + _loc2_["fql"] + " prm:" + _loc2_["prm"] + " cbfn:" + _loc2_["cbfn"] + "\n";
         }
         return _loc1_;
      }
      
      public static function isValidEventSuccess(param1:FacebookEvent) : Boolean
      {
         if(!isValidEvent(param1))
         {
            return false;
         }
         return param1.success;
      }
      
      public static function beginQuery(param1:Function, param2:Object = null) : Boolean
      {
         return true;
      }
      
      override public function getSession() : Object
      {
         return session as Object;
      }
      
      override public function isSessionActive() : Boolean
      {
         return session != null && session.is_connected;
      }
      
      override public function createUser(param1:String) : SocialPlatformUser
      {
         return registerUser(new SocialPlatformUser_Facebook(param1));
      }
      
      override public function preparePlayer(param1:String, param2:Function = null) : Boolean
      {
         super.preparePlayer(param1,param2);
         var _loc3_:String = "SELECT  first_name, last_name , name,significant_other_id, family, birthday_date, pic_square, pic_big, online_presence, is_app_user FROM user WHERE uid = " + param1;
         return queueQuery(_loc3_,onGetUserData,param1,param2);
      }
      
      override public function getNativeSession() : Object
      {
         return facebook as Object;
      }
      
      override public function getRPCNetworkID() : uint
      {
         return NetworkUid.FACEBOOK;
      }
      
      public function onGetUserData(param1:FacebookEvent, param2:Object, param3:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:SocialPlatformUser_Facebook = null;
         var _loc6_:Function = null;
         if(isValidEventSuccess(param1))
         {
            _loc4_ = param2 as String;
            _loc5_ = SocialPlatform.current.getPlayer(_loc4_) as SocialPlatformUser_Facebook;
            if(_loc5_ == null)
            {
               _loc5_ = SocialPlatform.current.createUser(_loc4_) as SocialPlatformUser_Facebook;
            }
            _loc5_.setFromXML(new XML(param1.data.rawResult));
            _loc6_ = param3 as Function;
            if(_loc6_ != null)
            {
               _loc6_(param1,_loc4_);
            }
         }
      }
   }
}


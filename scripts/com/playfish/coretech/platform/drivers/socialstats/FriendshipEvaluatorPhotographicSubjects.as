package com.playfish.coretech.platform.drivers.socialstats
{
   import com.facebook.events.FacebookEvent;
   import com.playfish.coretech.platform.drivers.socialplatform.facebook.SocialPlatform_Facebook;
   import com.playfish.coretech.platform.socialplatform.*;
   import com.playfish.coretech.platform.socialstats.*;
   
   public class FriendshipEvaluatorPhotographicSubjects extends FriendshipEvaluator
   {
      
      protected var processed:Boolean;
      
      public function FriendshipEvaluatorPhotographicSubjects()
      {
         super();
         processed = false;
      }
      
      private function photoSubjectHandler(param1:FacebookEvent, param2:RequestProcessor, param3:Object) : void
      {
         var _loc4_:XML = null;
         var _loc5_:Namespace = null;
         var _loc6_:Object = null;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:* = undefined;
         var _loc13_:String = null;
         if(param1.success)
         {
            _loc4_ = new XML(param1.data.rawResult);
            _loc5_ = SocialPlatform_Facebook.fb_namespace;
            _loc6_ = param3["query"];
            _loc7_ = uint(param3["weight"]);
            _loc8_ = param3["query"]["user"];
            _loc9_ = param3["query"]["target"];
            _loc10_ = 10 * _loc7_ / 100;
            _loc11_ = "";
            for each(_loc12_ in _loc4_.._loc5_::subject)
            {
               SocialPlatform.current.user.updateFriendStats(_loc12_,_loc10_);
            }
            for each(_loc13_ in SocialPlatform.current.user.getFriendIDList())
            {
               SocialPlatform.current.user.updateFriendStats(_loc13_,1);
            }
            processed = true;
         }
         param2.onComplete();
      }
      
      override public function generateQuery(param1:Object, param2:Object) : Object
      {
         if(processed)
         {
            return null;
         }
         var _loc3_:String = param1.toString();
         var _loc4_:String = param2.toString();
         updateFriendStatsAll(_loc3_);
         var _loc5_:Object = new Object();
         _loc5_["fql"] = "SELECT pid, subject FROM photo_tag WHERE pid IN (SELECT pid FROM photo_tag WHERE subject=" + _loc3_ + ") AND subject!=\'\' AND subject!=" + _loc3_ + " ORDER BY pid";
         _loc5_["user"] = _loc3_;
         _loc5_["target"] = _loc4_;
         return _loc5_;
      }
      
      override public function processQuery(param1:RequestProcessor, param2:Object) : Boolean
      {
         var _loc3_:Object = param2["query"];
         SocialPlatform_Facebook.queueQuery(_loc3_["fql"].toString(),photoSubjectHandler,param1,param2);
         return true;
      }
      
      override public function reset() : void
      {
         processed = false;
      }
   }
}


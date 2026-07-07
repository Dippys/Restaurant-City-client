package com.playfish.coretech.platform.drivers.socialstats
{
   import com.facebook.events.FacebookEvent;
   import com.playfish.coretech.platform.drivers.socialplatform.facebook.SocialPlatform_Facebook;
   import com.playfish.coretech.platform.socialplatform.*;
   import com.playfish.coretech.platform.socialstats.*;
   
   public class FriendshipEvaluatorPhotographicCaptions extends FriendshipEvaluator
   {
      
      protected var processed:Boolean;
      
      public function FriendshipEvaluatorPhotographicCaptions()
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
            processed = true;
         }
         param2.onComplete();
      }
      
      override public function processQuery(param1:RequestProcessor, param2:Object) : Boolean
      {
         var _loc3_:Object = param2["query"];
         SocialPlatform_Facebook.queueQuery(_loc3_["fql"].toString(),photoSubjectHandler,param1,param2);
         return true;
      }
      
      override public function generateQuery(param1:Object, param2:Object) : Object
      {
         if(processed)
         {
            return null;
         }
         var _loc3_:Object = new Object();
         _loc3_["fql"] = "SELECT pid, subject FROM photo_tag WHERE pid IN (SELECT pid FROM photo_tag WHERE subject=" + param1 + ") AND subject!=\'\' AND subject!=" + param1 + " ORDER BY pid";
         _loc3_["user"] = param1;
         _loc3_["target"] = param2;
         return _loc3_;
      }
   }
}


package com.playfish.coretech.platform.drivers.socialstats
{
   import com.playfish.coretech.platform.socialplatform.*;
   import com.playfish.coretech.platform.socialstats.*;
   
   public class FriendshipEvaluatorRandomize extends FriendshipEvaluator
   {
      
      protected var processed:Boolean;
      
      public function FriendshipEvaluatorRandomize()
      {
         super();
         processed = false;
      }
      
      override public function processQuery(param1:RequestProcessor, param2:Object) : Boolean
      {
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc3_:Array = SocialPlatform.current.user.getFriendIDList();
         var _loc4_:uint = uint(param2["weight"]);
         for each(_loc5_ in _loc3_)
         {
            _loc6_ = uint(Math.random() * _loc3_.length);
            _loc6_ = _loc6_ * _loc4_ / 100;
            SocialPlatform.current.user.updateFriendStats(_loc5_,_loc6_);
         }
         param1.onComplete();
         processed = true;
         return true;
      }
      
      override public function generateQuery(param1:Object, param2:Object) : Object
      {
         updateFriendStatsAll(param1.toString());
         return "";
      }
   }
}


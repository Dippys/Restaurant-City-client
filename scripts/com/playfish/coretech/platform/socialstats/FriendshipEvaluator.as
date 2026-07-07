package com.playfish.coretech.platform.socialstats
{
   import com.playfish.coretech.engine.core.PFDebug;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformUser;
   
   public class FriendshipEvaluator
   {
      
      protected var weighting:int;
      
      public function FriendshipEvaluator(param1:uint = 100)
      {
         super();
         weighting = param1;
      }
      
      public function processQuery(param1:RequestProcessor, param2:Object) : Boolean
      {
         return false;
      }
      
      public function updateFriendStatsPaired(param1:String, param2:String, param3:Boolean = false) : void
      {
         var _loc5_:SocialPlatformUser = null;
         var _loc4_:SocialPlatformUser = SocialPlatform.current.getPlayer(param1);
         PFDebug.assert(_loc4_ != null,"Trying to find friends for an un-prepared player. How/why is this being done?");
         _loc4_.updateFriendStats(param2,1);
         if(param3)
         {
            _loc5_ = SocialPlatform.current.getPlayer(param2);
            PFDebug.assert(_loc5_ != null,"Trying to find friends for an un-prepared player. How/why is this being done?");
            _loc5_.updateFriendStats(param1,1);
         }
      }
      
      public function generateQuery(param1:Object, param2:Object) : Object
      {
         return null;
      }
      
      public function exportProfileData() : Object
      {
         return "";
      }
      
      public function updateFriendStatsAll(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc2_:SocialPlatformUser = SocialPlatform.current.getPlayer(param1);
         var _loc3_:Array = _loc2_.getFriendIDList();
         for each(_loc4_ in _loc3_)
         {
            _loc2_.updateFriendStats(_loc4_,1);
         }
      }
      
      public function importProfileData(param1:Object) : void
      {
      }
      
      public function reset() : void
      {
      }
   }
}


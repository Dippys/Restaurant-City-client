package com.playfish.coretech.platform.socialplatform
{
   public class SocialPlatformFans extends SocialPlatformModule
   {
      
      private static var nullArray:Array = new Array();
      
      protected var fanPages:Array;
      
      protected var onlyLoadCurrentGameFans:Boolean;
      
      public function SocialPlatformFans(param1:SocialPlatformFansSettings)
      {
         super();
         PREPARATION_MASK = SocialPlatform.PREPARE_MASK_FANS;
         fanPages = new Array();
         onlyLoadCurrentGameFans = param1.onlyLoadCurrentGameFans;
      }
      
      public function isFan(param1:String = null) : Boolean
      {
         return isPlayerFan(param1,SocialPlatform.current.user.getID());
      }
      
      public function isPlayerFan(param1:String, param2:String) : Boolean
      {
         var _loc3_:FanPage = getFanPage(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return _loc3_.isPlayerFan(param2);
      }
      
      override public function toString() : String
      {
         var _loc2_:FanPage = null;
         var _loc1_:String = "Fan pages:";
         for each(_loc2_ in fanPages)
         {
            _loc1_ += _loc2_.toString() + "\n";
         }
         return _loc1_;
      }
      
      public function getFanPage(param1:String = null) : FanPage
      {
         if(param1 == null)
         {
            param1 = SocialPlatform.gameID;
         }
         if(fanPages[param1] == null)
         {
            fanPages[param1] = new FanPage(param1);
         }
         return fanPages[param1];
      }
      
      public function getFanFriends(param1:String = null) : Array
      {
         var _loc2_:FanPage = getFanPage(param1);
         var _loc3_:Array = _loc2_.getFanList();
         var _loc4_:int = _loc3_.indexOf(SocialPlatform.current.user.getID());
         if(_loc4_ != -1)
         {
            _loc3_.splice(_loc4_,1);
         }
         return _loc3_;
      }
   }
}


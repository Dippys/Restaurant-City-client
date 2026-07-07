package com.playfish.coretech.platform.socialplatform
{
   public class SocialPlatformFriends extends SocialPlatformModule
   {
      
      public function SocialPlatformFriends(param1:SocialPlatformModuleSettings)
      {
         super();
         PREPARATION_MASK = SocialPlatform.PREPARE_MASK_FRIENDS;
      }
      
      public function getFriendList() : Array
      {
         return SocialPlatform.current.user.getFriendIDList();
      }
      
      override public function toString() : String
      {
         var _loc7_:String = null;
         var _loc8_:SocialPlatformUser = null;
         var _loc1_:String = "Friends : ";
         var _loc2_:int = 0;
         var _loc3_:Array = SocialPlatform.current.user.getFriendIDList();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         for each(_loc7_ in _loc3_)
         {
            _loc8_ = SocialPlatform.current.getPlayer(_loc7_);
            _loc1_ += _loc7_ + "(" + _loc8_.toString() + ")" + ",";
            if(++_loc2_ == 10)
            {
               _loc1_ += "\n";
               _loc2_ = 0;
            }
            _loc4_.push(_loc8_.getFirstName().length);
            _loc5_.push(_loc8_.getLastName().length);
            _loc6_.push(_loc8_.getFullName().length);
         }
         return _loc1_ + "END";
      }
   }
}


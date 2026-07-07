package com.playfish.coretech.platform.drivers.socialplatform.offline
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformSettings;
   
   public class SocialPlatform_Offline extends SocialPlatform
   {
      
      private var userID:uint;
      
      private var fanPageList:Array;
      
      private var friendList:Array;
      
      public function SocialPlatform_Offline(param1:Function, param2:SocialPlatformSettings)
      {
         super(param1,param2);
      }
      
      public function addFriendAsFanOf(param1:String, param2:String) : Boolean
      {
         return false;
      }
      
      public function addAsFanOf(param1:String) : Boolean
      {
         fanPageList.push(param1);
         return true;
      }
      
      public function setUserId(param1:uint) : Boolean
      {
         userID = param1;
         return true;
      }
   }
}


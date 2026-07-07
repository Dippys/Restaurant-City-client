package com.playfish.coretech.platform.socialnetwork
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformSettings;
   
   public class SocialNetworkOffline extends SocialNetwork
   {
      
      public function SocialNetworkOffline()
      {
         super();
      }
      
      override public function getID() : String
      {
         return "offline";
      }
      
      override public function getName() : String
      {
         return "Offline Driver";
      }
      
      override public function createPlatform(param1:String, param2:Function, param3:Object, param4:SocialPlatformSettings) : SocialPlatform
      {
         return new SocialPlatform(param2,param4);
      }
   }
}


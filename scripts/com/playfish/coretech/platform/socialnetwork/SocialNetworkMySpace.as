package com.playfish.coretech.platform.socialnetwork
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformSettings;
   
   public class SocialNetworkMySpace extends SocialNetwork
   {
      
      public function SocialNetworkMySpace()
      {
         super();
      }
      
      override public function getID() : String
      {
         return "myspace";
      }
      
      override public function getName() : String
      {
         return "MySpace";
      }
      
      override public function getURL() : String
      {
         return "myspace.com";
      }
      
      override public function createPlatform(param1:String, param2:Function, param3:Object, param4:SocialPlatformSettings) : SocialPlatform
      {
         return new SocialPlatform(param2,param4);
      }
   }
}


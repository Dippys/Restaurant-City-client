package com.playfish.coretech.platform.socialnetwork
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformSettings;
   
   public class SocialNetworkBebo extends SocialNetwork
   {
      
      public function SocialNetworkBebo()
      {
         super();
      }
      
      override public function getID() : String
      {
         return "bebo";
      }
      
      override public function getName() : String
      {
         return "Bebo";
      }
      
      override public function getURL() : String
      {
         return "bebo.com";
      }
      
      override public function createPlatform(param1:String, param2:Function, param3:Object, param4:SocialPlatformSettings) : SocialPlatform
      {
         return new SocialPlatform(param2,param4);
      }
   }
}


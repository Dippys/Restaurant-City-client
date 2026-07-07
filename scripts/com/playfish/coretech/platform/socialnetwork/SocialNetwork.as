package com.playfish.coretech.platform.socialnetwork
{
   import com.playfish.coretech.engine.PFEngine;
   import com.playfish.coretech.engine.core.PFDebug;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformSettings;
   
   public class SocialNetwork
   {
      
      public static var current:SocialNetwork;
      
      public function SocialNetwork()
      {
         super();
      }
      
      public static function initialize() : SocialNetwork
      {
         if(current != null)
         {
            PFDebug.error("Attempting to re-initialize the SocialNetwork.");
            return current;
         }
         if(isFacebook())
         {
            current = new SocialNetworkFacebook();
         }
         else if(isFacebookConnect())
         {
            current = new SocialNetworkFacebookConnect();
         }
         else if(isMyspace())
         {
            current = new SocialNetworkMySpace();
         }
         else if(isBebo())
         {
            current = new SocialNetworkBebo();
         }
         else
         {
            current = new SocialNetworkOffline();
         }
         return current;
      }
      
      public static function isBebo() : Boolean
      {
         return PFEngine.instance.getParameterString("pf_network") == "bebo";
      }
      
      public static function isFacebook() : Boolean
      {
         return PFEngine.instance.getParameterString("pf_network") == "facebook";
      }
      
      public static function isFacebookConnect() : Boolean
      {
         return isFacebook() && PFEngine.instance.getParameterString("pf_facebook_connect") == "1";
      }
      
      public static function toString() : String
      {
         if(current == null)
         {
            return "Uninitialized social network - please call SocialNetwork.initialize()";
         }
         return "Unknown social network.";
      }
      
      public static function isMyspace() : Boolean
      {
         return PFEngine.instance.getParameterString("pf_network") == "myspace";
      }
      
      public function getID() : String
      {
         return null;
      }
      
      public function getAppURL(param1:String, param2:String = "") : String
      {
         return getURL() + "/" + param1 + param2;
      }
      
      public function getName() : String
      {
         return null;
      }
      
      public function getURL() : String
      {
         return "localhost";
      }
      
      public function createPlatform(param1:String, param2:Function, param3:Object, param4:SocialPlatformSettings) : SocialPlatform
      {
         return null;
      }
   }
}


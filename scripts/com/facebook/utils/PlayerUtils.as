package com.facebook.utils
{
   import flash.system.Capabilities;
   
   public class PlayerUtils
   {
      
      protected static var versionObj:Object;
      
      public function PlayerUtils()
      {
         super();
      }
      
      public static function get internalBuildNumber() : Number
      {
         return parseVersionString().internalBuildNumber;
      }
      
      public static function get platform() : String
      {
         return parseVersionString().platform;
      }
      
      public static function get buildNumber() : Number
      {
         return parseVersionString().buildNumber;
      }
      
      public static function get minorVersion() : Number
      {
         return parseVersionString().minorVersion;
      }
      
      public static function parseVersionString() : Object
      {
         if(versionObj != null)
         {
            return versionObj;
         }
         var _loc1_:String = Capabilities.version;
         versionObj = {};
         var _loc2_:Array = _loc1_.split(" ");
         versionObj.platform = _loc2_[0];
         _loc2_.shift();
         _loc2_ = _loc2_[0].split(",");
         versionObj.majorVersion = Number(_loc2_[0]);
         versionObj.minorVersion = Number(_loc2_[1]);
         versionObj.buildNumber = Number(_loc2_[2]);
         versionObj.internalBuildNumber = Number(_loc2_[3]);
         return versionObj;
      }
      
      public static function get majorVersion() : Number
      {
         return parseVersionString().majorVersion;
      }
   }
}


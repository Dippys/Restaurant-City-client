package com.playfish.coretech.platform.socialplatform
{
   public class SocialPlatformFeeds extends SocialPlatformModule
   {
      
      public static const DEFAULT_TYPE:String = null;
      
      protected var validFeeds:Array;
      
      public function SocialPlatformFeeds(param1:SocialPlatformFeedsSettings)
      {
         super();
         PREPARATION_MASK = SocialPlatform.PREPARE_MASK_FEEDS;
         validFeeds = new Array();
      }
      
      public static function publishFeedBasic(param1:String, param2:String, param3:String, param4:String) : Boolean
      {
         var _loc5_:SocialFeed = SocialPlatform.current.feeds.createFeed(param1,false);
         _loc5_.addStreamData(_loc5_.createTitleText(param2));
         _loc5_.addStreamData(_loc5_.createLink(param3,param4));
         return _loc5_.publish();
      }
      
      public static function publishFeedNewsStory(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:* = null) : Boolean
      {
         var _loc8_:SocialFeed = SocialPlatform.current.feeds.createFeed(param1,false);
         _loc8_.setTargetUser(param7);
         _loc8_.addStreamData(_loc8_.createLink(param5,param6));
         _loc8_.addStreamData(_loc8_.createTitleText(param2));
         _loc8_.addStreamData(_loc8_.createDescriptionText(param3));
         _loc8_.addStreamData(_loc8_.createCaptionText(param4));
         return _loc8_.publish();
      }
      
      public static function publishFeedNotify(param1:String, param2:String, param3:String, param4:String, param5:String, param6:* = null) : Boolean
      {
         var _loc7_:SocialFeed = SocialPlatform.current.feeds.createFeed(param1,false);
         _loc7_.setTargetUser(param6);
         _loc7_.addStreamData(_loc7_.createLink(param4,param5));
         _loc7_.addStreamData(_loc7_.createTitleText(param2));
         _loc7_.addStreamData(_loc7_.createDescriptionText(param3));
         return _loc7_.publish();
      }
      
      public static function publishFeedMain(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:String, param10:String, param11:String, param12:String) : Boolean
      {
         var _loc13_:SocialFeed = SocialPlatform.current.feeds.createFeed(param1,false);
         _loc13_.addStreamData(_loc13_.createTitleText(param2));
         _loc13_.addStreamData(_loc13_.createLink(param10,param11));
         _loc13_.addStreamData(_loc13_.createInformationText(param3,param4));
         _loc13_.addStreamData(_loc13_.createDescriptionText(param5));
         _loc13_.addStreamData(_loc13_.createCaptionText(param6));
         _loc13_.addStreamData(_loc13_.createMediaImage(param7,param8,param9));
         _loc13_.addStreamData(_loc13_.createUserAcknowledge());
         _loc13_.addStreamData(_loc13_.createUserInput(param12));
         return _loc13_.publish();
      }
      
      protected function createFeedType(param1:String, param2:String, param3:Boolean) : SocialFeed
      {
         return new SocialFeed(param3);
      }
      
      public function createFeed(param1:String, param2:Boolean = true) : SocialFeed
      {
         var _loc3_:String = null;
         if(param1 != null)
         {
            _loc3_ = validFeeds[param1];
            if(_loc3_ == null)
            {
               return new SocialFeedNull(param2);
            }
         }
         return createFeedType(param1,_loc3_,param2);
      }
      
      public function registerFeedType(param1:String, param2:String = null) : Boolean
      {
         if(validFeeds[param1] == null)
         {
            validFeeds[param1] = param2 == null ? param1 : param2;
            return true;
         }
         return false;
      }
      
      override public function toString() : String
      {
         return "Valid feeds: " + validFeeds.toString();
      }
      
      public function isLegalFeed(param1:String) : Boolean
      {
         return validFeeds[param1] == null ? false : true;
      }
   }
}


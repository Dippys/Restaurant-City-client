package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.playfish.coretech.platform.socialplatform.SocialFeed;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFeeds;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFeedsSettings;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformModuleSettings;
   
   public class SocialPlatformFeeds_Facebook extends SocialPlatformFeeds
   {
      
      public function SocialPlatformFeeds_Facebook(param1:SocialPlatformFeedsSettings)
      {
         super(param1);
      }
      
      override public function isSupported() : Boolean
      {
         return true;
      }
      
      override protected function createFeedType(param1:String, param2:String, param3:Boolean) : SocialFeed
      {
         var _loc4_:String = null;
         var _loc5_:RegExp = null;
         var _loc6_:Array = null;
         if(param2 == null)
         {
            return new SocialFeed_Facebook(param2,param3);
         }
         if(param2.substr(0,8) == "fb::news" || param2.substr(0,4) == "news")
         {
            _loc4_ = param1;
            _loc5_ = /\[(.*)\]/;
            _loc6_ = param2.match(_loc5_);
            if(_loc6_ != null)
            {
               _loc4_ = _loc6_[1];
            }
            return new SocialNewsFeed_Facebook(param1,_loc4_,param3);
         }
         if(param2 == "fb::notify" || param2 == "notify")
         {
            return new SocialNotificationsFeed_Facebook(param1,param3);
         }
         return new SocialFeed_Facebook(param2,param3);
      }
      
      override public function prepare(param1:SocialPlatform, param2:SocialPlatformModuleSettings) : Boolean
      {
         super.prepare(param1,param2);
         platformBackRef.onPrepareBegin(PREPARATION_MASK);
         platformBackRef.onPrepareComplete(PREPARATION_MASK,this);
         available = true;
         return true;
      }
   }
}


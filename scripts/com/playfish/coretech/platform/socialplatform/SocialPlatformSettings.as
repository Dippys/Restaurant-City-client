package com.playfish.coretech.platform.socialplatform
{
   import com.playfish.coretech.engine.PFEngine;
   
   public class SocialPlatformSettings
   {
      
      public var fans:SocialPlatformFansSettings;
      
      public var photos:SocialPlatformPhotosSettings;
      
      public var livechat:SocialPlatformLiveChatSettings;
      
      public var user:SocialPlatformUserSettings;
      
      public var application:SocialPlatformAppSettings;
      
      public var friends:SocialPlatformFriendsSettings;
      
      public var events:SocialPlatformEventsSettings;
      
      public var feeds:SocialPlatformFeedsSettings;
      
      public function SocialPlatformSettings()
      {
         super();
         feeds = new SocialPlatformFeedsSettings();
         friends = new SocialPlatformFriendsSettings();
         fans = new SocialPlatformFansSettings();
         user = new SocialPlatformUserSettings();
         photos = new SocialPlatformPhotosSettings(PFEngine.instance.getParameterString("pf_photo_album_name"));
         application = new SocialPlatformAppSettings();
         events = new SocialPlatformEventsSettings();
         livechat = new SocialPlatformLiveChatSettings();
      }
   }
}


package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformApp;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFeatureBookmark;
   import com.playfish.external.ExternalPage;
   
   public class SocialPlatformFeatureBookmark_Facebook extends SocialPlatformFeatureBookmark
   {
      
      public function SocialPlatformFeatureBookmark_Facebook(param1:Object)
      {
         super(param1);
      }
      
      override public function removeBookmark() : Boolean
      {
         return false;
      }
      
      override public function isBookmarked() : Boolean
      {
         return SocialPlatform.instance.application.isPermissionGranted(SocialPlatformApp.PERMISSION_BOOKMARKED);
      }
      
      override public function addBookmark() : Boolean
      {
         var _loc1_:ExternalPage = new ExternalPage("popup:callBookmark");
         _loc1_.show();
         return true;
      }
   }
}


package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.playfish.coretech.platform.natural.facebook.FBFacebookCall;
   import flash.net.URLVariables;
   
   public class SocialNewsStory_Facebook extends FBFacebookCall
   {
      
      public function SocialNewsStory_Facebook(param1:URLVariables = null)
      {
         super("dashboard.setNews",param1);
      }
      
      public function resetCall(param1:String) : void
      {
         this.method = param1;
         this.args = new URLVariables();
      }
   }
}


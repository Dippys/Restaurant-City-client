package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.playfish.coretech.platform.natural.facebook.FBFacebookCall;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFeatureCounter;
   
   public class SocialPlatformFeatureCounter_Facebook extends SocialPlatformFeatureCounter
   {
      
      public function SocialPlatformFeatureCounter_Facebook(param1:Object)
      {
         super(param1);
      }
      
      override public function decCounter(param1:String = null) : Boolean
      {
         var _loc2_:FBFacebookCall = new FBFacebookCall("dashboard.decrementCount");
         _loc2_.setArg("uid",userBackptr.getID());
         SocialPlatform_Facebook.facebook.post(_loc2_);
         return true;
      }
      
      override public function setCounter(param1:int, param2:String = null) : Boolean
      {
         var _loc3_:FBFacebookCall = new FBFacebookCall("dashboard.setCount");
         _loc3_.setArg("uid",userBackptr.getID());
         _loc3_.setArg("count",param1);
         SocialPlatform_Facebook.facebook.post(_loc3_);
         return true;
      }
      
      override public function getCounter() : Boolean
      {
         var _loc1_:FBFacebookCall = new FBFacebookCall("dashboard.getCount");
         _loc1_.setArg("uid",userBackptr.getID());
         SocialPlatform_Facebook.facebook.post(_loc1_);
         return true;
      }
      
      override public function incCounter(param1:String = null) : Boolean
      {
         var _loc2_:FBFacebookCall = new FBFacebookCall("dashboard.incrementCount");
         _loc2_.setArg("uid",userBackptr.getID());
         SocialPlatform_Facebook.facebook.post(_loc2_);
         return true;
      }
   }
}


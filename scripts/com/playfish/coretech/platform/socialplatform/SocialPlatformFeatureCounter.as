package com.playfish.coretech.platform.socialplatform
{
   public class SocialPlatformFeatureCounter extends SocialPlatformFeature
   {
      
      protected var userBackptr:SocialPlatformUser;
      
      public function SocialPlatformFeatureCounter(param1:Object)
      {
         super(param1);
         userBackptr = param1 as SocialPlatformUser;
      }
      
      public function setCounter(param1:int, param2:String = null) : Boolean
      {
         return false;
      }
      
      public function getCounter() : Boolean
      {
         return false;
      }
      
      public function decCounter(param1:String = null) : Boolean
      {
         return false;
      }
      
      public function incCounter(param1:String = null) : Boolean
      {
         return false;
      }
   }
}


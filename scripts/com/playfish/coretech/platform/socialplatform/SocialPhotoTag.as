package com.playfish.coretech.platform.socialplatform
{
   public class SocialPhotoTag
   {
      
      public var tagRef:String;
      
      public var x:uint;
      
      public var y:uint;
      
      public function SocialPhotoTag(param1:uint = 0, param2:uint = 0, param3:String = "")
      {
         super();
         this.x = param1;
         this.y = param2;
         this.tagRef = param3;
      }
   }
}


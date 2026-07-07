package com.playfish.coretech.platform.socialplatform
{
   public class SocialPhotoAlbum
   {
      
      public var name:String;
      
      public function SocialPhotoAlbum(param1:String)
      {
         super();
         name = param1;
      }
      
      public function getID() : String
      {
         return null;
      }
      
      public function hasCover() : Boolean
      {
         return false;
      }
      
      public function getLinkURL() : String
      {
         return "";
      }
   }
}


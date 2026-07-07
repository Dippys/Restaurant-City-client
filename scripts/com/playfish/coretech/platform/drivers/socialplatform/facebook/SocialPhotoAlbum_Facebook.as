package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.data.photos.AlbumData;
   import com.playfish.coretech.platform.socialplatform.SocialPhotoAlbum;
   
   public class SocialPhotoAlbum_Facebook extends SocialPhotoAlbum
   {
      
      protected var albumData:AlbumData;
      
      public function SocialPhotoAlbum_Facebook(param1:AlbumData)
      {
         super(param1.name);
         albumData = param1;
      }
      
      override public function getID() : String
      {
         return albumData.aid;
      }
      
      override public function hasCover() : Boolean
      {
         return albumData.cover_pid == "0" ? false : true;
      }
      
      override public function getLinkURL() : String
      {
         return albumData.link;
      }
   }
}


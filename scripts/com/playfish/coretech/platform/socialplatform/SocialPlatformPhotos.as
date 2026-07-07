package com.playfish.coretech.platform.socialplatform
{
   import com.playfish.coretech.engine.core.PFArray;
   import com.playfish.coretech.engine.core.PFCallbackEvent;
   import com.playfish.coretech.engine.core.PFString;
   
   public class SocialPlatformPhotos extends SocialPlatformModule
   {
      
      protected var photosAvailable:Boolean;
      
      protected var albumList:Array;
      
      protected var photosAlbumName:String;
      
      protected var currentAlbum:SocialPhotoAlbum;
      
      public function SocialPlatformPhotos(param1:SocialPlatformPhotosSettings)
      {
         super();
         PREPARATION_MASK = SocialPlatform.PREPARE_MASK_PHOTO_ALBUM;
         albumList = new Array();
         photosAvailable = false;
         photosAlbumName = PFString.replaceAll(param1.albumName,"-"," ");
         currentAlbum = new SocialPhotoAlbum(photosAlbumName);
      }
      
      public function isPhotoAlbumAvailable() : Boolean
      {
         return photosAvailable;
      }
      
      public function getCurrentPhotoAlbumName() : String
      {
         return photosAlbumName;
      }
      
      public function getPhotoAlbum(param1:String = null) : SocialPhotoAlbum
      {
         var _loc2_:SocialPhotoAlbum = null;
         if(param1 == null)
         {
            return currentAlbum;
         }
         for each(_loc2_ in albumList)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      override public function toString() : String
      {
         var _loc1_:String = null;
         if(isAvailable())
         {
            _loc1_ = "Photo album \'" + getCurrentPhotoAlbumName() + "\'. ";
            _loc1_ += isPhotoAlbumAvailable() ? "Available." : "Not available.";
            _loc1_ += SocialPlatform.instance.application.isPermissionGranted(SocialPlatformApp.PERMISSION_PHOTOS_UPLOAD) ? "Can write/upload to it." : "Read-only.";
            return _loc1_ + ("List:" + PFArray.toString(albumList));
         }
         return "No photo album supported on this platform.";
      }
      
      public function uploadPhoto(param1:SocialPhoto, param2:Function = null) : Boolean
      {
         if(param2 != null)
         {
            param2(new PFCallbackEvent(false));
         }
         return false;
      }
      
      public function createPhoto() : SocialPhoto
      {
         return new SocialPhoto();
      }
   }
}


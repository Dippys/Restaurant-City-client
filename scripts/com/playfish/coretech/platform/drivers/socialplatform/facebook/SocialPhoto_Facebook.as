package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.adobe.images.JPGEncoder;
   import com.adobe.images.PNGEncoder;
   import com.facebook.commands.photos.UploadPhoto;
   import com.facebook.commands.photos.UploadPhotoTypes;
   import com.facebook.net.FacebookCall;
   import com.playfish.coretech.platform.socialplatform.SocialPhoto;
   import com.playfish.coretech.platform.socialplatform.SocialPhotoAlbum;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import flash.utils.ByteArray;
   
   public class SocialPhoto_Facebook extends SocialPhoto
   {
      
      private static var UPLOAD_ENCODE_FORMAT:String = "png";
      
      public function SocialPhoto_Facebook()
      {
         super();
      }
      
      override public function build() : Object
      {
         var _loc1_:ByteArray = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:SocialPhotoAlbum = null;
         var _loc7_:JPGEncoder = null;
         if(UPLOAD_ENCODE_FORMAT == "jpg")
         {
            _loc7_ = new JPGEncoder(80);
            _loc1_ = _loc7_.encode(imageSource);
            _loc2_ = UploadPhotoTypes.JPEG;
            _loc3_ = _loc4_.getID();
         }
         else
         {
            _loc1_ = PNGEncoder.encode(imageSource);
            _loc2_ = UploadPhotoTypes.PNG;
            _loc3_ = null;
         }
         _loc4_ = SocialPlatform.instance.photos.getPhotoAlbum();
         var _loc5_:UploadPhoto = new UploadPhoto(_loc1_,null,caption);
         _loc5_.uploadType = _loc2_;
         return SocialPlatform_Facebook.facebook.post(_loc5_);
      }
   }
}


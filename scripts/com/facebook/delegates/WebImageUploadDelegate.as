package com.facebook.delegates
{
   import com.adobe.images.JPGEncoder;
   import com.adobe.images.PNGEncoder;
   import com.facebook.commands.photos.UploadPhoto;
   import com.facebook.commands.photos.UploadPhotoTypes;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.net.IUploadPhoto;
   import com.facebook.session.WebSession;
   import com.facebook.utils.PlayerUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.net.FileReference;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   use namespace facebook_internal;
   
   public class WebImageUploadDelegate extends AbstractFileUploadDelegate
   {
      
      public function WebImageUploadDelegate(param1:FacebookCall, param2:WebSession)
      {
         super(param1,param2);
      }
      
      override protected function getExt() : String
      {
         return (call as IUploadPhoto).uploadType == UploadPhotoTypes.JPEG ? "jpeg" : "png";
      }
      
      override protected function getContentType() : String
      {
         return "Content-Type: image/jpg";
      }
      
      override protected function sendRequest() : void
      {
         var _loc1_:ByteArray = null;
         var _loc4_:JPGEncoder = null;
         var _loc2_:URLRequest = new URLRequest(_session.rest_url);
         var _loc3_:Object = call.args.data;
         if(PlayerUtils.majorVersion == 9 && _loc3_ is FileReference)
         {
            throw new TypeError("Uploading FileReference with Player 9 is unsupported.  Use either an BitmapData or ByteArray.");
         }
         if(_loc3_ is Bitmap)
         {
            _loc3_ = (_loc3_ as Bitmap).bitmapData;
         }
         if(PlayerUtils.majorVersion == 10 && _loc3_ is FileReference)
         {
            _loc1_ = (_loc3_ as FileReference)["load"]();
            fileRef = _loc3_ as FileReference;
            fileRef.addEventListener(Event.COMPLETE,onFileRefComplete);
         }
         else if(_loc3_ is ByteArray)
         {
            uploadByteArray(_loc3_ as ByteArray);
         }
         else
         {
            if(!(_loc3_ is BitmapData))
            {
               throw new Error("Error data type " + call.args.data + " is not supported.  Please use one of the following types:  FileReference, ByteArray, BitmapData or Bitmap.");
            }
            switch((call as UploadPhoto).uploadType)
            {
               case UploadPhotoTypes.JPEG:
                  _loc4_ = new JPGEncoder((call as UploadPhoto).uploadQuality);
                  ba = _loc4_.encode(_loc3_ as BitmapData);
                  break;
               case UploadPhotoTypes.PNG:
                  ba = PNGEncoder.encode(_loc3_ as BitmapData);
            }
            uploadByteArray(ba);
         }
      }
   }
}


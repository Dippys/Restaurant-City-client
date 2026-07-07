package com.facebook.delegates
{
   import com.facebook.commands.video.UploadVideo;
   import com.facebook.net.FacebookCall;
   import com.facebook.session.WebSession;
   import com.facebook.utils.PlayerUtils;
   import flash.events.Event;
   import flash.net.FileReference;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class VideoUploadDelegate extends AbstractFileUploadDelegate
   {
      
      public function VideoUploadDelegate(param1:FacebookCall, param2:WebSession)
      {
         super(param1,param2);
      }
      
      override protected function onOpen(param1:Event) : void
      {
         super.onOpen(param1);
         loadTimer.stop();
      }
      
      override protected function getExt() : String
      {
         return (call as UploadVideo).ext;
      }
      
      override protected function getContentType() : String
      {
         return "Content-Type: video/" + (call as UploadVideo).ext;
      }
      
      override protected function sendRequest() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:URLRequest = new URLRequest(_session.rest_url);
         var _loc3_:Object = call.args.data;
         if(PlayerUtils.majorVersion == 9 && _loc3_ is FileReference)
         {
            throw new TypeError("Uploading FileReference with Player 9 is unsupported.  Use ByteArray.");
         }
         if(PlayerUtils.majorVersion == 10 && _loc3_ is FileReference)
         {
            _loc1_ = (_loc3_ as FileReference)["load"]();
            fileRef = _loc3_ as FileReference;
            fileRef.addEventListener(Event.COMPLETE,onFileRefComplete);
         }
         else
         {
            if(!(_loc3_ is ByteArray))
            {
               throw new Error("Error data type " + call.args.data + " is not supported.  Please use one of the following types:  FileReference or ByteArray.");
            }
            uploadByteArray(_loc3_ as ByteArray);
         }
      }
   }
}


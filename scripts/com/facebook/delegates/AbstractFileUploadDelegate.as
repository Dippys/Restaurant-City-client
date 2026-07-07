package com.facebook.delegates
{
   import com.facebook.errors.FacebookError;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.session.WebSession;
   import com.facebook.utils.PostRequest;
   import flash.events.Event;
   import flash.net.FileReference;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.utils.ByteArray;
   
   use namespace facebook_internal;
   
   public class AbstractFileUploadDelegate extends WebDelegate
   {
      
      protected var ba:ByteArray;
      
      public function AbstractFileUploadDelegate(param1:FacebookCall, param2:WebSession)
      {
         super(param1,param2);
         this.ba = new ByteArray();
      }
      
      protected function uploadByteArray(param1:ByteArray) : void
      {
         var _loc3_:String = null;
         var _loc4_:URLRequest = null;
         var _loc2_:PostRequest = new PostRequest();
         for(_loc3_ in call.args)
         {
            if(_loc3_ != "data")
            {
               _loc2_.writePostData(_loc3_,call.args[_loc3_]);
            }
         }
         _loc2_.writeFileData("fn" + call.args["call_id"] + "." + this.getExt(),param1,this.getContentType());
         _loc2_.close();
         _loc4_ = new URLRequest();
         _loc4_.method = URLRequestMethod.POST;
         _loc4_.contentType = "multipart/form-data; boundary=" + _loc2_.boundary;
         _loc4_.data = _loc2_.getPostData();
         _loc4_.url = _session.rest_url;
         createURLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.load(_loc4_);
         connectTimer.start();
      }
      
      protected function onFileRefComplete(param1:Event) : void
      {
         fileRef = call.args.data as FileReference;
         this.uploadByteArray(fileRef["data"]);
      }
      
      override protected function onDataComplete(param1:Event) : void
      {
         var _loc3_:FacebookError = null;
         var _loc4_:String = null;
         var _loc2_:ByteArray = param1.target.data as ByteArray;
         if(_loc2_ == null)
         {
            _loc3_ = new FacebookError();
            call.handleError(_loc3_);
            clean();
         }
         else
         {
            _loc4_ = _loc2_.readUTFBytes(_loc2_.length);
            _loc2_.length = 0;
            _loc2_ = null;
            handleResult(_loc4_);
         }
      }
      
      protected function getExt() : String
      {
         return null;
      }
      
      protected function getContentType() : String
      {
         return null;
      }
   }
}


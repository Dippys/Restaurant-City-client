package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.commands.batch.BatchRun;
   import com.facebook.commands.photos.*;
   import com.facebook.data.application.GetPublicInfoData;
   import com.facebook.data.batch.BatchCollection;
   import com.facebook.data.batch.BatchResult;
   import com.facebook.data.photos.*;
   import com.facebook.events.FacebookEvent;
   import com.facebook.net.FacebookCall;
   import com.playfish.coretech.engine.PFEngine;
   import com.playfish.coretech.engine.core.PFCallbackEvent;
   import com.playfish.coretech.platform.natural.facebook.*;
   import com.playfish.coretech.platform.socialplatform.*;
   
   public class SocialPlatformPhotos_Facebook extends SocialPlatformPhotos
   {
      
      private static var cbfnAlbumName:String = null;
      
      private static var cbfnPhotoHandler:Function = null;
      
      private var photoUploadCallbackHandler:Function;
      
      private var firstPrepareAttempt:Boolean;
      
      private var photoUploadCallbackPhotoRef:SocialPhoto;
      
      public function SocialPlatformPhotos_Facebook(param1:SocialPlatformPhotosSettings)
      {
         super(param1);
         firstPrepareAttempt = true;
      }
      
      private function onPhotoPostProcess(param1:FacebookEvent) : void
      {
         var _loc2_:Boolean = param1 == null ? true : param1.success;
         if(photoUploadCallbackHandler != null)
         {
            photoUploadCallbackHandler(new PFCallbackEvent(_loc2_,param1));
         }
      }
      
      override public function prepare(param1:SocialPlatform, param2:SocialPlatformModuleSettings) : Boolean
      {
         super.prepare(param1,param2);
         if(platformBackRef.isPreparing(PREPARATION_MASK) || !param2.enable || isAvailable())
         {
            return true;
         }
         if(triggerRequest())
         {
            platformBackRef.onPrepareBegin(PREPARATION_MASK);
         }
         return true;
      }
      
      private function onUploadPhoto(param1:FacebookEvent) : void
      {
         var _loc2_:FacebookPhoto = null;
         var _loc3_:BatchCollection = null;
         var _loc4_:GetAlbums = null;
         var _loc5_:PhotoTagCollection = null;
         var _loc6_:SocialPhotoTag = null;
         var _loc7_:uint = 0;
         var _loc8_:TagData = null;
         var _loc9_:AddTag = null;
         var _loc10_:FBCallBatchRun = null;
         var _loc11_:FacebookCall = null;
         if(SocialPlatform_Facebook.isValidEventSuccess(param1))
         {
            _loc2_ = param1.data as FacebookPhoto;
            _loc3_ = new BatchCollection();
            if(!isPhotoAlbumAvailable() && !SocialPlatform.instance.application.isPermissionGranted(SocialPlatformApp.PERMISSION_PHOTOS_UPLOAD))
            {
               _loc4_ = new GetAlbums("",[_loc2_.aid]);
               _loc3_.addItem(_loc4_);
            }
            if(photoUploadCallbackPhotoRef.getTagCount() > 0)
            {
               _loc5_ = new PhotoTagCollection();
               _loc7_ = 0;
               while(true)
               {
                  _loc6_ = photoUploadCallbackPhotoRef.getTag(_loc7_);
                  if(_loc6_ == null)
                  {
                     break;
                  }
                  _loc8_ = new TagData();
                  _loc8_.x = _loc6_.x;
                  _loc8_.y = _loc6_.y;
                  _loc8_.tag_uid = _loc6_.tagRef;
                  _loc5_.addPhotoTag(_loc8_);
                  _loc7_++;
               }
               if(_loc5_.length > 0)
               {
                  _loc9_ = new AddTag(_loc2_.pid,null,null,0,0,_loc5_);
                  _loc3_.addItem(_loc9_);
               }
            }
            if(_loc3_.length > 0)
            {
               _loc10_ = new FBCallBatchRun(_loc3_);
               _loc11_ = SocialPlatform_Facebook.facebook.post(_loc10_);
               _loc11_.addEventListener(FacebookEvent.COMPLETE,onPhotoPostProcess);
            }
            else
            {
               onPhotoPostProcess(null);
            }
            photosAvailable = true;
         }
         else if(photoUploadCallbackHandler != null)
         {
            photoUploadCallbackHandler(new PFCallbackEvent(false));
         }
      }
      
      override public function isSupported() : Boolean
      {
         return true;
      }
      
      override public function uploadPhoto(param1:SocialPhoto, param2:Function = null) : Boolean
      {
         photoUploadCallbackHandler = param2;
         var _loc3_:FacebookCall = param1.build() as FacebookCall;
         photoUploadCallbackPhotoRef = param1;
         _loc3_.addEventListener(FacebookEvent.COMPLETE,onUploadPhoto);
         return true;
      }
      
      private function triggerRequest() : Boolean
      {
         var _loc5_:String = null;
         var _loc6_:FBGetPublicInfo = null;
         var _loc1_:GetAlbums = new GetAlbums();
         var _loc2_:BatchCollection = new BatchCollection();
         if(photosAlbumName == null)
         {
            _loc5_ = PFEngine.instance.getParameterString("fb_sig_api_key");
            _loc6_ = new FBGetPublicInfo(null,_loc5_);
            _loc2_.addItem(_loc6_);
         }
         _loc2_.addItem(_loc1_);
         var _loc3_:BatchRun = new BatchRun(_loc2_);
         var _loc4_:FacebookCall = SocialPlatform_Facebook.facebook.post(_loc3_);
         _loc4_.addEventListener(FacebookEvent.COMPLETE,onGetPhotoResponse);
         return true;
      }
      
      private function onGetPhotoResponse(param1:FacebookEvent) : void
      {
         var _loc2_:BatchResult = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:GetAlbumsData = null;
         var _loc6_:GetPublicInfoData = null;
         var _loc7_:int = 0;
         var _loc8_:AlbumData = null;
         if(SocialPlatform_Facebook.isValidEventSuccess(param1))
         {
            _loc2_ = param1.data as BatchResult;
            _loc3_ = _loc2_ == null ? null : _loc2_.results;
            if(_loc2_ != null && _loc3_ != null)
            {
               _loc4_ = 0;
               if(photosAlbumName == null)
               {
                  _loc6_ = _loc3_[_loc4_++];
                  photosAlbumName = _loc6_.display_name;
               }
               _loc5_ = _loc3_[_loc4_++];
               if(_loc5_ != null && _loc5_.albumCollection != null)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc5_.albumCollection.length)
                  {
                     _loc8_ = _loc5_.albumCollection.getItemAt(_loc7_) as AlbumData;
                     albumList.push(new SocialPhotoAlbum_Facebook(_loc8_));
                     if(_loc8_.name.indexOf(photosAlbumName) != -1)
                     {
                        currentAlbum = albumList[albumList.length - 1];
                        photosAvailable = true;
                        break;
                     }
                     _loc7_++;
                  }
                  available = true;
               }
            }
         }
         if(!available && firstPrepareAttempt)
         {
            triggerRequest();
            firstPrepareAttempt = false;
         }
         else
         {
            platformBackRef.onPrepareComplete(PREPARATION_MASK,this);
         }
      }
      
      override public function createPhoto() : SocialPhoto
      {
         return new SocialPhoto_Facebook();
      }
   }
}


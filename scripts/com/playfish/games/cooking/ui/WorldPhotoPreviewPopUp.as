package com.playfish.games.cooking.ui
{
   import com.adobe.images.PNGEncoder;
   import com.facebook.commands.photos.GetAlbums;
   import com.facebook.commands.photos.UploadPhoto;
   import com.facebook.commands.photos.UploadPhotoTypes;
   import com.facebook.commands.users.HasAppPermission;
   import com.facebook.data.BooleanResultData;
   import com.facebook.data.photos.AlbumData;
   import com.facebook.data.photos.FacebookPhoto;
   import com.facebook.data.photos.GetAlbumsData;
   import com.facebook.data.users.HasAppPermissionValues;
   import com.facebook.events.FacebookEvent;
   import com.facebook.net.FacebookCall;
   import com.playfish.coretech.platform.socialplatform.*;
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class WorldPhotoPreviewPopUp extends WorldPopUp
   {
      
      public static const MAX_PHOTO_WIDTH:int = 604;
      
      public static const MAX_PHOTO_HEIGHT:int = 604;
      
      public static var photoSettingsRead:Boolean = false;
      
      private var messageTextField:TextField;
      
      private var photos:Array;
      
      private var albumLink:String;
      
      private var sceneContent:MovieClip;
      
      private var curPhotoBitmap:Bitmap;
      
      private var uploadAlbumCover:Boolean = false;
      
      private var loadingPopUp:WorldLoadingPopUp;
      
      public function WorldPhotoPreviewPopUp(param1:Array)
      {
         super(null,null,null);
         this.photos = param1;
         var _loc2_:MovieClip = Engine.getMovieClip("PhotoPopupAnim");
         addChild(_loc2_);
         sceneContent = _loc2_.mc_content;
         setButtonMode(sceneContent.mc_tick,true);
         setButtonMode(sceneContent.mc_cancel,true);
         sceneContent.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
         sceneContent.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         sceneContent.mc_roomPhoto.tooltip = new ToolTip(sceneContent.mc_roomPhoto,GameWorld.textHandler.getTextFromId("ToolTipFullRoomPhoto"));
         sceneContent.mc_screenPhoto.tooltip = new ToolTip(sceneContent.mc_screenPhoto,GameWorld.textHandler.getTextFromId("ToolTipCurrentScreenPhoto"));
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"PublishThePhoto");
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_caption,"PhotoCaption");
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_addCaptionLink,"AddCaptionLink");
         messageTextField = sceneContent.tf_message;
         messageTextField.addEventListener(Event.CHANGE,onTextFieldChanged,false,0,true);
         messageTextField.text = "";
         Engine.setFocus(messageTextField);
         sceneContent.mc_tickBox.addEventListener(MouseEvent.CLICK,onAddCaptionLinkTickBoxClick,false,0,true);
         sceneContent.mc_tickBox.buttonMode = true;
         toggleCaptionLink(false);
         onRoomPhotoClick(null);
         if(param1.length == 1)
         {
            sceneContent.mc_roomPhoto.visible = false;
            sceneContent.mc_screenPhoto.visible = false;
         }
         if(!photoSettingsRead)
         {
            photoSettingsRead = true;
            GameWorld.albumExists = SocialPlatform.instance.photos.isPhotoAlbumAvailable();
            GameWorld.photoUploadPermission = SocialPlatform.instance.application.isPermissionGranted(SocialPlatformApp.PERMISSION_PHOTOS_UPLOAD);
         }
         if(GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_PHOTO))
         {
            GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_PHOTO);
         }
         new GameSound("SfxCamera",GameSound.TYPE_SOUND).play(1);
      }
      
      private function onScreenPhotoClick(param1:MouseEvent) : void
      {
         showPhoto(photos[1]);
         setButtonMode(sceneContent.mc_screenPhoto,false);
         sceneContent.mc_screenPhoto.gotoAndStop("selected");
         sceneContent.mc_screenPhoto.removeEventListener(MouseEvent.CLICK,onScreenPhotoClick);
         setButtonMode(sceneContent.mc_roomPhoto,true);
         sceneContent.mc_roomPhoto.addEventListener(MouseEvent.CLICK,onRoomPhotoClick,false,0,true);
      }
      
      override public function remove() : void
      {
         super.remove();
         var _loc1_:int = 0;
         while(_loc1_ < photos.length)
         {
            photos[_loc1_].dispose();
            _loc1_++;
         }
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onFullScreen);
         FullScreenTextFieldHandler.unlockTextFieldInFullScreenMode(messageTextField);
      }
      
      private function onGetPhotoUploadPermission(param1:FacebookEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:WorldPopUp = null;
         loadingPopUp.remove();
         loadingPopUp = null;
         var _loc2_:BooleanResultData = param1.data as BooleanResultData;
         GameWorld.photoUploadPermission = _loc2_.value;
         if(GameWorld.photoUploadPermission)
         {
            if(GameWorld.albumExists)
            {
               _loc3_ = Engine.getMovieClip("PhotoPermissionAnim");
               _loc4_ = _loc3_.mc_content;
               GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_text,"PhotoAllowPermissionSendPhotoText");
               _loc5_ = new WorldPopUp(_loc3_,_loc3_.mc_content.mc_tick,_loc3_.mc_content.mc_cancel);
               _loc3_.mc_content.mc_tick.addEventListener(MouseEvent.CLICK,onPublishPhoto,false,0,true);
               _loc5_.show();
            }
            else
            {
               showAlbumCoverPopUp();
            }
         }
         else
         {
            onTickClick(null);
         }
      }
      
      private function onGrantPermissionOK(param1:MouseEvent) : void
      {
         var _loc2_:HasAppPermission = new HasAppPermission(HasAppPermissionValues.PHOTO_UPLOAD);
         var _loc3_:FacebookCall = GameWorld.socialNetworkHandler.session.facebook.post(_loc2_);
         _loc3_.addEventListener(FacebookEvent.COMPLETE,onGetPhotoUploadPermission);
         loadingPopUp = new WorldLoadingPopUp(GameWorld.textHandler.getTextFromId("Uploading"),WorldLoadingPopUp.PHOTO);
         loadingPopUp.x = GameWorld.CANVAS_CENTER_X;
         loadingPopUp.y = GameWorld.CANVAS_CENTER_Y;
         loadingPopUp.show();
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:WorldPopUp = null;
         if(!GameWorld.photoUploadPermission)
         {
            _loc2_ = Engine.getMovieClip("PhotoPermissionAnim");
            _loc3_ = _loc2_.mc_content;
            GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_text,"PhotoAllowPermissionText");
            _loc4_ = new WorldPopUp(_loc2_,_loc2_.mc_content.mc_tick,_loc2_.mc_content.mc_cancel);
            _loc2_.mc_content.mc_tick.addEventListener(MouseEvent.CLICK,onGrantPermission,false,0,true);
            _loc4_.x = GameWorld.CANVAS_CENTER_X;
            _loc4_.y = GameWorld.CANVAS_CENTER_Y;
            _loc4_.show();
         }
         else if(GameWorld.albumExists)
         {
            publish();
         }
         else
         {
            showAlbumCoverPopUp();
         }
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function toggleCaptionLink(param1:Boolean) : void
      {
         if(param1)
         {
            sceneContent.mc_tickBox.gotoAndStop("tick");
            GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_link,"PhotoCaptionLinkText");
         }
         else
         {
            sceneContent.mc_tickBox.gotoAndStop("untick");
            sceneContent.tf_link.text = "";
         }
      }
      
      private function onUploadAlbumCoverOK(param1:MouseEvent) : void
      {
         uploadAlbumCover = true;
         publish();
      }
      
      private function publish() : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:BitmapData = null;
         var _loc7_:ByteArray = null;
         var _loc8_:UploadPhoto = null;
         var _loc9_:FacebookCall = null;
         var _loc1_:String = messageTextField.text;
         var _loc2_:String = isCaptionLinkOn() ? GameWorld.textHandler.getTextFromId("PhotoCaptionLinkText") : "";
         if(_loc1_.length > 0)
         {
            if(_loc2_.length > 0)
            {
               _loc1_ += " " + _loc2_;
            }
         }
         else
         {
            _loc1_ = _loc2_;
         }
         if(!GameWorld.albumExists && uploadAlbumCover)
         {
            _loc5_ = Engine.getMovieClip("PhotoAlbumCover");
            _loc6_ = GameWorld.convertToBitmapData(_loc5_,1,_loc5_.getBounds(null),MAX_PHOTO_WIDTH,MAX_PHOTO_HEIGHT);
            _loc7_ = PNGEncoder.encode(_loc6_);
            _loc8_ = new UploadPhoto(_loc7_,null,_loc2_);
            _loc8_.uploadType = UploadPhotoTypes.PNG;
            _loc9_ = GameWorld.socialNetworkHandler.session.facebook.post(_loc8_);
         }
         var _loc3_:ByteArray = PNGEncoder.encode(curPhotoBitmap.bitmapData);
         var _loc4_:UploadPhoto = new UploadPhoto(_loc3_,null,_loc1_);
         _loc4_.uploadType = UploadPhotoTypes.PNG;
         _loc9_ = GameWorld.socialNetworkHandler.session.facebook.post(_loc4_);
         _loc9_.addEventListener(FacebookEvent.COMPLETE,onUploadPhoto);
         if(loadingPopUp == null)
         {
            loadingPopUp = new WorldLoadingPopUp(GameWorld.textHandler.getTextFromId("Uploading"),WorldLoadingPopUp.PHOTO);
            loadingPopUp.x = GameWorld.CANVAS_CENTER_X;
            loadingPopUp.y = GameWorld.CANVAS_CENTER_Y;
            loadingPopUp.show();
         }
      }
      
      private function onPublishPhoto(param1:Event) : void
      {
         publish();
      }
      
      private function onPhotoPostProcess(param1:FacebookEvent) : void
      {
         var _loc2_:GetAlbumsData = null;
         var _loc3_:AlbumData = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:WorldPopUp = null;
         loadingPopUp.remove();
         loadingPopUp = null;
         if(Boolean(param1) && param1.success)
         {
            _loc2_ = param1.data as GetAlbumsData;
            _loc3_ = _loc2_.albumCollection.getItemAt(0) as AlbumData;
            albumLink = _loc3_.link;
            _loc4_ = Engine.getMovieClip("PhotoPermissionAnim");
            _loc5_ = _loc4_.mc_content;
            GameWorld.textHandler.setTextFieldWithId(_loc5_.tf_text,"PhotoNeedToBeApprovedText");
            _loc6_ = new WorldPopUp(_loc4_,_loc4_.mc_content.mc_tick,_loc4_.mc_content.mc_cancel);
            _loc4_.mc_content.mc_tick.addEventListener(MouseEvent.CLICK,onApprovalOK,false,0,true);
            _loc4_.mc_content.mc_cancel.addEventListener(MouseEvent.CLICK,onApprovalCancel,false,0,true);
            _loc6_.x = GameWorld.CANVAS_CENTER_X;
            _loc6_.y = GameWorld.CANVAS_CENTER_Y;
            _loc6_.show();
         }
         else
         {
            remove();
         }
      }
      
      private function onUploadAlbumCoverCancel(param1:MouseEvent) : void
      {
         uploadAlbumCover = false;
         publish();
      }
      
      private function onApprovalOK(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:URLRequest = new URLRequest(albumLink);
         if(_loc2_ != null)
         {
            navigateToURL(_loc2_,"_blank");
         }
      }
      
      private function onTextFieldChanged(param1:Event) : void
      {
         if(messageTextField.scrollV > 1)
         {
            messageTextField.text = messageTextField.text.substring(0,messageTextField.text.length - 1);
            messageTextField.scrollV = 1;
         }
      }
      
      private function showAlbumCoverPopUp() : void
      {
         var _loc1_:MovieClip = Engine.getMovieClip("PhotoCoverPermissionAnim");
         var _loc2_:MovieClip = _loc1_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_text,"DoYouWantToAddAlbumCover");
         var _loc3_:WorldPopUp = new WorldPopUp(_loc1_,_loc1_.mc_content.mc_tick,_loc1_.mc_content.mc_cancel);
         _loc1_.mc_content.mc_tick.addEventListener(MouseEvent.CLICK,onUploadAlbumCoverOK,false,0,true);
         _loc1_.mc_content.mc_cancel.addEventListener(MouseEvent.CLICK,onUploadAlbumCoverCancel,false,0,true);
         _loc3_.show();
      }
      
      private function onUploadPhoto(param1:FacebookEvent) : void
      {
         var _loc2_:FacebookPhoto = null;
         var _loc3_:GetAlbums = null;
         var _loc4_:FacebookCall = null;
         var _loc5_:WorldRetryPopUp = null;
         if(param1.success)
         {
            GameWorld.albumExists = true;
            if(!GameWorld.photoUploadPermission)
            {
               _loc2_ = param1.data as FacebookPhoto;
               _loc3_ = new GetAlbums("",[_loc2_.aid]);
               _loc4_ = GameWorld.socialNetworkHandler.session.facebook.post(_loc3_);
               _loc4_.addEventListener(FacebookEvent.COMPLETE,onPhotoPostProcess);
            }
            else
            {
               onPhotoPostProcess(null);
            }
         }
         else
         {
            loadingPopUp.remove();
            loadingPopUp = null;
            _loc5_ = new WorldRetryPopUp(GameWorld.textHandler.getTextFromId("FailedToUploadPhotoRetry"),publish);
            _loc5_.show();
         }
      }
      
      private function onApprovalCancel(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onGrantPermission(param1:MouseEvent) : void
      {
         SocialPlatform.instance.application.grantPermissionTag(SocialPlatformApp.PERMISSION_PHOTOS_UPLOAD);
         var _loc2_:MovieClip = Engine.getMovieClip("PhotoPermissionAnim");
         var _loc3_:MovieClip = _loc2_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_text,"PhotoAllowPermissionProceedText");
         var _loc4_:WorldPopUp = new WorldPopUp(_loc2_,_loc2_.mc_content.mc_tick,_loc2_.mc_content.mc_cancel);
         _loc2_.mc_content.mc_tick.addEventListener(MouseEvent.CLICK,onGrantPermissionOK,false,0,true);
         _loc4_.x = GameWorld.CANVAS_CENTER_X;
         _loc4_.y = GameWorld.CANVAS_CENTER_Y;
         _loc4_.show();
      }
      
      private function onFullScreen(param1:Event) : void
      {
         if(Engine.isFullScreen())
         {
            FullScreenTextFieldHandler.lockTextFieldInFullScreenMode(messageTextField);
         }
         else
         {
            FullScreenTextFieldHandler.unlockTextFieldInFullScreenMode(messageTextField);
         }
      }
      
      private function isCaptionLinkOn() : Boolean
      {
         return sceneContent.mc_tickBox.currentLabel == "tick";
      }
      
      private function onRoomPhotoClick(param1:MouseEvent) : void
      {
         showPhoto(photos[0]);
         setButtonMode(sceneContent.mc_roomPhoto,false);
         sceneContent.mc_roomPhoto.gotoAndStop("selected");
         sceneContent.mc_roomPhoto.removeEventListener(MouseEvent.CLICK,onRoomPhotoClick);
         setButtonMode(sceneContent.mc_screenPhoto,true);
         sceneContent.mc_screenPhoto.addEventListener(MouseEvent.CLICK,onScreenPhotoClick,false,0,true);
      }
      
      private function onAddCaptionLinkTickBoxClick(param1:MouseEvent) : void
      {
         toggleCaptionLink(!isCaptionLinkOn());
      }
      
      private function showPhoto(param1:BitmapData) : void
      {
         var _loc2_:Bitmap = new Bitmap(param1);
         _loc2_.smoothing = true;
         if(_loc2_.width / _loc2_.height > sceneContent.mc_photo.width / sceneContent.mc_photo.height)
         {
            if(_loc2_.width > sceneContent.mc_photo.width)
            {
               _loc2_.width = sceneContent.mc_photo.width;
               _loc2_.scaleY = _loc2_.scaleX;
            }
         }
         else if(_loc2_.height > sceneContent.mc_photo.height)
         {
            _loc2_.height = sceneContent.mc_photo.height;
            _loc2_.scaleX = _loc2_.scaleY;
         }
         _loc2_.x = sceneContent.mc_photo.x + (sceneContent.mc_photo.width - _loc2_.width) / 2;
         _loc2_.y = sceneContent.mc_photo.y + (sceneContent.mc_photo.height - _loc2_.height) / 2;
         if(curPhotoBitmap)
         {
            sceneContent.removeChild(curPhotoBitmap);
         }
         curPhotoBitmap = _loc2_;
         sceneContent.addChild(curPhotoBitmap);
      }
      
      override public function show() : void
      {
         super.show();
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,0,true);
         onFullScreen(null);
      }
   }
}


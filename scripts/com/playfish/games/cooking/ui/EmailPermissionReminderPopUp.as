package com.playfish.games.cooking.ui
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformApp;
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class EmailPermissionReminderPopUp extends WorldPopUp
   {
      
      private var street:WorldStreet;
      
      public function EmailPermissionReminderPopUp(param1:WorldStreet)
      {
         super(null,null,null);
         this.street = param1;
         var _loc2_:MovieClip = Engine.getMovieClip("EmailPopupAnim2");
         addChild(_loc2_);
         var _loc3_:MovieClip = _loc2_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_title,"EmailPermissionRequest");
         setButtonMode(_loc3_.mc_cancel,true);
         setButtonMode(_loc3_.mc_tick,true);
         _loc3_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         _loc3_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         SocialPlatform.instance.application.grantPermissionTag(SocialPlatformApp.PERMISSION_EMAIL_ACCESS);
         street.startIntroMovieClip();
         remove();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         street.startIntroMovieClip();
         remove();
      }
   }
}


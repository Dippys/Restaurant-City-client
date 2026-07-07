package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.WorldPopUp;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class GameStartMessageMail extends WorldPopUp
   {
      
      private var scene:MovieClip;
      
      public function GameStartMessageMail(param1:MailItem)
      {
         super(null,null,null);
         var _loc2_:String = param1.mailObject.message;
         scene = Engine.getMovieClip("SalePopupAnim");
         addChild(scene);
         var _loc3_:MovieClip = scene.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_title,_loc2_ + "GameStartMessageTitle",true);
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_text,_loc2_ + "GameStartMessageBody",true);
         setButtonMode(_loc3_.mc_cancel,true);
         _loc3_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
      }
      
      override public function show() : void
      {
         super.show();
         scene.gotoAndPlay("in");
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
   }
}


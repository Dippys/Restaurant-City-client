package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class SpecialDayPresentMail extends WorldPopUp
   {
      
      private var mailClient:WorldMail;
      
      private var scene:MovieClip;
      
      private var presentItem:Object;
      
      private var mailItem:MailItem;
      
      private var presentType:String;
      
      public function SpecialDayPresentMail(param1:MailItem, param2:WorldMail)
      {
         super(null,null,null);
         this.mailClient = param2;
         this.mailItem = param1;
         presentType = param1.mailObject.message;
         scene = Engine.getMovieClip("PfPresentAnim");
         addChild(scene);
         var _loc3_:MovieClip = scene.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_congratulation,presentType + "PresentTitle");
         presentItem = GameWorld.getItemConfig(param1.mailObject.globalItemIds[0]);
         GameWorld.textHandler.setReplaceString("ItemName",presentItem.name);
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_message,presentType + "PresentMessage",true);
         _loc3_.mc_present.addChild(ItemChooser.getItemMovieClip(presentItem));
         _loc3_.mc_present.removeChildAt(0);
         setButtonMode(_loc3_.mc_skip,true);
         setHandCursor(_loc3_.mc_skip,true);
         _loc3_.mc_skip.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         setButtonMode(_loc3_.mc_share,true);
         GameWorld.textHandler.setTextFieldWithId(_loc3_.mc_share.mc_content.tf_text,"ButtonContinueText");
         _loc3_.mc_share.addEventListener(MouseEvent.CLICK,onShareClick,false,0,true);
      }
      
      private function onShareClick(param1:MouseEvent) : void
      {
         GameWorld.textHandler.setReplaceString("ItemName",presentItem.name);
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         GameWorld.postFeed(GameWorld.textHandler.getTextFromId(presentType + "PresentStreamTitle"),GameWorld.textHandler.getTextFromId(presentType + "PresentStreamInformation"),GameWorld.textHandler.getTextFromId(presentType + "PresentStreamCaption"),GameWorld.textHandler.getTextFromId(presentType + "PresentStreamDescription"),GameWorld.textHandler.getTextFromId(presentType + "PresentStreamLinkText"),GameWorld.STREAM_FEED_GAME_LINK + "&" + GameWorld.textHandler.getTextFromId(presentType + "PresentStreamLinkRef"),GameWorld.textHandler.getTextFromId(presentType + "PresentStreamDashboardText"),null,GameWorld.textHandler.getTextFromId(presentType + "PresentStreamInformation"),GameWorld.textHandler.getTextFromId(presentType + "PresentStreamCaption"),GameWorld.textHandler.getTextFromId(presentType + "PresentStreamLinkText"),GameWorld.FEED_FORM_GAME_LINK,"",[presentItem.id + "received.png"]);
         remove();
         if(mailClient)
         {
            mailClient.refresh();
            mailClient.show();
         }
      }
      
      override public function remove() : void
      {
         GameWorld.applyPerkReward(presentItem);
         super.remove();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
         if(mailClient)
         {
            mailClient.refresh();
            mailClient.show();
         }
      }
      
      override public function show() : void
      {
         super.show();
         scene.gotoAndPlay("in");
      }
   }
}


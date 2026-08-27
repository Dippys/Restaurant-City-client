package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldMailCoinBagPopUp extends WorldPopUp
   {
      
      private var mailClient:WorldMail;
      
      private var mailItem:MailItem;
      
      private var scene:MovieClip;
      
      private var sceneContent:MovieClip;
      
      private var coin:int;

      private var playfishCash:Boolean = false;
      
      public function WorldMailCoinBagPopUp(param1:MailItem, param2:WorldMail)
      {
         super(null,null,null);
         this.mailItem = param1;
         this.mailClient = param2;
         playfishCash = param1.mailObject.message.indexOf("PFC:") == 0;
         this.coin = parseInt(playfishCash ? param1.mailObject.message.substr(4) : param1.mailObject.message);
         scene = Engine.getMovieClip("MoneyMessageAnim");
         scene.stop();
         addChild(scene);
         sceneContent = scene.mc_content;
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"CreditDelivery");
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         if(playfishCash)
         {
            GameWorld.textHandler.setTextField(sceneContent.tf_message,"Hello " + GameWorld.gameUser.firstName + "!\n\nPlease find enclosed your " + coin + " Playfish Cash as requested.\n\nHappy shopping!",true);
         }
         else
         {
            GameWorld.textHandler.setReplaceString("Coins",coin.toString());
            GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_message,"CoinBagText",true);
         }
         setButtonMode(sceneContent.mc_tick,true);
         sceneContent.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         GameWorld.gameUser.removeMailItem(mailItem);
         if(mailClient)
         {
            mailClient.refresh();
         }
         if(WorldRestaurantPlay.instance != null)
         {
            WorldRestaurantPlay.instance.refreshMails();
         }
         GameWorld.saveProfileHandler.addDeletedMail(mailItem);
         sceneContent.mc_tick.removeEventListener(MouseEvent.CLICK,onTickClick);
         if(playfishCash)
         {
            GameWorld.cashPanel.refresh();
            GameWorld.cashPanel.showPlayfishCashPopUp(coin);
         }
         else
         {
            GameWorld.cashPanel.addCoins(coin,true);
         }
         remove();
      }
      
      override public function show() : void
      {
         super.show();
         scene.gotoAndPlay(0);
      }
   }
}


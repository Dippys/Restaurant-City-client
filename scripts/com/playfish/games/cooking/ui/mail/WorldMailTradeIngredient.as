package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WorldMailTradeIngredient extends WorldPopUp
   {
      
      private var mailClient:WorldMail;
      
      private var mailItem:MailItem;
      
      private var sender:GameUser;
      
      public function WorldMailTradeIngredient(param1:MailItem, param2:WorldMail)
      {
         super(null,null,null);
         this.mailItem = param1;
         this.mailClient = param2;
         var _loc3_:MovieClip = Engine.getMovieClip("SecureTradeMessageAnim");
         addChild(_loc3_);
         var _loc4_:MovieClip = _loc3_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_title,"SecureTradeRequest");
         _loc4_.mc_playerPanel.stop();
         _loc4_.mc_playerPanel.tf_name.text = GameWorld.gameUser.fullName;
         var _loc5_:DisplayObject = GameWorld.getUserFaceImage(GameWorld.gameUser);
         if(_loc5_ != null)
         {
            _loc4_.mc_playerPanel.mc_frame.mc_face.addChild(_loc5_);
         }
         _loc4_.mc_senderPanel.stop();
         sender = GameWorld.getGameUserWithId(param1.mailObject.senderId);
         if(sender != null)
         {
            _loc4_.mc_senderPanel.tf_name.text = sender.fullName;
            _loc5_ = GameWorld.getUserFaceImage(sender);
            if(_loc5_ != null)
            {
               _loc4_.mc_senderPanel.mc_frame.mc_face.addChild(_loc5_);
            }
         }
         _loc4_.mc_playerItem.stop();
         _loc4_.mc_senderItem.stop();
         var _loc6_:Object = GameWorld.getItemConfig(param1.mailObject.globalItemIds[1]);
         var _loc7_:Object = GameWorld.getItemConfig(param1.mailObject.globalItemIds[0]);
         WorldTradePanel.setupIngredientIcon(_loc4_.mc_playerItem,_loc6_);
         WorldTradePanel.setupIngredientIcon(_loc4_.mc_senderItem,_loc7_);
         GameWorld.textHandler.setReplaceString("ingredient1",_loc6_.name);
         GameWorld.textHandler.setReplaceString("ingredient2",_loc7_.name);
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_text,"TradeText",true);
         setButtonMode(_loc4_.mc_cancel,true);
         setButtonMode(_loc4_.mc_accept,true);
         setButtonMode(_loc4_.mc_decline,true);
         _loc4_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         _loc4_.mc_accept.addEventListener(MouseEvent.CLICK,onAcceptClick,false,0,true);
         _loc4_.mc_decline.addEventListener(MouseEvent.CLICK,onDeclineClick,false,0,true);
      }
      
      private function onAcceptClick(param1:Event) : void
      {
         var _loc2_:RpcRequestManager = null;
         _loc2_ = new RpcRequestManager();
         _loc2_.loadingPopUp = new WorldLoadingPopUp("Trading...",WorldLoadingPopUp.TRADING);
         _loc2_.loadingPopUp.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.loadingPopUp.y = GameWorld.CANVAS_CENTER_Y;
         _loc2_.retryText = GameWorld.textHandler.getTextFromId("TradingRetryText");
         var _loc3_:RpcTradeIngredients = _loc2_.tradeIngredients(mailItem.mailObject.senderId,GameWorld.getItemConfig(mailItem.mailObject.globalItemIds[1]),GameWorld.getItemConfig(mailItem.mailObject.globalItemIds[0]),true,mailItem.mailObject.id);
         _loc3_.addEventListener(RpcEvent.SUCCESS,onTradeIngredientSuccess);
         _loc2_.commit();
      }
      
      private function onRetry() : void
      {
         onAcceptClick(null);
      }
      
      override public function remove() : void
      {
         super.remove();
         if(mailClient)
         {
            mailClient.show();
         }
      }
      
      private function onTradeIngredientSuccess(param1:RpcEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:WorldInfoPopUp = null;
         if(param1.successCode == RpcClient.STATUS_OK)
         {
            _loc2_ = GameWorld.getItemConfig(mailItem.mailObject.globalItemIds[0]);
            _loc3_ = GameWorld.getItemConfig(mailItem.mailObject.globalItemIds[1]);
            GameWorld.gameUser.addIngredient(_loc2_,1);
            GameWorld.gameUser.getIngredient(_loc2_).lock = true;
            GameWorld.gameUser.removeIngredient(_loc3_,1);
            if(sender != null)
            {
               sender.addIngredient(_loc3_,1);
               sender.getIngredient(_loc3_).lock = true;
               sender.removeIngredient(_loc2_,1);
            }
         }
         else
         {
            _loc4_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("TradeFailed"));
            _loc4_.x = GameWorld.CANVAS_CENTER_X;
            _loc4_.y = GameWorld.CANVAS_CENTER_Y;
            _loc4_.show();
            GameWorld.saveProfileHandler.addDeletedMail(mailItem);
         }
         removeThisMail();
         super.remove();
         if(mailClient)
         {
            mailClient.queueToShow();
         }
      }
      
      private function onCancelClick(param1:Event) : void
      {
         remove();
      }
      
      private function onDeclineClick(param1:Event) : void
      {
         removeThisMail();
         GameWorld.saveProfileHandler.addDeletedMail(mailItem);
         remove();
      }
      
      private function removeThisMail() : void
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
      }
   }
}


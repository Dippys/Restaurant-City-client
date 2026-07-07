package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldMailTradeAcceptPopUp extends WorldPopUp
   {
      
      private var mailClient:WorldMail;
      
      private var mailItem:MailItem;
      
      public function WorldMailTradeAcceptPopUp(param1:MailItem, param2:WorldMail)
      {
         var _loc8_:DisplayObject = null;
         super(null,null,null);
         this.mailItem = param1;
         this.mailClient = param2;
         var _loc3_:MovieClip = Engine.getMovieClip("SecureTradeAcceptanceAnim");
         addChild(_loc3_);
         var _loc4_:MovieClip = _loc3_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_title,"SecureTradeAccepted");
         _loc4_.mc_senderPanel.stop();
         var _loc5_:GameUser = GameWorld.getGameUserWithId(param1.mailObject.senderId);
         if(_loc5_ != null)
         {
            _loc4_.mc_senderPanel.tf_name.text = _loc5_.fullName;
            _loc8_ = GameWorld.getUserFaceImage(_loc5_);
            if(_loc8_ != null)
            {
               _loc4_.mc_senderPanel.mc_frame.mc_face.addChild(_loc8_);
            }
         }
         else
         {
            _loc4_.mc_senderPanel.tf_name.text = param1.mailObject.senderId.toString();
         }
         var _loc6_:Object = GameWorld.getItemConfig(param1.mailObject.globalItemIds[0]);
         var _loc7_:Object = GameWorld.getItemConfig(param1.mailObject.globalItemIds[1]);
         GameWorld.textHandler.setReplaceString("ingredient1",_loc7_.name);
         GameWorld.textHandler.setReplaceString("ingredient2",_loc6_.name);
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_text,"TradeAcceptedText",true);
         setButtonMode(_loc4_.mc_tick,true);
         _loc4_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
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
         remove();
         if(mailClient)
         {
            mailClient.show();
         }
      }
   }
}


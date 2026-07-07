package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.WorldPopUp;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class GiftInviteFoodMail extends WorldPopUp
   {
      
      private var mailClient:WorldMail;
      
      private var mailItem:MailItem;
      
      private var scene:MovieClip;
      
      public function GiftInviteFoodMail(param1:MailItem, param2:WorldMail)
      {
         var _loc7_:DisplayObject = null;
         super(null,null,null);
         this.mailClient = param2;
         this.mailItem = param1;
         scene = Engine.getMovieClip("InviteGiftMailPopup");
         addChild(scene);
         var _loc3_:MovieClip = scene.mc_content;
         var _loc4_:Object = GameWorld.getItemConfig(param1.mailObject.globalItemIds[0]);
         GameWorld.textHandler.setReplaceString("itemName",GameWorld.textHandler.getTextFromId("GiftItem" + _loc4_.className));
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_title,"HeresAGiftForYourEmployees");
         _loc3_.mc_senderPanel.stop();
         var _loc5_:GameUser = GameWorld.getGameUserWithId(param1.mailObject.senderId);
         if(_loc5_ != null)
         {
            _loc3_.mc_senderPanel.tf_name.text = _loc5_.fullName;
            _loc7_ = GameWorld.getUserFaceImage(_loc5_);
            if(_loc7_ != null)
            {
               _loc3_.mc_senderPanel.mc_frame.mc_face.addChild(_loc7_);
            }
         }
         else
         {
            _loc3_.mc_senderPanel.tf_name.text = param1.mailObject.senderId.toString();
         }
         _loc3_.mc_item.stop();
         _loc3_.mc_item.visible = false;
         var _loc6_:MovieClip = Engine.getMovieClip(_loc4_.className);
         _loc6_.stop();
         _loc6_.scaleX = 1.5;
         _loc6_.scaleY = 1.5;
         _loc6_.x = _loc3_.mc_item.x;
         _loc6_.y = _loc3_.mc_item.y;
         _loc3_.addChildAt(_loc6_,_loc3_.getChildIndex(_loc3_.mc_item));
         setButtonMode(_loc3_.mc_tick,true);
         _loc3_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
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


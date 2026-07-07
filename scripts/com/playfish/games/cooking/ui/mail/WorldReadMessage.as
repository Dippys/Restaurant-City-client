package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.ui.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldReadMessage extends WorldPopUp
   {
      
      private var mailClient:WorldMail;
      
      private var scene:MovieClip;
      
      private var mailItem:MailItem;
      
      private var sender:GameUser;
      
      public function WorldReadMessage(param1:MailItem, param2:WorldMail)
      {
         var _loc5_:DisplayObject = null;
         super(null,null,null);
         this.mailClient = param2;
         this.mailItem = param1;
         scene = Engine.getMovieClip("ReadMessageAnim");
         addChild(scene);
         var _loc3_:MovieClip = scene.mc_content;
         var _loc4_:Object = GameWorld.getItemConfig(param1.mailObject.globalItemIds[0]);
         if(_loc4_)
         {
            GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_title,"GiftFromSomeone");
            GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_itemAdded,"ItemAddedToYourInventory");
            _loc3_.mc_messageIcon.visible = false;
            _loc3_.mc_item.removeChildAt(0);
            _loc3_.mc_item.addChild(ItemChooser.getItemMovieClip(_loc4_));
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_title,"MessageFromSomeone");
            _loc3_.mc_item.visible = false;
            _loc3_.tf_itemAdded.visible = false;
         }
         _loc3_.tf_message.text = param1.mailObject.message;
         _loc3_.mc_sender.stop();
         _loc3_.tf_date.text = param1.mailObject.sendDate.toDateString();
         _loc3_.mc_avatar.removeChildAt(0);
         sender = GameWorld.getGameUserWithId(param1.mailObject.senderId);
         if(sender)
         {
            _loc3_.mc_sender.tf_name.text = sender.fullName;
            _loc5_ = GameWorld.getUserFaceImage(sender);
            if(_loc5_ != null)
            {
               _loc3_.mc_sender.mc_frame.mc_face.addChild(_loc5_);
            }
         }
         else
         {
            _loc3_.mc_sender.tf_name.text = param1.mailObject.senderId;
         }
         setButtonMode(_loc3_.mc_cancel,true);
         setButtonMode(_loc3_.mc_reply,true);
         setButtonMode(_loc3_.mc_delete,true);
         _loc3_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         _loc3_.mc_reply.addEventListener(MouseEvent.CLICK,onReplyClick,false,0,true);
         _loc3_.mc_delete.addEventListener(MouseEvent.CLICK,onDeleteClick,false,0,true);
      }
      
      override public function remove() : void
      {
         super.remove();
         if(mailClient)
         {
            mailClient.show();
         }
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      override public function show() : void
      {
         super.show();
         scene.gotoAndPlay("in");
      }
      
      private function onDeleteClick(param1:MouseEvent) : void
      {
         GameWorld.gameUser.removeMailItem(mailItem);
         if(mailClient)
         {
            mailClient.refresh();
         }
         GameWorld.saveProfileHandler.addDeletedMail(mailItem);
         remove();
      }
      
      private function onReplyClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldWriteMessage = null;
         super.remove();
         _loc2_ = new WorldWriteMessage(null,sender,this);
         _loc2_.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.y = GameWorld.CANVAS_CENTER_Y;
         _loc2_.show();
      }
   }
}


package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.*;
   import flash.events.MouseEvent;
   
   public class DebugAddInviteGiftFoodMail extends DebugEntryButton
   {
      
      public function DebugAddInviteGiftFoodMail()
      {
         super("Add a invite gift food mail","");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Mail = new Mail();
         _loc2_.type = RpcClient.MAIL_TYPE_GIFT_INVITE;
         _loc2_.sendDate = new Date();
         _loc2_.message = "";
         _loc2_.senderId = GameWorld.gameUser.userInfo.id;
         _loc2_.globalItemIds = [GameWorld.perkItemDatabase.getItems("Employee")[0].id];
         GameWorld.addNewMail(_loc2_);
         if(WorldRestaurantPlay.instance)
         {
            WorldRestaurantPlay.instance.refreshMails();
         }
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


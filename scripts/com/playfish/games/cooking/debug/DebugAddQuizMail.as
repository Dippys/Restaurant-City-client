package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import com.playfish.rpc.cooking.Mail;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.events.MouseEvent;
   
   public class DebugAddQuizMail extends DebugEntryButton
   {
      
      public function DebugAddQuizMail()
      {
         super("Add a quiz mail","");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Mail = new Mail();
         _loc2_.type = RpcClient.MAIL_TYPE_QUIZZ;
         _loc2_.sendDate = new Date();
         _loc2_.message = "";
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


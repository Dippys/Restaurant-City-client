package com.playfish.games.cooking
{
   import com.playfish.rpc.cooking.Mail;
   
   public class MailItem
   {
      
      public static const MAX_MAIL_RETAIN_DAYS:int = 3;
      
      public static const MAIL_TYPE_FRAME_LABEL:Array = ["","message","quiz","system","gift","","trade","money","tradeaccept","giftinvite"];
      
      public var newsletterId:int = -1;
      
      public var mailObject:Mail;
      
      public var type:int;
      
      public function MailItem(param1:Mail)
      {
         super();
         this.mailObject = param1;
         this.type = param1.type;
      }
   }
}


package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   
   public class RpcSendMail extends RpcBase
   {
      
      private var playerIngredient:IngredientItem;
      
      private var giftItem:GameItemObject;
      
      private var mail:Mail;
      
      private var recipientIngredient:IngredientItem;
      
      public function RpcSendMail(param1:NetworkUid, param2:String, param3:GameItemObject, param4:IngredientItem, param5:IngredientItem)
      {
         super();
         priority = 3;
         this.playerIngredient = param4;
         this.recipientIngredient = param5;
         this.giftItem = param3;
         mail = new Mail();
         mail.message = param2;
         mail.recipientId = param1;
         mail.globalItemIds = new Array();
         if(param3 != null)
         {
            mail.type = RpcClient.MAIL_TYPE_GIFT;
            mail.globalItemIds = [param3.itemConfig.id];
            if(param3.fromInventory)
            {
               mail.itemId = 0;
            }
            else
            {
               mail.itemId = param3.serverUid;
            }
         }
         else if(param4 != null && param5 != null)
         {
            mail.type = RpcClient.MAIL_TYPE_SECURECHANGE;
            mail.globalItemIds[0] = param4.itemConfig.id;
            mail.globalItemIds[1] = param5.itemConfig.id;
         }
         else
         {
            mail.type = RpcClient.MAIL_TYPE_EMAIL;
         }
         Debug.out("mail.type=" + mail.type + " mail.globalItemIds=" + mail.globalItemIds);
      }
      
      private function onSendMailOK(param1:Number) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("onSendMailOK accepted=" + param1);
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      private function onSendMailFail() : void
      {
         Debug.out("onSendMailFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.sendMail(mail,onSendMailOK,onSendMailFail);
         return true;
      }
   }
}


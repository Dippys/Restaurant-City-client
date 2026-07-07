package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.*;
   
   public class RpcGetReceivedMails extends RpcBase
   {
      
      public var mails:Array;
      
      public function RpcGetReceivedMails()
      {
         super();
      }
      
      private function getReceivedMailsOK(param1:Array) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("getReceivedMailsOK " + param1.length);
         this.mails = param1;
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc2_);
         }
      }
      
      private function addNewMail(param1:Mail) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(param1.type == RpcClient.MAIL_TYPE_CASH)
         {
            GameWorld.gameUser.money.value -= parseInt(param1.message);
         }
         else if(Boolean(param1.globalItemIds) && param1.globalItemIds.length > 0)
         {
            _loc2_ = int(param1.globalItemIds[0]);
            _loc3_ = GameWorld.getItemSubType(_loc2_);
            if(_loc3_ == GameUser.PERK_ITEM_TYPE_COIN_REWARD)
            {
               _loc4_ = GameWorld.perkItemDatabase.getItemFromId(_loc2_);
               GameWorld.gameUser.money.value -= parseInt(_loc4_.cost);
            }
            else if(_loc3_ == GameUser.PERK_ITEM_TYPE_DEMAND_REWARD)
            {
               _loc4_ = GameWorld.perkItemDatabase.getItemFromId(_loc2_);
               GameWorld.gameUser.demandPoints.value = Math.max(GameWorld.MIN_DEMAND,GameWorld.gameUser.demandPoints.value - parseInt(_loc4_.value));
            }
         }
         GameWorld.addNewMail(param1);
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.getReceivedMails(getReceivedMailsOK,getReceivedMailsFail);
         return true;
      }
      
      private function getReceivedMailsFail() : void
      {
         Debug.out("getReceivedMailsFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      public function applyData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Mail = null;
         var _loc3_:Mail = null;
         if(mails)
         {
            GameWorld.gameUser.mailItems = new Array();
            _loc1_ = 0;
            while(_loc1_ < mails.length)
            {
               _loc2_ = mails[_loc1_];
               addNewMail(_loc2_);
               _loc1_++;
            }
         }
         if(Debug.TEST_CASH_MAILS > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < Debug.TEST_CASH_MAILS)
            {
               _loc3_ = new Mail();
               _loc3_.type = RpcClient.MAIL_TYPE_CASH;
               _loc3_.sendDate = new Date();
               _loc3_.message = "2000";
               addNewMail(_loc3_);
               _loc1_++;
            }
         }
         if(Debug.TEST_PLAYFISH_MAILS > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < Debug.TEST_PLAYFISH_MAILS)
            {
               _loc3_ = new Mail();
               _loc3_.type = RpcClient.MAIL_TYPE_PLAYFISH;
               _loc3_.sendDate = new Date();
               _loc3_.message = "Test playfish mail yo no." + _loc1_;
               addNewMail(_loc3_);
               _loc1_++;
            }
         }
      }
   }
}


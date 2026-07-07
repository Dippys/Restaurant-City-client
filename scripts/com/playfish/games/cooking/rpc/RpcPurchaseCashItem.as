package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.*;
   
   public class RpcPurchaseCashItem extends RpcBase
   {
      
      public var item:UserItem;
      
      public function RpcPurchaseCashItem(param1:UserItem)
      {
         super();
         this.item = param1;
      }
      
      private function onPurchaseCashItemOK(param1:int, param2:int) : void
      {
         var _loc3_:RpcEvent = null;
         Debug.out("onPurchaseCashItemOK success=" + param1);
         GameWorld.gameUser.playfishCash.value = param2;
         if(GameWorld.cashPanel)
         {
            GameWorld.cashPanel.refresh();
         }
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc3_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc3_.successCode = param1;
            dispatchEvent(_loc3_);
         }
      }
      
      private function onPurchaseCashItemFail() : void
      {
         Debug.out("onPurchaseCashItemFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.purchaseCashItem(item.itemConfig.hash,1,item.getOwnedItem(),false,onPurchaseCashItemOK,onPurchaseCashItemFail);
         return true;
      }
   }
}


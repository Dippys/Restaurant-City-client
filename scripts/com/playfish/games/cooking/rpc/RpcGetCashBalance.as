package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.rpc.cooking.RpcClient;
   
   public class RpcGetCashBalance extends RpcBase
   {
      
      public var playfishCash:int = 0;
      
      public function RpcGetCashBalance()
      {
         super();
      }
      
      private function onGetCashBalanceFail() : void
      {
         Debug.out("onGetCashBalanceFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.getCashBalance(onGetCashBalanceOK,onGetCashBalanceFail);
         return true;
      }
      
      public function applyData() : void
      {
         if(GameWorld.gameUser)
         {
            GameWorld.gameUser.playfishCash.value = playfishCash;
         }
         if(GameWorld.cashPanel)
         {
            GameWorld.cashPanel.refresh();
         }
      }
      
      private function onGetCashBalanceOK(param1:uint) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("onGetCashBalanceOK credits=" + param1);
         this.playfishCash = param1;
         applyData();
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc2_);
         }
      }
   }
}


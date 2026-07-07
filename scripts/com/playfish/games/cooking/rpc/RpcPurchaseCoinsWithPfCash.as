package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   
   public class RpcPurchaseCoinsWithPfCash extends RpcBase
   {
      
      private var token:String;
      
      public function RpcPurchaseCoinsWithPfCash(param1:String)
      {
         super();
         this.token = param1;
      }
      
      private function onPurchaseCoinsWithPfCashOK(param1:uint, param2:uint) : void
      {
         var _loc3_:RpcEvent = null;
         Debug.out("onPurchaseCoinsWithPfCashOK status=" + param1 + " credits=" + param2);
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc3_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc3_.successCode = param1;
            dispatchEvent(_loc3_);
         }
      }
      
      private function onPurchaseCoinsWithPfCashFail() : void
      {
         Debug.out("onPurchaseCoinsWithPfCashFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.purchaseCoinsWithPfCash(token,onPurchaseCoinsWithPfCashOK,onPurchaseCoinsWithPfCashFail);
         return true;
      }
   }
}


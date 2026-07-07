package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   
   public class RpcPurchaseCashItemIngredients extends RpcBase
   {
      
      public var tokens:Array;
      
      public function RpcPurchaseCashItemIngredients(param1:Array)
      {
         super();
         this.tokens = param1;
      }
      
      private function onPurchaseCashItemIngredientsOK(param1:int, param2:int) : void
      {
         var _loc3_:RpcEvent = null;
         Debug.out("onPurchaseCashItemIngredientsOK success=" + param1 + " credit=" + param2);
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
      
      private function onPurchaseCashItemIngredientsFail() : void
      {
         Debug.out("onPurchaseCashItemIngredientsFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.purchaseCashItemIngredients(tokens,onPurchaseCashItemIngredientsOK,onPurchaseCashItemIngredientsFail);
         return true;
      }
   }
}


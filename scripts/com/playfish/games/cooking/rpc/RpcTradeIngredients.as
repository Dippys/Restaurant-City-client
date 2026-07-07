package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   
   public class RpcTradeIngredients extends RpcBase
   {
      
      private var targetUserIngredient:Object;
      
      private var mailId:int;
      
      private var secure:Boolean;
      
      private var userIngredient:Object;
      
      private var targetUserId:NetworkUid;
      
      public function RpcTradeIngredients(param1:NetworkUid, param2:Object, param3:Object, param4:Boolean, param5:int = 0)
      {
         super();
         this.targetUserId = param1;
         this.userIngredient = param2;
         this.targetUserIngredient = param3;
         this.secure = param4;
         this.mailId = param5;
      }
      
      private function onSwapIngredientFail() : void
      {
         Debug.out("onExchangeIngredientFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.swapIngredient(targetUserId,userIngredient.hash,targetUserIngredient.hash,secure,mailId,true,onSwapIngredientOK,onSwapIngredientFail);
         return true;
      }
      
      private function onSwapIngredientOK(param1:Number) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("onExchangeIngredientOK success=" + param1);
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = param1;
            dispatchEvent(_loc2_);
         }
      }
   }
}


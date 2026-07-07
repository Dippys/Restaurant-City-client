package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.*;
   
   public class RpcGetPurchasableItems extends RpcBase
   {
      
      public function RpcGetPurchasableItems()
      {
         super();
      }
      
      private function onGetPurchasableItemsOK(param1:Array) : void
      {
         var _loc3_:RpcEvent = null;
         Debug.out("onGetPurchasableItemsOK " + param1);
         var _loc2_:Number = 0;
         while(_loc2_ < param1.length)
         {
            Debug.out("purchasableItems " + _loc2_ + " skuId " + param1[_loc2_].skuId);
            _loc2_++;
         }
         SkuHandler.purchasableItems = param1;
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc3_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc3_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc3_);
         }
      }
      
      private function onGetPurchasableItemsFail() : void
      {
         Debug.out("onGetPurchasableItemsFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.getPurchasableItems(onGetPurchasableItemsOK,onGetPurchasableItemsFail);
         return true;
      }
   }
}


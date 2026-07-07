package com.playfish.games.cooking.rpc
{
   import com.playfish.coretech.billing.PFBillingSystem;
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.rpc.cooking.RpcClient;
   
   public class RpcGetPricepoints extends RpcBase
   {
      
      private var countryOverride:String;
      
      public function RpcGetPricepoints(param1:String)
      {
         super();
         this.countryOverride = param1;
      }
      
      private function onGetPricepointsOK(param1:Boolean, param2:Array) : void
      {
         var _loc3_:RpcEvent = null;
         Debug.out("onGetPricepointsOK isMaintenance=" + param1 + " pricepoints=" + param2.length);
         if(!param1)
         {
            GameWorld.pricepoints = param2;
            PFBillingSystem.instance.setPricepoints(param2);
         }
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc3_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc3_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc3_);
         }
      }
      
      private function onGetPricepointsFail() : void
      {
         Debug.out("onGetPricepointsFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.getPricepoints(countryOverride,onGetPricepointsOK,onGetPricepointsFail);
         return true;
      }
   }
}


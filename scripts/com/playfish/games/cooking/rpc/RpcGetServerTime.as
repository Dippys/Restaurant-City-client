package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.utils.getTimer;
   
   public class RpcGetServerTime extends RpcBase
   {
      
      public function RpcGetServerTime()
      {
         super();
      }
      
      private function onGetServerTimeOK(param1:Date) : void
      {
         var _loc3_:RpcEvent = null;
         Debug.out("onGetServerTimeOK");
         GameWorld.serverTime = param1;
         GameWorld.localTime = getTimer();
         var _loc2_:Number = GameWorld.getShopWeek(param1.time);
         Debug.out("shop weeks=" + _loc2_ + " prev=" + GameWorld.shopWeeks);
         if(GameWorld.shopWeeks == -1)
         {
            GameWorld.shopWeeks = _loc2_;
         }
         else if(GameWorld.shopWeeks < _loc2_)
         {
         }
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc3_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc3_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc3_);
         }
      }
      
      private function onGetServerTimeFail() : void
      {
         Debug.out("onGetServerTimeFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.getServerTime(onGetServerTimeOK,onGetServerTimeFail);
         return true;
      }
   }
}


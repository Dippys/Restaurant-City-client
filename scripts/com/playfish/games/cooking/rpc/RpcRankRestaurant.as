package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.rpc.share.NetworkUid;
   
   public class RpcRankRestaurant extends RpcBase
   {
      
      private static const MAX_RANK:int = 5;
      
      private static const MIN_RANK:int = 1;
      
      private var userID:NetworkUid;
      
      private var rank:Number = 0;
      
      public function RpcRankRestaurant(param1:NetworkUid, param2:Number)
      {
         super();
         this.userID = param1;
         this.rank = Math.min(MAX_RANK,Math.max(MIN_RANK,param2));
      }
      
      private function onRankRestaurantOK(param1:int) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("onRankRestaurantOK success=" + param1);
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.rankRestaurant(userID,rank,onRankRestaurantOK,onRankRestaurantFail);
         return true;
      }
      
      private function onRankRestaurantFail() : void
      {
         Debug.out("onRankRestaurantFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
   }
}


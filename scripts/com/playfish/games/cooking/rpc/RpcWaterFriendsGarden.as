package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.rpc.share.NetworkUid;
   
   public class RpcWaterFriendsGarden extends RpcBase
   {
      
      private var friendUserId:NetworkUid;
      
      private var gameUserId:NetworkUid;
      
      private var plotId:int;
      
      public function RpcWaterFriendsGarden(param1:NetworkUid, param2:NetworkUid, param3:int)
      {
         super();
         this.friendUserId = param2;
         this.gameUserId = param1;
         this.plotId = param3;
      }
      
      private function onWaterFriendsPlotSuccess(param1:Number) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("onWaterFriendsPlotSuccess success=" + param1);
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      private function onWaterFriendsPlotFail() : void
      {
         var _loc1_:RpcEvent = null;
         Debug.out("onWaterFriendsPlotFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            _loc1_ = new RpcEvent(RpcEvent.FAIL);
            dispatchEvent(_loc1_);
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.waterFriendGarden(gameUserId,friendUserId,plotId,onWaterFriendsPlotSuccess,onWaterFriendsPlotFail);
         return true;
      }
   }
}


package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.RpcClient;

   public class RpcGetHireCandidates extends RpcBase
   {

      public var newUsers:Array;

      private var count:int;

      public function RpcGetHireCandidates(param1:int)
      {
         super();
         count = param1;
      }

      override public function commit() : Boolean
      {
         GameWorld.rpcClient.getHireCandidates(count,onSuccess,onFail);
         return true;
      }

      private function onSuccess(param1:Array) : void
      {
         var _loc2_:int = 0;
         newUsers = new Array();
         while(_loc2_ < param1.length)
         {
            newUsers.push(new GameUser(param1[_loc2_]));
            _loc2_++;
         }
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            dispatchEvent(new RpcEvent(RpcEvent.SUCCESS));
         }
      }

      private function onFail() : void
      {
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
   }
}

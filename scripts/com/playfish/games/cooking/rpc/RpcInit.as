package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   
   public class RpcInit extends RpcBase
   {
      
      public function RpcInit()
      {
         super();
      }
      
      private function onInitSuccess() : void
      {
         Debug.out("onInitSuccess");
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            dispatchEvent(new RpcEvent(RpcEvent.SUCCESS));
         }
      }
      
      private function onInitFail() : void
      {
         Debug.out("onInitFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.init(onInitSuccess,onInitFail);
         return true;
      }
   }
}


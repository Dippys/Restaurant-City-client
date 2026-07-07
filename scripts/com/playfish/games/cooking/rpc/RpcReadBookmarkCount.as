package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   
   public class RpcReadBookmarkCount extends RpcBase
   {
      
      public function RpcReadBookmarkCount()
      {
         super();
      }
      
      private function onReadBookmarkCountOK(param1:Number, param2:Number) : void
      {
         var _loc3_:RpcEvent = null;
         Debug.out("onReadBookmarkCountOK success=" + param1 + " bookmarkCount=" + param2 + " date=" + new Date(param2 * 1000).toString());
         GameWorld.lastBookmarkPopUpTime = param2;
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc3_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc3_.successCode = param1;
            dispatchEvent(_loc3_);
         }
      }
      
      private function onReadBookmarkCountFail() : void
      {
         Debug.out("onReadBookmarkCountFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.readBookmarkCount(onReadBookmarkCountOK,onReadBookmarkCountFail);
         return true;
      }
   }
}


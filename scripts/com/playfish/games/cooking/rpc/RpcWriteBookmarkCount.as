package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   
   public class RpcWriteBookmarkCount extends RpcBase
   {
      
      private var lastBookmarkPopUpTime:int;
      
      public function RpcWriteBookmarkCount(param1:int)
      {
         super();
         this.lastBookmarkPopUpTime = param1;
      }
      
      private function onWriteBookmarkCountOK(param1:Number) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("onWriteBookmarkCountOK success=" + param1);
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      private function onWriteBookmarkCountFail() : void
      {
         Debug.out("onWriteBookmarkCountFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.writeBookmarkCount(lastBookmarkPopUpTime,onWriteBookmarkCountOK,onWriteBookmarkCountFail);
         return true;
      }
   }
}


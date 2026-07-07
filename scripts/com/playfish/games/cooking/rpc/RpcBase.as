package com.playfish.games.cooking.rpc
{
   import flash.events.EventDispatcher;
   
   public class RpcBase extends EventDispatcher
   {
      
      public var priority:int = 0;
      
      public function RpcBase()
      {
         super();
      }
      
      public function commit() : Boolean
      {
         return false;
      }
   }
}


package com.playfish.games.cooking.rpc
{
   import flash.events.Event;
   
   public class RpcEvent extends Event
   {
      
      public static const FAIL:String = "rpc_fail";
      
      public static const SUCCESS:String = "rpc_success";
      
      public var successCode:int;
      
      public function RpcEvent(param1:String)
      {
         super(param1);
      }
   }
}


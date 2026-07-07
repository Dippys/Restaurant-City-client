package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.RpcClient;
   
   public class RpcGetStreetRestaurant extends RpcBase
   {
      
      public var newUsers:Array;
      
      private var count:int;
      
      public function RpcGetStreetRestaurant(param1:int)
      {
         super();
         this.count = param1;
      }
      
      private function onGetStreetRestaurantFail() : void
      {
         Debug.out("onGetStreetRestaurantFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.getRandomStreetUsers(count,onGetStreetRestaurantOK,onGetStreetRestaurantFail);
         return true;
      }
      
      private function onGetStreetRestaurantOK(param1:Array) : void
      {
         var _loc3_:GameUser = null;
         var _loc4_:RpcEvent = null;
         Debug.out("onGetStreetRestaurantOK");
         newUsers = new Array();
         var _loc2_:Number = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new GameUser(param1[_loc2_]);
            _loc3_.addItemsFromProfileObject(param1[_loc2_],GameUser.ITEM_CONTEXT_BUILDING);
            newUsers[_loc2_] = _loc3_;
            _loc2_++;
         }
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc4_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc4_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc4_);
         }
      }
   }
}


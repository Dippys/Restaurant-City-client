package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameUser;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.IngredientItem;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import com.playfish.rpc.cooking.Ingredient;
   
   public class RpcFirstTimeVisitFriend extends RpcBase
   {
      
      private var friendUser:GameUser;
      
      public function RpcFirstTimeVisitFriend(param1:GameUser)
      {
         super();
         this.friendUser = param1;
      }
      
      private function onFirstTimeVisitFriendSuccess(param1:Number, param2:Ingredient) : void
      {
         var _loc3_:Object = null;
         var _loc4_:RpcEvent = null;
         Debug.out("onFirstTimeVisitFriendSuccess success=" + param1 + " ingredient=" + param2.globalItemId);
         if(param2.globalItemId > 0)
         {
            _loc3_ = GameWorld.getItemConfig(param2.globalItemId);
            GameWorld.gameUser.addIngredient(_loc3_,1);
            GameWorld.gameUser.getIngredient(_loc3_).lock = true;
            GameWorld.gameUser.addVisitedFriend(friendUser);
            WorldRestaurantPlay.firstVisitIngredientReward = new IngredientItem(_loc3_);
         }
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc4_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc4_.successCode = param1;
            dispatchEvent(_loc4_);
         }
      }
      
      private function onFirstTimeVisitFriendFail() : void
      {
         var _loc1_:RpcEvent = null;
         Debug.out("onFirstTimeVisitFriendFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            _loc1_ = new RpcEvent(RpcEvent.FAIL);
            dispatchEvent(_loc1_);
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.firstTimeVisitFriend(friendUser.userInfo.id,onFirstTimeVisitFriendSuccess,onFirstTimeVisitFriendFail);
         return true;
      }
   }
}


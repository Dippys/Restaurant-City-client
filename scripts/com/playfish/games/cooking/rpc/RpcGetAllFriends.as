package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.*;
   
   public class RpcGetAllFriends extends RpcBase
   {
      
      public var scores:Array;
      
      public function RpcGetAllFriends()
      {
         super();
      }
      
      public function getScoresFail() : void
      {
         var _loc1_:int = 0;
         Debug.out("getScoresFail");
         if(!Debug.NETWORK_ONLY)
         {
            scores = new Array();
            _loc1_ = 0;
            while(_loc1_ < 20)
            {
               scores[_loc1_] = GameWorld.getDummyUserInfo(_loc1_);
               _loc1_++;
            }
         }
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.getAllFriends(getScoresOK,getScoresFail);
         return true;
      }
      
      public function applyData() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(scores)
         {
            _loc1_ = uint(RpcClient.USER_CONTEXT_FRIENDS | RpcClient.TIME_CONTEXT_ALL);
            GameWorld.cachedGameUsers[_loc1_] = new Array();
            _loc2_ = 0;
            while(_loc2_ < scores.length)
            {
               GameWorld.cachedGameUsers[_loc1_][_loc2_] = new GameUser(scores[_loc2_]);
               _loc2_++;
            }
            _loc3_ = GameWorld.getUserProfileIndex(scores);
            if(_loc3_ != -1)
            {
               GameWorld.cachedGameUsers[_loc1_][_loc3_] = GameWorld.gameUser;
            }
            GameWorld.gameUser.setEmployeesFromProfile(GameWorld.gameUser.userInfo);
         }
      }
      
      public function getScoresOK(param1:Array) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("getScoresOK");
         this.scores = param1;
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc2_);
         }
      }
   }
}


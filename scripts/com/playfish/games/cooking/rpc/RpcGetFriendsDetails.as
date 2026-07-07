package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   
   public class RpcGetFriendsDetails extends RpcBase
   {
      
      private var forceReload:Boolean;
      
      private var gameUsers:Array;
      
      private var itemContext:int;
      
      public function RpcGetFriendsDetails(param1:Array, param2:int, param3:Boolean)
      {
         super();
         this.gameUsers = param1;
         this.itemContext = param2;
         this.forceReload = param3;
      }
      
      private function getFriendsDetailsFail(param1:Array, param2:int) : void
      {
         Debug.out("getFriendsDetailsFail");
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            param1[_loc3_].loadingItemContext &= ~param2;
            _loc3_++;
         }
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         var gameUsersToLoad:Array = null;
         var curUser:GameUser = null;
         var uids:Array = null;
         gameUsersToLoad = new Array();
         var i:Number = 0;
         while(i < gameUsers.length)
         {
            curUser = gameUsers[i];
            if(curUser.userInfo.playCount > 0 && (forceReload || curUser.needLoadItemContext(itemContext)))
            {
               curUser.loadingItemContext |= itemContext;
               gameUsersToLoad.push(curUser);
            }
            i++;
         }
         if(gameUsersToLoad.length > 0)
         {
            uids = new Array(gameUsersToLoad.length);
            i = 0;
            while(i < uids.length)
            {
               uids[i] = gameUsersToLoad[i].userInfo.id;
               i++;
            }
            GameWorld.rpcClient.getUsers(itemContext,uids,function(param1:Array):void
            {
               getFriendsDetailsOk(gameUsersToLoad,param1,itemContext);
            },function():void
            {
               getFriendsDetailsFail(gameUsersToLoad,itemContext);
            });
            return true;
         }
         return false;
      }
      
      private function getFriendsDetailsOk(param1:Array, param2:Array, param3:int) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:GameUser = null;
         var _loc7_:RpcEvent = null;
         Debug.out("getFriendsDetailsOk");
         var _loc4_:Number = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc6_ = param1[_loc5_];
               if(NetworkUid.areEqual(param2[_loc4_].id,_loc6_.userInfo.id))
               {
                  if(_loc6_.userInfo == null || _loc6_.firstName.length == 0 || (param3 & GameUser.ITEM_CONTEXT_RESTAURANT) != 0)
                  {
                     _loc6_.setProfile(param2[_loc4_]);
                  }
                  _loc6_.loadingItemContext &= ~param3;
                  _loc6_.addItemsFromProfileObject(param2[_loc4_],param3);
                  break;
               }
               _loc5_++;
            }
            _loc4_++;
         }
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc7_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc7_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc7_);
         }
      }
   }
}


package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   
   public class RpcRequestManager extends RpcBase
   {
      
      private static var activeRequests:Array = new Array();
      
      private var retryCount:int = 0;
      
      public var maxRetryCount:int = 2;
      
      public var keepLoadingPopUpOnSuccess:Boolean = false;
      
      public var hideRetryCancel:Boolean = false;
      
      public var retryCancelCallBack:Function;
      
      private var rpcQueue:Array = new Array();
      
      public var loadingPopUp:WorldLoadingPopUp = null;
      
      public var retryText:String = null;
      
      private var batchMode:int;
      
      public function RpcRequestManager(param1:int = 2)
      {
         super();
         this.batchMode = param1;
      }
      
      public function getCashBalance() : RpcGetCashBalance
      {
         var _loc1_:RpcGetCashBalance = new RpcGetCashBalance();
         addRequest(_loc1_);
         return _loc1_;
      }
      
      public function readBookmarkCount() : RpcReadBookmarkCount
      {
         var _loc1_:RpcReadBookmarkCount = new RpcReadBookmarkCount();
         addRequest(_loc1_);
         return _loc1_;
      }
      
      public function getGourmetStreetUsers(param1:int) : RpcGetGourmetStreetUsers
      {
         var _loc2_:RpcGetGourmetStreetUsers = new RpcGetGourmetStreetUsers(param1);
         addRequest(_loc2_);
         return _loc2_;
      }
      
      public function getReceivedMails() : RpcGetReceivedMails
      {
         var _loc1_:RpcGetReceivedMails = new RpcGetReceivedMails();
         addRequest(_loc1_);
         return _loc1_;
      }
      
      public function addRequest(param1:RpcBase) : void
      {
         var _loc2_:Number = 0;
         while(_loc2_ < rpcQueue.length)
         {
            if(param1.priority < rpcQueue[_loc2_].priority)
            {
               rpcQueue.splice(_loc2_,0,param1);
               break;
            }
            _loc2_++;
         }
         if(_loc2_ == rpcQueue.length)
         {
            rpcQueue.push(param1);
         }
      }
      
      public function rankRestaurant(param1:NetworkUid, param2:Number) : RpcRankRestaurant
      {
         var _loc3_:RpcRankRestaurant = new RpcRankRestaurant(param1,param2);
         addRequest(_loc3_);
         return _loc3_;
      }
      
      public function purchaseCashItemIngredients(param1:Array) : RpcPurchaseCashItemIngredients
      {
         var _loc2_:RpcPurchaseCashItemIngredients = new RpcPurchaseCashItemIngredients(param1);
         addRequest(_loc2_);
         return _loc2_;
      }
      
      private function onRetryOk() : void
      {
         if(loadingPopUp != null)
         {
            loadingPopUp.show();
         }
         doCommit();
      }
      
      public function clear() : void
      {
         rpcQueue.splice(0,rpcQueue.length);
         retryCount = 0;
      }
      
      public function init() : RpcInit
      {
         var _loc1_:RpcInit = new RpcInit();
         addRequest(_loc1_);
         return _loc1_;
      }
      
      private function onLastRpcSuccess(param1:RpcEvent) : void
      {
         Debug.out("RpcRequestManager onLastRpcSuccess");
         if(loadingPopUp != null && !keepLoadingPopUpOnSuccess)
         {
            loadingPopUp.remove();
         }
         clear();
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            dispatchEvent(new RpcEvent(RpcEvent.SUCCESS));
         }
         onComplete();
      }
      
      private function onLastRpcFail(param1:RpcEvent) : void
      {
         var _loc2_:WorldRetryPopUp = null;
         Debug.out("RpcRequestManager onLastRpcFail retry=" + retryCount);
         if(retryCount > maxRetryCount)
         {
            if(loadingPopUp != null)
            {
               loadingPopUp.remove();
            }
            retryCount = 0;
            if(hasEventListener(RpcEvent.FAIL))
            {
               dispatchEvent(new RpcEvent(RpcEvent.FAIL));
            }
            if(retryText != null)
            {
               _loc2_ = new WorldRetryPopUp(retryText,onRetryOk,onRetryCancel,hideRetryCancel);
               _loc2_.show();
            }
            else
            {
               onComplete();
            }
         }
         else
         {
            doCommit();
         }
      }
      
      public function getStreetRestaurant(param1:int) : RpcGetStreetRestaurant
      {
         var _loc2_:RpcGetStreetRestaurant = new RpcGetStreetRestaurant(param1);
         addRequest(_loc2_);
         return _loc2_;
      }
      
      public function purchaseCoinsWithPfCash(param1:String) : RpcPurchaseCoinsWithPfCash
      {
         var _loc2_:RpcPurchaseCoinsWithPfCash = new RpcPurchaseCoinsWithPfCash(param1);
         addRequest(_loc2_);
         return _loc2_;
      }
      
      public function getPurchasableItems() : RpcGetPurchasableItems
      {
         var _loc1_:RpcGetPurchasableItems = new RpcGetPurchasableItems();
         addRequest(_loc1_);
         return _loc1_;
      }
      
      public function writeBookmarkCount(param1:int) : RpcWriteBookmarkCount
      {
         var _loc2_:RpcWriteBookmarkCount = new RpcWriteBookmarkCount(param1);
         addRequest(_loc2_);
         return _loc2_;
      }
      
      public function getLength() : int
      {
         return rpcQueue.length;
      }
      
      private function doCommit() : void
      {
         Debug.out("doCommit");
         ++retryCount;
         var _loc1_:RpcBase = rpcQueue[rpcQueue.length - 1];
         _loc1_.addEventListener(RpcEvent.SUCCESS,onLastRpcSuccess);
         _loc1_.addEventListener(RpcEvent.FAIL,onLastRpcFail);
         var _loc2_:int = 0;
         GameWorld.rpcClient.beginBatch(batchMode);
         var _loc3_:Number = 0;
         while(_loc3_ < rpcQueue.length)
         {
            if(rpcQueue[_loc3_].commit())
            {
               _loc2_++;
            }
            _loc3_++;
         }
         GameWorld.rpcClient.endBatch();
         if(_loc2_ == 0)
         {
            onLastRpcSuccess(null);
         }
      }
      
      public function getFriendsDetails(param1:Array, param2:int, param3:Boolean = false) : RpcGetFriendsDetails
      {
         var _loc4_:RpcGetFriendsDetails = new RpcGetFriendsDetails(param1,param2,param3);
         addRequest(_loc4_);
         return _loc4_;
      }
      
      public function sendMail(param1:NetworkUid, param2:String, param3:GameItemObject, param4:IngredientItem = null, param5:IngredientItem = null) : RpcSendMail
      {
         var _loc6_:RpcSendMail = new RpcSendMail(param1,param2,param3,param4,param5);
         addRequest(_loc6_);
         return _loc6_;
      }
      
      public function getUserProfile() : RpcGetUserProfile
      {
         var _loc1_:RpcGetUserProfile = new RpcGetUserProfile();
         addRequest(_loc1_);
         return _loc1_;
      }
      
      public function getServerTime() : RpcGetServerTime
      {
         var _loc1_:RpcGetServerTime = new RpcGetServerTime();
         addRequest(_loc1_);
         return _loc1_;
      }
      
      public function replyQuiz(param1:int, param2:Object, param3:Boolean) : RpcReplyQuiz
      {
         var _loc4_:RpcReplyQuiz = new RpcReplyQuiz(param1,param2,param3);
         addRequest(_loc4_);
         return _loc4_;
      }
      
      public function getAllFriends() : RpcGetAllFriends
      {
         var _loc1_:RpcGetAllFriends = new RpcGetAllFriends();
         addRequest(_loc1_);
         return _loc1_;
      }
      
      private function onRetryCancel() : void
      {
         onComplete();
         if(retryCancelCallBack != null)
         {
            retryCancelCallBack();
         }
      }
      
      public function purchaseCashItem(param1:UserItem) : RpcPurchaseCashItem
      {
         var _loc2_:RpcPurchaseCashItem = new RpcPurchaseCashItem(param1);
         addRequest(_loc2_);
         return _loc2_;
      }
      
      public function getPricepoints(param1:String) : RpcGetPricepoints
      {
         var _loc2_:RpcGetPricepoints = new RpcGetPricepoints(param1);
         addRequest(_loc2_);
         return _loc2_;
      }
      
      override public function commit() : Boolean
      {
         if(rpcQueue.length > 0)
         {
            if(loadingPopUp != null)
            {
               loadingPopUp.show();
            }
            activeRequests.push(this);
            if(activeRequests.length == 1)
            {
               doCommit();
            }
            return true;
         }
         return false;
      }
      
      private function onComplete() : void
      {
         activeRequests.splice(activeRequests.indexOf(this),1);
         if(activeRequests.length > 0)
         {
            activeRequests[0].doCommit();
         }
      }
      
      public function firstTimeVisitFriend(param1:GameUser) : RpcFirstTimeVisitFriend
      {
         var _loc2_:RpcFirstTimeVisitFriend = new RpcFirstTimeVisitFriend(param1);
         addRequest(_loc2_);
         return _loc2_;
      }
      
      public function tradeIngredients(param1:NetworkUid, param2:Object, param3:Object, param4:Boolean, param5:int = 0) : RpcTradeIngredients
      {
         var _loc6_:RpcTradeIngredients = new RpcTradeIngredients(param1,param2,param3,param4,param5);
         addRequest(_loc6_);
         return _loc6_;
      }
      
      public function waterFriendsPlot(param1:NetworkUid, param2:NetworkUid, param3:int) : RpcWaterFriendsGarden
      {
         var _loc4_:RpcWaterFriendsGarden = new RpcWaterFriendsGarden(param1,param2,param3);
         addRequest(_loc4_);
         return _loc4_;
      }
   }
}


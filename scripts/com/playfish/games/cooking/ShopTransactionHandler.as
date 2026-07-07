package com.playfish.games.cooking
{
   import com.playfish.games.cooking.rpc.RpcBase;
   import com.playfish.games.cooking.rpc.RpcEvent;
   import com.playfish.games.cooking.ui.WorldLoadingPopUp;
   import com.playfish.rpc.cooking.RpcClient;
   
   public class ShopTransactionHandler extends RpcBase
   {
      
      private var loadingPopUp:WorldLoadingPopUp;
      
      public function ShopTransactionHandler()
      {
         super();
      }
      
      override public function commit() : Boolean
      {
         GameWorld.saveProfileHandler.addEventListener(RpcEvent.SUCCESS,onSuccess,false,0,true);
         GameWorld.saveProfileHandler.addEventListener(RpcEvent.FAIL,onFail,false,0,true);
         GameWorld.globalRpcs.loadingPopUp = new WorldLoadingPopUp("Saving...",WorldLoadingPopUp.SAVING);
         GameWorld.globalRpcs.retryText = GameWorld.textHandler.getTextFromId("SaveDecorationRetryText");
         GameWorld.globalRpcs.retryCancelCallBack = onRetryCancel;
         if(GameWorld.commitGlobalRpcs())
         {
            return true;
         }
         return false;
      }
      
      public function addChangedItem(param1:UserItem, param2:Boolean) : void
      {
         GameWorld.saveProfileHandler.moveItem(param1,param2);
      }
      
      public function addSoldItem(param1:UserItem, param2:int, param3:Boolean) : void
      {
         GameWorld.saveProfileHandler.sellItem(param1,param2,param3);
      }
      
      public function hasChanges() : Boolean
      {
         return GameWorld.saveProfileHandler.hasItemsChanged();
      }
      
      private function onRetryCancel() : void
      {
         GameWorld.error();
      }
      
      private function onSuccess(param1:RpcEvent) : void
      {
         Debug.out("ShopTransactionHandler onSuccess");
         if(Debug.NETWORK_ONLY && param1.successCode == RpcClient.STATUS_SAVE_FAIL)
         {
            GameWorld.error();
         }
         else if(hasEventListener(RpcEvent.SUCCESS))
         {
            dispatchEvent(new RpcEvent(RpcEvent.SUCCESS));
         }
      }
      
      private function onFail(param1:RpcEvent) : void
      {
         Debug.out("ShopTransactionHandler onFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      public function addBoughtItem(param1:UserItem) : void
      {
         GameWorld.saveProfileHandler.purchaseItem(param1);
      }
      
      public function saveFloor(param1:int) : void
      {
         GameWorld.saveProfileHandler.saveRestaurantFloor(param1);
      }
   }
}


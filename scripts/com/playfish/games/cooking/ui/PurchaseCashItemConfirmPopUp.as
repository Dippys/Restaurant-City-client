package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PurchaseCashItemConfirmPopUp extends WorldPopUp
   {
      
      private var item:UserItem;
      
      private var successCallBack:Function;
      
      private var cancelCallBack:Function;
      
      public function PurchaseCashItemConfirmPopUp(param1:UserItem, param2:Function = null, param3:Function = null)
      {
         super(null,null,null);
         this.item = param1;
         this.successCallBack = param2;
         this.cancelCallBack = param3;
         var _loc4_:MovieClip = Engine.getMovieClip("PfCashConfirmAnim");
         addChild(_loc4_);
         var _loc5_:MovieClip = _loc4_.mc_content;
         ItemChooser.setItemOnIconButton(param1.itemConfig,_loc5_.mc_item);
         GameWorld.textHandler.setReplaceString("ItemName",param1.itemConfig.name);
         GameWorld.textHandler.setReplaceString("ItemPrice",param1.itemConfig.cash);
         GameWorld.textHandler.setTextFieldWithId(_loc5_.tf_text,"BuyItemWithPlayfishCash",true);
         setButtonMode(_loc5_.mc_tick,true);
         setButtonMode(_loc5_.mc_cancel,true);
         _loc5_.mc_tick.addEventListener(MouseEvent.CLICK,onPurchaseCashItemTickClick,false,0,true);
         _loc5_.mc_cancel.addEventListener(MouseEvent.CLICK,onPurchaseCashItemCancelClick,false,0,true);
      }
      
      private function onPurchaseCashItemTickClick(param1:MouseEvent) : void
      {
         var _loc3_:RpcRequestManager = null;
         remove();
         var _loc2_:WorldLoadingPopUp = new WorldLoadingPopUp("Purchasing...",WorldLoadingPopUp.PURCHASE_CASH_ITEM);
         _loc3_ = new RpcRequestManager();
         _loc3_.loadingPopUp = _loc2_;
         _loc3_.retryText = GameWorld.textHandler.getTextFromId("PurchaseCashItemRetryText");
         _loc3_.hideRetryCancel = true;
         var _loc4_:RpcPurchaseCashItem = _loc3_.purchaseCashItem(item);
         _loc4_.addEventListener(RpcEvent.SUCCESS,onPurchaseCashItemSuccess,false,0,true);
         _loc3_.commit();
      }
      
      private function onPurchaseCashItemCancelClick(param1:MouseEvent) : void
      {
         remove();
         if(cancelCallBack != null)
         {
            cancelCallBack(-1);
         }
      }
      
      private function onPurchaseCashItemSuccess(param1:RpcEvent) : void
      {
         var _loc2_:WorldInfoPopUp = null;
         if(param1.successCode == RpcClient.STATUS_OK || param1.successCode == RpcClient.PURCHASE_CASH_ITEM_EXISTS)
         {
            if(successCallBack != null)
            {
               successCallBack(param1.successCode);
            }
         }
         else
         {
            if(param1.successCode == RpcClient.STATUS_NOT_ENOUGH_CASH)
            {
               _loc2_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("NotEnoughPlayfishCashToBuyItem"));
            }
            else if(param1.successCode == RpcClient.STATUS_INVALID_TOKEN)
            {
               _loc2_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("ErrorBuyingPlayfishCashItem"));
            }
            else if(param1.successCode == RpcClient.STATUS_SHARD_OFFLINE)
            {
               _loc2_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("UserMaintenance"));
            }
            _loc2_.show();
            if(cancelCallBack != null)
            {
               cancelCallBack(param1.successCode);
            }
         }
      }
   }
}


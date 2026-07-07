package com.playfish.games.cooking.ui.bank
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.rpc.RpcEvent;
   import com.playfish.games.cooking.rpc.RpcPurchaseCoinsWithPfCash;
   import com.playfish.games.cooking.rpc.RpcRequestManager;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldConfirmConvert extends WorldPopUp
   {
      
      public static const BAG_SMALL:int = 0;
      
      public static const BAG_BIG:int = 1;
      
      private var itemConfig:Object;
      
      public function WorldConfirmConvert(param1:Object, param2:int)
      {
         super(null,null,null);
         this.itemConfig = param1;
         var _loc3_:MovieClip = Engine.getMovieClip("ConvertConfirmationAnim");
         addChild(_loc3_);
         var _loc4_:MovieClip = _loc3_.mc_content;
         GameWorld.textHandler.setReplaceString("PlayfishCash",param1.cash);
         GameWorld.textHandler.setReplaceString("Coins",param1.cost);
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_text,"ConvertPlayfishCashToCoins",true);
         setButtonMode(_loc4_.mc_tick,true);
         setButtonMode(_loc4_.mc_cancel,true);
         _loc4_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
         _loc4_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         if(param2 == BAG_SMALL)
         {
            _loc4_.mc_bagBig.visible = false;
            _loc4_.mc_bagSmall.tf_coins.text = param1.cost;
            _loc4_.mc_bagSmall.tf_pfCash.text = param1.cash;
         }
         else if(param2 == BAG_BIG)
         {
            _loc4_.mc_bagSmall.visible = false;
            _loc4_.mc_bagBig.tf_coins.text = param1.cost;
            _loc4_.mc_bagBig.tf_pfCash.text = param1.cash;
         }
      }
      
      private function onPurchaseCoinsWithPfCashSuccess(param1:RpcEvent) : void
      {
         var _loc2_:WorldInfoPopUp = null;
         if(param1.successCode == RpcClient.STATUS_OK)
         {
            GameWorld.cashPanel.addCoins(itemConfig.cost);
            GameWorld.cashPanel.showPlayfishCashPopUp(-itemConfig.cash);
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
         }
         remove();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:WorldBankPaymentProvider = new WorldBankPaymentProvider(WorldBankPaymentProvider.PRODUCT_TYPE_COIN);
         _loc2_.show();
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldLoadingPopUp = null;
         _loc2_ = new WorldLoadingPopUp("Purchasing...",WorldLoadingPopUp.PURCHASE_CASH_ITEM);
         _loc2_.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.y = GameWorld.CANVAS_CENTER_Y;
         var _loc3_:RpcRequestManager = new RpcRequestManager();
         _loc3_.loadingPopUp = _loc2_;
         _loc3_.maxRetryCount = 0;
         var _loc4_:RpcPurchaseCoinsWithPfCash = _loc3_.purchaseCoinsWithPfCash(itemConfig.hash);
         _loc4_.addEventListener(RpcEvent.SUCCESS,onPurchaseCoinsWithPfCashSuccess,false,0,true);
         _loc4_.addEventListener(RpcEvent.FAIL,onPurchaseCoinsWithPfCashFail,false,0,true);
         _loc3_.getCashBalance();
         _loc3_.commit();
      }
      
      private function onPurchaseCoinsWithPfCashFail(param1:RpcEvent) : void
      {
         GameWorld.error();
      }
   }
}


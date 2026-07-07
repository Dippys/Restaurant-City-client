package com.playfish.games.cooking.ui.bank
{
   import com.playfish.external.*;
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.rpc.RpcGetCashBalance;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.share.Pricepoint;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.*;
   
   public class WorldBankPaymentAgreement extends WorldPopUp
   {
      
      public static const BACK_TO_NONE:int = -1;
      
      public static const BACK_TO_PAYMENT_OPTIONS:int = 0;
      
      public static const BACK_TO_PAYMENT_PROVIDERS:int = 1;
      
      private var backTo:int = 0;
      
      private var pricepoint:Pricepoint;
      
      private var scene:MovieClip;
      
      private var tickBox:MovieClip;
      
      private var saveGameEnabled:Boolean;
      
      public function WorldBankPaymentAgreement(param1:Pricepoint, param2:int = 0)
      {
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         super(null,null,null);
         this.backTo = param2;
         this.pricepoint = param1;
         _loc3_ = WorldBankPaymentProvider.getPaymentProviderIndex(param1);
         if(_loc3_ == Pricepoint.PAYMENT_PROVIDER_SUPERREWARDS)
         {
            scene = Engine.getMovieClip("BankAgreementPopupSuperRewards");
         }
         else
         {
            scene = Engine.getMovieClip("BankAgreementPopup");
         }
         addChild(scene);
         _loc4_ = scene.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_text,WorldBankPaymentProvider.PAYMENT_PROVIDER_AGREEMENT_TEXTS[_loc3_],true);
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_tos,"BillingTOS",true);
         if(param1.productType == WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH)
         {
            _loc5_ = Engine.getMovieClip("PaymentCashMethodButton");
         }
         else
         {
            _loc5_ = Engine.getMovieClip("PaymentMethodButton");
         }
         _loc5_.x = _loc4_.mc_pay.x;
         _loc5_.y = _loc4_.mc_pay.y;
         _loc5_.scaleX = _loc4_.mc_pay.scaleX;
         _loc5_.scaleY = _loc4_.mc_pay.scaleY;
         _loc4_.addChild(_loc5_);
         _loc4_.mc_pay.stop();
         _loc4_.mc_pay.visible = false;
         WorldBankPaymentProvider.setupPaymentProviderButton(_loc3_,_loc5_);
         setButtonMode(_loc5_,true);
         _loc5_.addEventListener(MouseEvent.CLICK,onPayClick,false,0,true);
         tickBox = _loc4_.mc_tick;
         _loc4_.mc_tick.buttonMode = true;
         _loc4_.mc_tick.stop();
         _loc4_.mc_tick.addEventListener(MouseEvent.MOUSE_DOWN,onTickMouseDown,false,0,true);
         setButtonMode(_loc4_.mc_cancel,true);
         _loc4_.mc_cancel.addEventListener(MouseEvent.CLICK,onBackClick,false,0,true);
      }
      
      private function onBackClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:WorldBankPaymentOption = null;
         var _loc4_:WorldBankPaymentProvider = null;
         remove();
         switch(backTo)
         {
            case BACK_TO_PAYMENT_OPTIONS:
               _loc2_ = WorldBankPaymentProvider.getPaymentProviderIndex(pricepoint);
               _loc3_ = new WorldBankPaymentOption(_loc2_,pricepoint.productType);
               _loc3_.show();
               break;
            case BACK_TO_PAYMENT_PROVIDERS:
               _loc4_ = new WorldBankPaymentProvider(pricepoint.productType);
               _loc4_.show();
         }
      }
      
      public function openPricepoint(param1:Pricepoint) : void
      {
         var _loc3_:ExternalPage = null;
         var _loc4_:URLRequest = null;
         var _loc2_:Boolean = false;
         if(Boolean(param1.clientData) && param1.clientData["overlay"] != null)
         {
            _loc2_ = true;
         }
         Engine.setFullScreen(false);
         if(_loc2_)
         {
            _loc3_ = new ExternalPage(param1.clientData["overlay"]);
            _loc4_ = param1.getPurchaseLink();
            _loc3_.show(_loc4_.url + "?" + _loc4_.data);
            _loc3_.addEventListener(ExternalPageEvent.COMPLETE,onExternalPageComplete);
            saveGameEnabled = GameWorld.settingOverlay.saveButtonVisible();
            GameWorld.settingOverlay.hideSaveButton();
         }
         else
         {
            _loc4_ = param1.getPurchaseLink();
            if(_loc4_ != null)
            {
               navigateToURL(_loc4_,"_top");
            }
         }
      }
      
      private function onExternalPageComplete(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(ExternalPageEvent.COMPLETE,onExternalPageComplete);
         remove();
         if(pricepoint.productType == WorldBankPaymentProvider.PRODUCT_TYPE_COIN)
         {
            GameWorld.forceAutoSave();
         }
         else
         {
            new RpcGetCashBalance().commit();
            GameWorld.globalRpcs.getCashBalance();
         }
         if(saveGameEnabled)
         {
            GameWorld.settingOverlay.showSaveButton();
         }
      }
      
      private function onTickMouseDown(param1:MouseEvent) : void
      {
         if(tickBox.currentLabel == "tick")
         {
            tickBox.gotoAndStop("untick");
         }
         else
         {
            tickBox.gotoAndStop("tick");
         }
      }
      
      private function onPayClick(param1:MouseEvent) : void
      {
         if(tickBox.currentLabel == "tick")
         {
            openPricepoint(pricepoint);
            removeChild(scene);
         }
      }
   }
}


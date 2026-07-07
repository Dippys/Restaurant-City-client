package com.playfish.games.cooking.ui.bank
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.share.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   
   public class WorldBankPaymentOption extends WorldPopUp
   {
      
      private static const WHAT_IS_FACEBOOK_CREDITS_URL:String = "http://www.facebook.com/help.php?page=837";
      
      private static const FACEBOOK_CREDITS_CURRENCY:String = "zzf";
      
      private var provider:int;
      
      private var coinType:int;
      
      private var scene:MovieClip;
      
      public function WorldBankPaymentOption(param1:int, param2:int)
      {
         var _loc3_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Pricepoint = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:URLVariables = null;
         var _loc11_:String = null;
         var _loc12_:MovieClip = null;
         super(null,null,null);
         this.provider = param1;
         this.coinType = param2;
         scene = Engine.getMovieClip("BankMenuAmountPopup");
         addChild(scene);
         _loc3_ = scene.mc_content;
         GameWorld.textHandler.setReplaceString("PaymentProvider",WorldBankPaymentProvider.PAYMENT_PROVIDER_DISPLAY_NAMES[param1]);
         if(param2 == WorldBankPaymentProvider.PRODUCT_TYPE_COIN)
         {
            GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_title,"AddCoinsWith");
         }
         else if(param2 == WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH)
         {
            GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_title,"AddPlayfishCashWith");
         }
         if(param1 == Pricepoint.PAYMENT_PROVIDER_FACEBOOK)
         {
            setButtonMode(_loc3_.mc_facebook,true);
            _loc3_.mc_facebook.addEventListener(MouseEvent.CLICK,onWhatIsFacebookCreditsClick,false,0,true);
         }
         else
         {
            _loc3_.mc_facebook.stop();
            _loc3_.mc_facebook.visible = false;
         }
         var _loc4_:Array = WorldBankPaymentProvider.getPricepoints(param2,param1);
         var _loc5_:Number = 0;
         while(_loc5_ < 5)
         {
            _loc6_ = _loc3_["mc_panel" + _loc5_];
            _loc6_.visible = false;
            if(_loc5_ < _loc4_.length)
            {
               _loc7_ = _loc4_[_loc5_];
               _loc8_ = WorldBankPaymentProvider.getPaymentProviderIndex(_loc7_);
               _loc9_ = addCommaToCoins(_loc7_.payoutParameter);
               GameWorld.textHandler.setReplaceString("coins",_loc9_);
               if(_loc7_.clientData)
               {
                  _loc10_ = _loc7_.clientData;
               }
               else
               {
                  _loc10_ = new URLVariables();
               }
               _loc11_ = _loc10_["type"];
               if(_loc7_.productType == WorldBankPaymentProvider.PRODUCT_TYPE_COIN)
               {
                  if(_loc11_ == "cc" && _loc10_["cc_type"] == "movieticket")
                  {
                     _loc12_ = Engine.getMovieClip("PaymentAmountButton2");
                     _loc12_.mc_content.mc_text2.mouseEnabled = false;
                  }
                  else
                  {
                     _loc12_ = Engine.getMovieClip("PaymentButtonCoin");
                  }
               }
               else
               {
                  _loc12_ = Engine.getMovieClip("PaymentButtonCash");
               }
               _loc12_.pricepoint = _loc7_;
               if(_loc11_ == "survey")
               {
                  _loc12_.mc_content.mc_text.visible = false;
                  if(_loc7_.productType == WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH)
                  {
                     GameWorld.textHandler.setTextFieldWithId(_loc12_.mc_content.mc_textLong,"TrialPayPlayfishCashByCompletingASurvey");
                  }
                  else
                  {
                     GameWorld.textHandler.setTextFieldWithId(_loc12_.mc_content.mc_textLong,"TrialPayCoinsByCompletingASurvey");
                  }
               }
               else if(_loc11_ == "offer")
               {
                  _loc12_.mc_content.mc_text.visible = false;
                  if(_loc7_.productType == WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH)
                  {
                     GameWorld.textHandler.setTextFieldWithId(_loc12_.mc_content.mc_textLong,"TrialPayEarnPlayfishCashByTryingOrBuyingAnOffer");
                  }
                  else
                  {
                     GameWorld.textHandler.setTextFieldWithId(_loc12_.mc_content.mc_textLong,"TrialPayEarnCoinsByTryingOrBuyingAnOffer");
                  }
               }
               else if(_loc11_ == "gamercard")
               {
                  _loc12_.mc_content.mc_text.visible = false;
                  GameWorld.textHandler.setReplaceString("cash",(_loc7_.price / _loc7_.currencyScale).toFixed(_loc7_.currencyScale.toString().length - 1));
                  GameWorld.textHandler.setReplaceString("currency",_loc7_.currency);
                  GameWorld.textHandler.setTextFieldWithId(_loc12_.mc_content.mc_textLong,"CoinsWithUltimateGamerCard");
               }
               else
               {
                  if(_loc12_.mc_content.mc_textLong)
                  {
                     _loc12_.mc_content.mc_textLong.visible = false;
                  }
                  if(_loc7_.price == 0)
                  {
                     if(param2 == WorldBankPaymentProvider.PRODUCT_TYPE_COIN)
                     {
                        GameWorld.textHandler.setTextFieldWithId(_loc12_.mc_content.mc_text,"NumberOfCoins");
                     }
                     else if(param2 == WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH)
                     {
                        GameWorld.textHandler.setTextFieldWithId(_loc12_.mc_content.mc_text,"NumberOfPlayfishCash");
                     }
                  }
                  else
                  {
                     GameWorld.textHandler.setReplaceString("cash",(_loc7_.price / _loc7_.currencyScale).toFixed(_loc7_.currencyScale.toString().length - 1));
                     if(_loc7_.currency.toLowerCase() == FACEBOOK_CREDITS_CURRENCY)
                     {
                        GameWorld.textHandler.setReplaceString("currency","FbC");
                     }
                     else
                     {
                        GameWorld.textHandler.setReplaceString("currency",_loc7_.currency);
                     }
                     GameWorld.textHandler.setTextFieldWithId(_loc12_.mc_content.mc_text,"CoinsWithCash");
                  }
               }
               _loc12_.mc_content.mc_text.mouseEnabled = false;
               if(_loc12_.mc_content.mc_textLong)
               {
                  _loc12_.mc_content.mc_textLong.mouseEnabled = false;
               }
               _loc12_.x = _loc6_.x;
               _loc12_.y = _loc6_.y;
               _loc12_.scaleX = _loc6_.scaleX;
               _loc12_.scaleY = _loc6_.scaleY;
               setButtonMode(_loc12_,true);
               _loc12_.addEventListener(MouseEvent.CLICK,onPaymentClick,false,0,true);
               _loc3_.addChild(_loc12_);
            }
            _loc5_++;
         }
         setButtonMode(_loc3_.mc_cancel,true);
         _loc3_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
      }
      
      private function onWhatIsFacebookCreditsClick(param1:MouseEvent) : void
      {
         GameWorld.openUrl(WHAT_IS_FACEBOOK_CREDITS_URL);
      }
      
      private function onPaymentClick(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:WorldBankPaymentAgreement = new WorldBankPaymentAgreement(param1.currentTarget.pricepoint);
         _loc2_.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.y = GameWorld.CANVAS_CENTER_Y;
         _loc2_.show();
      }
      
      private function addCommaToCoins(param1:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc2_:String = param1.toString();
         if(_loc2_.length > 3)
         {
            _loc3_ = _loc2_.substr(_loc2_.length - 3,3);
            _loc4_ = _loc2_.length - 3;
            while(_loc4_ > 0)
            {
               _loc3_ = _loc2_.substring(Math.max(0,_loc4_ - 3),_loc4_) + "," + _loc3_;
               _loc4_ -= 3;
            }
            return _loc3_;
         }
         return _loc2_;
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         scene.mc_content.mc_cancel.removeEventListener(MouseEvent.CLICK,onCancelClick);
         remove();
         var _loc2_:WorldBankPaymentProvider = new WorldBankPaymentProvider(coinType);
         _loc2_.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.y = GameWorld.CANVAS_CENTER_Y;
         _loc2_.show();
      }
   }
}


package com.playfish.games.cooking.ui.bank
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.share.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class WorldBankPaymentProvider extends WorldPopUp
   {
      
      private static var PAYMENT_PROVIDER_TEXT:Array = [null,"Pay using","Earn free coins using","Pay using your mobile/cellphone","Pay using","Pay using your mobile/cellphone","Pay by Credit Card","Earn free coins by completing offers","Pay using Playfish Cash Card","Pay by Credit Card","Pay using Facebook Credits","Earn free coins using"];
      
      public static const PAYMENT_PROVIDER_NAMES:Array = ["","paypal","trialpay","paymo","paybycash","onebip","moneybookers","superrewards","incomm","trialpaycc","facebook","trialpaynew"];
      
      public static const PAYMENT_PROVIDER_DISPLAY_NAMES:Array = ["","PayPal","trialpay","paymo","Pay By Cash","onebip","Credit Card","SuperRewards","Playfish Cash Card","Credit Card","Facebook Credits","trialpay"];
      
      public static const PAYMENT_PROVIDER_PRIORITY:Array = [-1,1,8,5,10,6,2,9,11,3,4,7];
      
      public static const PAYMENT_PROVIDER_AGREEMENT_TEXTS:Array = ["","BillingSupportText","TrialPaySupportText","BillingSupportText","BillingSupportText","BillingSupportText","BillingSupportText","SuperRewardsText","BillingSupportText","BillingSupportText","BillingSupportText","TrialPaySupportText"];
      
      public static var PAYMENT_PROVIDER_TRIAL_PAY_CC:int = 9;
      
      public static var PRODUCT_TYPE_PLAYFISH_CASH:int = 2000;
      
      public static var PRODUCT_TYPE_COIN:int = 2001;
      
      private static var BUY_COINS_WITH_PF_CASH_ITEM_ID_BIG:int = 3700000;
      
      private static var BUY_COINS_WITH_PF_CASH_ITEM_ID_SMALL:int = 3700001;
      
      private static var CASH_CARD_PROMOTE_URL:String = "http://www.playfish.com/redeem/about.php";
      
      private static var FACEBOOK_TRACKING_PIXEL:String = "http://www.facebook.com/connect/button.php?app_id=43016202276&feature=payments&type=pixel";
      
      private var coinType:int;
      
      private var scene:MovieClip;
      
      private var paymentPanels:Array;
      
      public function WorldBankPaymentProvider(param1:int)
      {
         var _loc5_:String = null;
         var _loc6_:MovieClip = null;
         var _loc7_:int = 0;
         paymentPanels = new Array();
         super(null,null,null);
         Debug.out("pf_user_country=" + Engine.instance.getParameter("pf_user_country"));
         this.coinType = param1;
         if(param1 == PRODUCT_TYPE_COIN)
         {
            scene = Engine.getMovieClip("BankMenuPopup");
         }
         else if(param1 == PRODUCT_TYPE_PLAYFISH_CASH)
         {
            scene = Engine.getMovieClip("BankMenuPfCashPopup");
         }
         addChild(scene);
         var _loc2_:MovieClip = scene.mc_content;
         var _loc3_:Array = getPaymentProviders(param1);
         if(_loc2_.mc_cashCard)
         {
            _loc5_ = Engine.instance.getParameter("pf_user_country").toLowerCase();
            if(_loc5_ == "uk" || _loc5_ == "gb" || _loc5_ == "us")
            {
               setButtonMode(_loc2_.mc_cashCard,true);
               _loc2_.mc_cashCard.addEventListener(MouseEvent.CLICK,onCashCardClick,false,0,true);
            }
            else
            {
               _loc2_.mc_cashCard.stop();
               _loc2_.mc_cashCard.visible = false;
            }
         }
         if(param1 == PRODUCT_TYPE_COIN)
         {
            GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_buyCoins,"BuyCoinsDirectly");
         }
         else if(param1 == PRODUCT_TYPE_PLAYFISH_CASH)
         {
            setButtonMode(_loc2_.mc_playfishCash,true);
            _loc2_.mc_playfishCash.addEventListener(MouseEvent.CLICK,onWhatIsPlayfishCashClick,false,0,true);
            GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_title,"AddPlayfishCash");
         }
         var _loc4_:int = 0;
         while(_loc4_ < 5)
         {
            _loc6_ = _loc2_["mc_panel" + _loc4_];
            if(_loc4_ < _loc3_.length)
            {
               _loc7_ = int(_loc3_[_loc4_]);
               setupPaymentProviderButton(_loc7_,_loc6_);
               setButtonMode(_loc6_,true);
               _loc6_.provider = _loc7_;
               _loc6_.addEventListener(MouseEvent.CLICK,onPaymentProviderClick,false,0,true);
               if(_loc7_ == Pricepoint.PAYMENT_PROVIDER_FACEBOOK)
               {
               }
            }
            else
            {
               _loc6_.visible = false;
            }
            _loc4_++;
         }
         setButtonMode(_loc2_.mc_cancel,true);
         _loc2_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
      }
      
      public static function getPaymentProviderIndex(param1:Pricepoint) : int
      {
         if(param1.paymentProvider == Pricepoint.PAYMENT_PROVIDER_TRIALPAY)
         {
            if(Boolean(param1.clientData) && param1.clientData["type"] == "cc")
            {
               return PAYMENT_PROVIDER_TRIAL_PAY_CC;
            }
         }
         return param1.paymentProvider;
      }
      
      private static function hasFrameLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:Array = param1.currentLabels;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] == param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private static function providersPriorityCompare(param1:int, param2:int) : int
      {
         if(PAYMENT_PROVIDER_PRIORITY[param1] > PAYMENT_PROVIDER_PRIORITY[param2])
         {
            return 1;
         }
         if(PAYMENT_PROVIDER_PRIORITY[param1] == PAYMENT_PROVIDER_PRIORITY[param2])
         {
            return 0;
         }
         return -1;
      }
      
      public static function isPaymentProviderValid(param1:int) : Boolean
      {
         return Boolean(PAYMENT_PROVIDER_NAMES[param1]) && PAYMENT_PROVIDER_NAMES[param1].length > 0;
      }
      
      public static function setupPaymentProviderButton(param1:int, param2:MovieClip) : void
      {
         param2.mc_content.tf_text.mouseEnabled = false;
         GameWorld.textHandler.setTextField(param2.mc_content.tf_text,PAYMENT_PROVIDER_TEXT[param1]);
         var _loc3_:String = PAYMENT_PROVIDER_NAMES[param1] + "_" + Engine.instance.getParameter("pf_user_country");
         if(!hasFrameLabel(param2.mc_content.mc_logo,_loc3_))
         {
            _loc3_ = PAYMENT_PROVIDER_NAMES[param1];
         }
         param2.mc_content.mc_logo.gotoAndStop(_loc3_);
      }
      
      public static function getPaymentProviders(param1:int) : Array
      {
         var _loc4_:Pricepoint = null;
         var _loc5_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < GameWorld.pricepoints.length)
         {
            _loc4_ = GameWorld.pricepoints[_loc3_];
            if(_loc4_.productType == param1)
            {
               _loc5_ = getPaymentProviderIndex(_loc4_);
               if(isPaymentProviderValid(_loc5_) && _loc2_.indexOf(_loc5_) == -1)
               {
                  _loc2_.push(_loc5_);
               }
            }
            _loc3_++;
         }
         _loc2_.sort(providersPriorityCompare);
         return _loc2_;
      }
      
      public static function getPricepoints(param1:int, param2:int) : Array
      {
         var _loc5_:Pricepoint = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < GameWorld.pricepoints.length)
         {
            _loc5_ = GameWorld.pricepoints[_loc4_];
            if(_loc5_.productType == param1 && getPaymentProviderIndex(_loc5_) == param2)
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         _loc3_.sortOn("payoutParameter",Array.DESCENDING | Array.NUMERIC);
         return _loc3_;
      }
      
      private function onWhatIsPlayfishCashClick(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:WorldWhatIsPlayFishCash = new WorldWhatIsPlayFishCash(true);
         _loc2_.show();
      }
      
      private function setCashToCoinsButton(param1:MovieClip, param2:Object, param3:Function) : void
      {
         param1.mc_content.tf_pfCash.text = param2.cash;
         param1.mc_content.tf_pfCash.mouseEnabled = false;
         param1.mc_content.tf_coins.text = param2.cost;
         param1.mc_content.tf_coins.mouseEnabled = false;
         if(GameWorld.gameUser.playfishCash.value >= param2.cash)
         {
            setButtonMode(param1,true);
            param1.itemConfig = param2;
            param1.addEventListener(MouseEvent.CLICK,param3,false,0,true);
         }
         else
         {
            setButtonMode(param1,false);
            GameWorld.greyOutDisplayObject(param1);
            param1.toolTip = new ToolTip(param1,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughPlayfishCash"));
         }
      }
      
      private function onCashCardClick(param1:MouseEvent) : void
      {
         GameWorld.openUrl(CASH_CARD_PROMOTE_URL);
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         scene.mc_content.mc_cancel.removeEventListener(MouseEvent.CLICK,onCancelClick);
         scene.gotoAndPlay("out");
      }
      
      private function onPaymentProviderClick(param1:MouseEvent) : void
      {
         var provider:int;
         var providerName:String;
         var paymentScreen:WorldBankPaymentAgreement = null;
         var urlRequest:URLRequest = null;
         var bank:WorldBankPaymentOption = null;
         var e:MouseEvent = param1;
         remove();
         provider = int(e.currentTarget.provider);
         if(provider == Pricepoint.PAYMENT_PROVIDER_SUPERREWARDS)
         {
            paymentScreen = new WorldBankPaymentAgreement(getPricepoints(coinType,provider)[0],WorldBankPaymentAgreement.BACK_TO_PAYMENT_PROVIDERS);
            paymentScreen.show();
         }
         else if(provider == Pricepoint.PAYMENT_PROVIDER_INCOMM)
         {
            urlRequest = getPricepoints(coinType,provider)[0].getPurchaseLink();
            if(urlRequest != null)
            {
               navigateToURL(urlRequest,"_top");
            }
         }
         else if(provider == Pricepoint.PAYMENT_PROVIDER_TRIALPAY_CURRENCY)
         {
            paymentScreen = new WorldBankPaymentAgreement(getPricepoints(coinType,provider)[0],WorldBankPaymentAgreement.BACK_TO_PAYMENT_PROVIDERS);
            paymentScreen.show();
         }
         else
         {
            bank = new WorldBankPaymentOption(provider,coinType);
            bank.show();
         }
         providerName = PAYMENT_PROVIDER_NAMES[provider];
         GameWorld.rpcClient.recordGameEvent(RpcClientBase.GAME_EVENT_SELL_PAGE,"provider=" + providerName + " type=" + (coinType == PRODUCT_TYPE_COIN ? "coin" : "cash"),function():void
         {
         },function():void
         {
         });
      }
      
      private function onCashToCoin1Click(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:Object = GameWorld.interiorItemDatabase.getItemFromId(BUY_COINS_WITH_PF_CASH_ITEM_ID_SMALL);
         var _loc3_:WorldConfirmConvert = new WorldConfirmConvert(_loc2_,WorldConfirmConvert.BAG_SMALL);
         _loc3_.show();
      }
      
      private function onCashToCoin0Click(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:Object = GameWorld.interiorItemDatabase.getItemFromId(BUY_COINS_WITH_PF_CASH_ITEM_ID_BIG);
         var _loc3_:WorldConfirmConvert = new WorldConfirmConvert(_loc2_,WorldConfirmConvert.BAG_BIG);
         _loc3_.show();
      }
      
      override public function tick(param1:uint) : void
      {
         if(scene.currentFrame >= scene.totalFrames)
         {
            remove();
         }
      }
   }
}


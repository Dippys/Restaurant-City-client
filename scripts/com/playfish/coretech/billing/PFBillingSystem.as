package com.playfish.coretech.billing
{
   import com.playfish.coretech.billing.providers.*;
   import com.playfish.coretech.engine.PFEngine;
   import com.playfish.coretech.engine.core.PFDebug;
   import com.playfish.rpc.share.Pricepoint;
   
   public class PFBillingSystem
   {
      
      protected static var _instance:PFBillingSystem;
      
      private static var CASH_CARD_PROMOTE_URL:String = "http://www.playfish.com/redeem/about.php";
      
      protected var productTypeList:Array;
      
      protected var userCountryCode:String;
      
      private var pricepointList:Array;
      
      protected var primaryProductType:int;
      
      public var providerList:Array;
      
      private var trialpayCC:PFPaymentProvider;
      
      public function PFBillingSystem(param1:String)
      {
         super();
         userCountryCode = param1;
         primaryProductType = 0;
         if(userCountryCode == null)
         {
            userCountryCode = PFEngine.instance.getParameterString("pf_user_country");
         }
         if(userCountryCode != null)
         {
            userCountryCode = userCountryCode.toLowerCase();
         }
         pricepointList = new Array();
         productTypeList = new Array();
         providerList = new Array();
         providerList.push(new PFPaymentProviderCreditCard());
         providerList.push(new PFPaymentProviderFacebookCredits());
         providerList.push(new PFPaymentProviderOneBip());
         providerList.push(new PFPaymentProviderPayByCash());
         providerList.push(new PFPaymentProviderPayMo());
         providerList.push(new PFPaymentProviderPayPal());
         providerList.push(new PFPaymentProviderSuperRewards());
         providerList.push(new PFPaymentProviderTrialPay());
         providerList.push(trialpayCC = new PFPaymentProviderTrialPayCreditCard());
         PFDebug.trace(null,toString());
      }
      
      public static function get instance() : PFBillingSystem
      {
         return _instance;
      }
      
      public static function create(param1:String = null) : PFBillingSystem
      {
         _instance = new PFBillingSystem(param1);
         return _instance;
      }
      
      public function getPaymentProviderFromPricepoint(param1:Pricepoint) : PFPaymentProvider
      {
         var _loc2_:PFPaymentProvider = getProvider(param1.paymentProvider);
         if(_loc2_ != null)
         {
            if(param1.paymentProvider == Pricepoint.PAYMENT_PROVIDER_TRIALPAY)
            {
               if(Boolean(param1.clientData) && param1.clientData["type"] == "cc")
               {
                  _loc2_ = trialpayCC;
               }
            }
         }
         return _loc2_;
      }
      
      public function getCashCardPromotionURL() : String
      {
         return CASH_CARD_PROMOTE_URL;
      }
      
      public function getProductType(param1:int) : PFProductType
      {
         var _loc2_:PFProductType = null;
         for each(_loc2_ in productTypeList)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function changeCountryCode(param1:String) : void
      {
         userCountryCode = param1.toLowerCase();
      }
      
      private function providersPriorityCompare(param1:PFPaymentProvider, param2:PFPaymentProvider) : int
      {
         if(param1.priority > param2.priority)
         {
            return 1;
         }
         if(param1.priority == param2.priority)
         {
            return 0;
         }
         return -1;
      }
      
      public function isCashCardSupport() : Boolean
      {
         return userCountryCode == "uk" || userCountryCode == "gb" || userCountryCode == "us";
      }
      
      public function registerProductType(param1:PFProductType) : void
      {
         if(primaryProductType == 0 && param1.id != PFProductType.PLAYFISH_CASH)
         {
            setGamePrimaryProductType(param1.id);
         }
         productTypeList.push(param1);
      }
      
      public function setPricepoints(param1:Array) : void
      {
         pricepointList = param1;
         PFDebug.trace(null,pricepointList.toString());
      }
      
      public function toString() : String
      {
         var _loc2_:PFPaymentProvider = null;
         var _loc1_:String = "";
         for each(_loc2_ in providerList)
         {
            _loc1_ += _loc2_.toString();
            _loc1_ += " ";
         }
         return _loc1_;
      }
      
      public function getCountryCode() : String
      {
         return userCountryCode;
      }
      
      public function getProvider(param1:int) : PFPaymentProvider
      {
         var _loc2_:PFPaymentProvider = null;
         for each(_loc2_ in providerList)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getPricepoints(param1:PFProductType, param2:PFPaymentProvider) : Array
      {
         var _loc5_:Pricepoint = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < pricepointList.length)
         {
            _loc5_ = pricepointList[_loc4_];
            if(_loc5_.productType == param1.id && getPaymentProviderFromPricepoint(_loc5_) == param2)
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         _loc3_.sortOn("payoutParameter",Array.DESCENDING | Array.NUMERIC);
         return _loc3_;
      }
      
      public function getPaymentProviders(param1:PFProductType, param2:int = -1) : Array
      {
         var _loc4_:Pricepoint = null;
         var _loc5_:PFPaymentProvider = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in pricepointList)
         {
            if(_loc4_.productType == param1.id)
            {
               _loc5_ = getPaymentProviderFromPricepoint(_loc4_);
               if(_loc5_ != null && _loc5_.isEnabled() && _loc3_.indexOf(_loc5_) == -1)
               {
                  _loc3_.push(_loc5_);
               }
            }
         }
         _loc3_.sort(providersPriorityCompare);
         if(param2 != -1 && _loc3_.length > param2)
         {
            _loc3_ = _loc3_.slice(0,param2);
         }
         return _loc3_;
      }
      
      public function setGamePrimaryProductType(param1:int) : void
      {
         primaryProductType = param1;
      }
      
      public function getGamePrimaryProductType() : int
      {
         return primaryProductType;
      }
   }
}


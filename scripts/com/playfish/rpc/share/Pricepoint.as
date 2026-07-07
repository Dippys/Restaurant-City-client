package com.playfish.rpc.share
{
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   public class Pricepoint
   {
      
      public static const PAYMENT_PROVIDER_PAYPAL:uint = 1;
      
      public static const PAYMENT_PROVIDER_TRIALPAY:uint = 2;
      
      public static const PAYMENT_PROVIDER_PAYMO:uint = 3;
      
      public static const PAYMENT_PROVIDER_PAYBYCASH:uint = 4;
      
      public static const PAYMENT_PROVIDER_ONEBIP:uint = 5;
      
      public static const PAYMENT_PROVIDER_MONEYBOOKERS:uint = 6;
      
      public static const PAYMENT_PROVIDER_SUPERREWARDS:uint = 7;
      
      public static const PAYMENT_PROVIDER_INCOMM:uint = 8;
      
      public static const PAYMENT_PROVIDER_FACEBOOK:uint = 10;
      
      public static const PAYMENT_PROVIDER_TRIALPAY_CURRENCY:uint = 11;
      
      private var _currencyScale:uint;
      
      private var _price:uint;
      
      private var _productType:uint;
      
      private var baseUrl:String;
      
      private var _paymentProvider:uint;
      
      private var _payoutParameter:uint;
      
      private var _currency:String;
      
      private var token:String;
      
      private var _clientData:String;
      
      public function Pricepoint(param1:String, param2:uint, param3:uint, param4:uint, param5:uint, param6:String, param7:uint, param8:String, param9:String)
      {
         super();
         this.baseUrl = param1;
         this._productType = param2;
         this._payoutParameter = param3;
         this._paymentProvider = param4;
         this._price = param5;
         this._currency = param6;
         this._currencyScale = param7;
         this._clientData = param8;
         this.token = param9;
      }
      
      public function get currencyScale() : uint
      {
         return _currencyScale;
      }
      
      public function get price() : uint
      {
         return _price;
      }
      
      public function get productType() : uint
      {
         return _productType;
      }
      
      public function get clientData() : URLVariables
      {
         return _clientData == "" ? null : new URLVariables(_clientData);
      }
      
      public function get paymentProvider() : uint
      {
         return _paymentProvider;
      }
      
      public function get currency() : String
      {
         return _currency;
      }
      
      public function get payoutParameter() : uint
      {
         return _payoutParameter;
      }
      
      public function getPurchaseLink() : URLRequest
      {
         var _loc1_:URLRequest = new URLRequest(baseUrl);
         var _loc2_:URLVariables = new URLVariables();
         _loc2_["token"] = this.token;
         _loc1_.method = URLRequestMethod.POST;
         _loc1_.data = _loc2_;
         return _loc1_;
      }
   }
}


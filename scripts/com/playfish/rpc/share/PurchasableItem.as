package com.playfish.rpc.share
{
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   public class PurchasableItem
   {
      
      public static const PAYMENT_PROVIDER_PAYPAL:uint = 1;
      
      public static const PAYMENT_PROVIDER_TRIALPAY:uint = 2;
      
      public static const PAYMENT_PROVIDER_PAYMO:uint = 3;
      
      public static const PAYMENT_PROVIDER_PAYBYCASH:uint = 4;
      
      public static const PAYMENT_PROVIDER_ONEBIP:uint = 5;
      
      public static const PAYMENT_PROVIDER_MONEYBOOKERS:uint = 6;
      
      public static const PAYMENT_PROVIDER_SUPERREWARDS:uint = 7;
      
      public static const PAYMENT_PROVIDER_INCOMM:uint = 8;
      
      private var token:String;
      
      private var _price:uint;
      
      private var _currency:String;
      
      private var _skuId:uint;
      
      private var baseUrl:String;
      
      public function PurchasableItem(param1:String, param2:uint, param3:uint, param4:String, param5:String)
      {
         super();
         this.baseUrl = param1;
         this._skuId = param2;
         this._price = param3;
         this._currency = param4;
         this.token = param5;
      }
      
      public function getPurchaseLink(param1:uint, param2:String = null, param3:uint = 1) : URLRequest
      {
         if(param3 < 1)
         {
            throw new Error("quantity cannot be less than 1");
         }
         var _loc4_:URLRequest = new URLRequest(baseUrl);
         var _loc5_:URLVariables = new URLVariables();
         _loc5_["token"] = this.token;
         _loc5_["pp"] = String(param1);
         if(param2 != null)
         {
            _loc5_["x"] = param2;
         }
         if(param3 != 1)
         {
            _loc5_["qty"] = String(param3);
         }
         _loc4_.method = URLRequestMethod.POST;
         _loc4_.data = _loc5_;
         return _loc4_;
      }
      
      public function get price() : uint
      {
         return _price;
      }
      
      public function get currency() : String
      {
         return _currency;
      }
      
      public function get skuId() : uint
      {
         return _skuId;
      }
   }
}


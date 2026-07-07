package com.playfish.games.cooking
{
   import com.playfish.rpc.share.*;
   import flash.events.*;
   import flash.net.*;
   
   public class SkuHandler extends URLLoader
   {
      
      public static var purchasableItems:Array = new Array();
      
      public static const COIN_TYPE_GAME_COIN:int = 0;
      
      public static const COIN_TYPE_PLAYFISH_CASH:int = 1;
      
      public static const COIN_TYPE_ALL:int = 2;
      
      public static const PURCHASABLE_ITEM_PAYMENT_PROVIDER_NAMES:Array = ["","paypal","trialpay","paymo","paybycash","onebip","moneybookers","superrewards"];
      
      public static const PAYMENT_PROVIDER_NAMES:Array = ["","paypal","trialpay","paymo","paybycash","onebip","trialpaycc","moneybookers","superrewards"];
      
      public static const PAYMENT_PROVIDER_MAP:Array = [0,PurchasableItem.PAYMENT_PROVIDER_PAYPAL,PurchasableItem.PAYMENT_PROVIDER_TRIALPAY,PurchasableItem.PAYMENT_PROVIDER_PAYMO,PurchasableItem.PAYMENT_PROVIDER_PAYBYCASH,PurchasableItem.PAYMENT_PROVIDER_ONEBIP,PurchasableItem.PAYMENT_PROVIDER_TRIALPAY,PurchasableItem.PAYMENT_PROVIDER_MONEYBOOKERS,PurchasableItem.PAYMENT_PROVIDER_SUPERREWARDS];
      
      private var skuProviders:Array = new Array();
      
      private var countrySkusDisabled:Array = new Array();
      
      private var skuIds:Array = new Array();
      
      private var skuTypes:Array = new Array();
      
      private var skuCoins:Array = new Array();
      
      private var skuCash:Array = new Array();
      
      public var countries:Array = new Array();
      
      private var countrySkusEnabled:Array = new Array();
      
      public function SkuHandler(param1:String)
      {
         super(new URLRequest(param1));
         this.addEventListener(Event.COMPLETE,init);
      }
      
      public static function itemToString(param1:PurchasableItem) : String
      {
         return "SKU: " + param1.skuId + ", Price: " + param1.price + ", Currency: " + param1.currency;
      }
      
      public function getSkuType(param1:uint) : String
      {
         var _loc2_:int = skuIds.indexOf(param1);
         if(_loc2_ != -1)
         {
            return skuTypes[_loc2_];
         }
         return null;
      }
      
      public function getSkuIds(param1:String, param2:int = 0) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1 != null)
         {
            param1 = param1.toUpperCase();
         }
         else
         {
            param1 = "DEFAULT";
         }
         var _loc3_:Array = countrySkusEnabled[param1];
         var _loc4_:Array = countrySkusDisabled[param1];
         var _loc5_:Array = new Array();
         if(_loc3_ == null)
         {
            _loc3_ = countrySkusEnabled["DEFAULT"];
         }
         if(_loc3_ != null)
         {
            for each(_loc6_ in _loc3_)
            {
               if(_loc5_.indexOf(_loc6_) == -1 && (param2 == 0 || getSkuProvider(_loc6_) == param2))
               {
                  _loc5_.push(_loc6_);
               }
            }
         }
         if(_loc4_ != null)
         {
            _loc7_ = int(_loc4_.length - 1);
            while(_loc7_ >= 0)
            {
               _loc8_ = int(_loc4_[_loc7_]);
               _loc9_ = _loc5_.indexOf(_loc8_);
               if(_loc9_ != -1)
               {
                  _loc5_.splice(_loc9_,1);
               }
               _loc7_--;
            }
         }
         return _loc5_;
      }
      
      private function init(param1:Event) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         var _loc16_:Array = null;
         var _loc2_:XML = new XML(param1.currentTarget.data);
         if(Debug.DEBUG)
         {
         }
         for each(_loc3_ in _loc2_..skuEntry)
         {
            _loc6_ = int(_loc3_.@id);
            _loc7_ = getProviderIndex(_loc3_.@provider);
            _loc8_ = int(_loc3_.@coin);
            _loc9_ = _loc3_.@type;
            _loc10_ = int(_loc3_.@cash);
            skuIds.push(_loc6_);
            skuProviders.push(_loc7_);
            skuCoins.push(_loc8_);
            skuTypes.push(_loc9_);
            skuCash.push(_loc10_);
         }
         for each(_loc4_ in _loc2_..country)
         {
            _loc11_ = _loc4_.@code.split(/\s*,\s*/);
            _loc12_ = new Array();
            _loc13_ = new Array();
            for each(_loc3_ in _loc4_..sku)
            {
               _loc6_ = int(_loc3_.@id);
               _loc15_ = _loc3_.@enabled == "true";
               if(_loc15_)
               {
                  if(_loc12_.indexOf(_loc6_) == -1)
                  {
                     _loc12_.push(_loc6_);
                  }
               }
               else if(_loc13_.indexOf(_loc6_) == -1)
               {
                  _loc13_.push(_loc6_);
               }
            }
            for each(_loc14_ in _loc11_)
            {
               _loc14_ = _loc14_.toUpperCase();
               if(countries.indexOf(_loc14_) == -1)
               {
                  countries.push(_loc14_);
               }
               for each(_loc6_ in _loc12_)
               {
                  _loc16_ = countrySkusEnabled[_loc14_];
                  if(_loc16_ == null)
                  {
                     _loc16_ = new Array();
                     countrySkusEnabled[_loc14_] = _loc16_;
                  }
                  _loc16_.push(_loc6_);
               }
               for each(_loc6_ in _loc13_)
               {
                  _loc16_ = countrySkusDisabled[_loc14_];
                  if(_loc16_ == null)
                  {
                     _loc16_ = new Array();
                     countrySkusDisabled[_loc14_] = _loc16_;
                  }
                  _loc16_.push(_loc6_);
               }
            }
         }
         _loc5_ = countrySkusEnabled["DEFAULT"] as Array;
         if(_loc5_ != null)
         {
            for each(_loc16_ in countrySkusEnabled)
            {
               if(_loc16_ != _loc5_)
               {
                  for each(_loc6_ in _loc5_)
                  {
                     if(_loc16_.indexOf(_loc6_) == -1)
                     {
                        _loc16_.push(_loc6_);
                     }
                  }
               }
            }
         }
         else if(Debug.DEBUG)
         {
         }
      }
      
      public function getPurchasableItems(param1:String, param2:int, param3:int = 0) : Array
      {
         var _loc7_:PurchasableItem = null;
         var _loc4_:Array = new Array();
         var _loc5_:Array = getSkuIds(param1,param3);
         var _loc6_:Number = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = getPurchasableItem(_loc5_[_loc6_],param2);
            if(_loc7_ != null)
            {
               _loc4_.push(_loc7_);
            }
            _loc6_++;
         }
         return _loc4_;
      }
      
      public function getSkuCoin(param1:uint) : int
      {
         var _loc2_:int = skuIds.indexOf(param1);
         if(_loc2_ != -1)
         {
            return skuCoins[_loc2_];
         }
         return -1;
      }
      
      private function getProviderIndex(param1:String) : int
      {
         var _loc2_:Number = 0;
         while(_loc2_ < PAYMENT_PROVIDER_NAMES.length)
         {
            if(PAYMENT_PROVIDER_NAMES[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getPaymentProviders(param1:String, param2:int) : Array
      {
         var _loc5_:Array = null;
         var _loc3_:Array = new Array();
         var _loc4_:Number = 0;
         while(_loc4_ < skuProviders.length)
         {
            if(_loc3_.indexOf(skuProviders[_loc4_]) == -1)
            {
               _loc5_ = getPurchasableItems(param1,param2,skuProviders[_loc4_]);
               if(_loc5_.length > 0)
               {
                  _loc3_.push(skuProviders[_loc4_]);
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getSkuCash(param1:uint) : int
      {
         var _loc2_:int = skuIds.indexOf(param1);
         if(_loc2_ != -1)
         {
            return skuCash[_loc2_];
         }
         return -1;
      }
      
      public function getPurchasableItem(param1:uint, param2:int) : PurchasableItem
      {
         var _loc3_:PurchasableItem = null;
         if(param2 == COIN_TYPE_PLAYFISH_CASH)
         {
            if(getSkuCash(param1) <= 0)
            {
               return null;
            }
         }
         else if(param2 == COIN_TYPE_GAME_COIN)
         {
            if(getSkuCoin(param1) <= 0)
            {
               return null;
            }
         }
         for each(_loc3_ in purchasableItems)
         {
            if(_loc3_.skuId == param1)
            {
               return _loc3_;
            }
         }
         if(Debug.DEBUG)
         {
            return new PurchasableItem("",param1,0,"$",null);
         }
         return null;
      }
      
      public function getSkuProvider(param1:uint) : int
      {
         var _loc2_:int = skuIds.indexOf(param1);
         if(_loc2_ != -1)
         {
            return skuProviders[_loc2_];
         }
         return -1;
      }
   }
}


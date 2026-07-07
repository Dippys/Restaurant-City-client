package com.playfish.games.cooking.utils
{
   import com.playfish.games.cooking.*;
   
   public class RandomBasket
   {
      
      private var basket:Array = new Array();
      
      public function RandomBasket(param1:int = 0, param2:int = 0)
      {
         super();
         var _loc3_:Number = param1;
         while(_loc3_ < param2)
         {
            basket.push(_loc3_);
            _loc3_++;
         }
      }
      
      public function getNextItem() : Object
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         if(basket.length > 0)
         {
            _loc1_ = Engine.rnd(0,basket.length);
            _loc2_ = basket[_loc1_];
            basket.splice(_loc1_,1);
            return _loc2_;
         }
         return null;
      }
      
      public function addItemArray(param1:Array) : void
      {
         basket = basket.concat(param1);
      }
      
      public function getItemAt(param1:int) : Object
      {
         return basket[param1];
      }
      
      public function clone() : RandomBasket
      {
         var _loc1_:RandomBasket = new RandomBasket(0,0);
         _loc1_.basket = basket.concat();
         return _loc1_;
      }
      
      public function removeItems(... rest) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Number = 0;
         while(_loc2_ < rest.length)
         {
            _loc3_ = basket.indexOf(rest[_loc2_]);
            if(_loc3_ != -1)
            {
               basket.splice(basket.indexOf(rest[_loc2_]),1);
            }
            _loc2_++;
         }
      }
      
      public function length() : int
      {
         return basket.length;
      }
      
      public function contains(param1:Object) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in basket)
         {
            if(param1 == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function addItems(... rest) : void
      {
         var _loc2_:Number = 0;
         while(_loc2_ < rest.length)
         {
            basket.push(rest[_loc2_]);
            _loc2_++;
         }
      }
   }
}


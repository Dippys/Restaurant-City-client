package com.playfish.rpc.cooking
{
   public class IngredientMarketItem
   {
      
      public var price:Number;
      
      public var ingredientId:Number;
      
      public function IngredientMarketItem()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[" + ingredientId + " price :" + price + "]";
      }
   }
}


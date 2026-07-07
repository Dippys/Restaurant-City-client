package com.playfish.games.cooking
{
   public class IngredientItem
   {
      
      public var className:String;
      
      public var name:String;
      
      public var count:int = 1;
      
      public var lock:Boolean = false;
      
      public var itemConfig:Object;
      
      public var rarity:int;
      
      public function IngredientItem(param1:Object)
      {
         super();
         this.itemConfig = param1;
         this.name = param1.name;
         this.className = param1.className;
         this.rarity = param1.rarity;
      }
   }
}


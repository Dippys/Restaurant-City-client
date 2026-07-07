package com.playfish.games.cooking
{
   import com.playfish.games.cooking.actors.*;
   
   public class Recipe
   {
      
      public static const MENU_RECIPE_STARTER:int = 0;
      
      public static const MENU_RECIPE_MAIN:int = 1;
      
      public static const MENU_RECIPE_DESSERT:int = 2;
      
      public static const MENU_RECIPE_DRINK:int = 3;
      
      public static const NUM_MENU_RECIPE_TYPE:int = 4;
      
      public static const MENU_RECIPE_TYPE_NAMES:Array = ["Starter","Main","Dessert","Drink"];
      
      public var type:int = -1;
      
      public var config:Object;
      
      public var className:String;
      
      public var name:String;
      
      public var serverUid:int;
      
      public var ingredientItems:Array;
      
      public var level:int = 1;
      
      public var selected:Boolean;
      
      public var cost:int;
      
      public function Recipe(param1:Object)
      {
         var _loc4_:Object = null;
         ingredientItems = new Array();
         super();
         this.config = param1;
         this.className = param1.className;
         this.name = param1.name;
         this.cost = param1.cost;
         type = MENU_RECIPE_TYPE_NAMES.indexOf(String(param1.group.name));
         var _loc2_:Array = param1.ingredients.split(/\s*,\s*/);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = GameWorld.ingredientItemDatabase.getItemFromGroup(_loc2_[_loc3_],"Ingredient");
            if(_loc4_)
            {
               addIngredient(_loc4_);
            }
            _loc3_++;
         }
      }
      
      public function clone() : Recipe
      {
         var _loc1_:Recipe = new Recipe(config);
         _loc1_.level = this.level;
         _loc1_.serverUid = this.serverUid;
         return _loc1_;
      }
      
      private function addIngredient(param1:Object) : void
      {
         var _loc2_:Number = 0;
         while(_loc2_ < ingredientItems.length)
         {
            if(ingredientItems[_loc2_].itemConfig.id == param1.id)
            {
               ++ingredientItems[_loc2_].count;
               return;
            }
            _loc2_++;
         }
         ingredientItems.push(new IngredientItem(param1));
      }
   }
}


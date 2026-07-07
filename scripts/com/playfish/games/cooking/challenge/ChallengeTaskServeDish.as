package com.playfish.games.cooking.challenge
{
   import com.playfish.games.cooking.*;
   
   public class ChallengeTaskServeDish
   {
      
      private var recipeItemConfig:Object;
      
      private var containIngredientItemConfigs:Array;
      
      private var count:int;
      
      public function ChallengeTaskServeDish()
      {
         super();
      }
      
      public function parse(param1:XML) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc2_:String = param1.attribute("recipe");
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            recipeItemConfig = GameWorld.recipeItemDatabase.getItem(_loc2_);
         }
         var _loc3_:String = param1.attribute("containIngredients");
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = _loc3_.split(/\s*,\s*/);
            if(_loc4_.length > 0)
            {
               containIngredientItemConfigs = new Array();
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  containIngredientItemConfigs[_loc5_] = GameWorld.ingredientItemDatabase.getItem(_loc4_[_loc5_]);
                  _loc5_++;
               }
            }
         }
         count = param1.attribute("count");
         Debug.out("\ttask serve dish recipe=" + _loc2_ + " include ingredients=" + _loc4_ + " count=" + count);
      }
   }
}


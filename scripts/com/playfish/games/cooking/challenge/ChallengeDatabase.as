package com.playfish.games.cooking.challenge
{
   import com.playfish.games.cooking.*;
   import flash.utils.*;
   
   public class ChallengeDatabase
   {
      
      public var challenges:Array = new Array();
      
      public function ChallengeDatabase(param1:ByteArray)
      {
         super();
         load(param1);
      }
      
      public function load(param1:ByteArray) : void
      {
         var _loc4_:XML = null;
         var _loc5_:ChallengeItem = null;
         var _loc6_:Array = null;
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         var _loc9_:ChallengeTaskServeDish = null;
         var _loc10_:XML = null;
         var _loc11_:XML = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_.challenge;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new ChallengeItem();
            _loc5_.id = _loc4_.attribute("id");
            _loc5_.name = _loc4_.attribute("name");
            _loc5_.text = _loc4_.attribute("text");
            _loc5_.iconName = _loc4_.attribute("iconName");
            _loc5_.durationHours = _loc4_.attribute("durationHours");
            Debug.out("challenge id=" + _loc5_.id + " name=" + _loc5_.name);
            _loc6_ = new Array();
            for each(_loc7_ in _loc4_.serve)
            {
               _loc9_ = new ChallengeTaskServeDish();
               _loc9_.parse(_loc7_);
            }
            _loc5_.tasks = _loc6_;
            for each(_loc8_ in _loc4_.reward)
            {
               Debug.out("\trewards " + _loc8_.ingredients.length);
               for each(_loc10_ in _loc8_.ingredients)
               {
                  _loc12_ = _loc10_.toString().split(/\s*,\s*/);
                  if(_loc12_.length > 0)
                  {
                     if(_loc5_.rewardIngredients == null)
                     {
                        _loc5_.rewardIngredients = new Array();
                     }
                     _loc13_ = 0;
                     while(_loc13_ < _loc12_.length)
                     {
                        _loc5_.rewardIngredients.push(GameWorld.ingredientItemDatabase.getItem(_loc12_[_loc13_]));
                        Debug.out("\treward ingredient=" + _loc12_[_loc13_]);
                        _loc13_++;
                     }
                  }
               }
               for each(_loc11_ in _loc8_.recipe)
               {
                  _loc14_ = _loc11_.toString();
                  if(_loc14_)
                  {
                     _loc5_.rewardRecipe = GameWorld.recipeItemDatabase.getItem(_loc14_);
                     Debug.out("\treward recipe=" + _loc14_);
                  }
               }
            }
            challenges.push(_loc5_);
         }
      }
   }
}


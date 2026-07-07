package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.DishMaxLevelPopUp;
   import flash.events.MouseEvent;
   
   public class DebugTestLevel10DishPopUp extends DebugEntryButton
   {
      
      public function DebugTestLevel10DishPopUp()
      {
         super("Test level 10 dish pop up",null);
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = GameWorld.recipeItemDatabase.getItems("Starter").concat(GameWorld.recipeItemDatabase.getItems("Main")).concat(GameWorld.recipeItemDatabase.getItems("Dessert")).concat(GameWorld.recipeItemDatabase.getItems("Drink"));
         var _loc3_:Object = _loc2_[Engine.rnd(0,_loc2_.length)];
         var _loc4_:DishMaxLevelPopUp = new DishMaxLevelPopUp(new Recipe(_loc3_));
         _loc4_.show();
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


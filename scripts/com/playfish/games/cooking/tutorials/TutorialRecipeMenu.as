package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.*;
   
   public class TutorialRecipeMenu extends TutorialScript
   {
      
      public static const LEARN_RECIPE_ID:int = 5000008;
      
      private var step:int = 0;
      
      private var worldRecipeMenu:WorldRecipeMenu;
      
      public function TutorialRecipeMenu(param1:WorldRecipeMenu)
      {
         super();
         this.worldRecipeMenu = param1;
         displayHelpTextBox("",GameWorld.textHandler.getTextFromId("TutorialRecipeMenu1"));
      }
      
      override public function tickScript(param1:uint) : void
      {
         if(step == 0)
         {
            if(GameWorld.gameUser.getOwnedRecipe(LEARN_RECIPE_ID) != null)
            {
               wait(1000);
               step = 1;
            }
         }
         else if(step == 1)
         {
            displayHelpTextBox("",GameWorld.textHandler.getTextFromId("TutorialRecipeMenu2"));
            step = 2;
         }
         else if(step == 2)
         {
            if(curHelpTextBox == null)
            {
               displayHelpTextBox("",GameWorld.textHandler.getTextFromId("TutorialRecipeMenu3"));
               step = 3;
            }
         }
         else if(step == 3)
         {
            if(curHelpTextBox == null)
            {
               remove();
               enableButton(worldRecipeMenu.bottomButtonLayer.buttonMyRestaurant);
               worldRecipeMenu.bottomButtonLayer.buttonMyRestaurant.mc_icon.gotoAndPlay("on");
               step = 4;
            }
         }
      }
   }
}


package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.WorldCustomiseAvatar;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   
   public class Tutorial1 extends TutorialScript
   {
      
      private var step:int = 0;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function Tutorial1(param1:WorldRestaurantPlay)
      {
         super();
         this.restaurant = param1;
         GameWorld.stopGlobalRpcs();
         GameWorld.settingOverlay.hideSaveButton();
         param1.uiButton.visible = false;
         param1.uiLevelBar.visible = false;
         param1.uiPopularity.visible = false;
         GameWorld.cashPanel.hideCoins();
         GameWorld.cashPanel.hidePlayfishCash();
         wait(2000);
      }
      
      override public function tickScript(param1:uint) : void
      {
         var _loc2_:WorldCustomiseAvatar = null;
         if(step == 0)
         {
            displayHelpTextBox("",GameWorld.textHandler.getTextFromId("TutorialWelcome1"));
            step = 1;
         }
         else if(step == 1)
         {
            if(curHelpTextBox == null)
            {
               restaurant.destroy();
               _loc2_ = new WorldCustomiseAvatar(GameWorld.gameUser,GameWorld.gameUser);
               GameWorld.fadeToWorld(_loc2_);
               remove();
               new Tutorial2(_loc2_);
            }
         }
      }
   }
}


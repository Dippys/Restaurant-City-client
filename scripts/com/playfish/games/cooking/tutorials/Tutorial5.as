package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import flash.events.*;
   
   public class Tutorial5 extends TutorialScript
   {
      
      private var toolTip:TutorialTextPopUp;
      
      private var step:int = 0;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function Tutorial5(param1:WorldRestaurantPlay)
      {
         super();
         this.restaurant = param1;
         GameWorld.settingOverlay.hideSaveButton();
         param1.uiButton.visible = false;
         param1.uiLevelBar.visible = false;
         param1.uiPopularity.visible = false;
         param1.employeeActors[0].mouseEnabled = false;
         param1.employeeActors[0].mouseChildren = false;
         wait(500);
      }
      
      private function haveJob(param1:int) : Boolean
      {
         return param1 == GameUserEmployee.JOB_WAITOR || param1 == GameUserEmployee.JOB_COOK;
      }
      
      override public function tickScript(param1:uint) : void
      {
         var _loc4_:WorldEmployeePopUp = null;
         var _loc5_:int = 0;
         var _loc2_:int = restaurant.gameUser.getEmployeeCount(GameUserEmployee.JOB_COOK);
         var _loc3_:int = restaurant.gameUser.getEmployeeCount(GameUserEmployee.JOB_WAITOR);
         if(step == 0)
         {
            step = 1;
         }
         else if(step == 1)
         {
            if(curHelpTextBox == null && WorldPopUp.getTopActivePopUp() is WorldEmployeePopUp)
            {
               _loc4_ = WorldPopUp.getTopActivePopUp() as WorldEmployeePopUp;
               _loc4_.contentPanel.mc_waitor.mc_icon.gotoAndPlay("on");
               enableButton(_loc4_.contentPanel.mc_waitor);
               disableButton(_loc4_.contentPanel.mc_giftFood);
               disableButton(_loc4_.contentPanel.mc_outfit);
               disableButton(_loc4_.contentPanel.mc_cook);
               disableButton(_loc4_.contentPanel.mc_rest);
               disableButton(_loc4_.contentPanel.mc_cleaner);
               disableButton(_loc4_.contentPanel.mc_fire);
               disableButton(_loc4_.contentPanel.mc_prev);
               disableButton(_loc4_.contentPanel.mc_next);
               disableButton(_loc4_.contentPanel.mc_cancel);
               disableButton(_loc4_.contentPanel.mc_item0);
               disableButton(_loc4_.contentPanel.mc_item1);
               disableButton(_loc4_.contentPanel.mc_item2);
               disableButton(_loc4_.contentPanel.mc_item3);
               disableButton(_loc4_.contentPanel.mc_restaurant);
               step = 2;
            }
         }
         else if(step == 2)
         {
            if(restaurant.gameUser.getEmployeeCount(GameUserEmployee.JOB_WAITOR) > 0)
            {
               _loc4_ = WorldPopUp.getTopActivePopUp() as WorldEmployeePopUp;
               _loc4_.contentPanel.mc_waitor.mc_icon.gotoAndPlay("off");
               disableButton(_loc4_.contentPanel.mc_waitor,false);
               enableButton(_loc4_.contentPanel.mc_cancel);
               _loc4_.contentPanel.mc_cancel.mc_content.gotoAndPlay("on");
               step = 3;
            }
         }
         else if(step == 3)
         {
            if(WorldPopUp.getTopActivePopUp() == null)
            {
               wait(1000);
               restaurant.employeeActors[1].mouseEnabled = false;
               restaurant.employeeActors[1].mouseChildren = false;
               step = 4;
            }
         }
         else if(step == 4)
         {
            displayHelpTextBox("",GameWorld.textHandler.getTextFromId("Tutorial5_1"));
            step = 5;
         }
         else if(step == 5)
         {
            if(curHelpTextBox == null)
            {
               restaurant.employeeActors[0].mouseEnabled = true;
               restaurant.employeeActors[0].mouseChildren = true;
               restaurant.employeeActors[1].mouseEnabled = true;
               restaurant.employeeActors[1].mouseChildren = true;
               restaurant.uiButton.visible = true;
               restaurant.uiLevelBar.visible = true;
               restaurant.uiPopularity.visible = true;
               GameWorld.settingOverlay.showSaveButton();
               GameWorld.hiredFriendsPanel.show();
               GameWorld.cashPanel.showCoins();
               GameWorld.cashPanel.showPlayfishCash();
               GameWorld.startGlobalRpcs();
               _loc5_ = GameWorld.LEVEL_THRESHOLDS[1].points - GameWorld.gameUser.getGourmetPoints();
               if(_loc5_ > 0)
               {
                  restaurant.addGourmetPoints(_loc5_);
               }
               remove();
               restaurant.displayGameStartUpPopUps();
               step = 6;
            }
         }
      }
   }
}


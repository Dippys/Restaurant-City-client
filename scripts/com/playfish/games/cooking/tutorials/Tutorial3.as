package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import flash.events.*;
   
   public class Tutorial3 extends TutorialScript
   {
      
      private var toolTip:TutorialTextPopUp;
      
      private var step:int = 0;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function Tutorial3(param1:WorldRestaurantPlay)
      {
         super();
         this.restaurant = param1;
         GameWorld.settingOverlay.hideSaveButton();
         param1.buttonStreet.visible = false;
         param1.buttonDecorate.visible = false;
         param1.buttonChangeMenu.visible = false;
         param1.buttonMessage.visible = false;
         param1.buttonAvatar.visible = false;
         param1.buttonAward.visible = false;
         param1.buttonMarket.visible = false;
         param1.buttonMusicPlayer.visible = false;
         param1.buttonGift.visible = false;
         param1.buttonFolder.visible = false;
         param1.uiLevelBar.mc_levelIcon.visible = false;
         param1.uiLevelBar.mc_level.visible = false;
         param1.uiPopularity.mc_demandIcon.visible = false;
         param1.uiPopularity.tf_demand.visible = false;
         param1.employeeActors[0].mouseEnabled = false;
         param1.employeeActors[0].mouseChildren = false;
         wait(1000);
      }
      
      override public function tickScript(param1:uint) : void
      {
         var _loc2_:WorldEmployeePopUp = null;
         var _loc3_:WorldHire = null;
         if(step == 0)
         {
            restaurant.employeeActors[0].mouseEnabled = true;
            restaurant.employeeActors[0].mouseChildren = true;
            step = 1;
         }
         else if(step == 1)
         {
            if(curHelpTextBox == null && WorldPopUp.getTopActivePopUp() is WorldEmployeePopUp)
            {
               _loc2_ = WorldPopUp.getTopActivePopUp() as WorldEmployeePopUp;
               _loc2_.contentPanel.mc_cook.mc_icon.gotoAndPlay("on");
               enableButton(_loc2_.contentPanel.mc_cook);
               disableButton(_loc2_.contentPanel.mc_giftFood);
               disableButton(_loc2_.contentPanel.mc_outfit);
               disableButton(_loc2_.contentPanel.mc_waitor);
               disableButton(_loc2_.contentPanel.mc_rest);
               disableButton(_loc2_.contentPanel.mc_cleaner);
               disableButton(_loc2_.contentPanel.mc_fire);
               disableButton(_loc2_.contentPanel.mc_prev);
               disableButton(_loc2_.contentPanel.mc_next);
               disableButton(_loc2_.contentPanel.mc_cancel);
               disableButton(_loc2_.contentPanel.mc_item0);
               disableButton(_loc2_.contentPanel.mc_item1);
               disableButton(_loc2_.contentPanel.mc_item2);
               disableButton(_loc2_.contentPanel.mc_item3);
               step = 2;
            }
         }
         else if(step == 2)
         {
            if(restaurant.gameUser.getEmployeeCount(GameUserEmployee.JOB_COOK) > 0)
            {
               _loc2_ = WorldPopUp.getTopActivePopUp() as WorldEmployeePopUp;
               _loc2_.contentPanel.mc_cook.mc_icon.gotoAndPlay("off");
               disableButton(_loc2_.contentPanel.mc_cook,false);
               enableButton(_loc2_.contentPanel.mc_cancel);
               _loc2_.contentPanel.mc_cancel.mc_content.gotoAndPlay("on");
               restaurant.employeeActors[0].mouseEnabled = false;
               restaurant.employeeActors[0].mouseChildren = false;
               step = 3;
            }
         }
         else if(step == 3)
         {
            if(WorldPopUp.getTopActivePopUp() == null)
            {
               wait(1000);
               step = 4;
            }
         }
         else if(step == 4)
         {
            displayHelpTextBox("",GameWorld.textHandler.getTextFromId("Tutorial3_1"));
            step = 5;
         }
         else if(step == 5)
         {
            if(curHelpTextBox == null)
            {
               restaurant.destroy();
               _loc3_ = new WorldHire();
               GameWorld.fadeToWorld(_loc3_);
               remove();
               new Tutorial4(_loc3_);
               step = 6;
            }
         }
         else if(step == 6)
         {
         }
      }
   }
}


package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.*;
   import flash.events.*;
   
   public class Tutorial4 extends TutorialScript
   {
      
      private var step:int = 0;
      
      private var worldHire:WorldHire;
      
      public function Tutorial4(param1:WorldHire)
      {
         super();
         this.worldHire = param1;
         param1.buttonMyRestaurant.visible = false;
         var _loc2_:int = 0;
         while(_loc2_ < param1.userInfoPopup.length)
         {
            param1.userInfoPopup[_loc2_].mc_ok.mc_content.gotoAndPlay("on");
            _loc2_++;
         }
      }
      
      override public function tickScript(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:WorldRestaurantPlay = null;
         if(step == 0)
         {
            if(GameWorld.gameUser.employeeUsers.length >= 2)
            {
               _loc2_ = 0;
               while(_loc2_ < worldHire.userInfoPopup.length)
               {
                  worldHire.userInfoPopup[_loc2_].mc_ok.mc_content.gotoAndStop("off");
                  _loc2_++;
               }
               wait(1000);
               step = 1;
            }
         }
         else if(step == 1)
         {
            step = 2;
         }
         else if(step == 2)
         {
            if(curHelpTextBox == null)
            {
               step = 3;
            }
         }
         else if(step == 3)
         {
            remove();
            _loc3_ = new WorldRestaurantPlay(GameWorld.gameUser);
            GameWorld.fadeToWorld(_loc3_);
            new Tutorial5(_loc3_);
         }
      }
   }
}


package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.ItemChooser;
   
   public class Tutorial2 extends TutorialScript
   {
      
      private var worldCustomiseAvatar:WorldCustomiseAvatar;
      
      private var step:int = 0;
      
      public function Tutorial2(param1:WorldCustomiseAvatar)
      {
         super();
         this.worldCustomiseAvatar = param1;
         disableButton(param1.itemChooser.sellButton);
         disableButton(param1.itemChooser.giftButton);
         disableButton(param1.itemChooser.tabButtons[ItemChooser.TAB_NEW]);
         disableButton(param1.itemChooser.tabButtons[ItemChooser.TAB_OWN]);
         disableButton(param1.itemChooser.tabButtons[ItemChooser.TAB_CASH]);
      }
      
      override public function tickScript(param1:uint) : void
      {
         var _loc2_:WorldRestaurantPlay = null;
         if(step == 0)
         {
            if(Engine.curWorld is WorldRestaurantPlay)
            {
               remove();
               _loc2_ = WorldRestaurantPlay(Engine.curWorld);
               if(GameWorld.gameUser.employeeUsers.length == 0)
               {
                  _loc2_.onHireUser(GameWorld.hireUser(GameWorld.gameUser,false));
                  _loc2_.refreshEmployeeCount();
               }
               GameWorld.stopGlobalRpcs();
               new Tutorial3(_loc2_);
            }
         }
         else if(step == 1)
         {
         }
      }
   }
}


package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.GameSettings;
   import com.playfish.games.cooking.GameWorld;
   
   public class TutorialStreet extends TutorialScript
   {
      
      private var step:int = 0;
      
      public function TutorialStreet()
      {
         super();
         wait(1000);
      }
      
      override public function tickScript(param1:uint) : void
      {
         if(step == 0)
         {
            displayHelpTextBox("",GameWorld.textHandler.getTextFromId("TutorialStreet1"));
            step = 1;
         }
         else if(step == 1)
         {
            if(curHelpTextBox == null)
            {
               step = 2;
            }
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
            if(curHelpTextBox == null)
            {
               GameWorld.gameUser.settings.setValue(GameSettings.TYPE_STREET_TUTORIAL_STEP,1);
               remove();
               step = 4;
            }
         }
      }
   }
}


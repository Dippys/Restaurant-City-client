package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.GameSettings;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.ui.mail.WorldQuiz;
   
   public class TutorialQuiz extends TutorialScript
   {
      
      private var step:int = 0;
      
      private var quiz:WorldQuiz;
      
      public function TutorialQuiz(param1:WorldQuiz)
      {
         super();
         this.quiz = param1;
         displayHelpTextBox("",GameWorld.textHandler.getTextFromId("TutorialQuiz1"));
      }
      
      override public function tickScript(param1:uint) : void
      {
         if(step == 0)
         {
            if(curHelpTextBox == null)
            {
               GameWorld.gameUser.settings.setValue(GameSettings.TYPE_QUIZ_TUTORIAL_STEP,1);
               remove();
               quiz.unpause();
               step = 1;
            }
         }
      }
   }
}


package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.GameSettings;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.ui.mail.WorldMail;
   
   public class TutorialMailClient extends TutorialScript
   {
      
      private var mailClient:WorldMail;
      
      public function TutorialMailClient(param1:WorldMail)
      {
         super();
         this.mailClient = param1;
      }
      
      override public function tickScript(param1:uint) : void
      {
         if(curHelpTextBox == null)
         {
            GameWorld.gameUser.settings.setValue(GameSettings.TYPE_MAIL_CLIENT_TUTORIAL_STEP,1);
            remove();
         }
      }
   }
}


package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.GameSettings;
   import com.playfish.games.cooking.GameWorld;
   import flash.events.MouseEvent;
   
   public class DebugResetFirstTimeAccess extends DebugEntryButton
   {
      
      public function DebugResetFirstTimeAccess()
      {
         super("Reset first time access","This will reset the places in the game as if it\'s the first time the player\'s used it.");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         GameWorld.gameUser.settings.setValue(GameSettings.TYPE_FIRST_TIME_ACCESS,0);
         GameWorld.gameUser.settings.setValue(GameSettings.TYPE_FIRST_TIME_ACCESS_2,0);
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


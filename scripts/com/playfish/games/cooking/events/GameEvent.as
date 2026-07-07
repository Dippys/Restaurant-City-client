package com.playfish.games.cooking.events
{
   import flash.events.Event;
   
   public class GameEvent extends Event
   {
      
      public static const NEW_MAIL:String = "new_mail";
      
      public static const INGREDIENT_CHANGED:String = "ingredient_changed";
      
      public static const LEVEL_UP:String = "level_up";
      
      public function GameEvent(param1:String)
      {
         super(param1);
      }
   }
}


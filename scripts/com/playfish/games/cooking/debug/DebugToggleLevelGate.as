package com.playfish.games.cooking.debug
{
   import flash.events.MouseEvent;
   
   public class DebugToggleLevelGate extends DebugEntryButton
   {
      
      public static var disabled:Boolean;
      
      public function DebugToggleLevelGate()
      {
         super("Disable level gating","");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         disabled = !disabled;
         if(disabled)
         {
            setButtonText("Enable level gating");
         }
         else
         {
            setButtonText("disabled level gating");
         }
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


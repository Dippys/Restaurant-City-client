package com.playfish.coretech.engine.debug
{
   import com.playfish.coretech.engine.debug.commands.system.DebugCommandSystem;
   
   public class DebugCommands
   {
      
      public function DebugCommands()
      {
         super();
      }
      
      public static function registerDefaultCommands(param1:DebugConsole) : void
      {
         DebugCommandSystem.registerDefaultCommands(param1);
      }
   }
}


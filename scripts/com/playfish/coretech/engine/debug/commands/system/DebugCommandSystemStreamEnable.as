package com.playfish.coretech.engine.debug.commands.system
{
   import com.playfish.coretech.engine.debug.DebugConsole;
   import com.playfish.coretech.engine.debug.commands.DebugCommand;
   
   public class DebugCommandSystemStreamEnable extends DebugCommand
   {
      
      public function DebugCommandSystemStreamEnable(param1:DebugConsole)
      {
         super();
         param1.registerCommand("enable",this);
      }
      
      override public function usage() : String
      {
         return "<stream name>";
      }
      
      override public function exec(param1:DebugConsole, param2:Array) : void
      {
         param1.enableStream(param2[1]);
         param1.traceMessage(null,"Stream \'" + param2[1] + "\' has been enabled.");
      }
      
      override public function help() : String
      {
         return "Enables the named stream. You can not disable the system (aka null) stream.";
      }
   }
}


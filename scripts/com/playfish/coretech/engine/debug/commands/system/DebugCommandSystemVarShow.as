package com.playfish.coretech.engine.debug.commands.system
{
   import com.playfish.coretech.engine.debug.DebugConsole;
   import com.playfish.coretech.engine.debug.commands.DebugCommand;
   
   public class DebugCommandSystemVarShow extends DebugCommand
   {
      
      public function DebugCommandSystemVarShow(param1:DebugConsole)
      {
         super();
         param1.registerCommand("show",this);
      }
      
      override public function help() : String
      {
         return "Retrieves the toString() state of an abitrarily registered object.";
      }
      
      override public function exec(param1:DebugConsole, param2:Array) : void
      {
         var _loc3_:Object = DebugCommandSystem.watchVarList[param2[1]];
         if(_loc3_ == null)
         {
            param1.traceMessage(null,"Object " + param2[1] + " is not registered.");
         }
         else
         {
            param1.traceMessage(null,param2[1] + " = " + _loc3_["object"].toString());
         }
      }
   }
}


package com.playfish.coretech.engine.debug.commands.system
{
   import com.playfish.coretech.engine.debug.DebugConsole;
   import com.playfish.coretech.engine.debug.commands.DebugCommand;
   
   public class DebugCommandSystemFunctionCall extends DebugCommand
   {
      
      public function DebugCommandSystemFunctionCall(param1:DebugConsole)
      {
         super();
         param1.registerCommand("call",this);
      }
      
      override public function help() : String
      {
         return "Invoke a previously registered function.";
      }
      
      override public function exec(param1:DebugConsole, param2:Array) : void
      {
         var _loc3_:Object = DebugCommandSystem.callFunctionList[param2[1]];
         if(_loc3_ == null)
         {
            param1.traceMessage(null,"Function " + param2[1] + " is not defined.");
         }
         else
         {
            _loc3_["callback"](param2);
         }
      }
   }
}


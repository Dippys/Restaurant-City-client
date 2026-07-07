package com.playfish.coretech.engine.debug.commands.system
{
   import com.playfish.coretech.engine.debug.DebugConsole;
   import com.playfish.coretech.engine.debug.commands.DebugCommand;
   
   public class DebugCommandSystemFunctionList extends DebugCommand
   {
      
      public function DebugCommandSystemFunctionList(param1:DebugConsole)
      {
         super();
         param1.registerCommand("fns",this);
      }
      
      override public function help() : String
      {
         return "List all currently registered functions.";
      }
      
      override public function exec(param1:DebugConsole, param2:Array) : void
      {
         var _loc4_:Object = null;
         var _loc3_:String = "Functions: ";
         for each(_loc4_ in DebugCommandSystem.callFunctionList)
         {
            _loc3_ += _loc4_["id"] + " ";
         }
         param1.traceMessage(null,_loc3_);
      }
   }
}


package com.playfish.coretech.engine.debug.commands.system
{
   import com.playfish.coretech.engine.debug.DebugConsole;
   import com.playfish.coretech.engine.debug.commands.DebugCommand;
   
   public class DebugCommandSystemHelp extends DebugCommand
   {
      
      public function DebugCommandSystemHelp(param1:DebugConsole)
      {
         super();
         param1.registerCommand("help",this);
      }
      
      override public function help() : String
      {
         return "Learn about the commands available.";
      }
      
      override public function exec(param1:DebugConsole, param2:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(param2.length > 1)
         {
            _loc3_ = "Help " + param2[1] + " : ";
            _loc4_ = param1.cmdHandler[param2[1]];
            _loc3_ += _loc4_["callback"].usage();
            _loc3_ += "\n";
            _loc3_ += _loc4_["callback"].help();
            param1.traceMessage(null,_loc3_);
         }
         else
         {
            param1.traceMessage(null,"Help:" + param1.toString() + "\nPostfix the name of the command for more information");
         }
      }
   }
}


package com.playfish.coretech.engine.debug.commands.system
{
   import com.playfish.coretech.engine.debug.DebugConsole;
   import com.playfish.coretech.engine.debug.commands.DebugCommand;
   import flash.system.System;
   
   public class DebugCommandSystemCopy extends DebugCommand
   {
      
      public function DebugCommandSystemCopy(param1:DebugConsole)
      {
         super();
         param1.registerCommand("copy",this);
      }
      
      override public function usage() : String
      {
         return "[all]";
      }
      
      override public function exec(param1:DebugConsole, param2:Array) : void
      {
         var _loc4_:String = null;
         var _loc3_:String = "";
         if(param2[1] == "all")
         {
            for each(_loc4_ in param1.outputHistory)
            {
               _loc3_ += _loc4_;
               _loc3_ += "\n";
            }
         }
         else
         {
            _loc3_ += param1.getLastOutput();
         }
         System.setClipboard(_loc3_);
      }
      
      override public function help() : String
      {
         return "Copy the last line of the output, or \'all\' of it, to the system clipboard.";
      }
   }
}


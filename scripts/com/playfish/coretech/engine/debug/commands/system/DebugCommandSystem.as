package com.playfish.coretech.engine.debug.commands.system
{
   import com.playfish.coretech.engine.debug.DebugConsole;
   
   public class DebugCommandSystem
   {
      
      public static var watchVarList:Array = new Array();
      
      public static var callFunctionList:Array = new Array();
      
      public function DebugCommandSystem()
      {
         super();
      }
      
      public static function addWatchObject(param1:String, param2:Object) : void
      {
         watchVarList[param1] = {
            "object":param2,
            "id":param1
         };
      }
      
      public static function registerDefaultCommands(param1:DebugConsole) : void
      {
         new DebugCommandSystemCopy(param1);
         new DebugCommandSystemFunctionCall(param1);
         new DebugCommandSystemFunctionList(param1);
         new DebugCommandSystemHelp(param1);
         new DebugCommandSystemStreamDisable(param1);
         new DebugCommandSystemStreamEnable(param1);
         new DebugCommandSystemVarList(param1);
         new DebugCommandSystemVarShow(param1);
         new DebugCommandSystemVarSet(param1);
         new DebugCommandSystemVarGet(param1);
      }
      
      public static function addCallFunction(param1:String, param2:Function) : void
      {
         callFunctionList[param1] = {
            "callback":param2,
            "id":param1
         };
      }
   }
}


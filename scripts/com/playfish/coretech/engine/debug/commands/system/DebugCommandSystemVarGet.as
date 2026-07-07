package com.playfish.coretech.engine.debug.commands.system
{
   import com.playfish.coretech.engine.debug.DebugConsole;
   import com.playfish.coretech.engine.debug.commands.DebugCommand;
   import com.playfish.coretech.engine.debug.commands.IDebugTweak;
   
   public class DebugCommandSystemVarGet extends DebugCommand
   {
      
      public function DebugCommandSystemVarGet(param1:DebugConsole)
      {
         super();
         param1.registerCommand("get",this);
      }
      
      override public function usage() : String
      {
         return "<var name>";
      }
      
      override public function exec(param1:DebugConsole, param2:Array) : void
      {
         var _loc4_:IDebugTweak = null;
         var _loc5_:String = null;
         var _loc3_:Object = DebugCommandSystem.watchVarList[param2[1]];
         if(_loc3_ == null)
         {
            param1.traceMessage(null,"Object " + param2[1] + " is not registered.");
         }
         else
         {
            _loc4_ = _loc3_["object"] as IDebugTweak;
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.getTweak(param2[2]);
               param1.traceMessage(null,param2[1] + " = " + _loc5_);
            }
            else
            {
               param1.traceMessage(null,param2[1] + " is not a tweakable object. Ensure it implements \'IDebugTweak\'");
            }
         }
      }
      
      override public function help() : String
      {
         return "Retrieves the state of a tweakable object member.";
      }
   }
}


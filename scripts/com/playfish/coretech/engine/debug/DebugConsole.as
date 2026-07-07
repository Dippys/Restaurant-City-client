package com.playfish.coretech.engine.debug
{
   public class DebugConsole
   {
      
      protected var denyStreams:Array;
      
      protected var allowStreams:Array;
      
      public var cmdHandler:Array;
      
      protected var defaultStreamVisible:Boolean;
      
      public var outputHistory:Array;
      
      protected var objList:Array;
      
      protected var lastCommand:String;
      
      public function DebugConsole()
      {
         super();
         objList = new Array();
         allowStreams = new Array();
         denyStreams = new Array();
         outputHistory = new Array();
         cmdHandler = new Array();
         defaultStreamVisible = true;
         lastCommand = "help";
      }
      
      public function enableStream(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:int = allowStreams.indexOf(param1);
         if(_loc3_ != -1)
         {
            allowStreams.splice(_loc3_,1);
         }
         _loc3_ = denyStreams.indexOf(param1);
         if(_loc3_ != -1)
         {
            denyStreams.splice(_loc3_,1);
         }
         if(param2)
         {
            allowStreams.push(param1);
         }
         else
         {
            denyStreams.push(param1);
         }
      }
      
      public function registerObject(param1:String, param2:*) : void
      {
         objList[param1] = param2;
      }
      
      public function registerCommand(param1:String, param2:Object) : void
      {
         cmdHandler[param1] = {
            "callback":param2,
            "cmd":param1
         };
      }
      
      public function traceMessage(param1:String, param2:String) : Boolean
      {
         if(isStreamVisible(param1))
         {
            addTraceLine(param1,param2);
            return true;
         }
         return false;
      }
      
      public function submitCommand(param1:String) : String
      {
         if(param1 == "!")
         {
            param1 = lastCommand;
         }
         var _loc2_:Array = param1.split(/\s+/);
         var _loc3_:Object = cmdHandler[_loc2_[0]];
         var _loc4_:uint = outputHistory.length;
         if(_loc3_ == null)
         {
            traceMessage(null,"Unknown command:" + _loc2_[0]);
         }
         else
         {
            _loc3_["callback"].exec(this,_loc2_);
         }
         if(_loc4_ == outputHistory.length)
         {
            traceMessage(null,"OK");
         }
         lastCommand = param1;
         return getLastOutput();
      }
      
      public function getLastOutput() : String
      {
         if(outputHistory.length == 0)
         {
            return "";
         }
         return outputHistory[outputHistory.length - 1];
      }
      
      public function disableStream(param1:String) : void
      {
         enableStream(param1,false);
      }
      
      public function isStreamVisible(param1:String) : Boolean
      {
         if(param1 == null || allowStreams.indexOf(param1) != -1)
         {
            return true;
         }
         if(denyStreams.indexOf(param1) != -1)
         {
            return false;
         }
         return defaultStreamVisible;
      }
      
      private function addTraceLine(param1:String, param2:String) : void
      {
         outputHistory.push("[" + (param1 == null ? "DEBUG" : param1) + "] " + param2);
      }
      
      public function toString() : String
      {
         var _loc2_:Object = null;
         var _loc1_:String = "";
         for each(_loc2_ in cmdHandler)
         {
            _loc1_ += _loc2_["cmd"];
            _loc1_ += " - ";
            _loc1_ += _loc2_["callback"].help();
            _loc1_ += "\n";
         }
         return _loc1_;
      }
   }
}


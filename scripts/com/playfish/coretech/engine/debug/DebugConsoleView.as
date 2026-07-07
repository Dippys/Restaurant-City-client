package com.playfish.coretech.engine.debug
{
   import com.playfish.coretech.engine.debug.commands.IDebugTweak;
   
   public class DebugConsoleView implements IDebugTweak
   {
      
      public static var current:DebugConsoleView;
      
      public var ss:String;
      
      private var command:String;
      
      public var console:DebugConsole;
      
      public function DebugConsoleView(param1:DebugConsole)
      {
         super();
         ss = "wallop!";
         command = "";
         console = param1;
      }
      
      public static function create(param1:DebugConsole = null) : DebugConsoleView
      {
         if(param1 == null)
         {
            param1 = new DebugConsole();
            DebugCommands.registerDefaultCommands(param1);
         }
         current = new DebugConsoleView(param1);
         return current;
      }
      
      public function getConsole() : DebugConsole
      {
         return console;
      }
      
      public function getTweak(param1:String) : String
      {
         return ss;
      }
      
      public function getCommandString() : String
      {
         return command;
      }
      
      public function setTweak(param1:String, param2:String) : void
      {
         ss = param2;
      }
      
      public function introduceCommandText(param1:String, param2:Boolean = false) : String
      {
         command += param1;
         if(param2)
         {
            return submitCommand();
         }
         return command;
      }
      
      public function submitCommand() : String
      {
         var _loc1_:String = command;
         command = "";
         return console.submitCommand(_loc1_);
      }
      
      public function applyKeyDelete() : String
      {
         command = command.substr(0,command.length - 1);
         return command;
      }
      
      public function applyKeyCode(param1:uint) : String
      {
         if(param1 == 8)
         {
            return applyKeyDelete();
         }
         if(param1 == 13)
         {
            return submitCommand();
         }
         if(param1 >= 32)
         {
            introduceCommandText(String.fromCharCode(param1));
         }
         return command;
      }
   }
}


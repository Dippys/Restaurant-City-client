package com.playfish.coretech.engine.debug.commands
{
   public interface IDebugTweak
   {
      
      function setTweak(param1:String, param2:String) : void;
      
      function getTweak(param1:String) : String;
   }
}


package com.playfish.coretech.engine.core
{
   public class PFDebug
   {
      
      public static const TRACE_INFO:int = 0;
      
      public static const TRACE_MESSAGE:int = 1;
      
      public static const TRACE_WARNING:int = 2;
      
      public static const TRACE_ERROR:int = 3;
      
      public static var DEBUG:Boolean = true;
      
      public static const TRUE:Boolean = true;
      
      public static const FALSE:Boolean = false;
      
      DEBUG = false;
      
      public static var traceLevel:int = TRACE_INFO;
      
      public static var cbf:Function = null;
      
      public function PFDebug()
      {
         super();
      }
      
      public static function setDebugState(param1:Boolean) : void
      {
         DEBUG = param1;
      }
      
      public static function setTraceLevel(param1:int) : void
      {
         traceLevel = param1;
      }
      
      public static function trace(param1:String, param2:String) : void
      {
         announce(TRACE_MESSAGE,param2);
      }
      
      public static function message(param1:String) : void
      {
         announce(TRACE_MESSAGE,param1);
      }
      
      public static function setHandler(param1:Function) : void
      {
         cbf = param1;
      }
      
      public static function error(param1:String) : void
      {
         announce(TRACE_ERROR,param1);
      }
      
      public static function assert(param1:Boolean, param2:String = "Unspecified assertion") : Boolean
      {
         if(!param1)
         {
            error(param2);
         }
         return !param1;
      }
      
      public static function warning(param1:String) : void
      {
         announce(TRACE_WARNING,param1);
      }
      
      public static function info(param1:String) : void
      {
         announce(TRACE_INFO,param1);
      }
      
      public static function announce(param1:int, param2:String) : void
      {
         if(DEBUG && param1 >= traceLevel && cbf != null)
         {
            cbf(param1,param2);
         }
      }
   }
}


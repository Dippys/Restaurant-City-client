package com.playfish.coretech.engine.core
{
   public class PFCallbackEvent
   {
      
      public var success:Boolean;
      
      public var errorCode:int;
      
      public var platformEvent:Object;
      
      public var errorMsg:String;
      
      public var param:Object;
      
      public function PFCallbackEvent(param1:Boolean, param2:Object = null, param3:Object = null, param4:int = 0, param5:String = "")
      {
         super();
         this.success = param1;
         this.platformEvent = param2;
         this.param = param3;
         this.errorCode = param4;
         this.errorMsg = param5;
      }
   }
}


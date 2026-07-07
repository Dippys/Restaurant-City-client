package com.playfish.coretech.platform.socialplatform.stream
{
   public class StreamUnlinkedText implements IStreamParameter
   {
      
      protected var messageKeyType:String;
      
      public var textMessage:String;
      
      public function StreamUnlinkedText(param1:String = "")
      {
         super();
         textMessage = param1;
         messageKeyType = null;
      }
      
      public function build() : String
      {
         return "\"" + messageKeyType + "\":\"" + textMessage + "\"";
      }
   }
}


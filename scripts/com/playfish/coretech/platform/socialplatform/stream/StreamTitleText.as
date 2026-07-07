package com.playfish.coretech.platform.socialplatform.stream
{
   public class StreamTitleText extends StreamUnlinkedText
   {
      
      public function StreamTitleText(param1:String)
      {
         super(param1);
      }
      
      override public function build() : String
      {
         return textMessage;
      }
   }
}


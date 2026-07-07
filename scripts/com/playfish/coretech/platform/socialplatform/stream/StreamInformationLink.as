package com.playfish.coretech.platform.socialplatform.stream
{
   public class StreamInformationLink extends StreamLinkedText
   {
      
      public function StreamInformationLink(param1:String, param2:String)
      {
         super(param1,param2);
      }
      
      override public function build() : String
      {
         return " \"name\": \"" + text + "\", \"href\": \"" + href + "\"";
      }
   }
}


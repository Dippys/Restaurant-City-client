package com.playfish.coretech.platform.socialplatform.stream
{
   public class StreamLinkedText implements IStreamParameter
   {
      
      public var href:String;
      
      public var text:String;
      
      public function StreamLinkedText(param1:String = "", param2:String = "")
      {
         super();
         this.text = param1;
         this.href = param2;
      }
      
      public function build() : String
      {
         return "{ \"text\": \"" + text + "\", \"href\": \"" + href + "\" }";
      }
   }
}


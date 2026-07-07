package com.playfish.coretech.platform.socialplatform.stream
{
   public class StreamMedia implements IStreamParameter
   {
      
      public var src:String;
      
      public var href:String;
      
      public function StreamMedia(param1:String, param2:String)
      {
         super();
         this.src = param1;
         this.href = param2;
      }
      
      public function build() : String
      {
         return "";
      }
   }
}


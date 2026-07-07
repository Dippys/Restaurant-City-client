package com.playfish.coretech.platform.socialplatform.stream
{
   public class StreamMediaImage extends StreamMedia
   {
      
      private var caption:String;
      
      public function StreamMediaImage(param1:String, param2:String, param3:String = "")
      {
         super(param1,param2);
         this.caption = param3;
      }
      
      override public function build() : String
      {
         var _loc1_:String = "{\"type\": \"image\",";
         _loc1_ += "\"src\": \"" + src + "\",";
         return _loc1_ + ("\"href\": \"" + href + "\"}");
      }
   }
}


package com.playfish.coretech.platform.socialplatform.stream
{
   public class StreamMediaSWF extends StreamMedia
   {
      
      private var expandedHeight:int;
      
      private var width:int;
      
      private var expandedWidth:int;
      
      private var height:int;
      
      private var hrefPreviewImage:String;
      
      public function StreamMediaSWF(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int)
      {
         super(param1,param2);
         this.expandedWidth = param3;
         this.expandedHeight = param4;
         this.width = param5;
         this.height = param6;
      }
      
      override public function build() : String
      {
         var _loc1_:String = "{\"type\": \"flash\",";
         _loc1_ += "\"swfsrc\": \"" + src + "\",";
         _loc1_ += "\"imgsrc\": \"" + href + "\",";
         _loc1_ += "\"expanded_width\": \"" + expandedWidth + "\",";
         _loc1_ += "\"expanded_height\": \"" + expandedHeight + "\",";
         _loc1_ += "\"width\": \"" + width + "\",";
         _loc1_ += "\"height\": \"" + height + "\"";
         return _loc1_ + "}";
      }
   }
}


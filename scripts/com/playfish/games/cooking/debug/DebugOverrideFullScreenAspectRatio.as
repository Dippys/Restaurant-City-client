package com.playfish.games.cooking.debug
{
   import flash.events.MouseEvent;
   
   public class DebugOverrideFullScreenAspectRatio extends DebugEntryButton
   {
      
      public static var overrideWidth:int = 0;
      
      public static var overrideHeight:int = 0;
      
      private var width:int = 0;
      
      private var height:int = 0;
      
      public function DebugOverrideFullScreenAspectRatio(param1:int, param2:int)
      {
         this.width = param1;
         this.height = param2;
         super("set full screen aspect ratio " + param1 + " : " + param2,"test full screen mode under different aspect ratio, click again to disable");
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         if(overrideWidth == 0)
         {
            overrideWidth = width;
            overrideHeight = height;
         }
         else
         {
            overrideWidth = 0;
            overrideHeight = 0;
         }
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


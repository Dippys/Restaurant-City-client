package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.ToolTip;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class DebugEntryButton extends DebugEntry
   {
      
      public var button:MovieClip;
      
      public function DebugEntryButton(param1:String, param2:String)
      {
         super();
         button = Engine.getMovieClip("DebugButton");
         button.buttonMode = true;
         button.tf_text.text = param1;
         button.tf_text.mouseEnabled = false;
         if(param2)
         {
            button.toolTip = new ToolTip(button,param2);
         }
         button.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
      }
      
      override public function getButton() : Object
      {
         return button;
      }
      
      public function onClick(param1:MouseEvent) : void
      {
      }
      
      public function setButtonText(param1:String) : void
      {
         button.tf_text.text = param1;
      }
   }
}


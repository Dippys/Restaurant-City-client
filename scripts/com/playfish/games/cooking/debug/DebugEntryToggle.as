package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class DebugEntryToggle extends DebugEntry
   {
      
      public var toggle:MovieClip;
      
      public var textIndex:int;
      
      public var texts:Array;
      
      public function DebugEntryToggle(param1:String, param2:Array)
      {
         super();
         this.texts = param2;
         toggle = Engine.getMovieClip("DebugToggle");
         toggle.mc_left.addEventListener(MouseEvent.CLICK,onLeftClick,false,0,true);
         toggle.mc_right.addEventListener(MouseEvent.CLICK,onRightClick,false,0,true);
         toggle.tf_text.mouseEnabled = false;
         toggle.mc_left.buttonMode = true;
         toggle.mc_right.buttonMode = true;
         toggle.tf_text.text = param1;
         refresh();
      }
      
      protected function onLeftClick(param1:MouseEvent) : void
      {
         --textIndex;
         if(textIndex < 0)
         {
            textIndex = texts.length + textIndex;
         }
         refresh();
      }
      
      protected function onRightClick(param1:MouseEvent) : void
      {
         ++textIndex;
         if(textIndex >= texts.length)
         {
            textIndex -= texts.length;
         }
         refresh();
      }
      
      private function refresh() : void
      {
         if(texts)
         {
            toggle.tf_text.text = texts[textIndex];
         }
      }
      
      override public function getButton() : Object
      {
         return toggle;
      }
   }
}


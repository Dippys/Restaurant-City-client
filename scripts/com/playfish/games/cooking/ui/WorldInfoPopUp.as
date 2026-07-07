package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.events.*;
   
   public class WorldInfoPopUp extends WorldPopUp
   {
      
      private var scene:MovieClip;
      
      public function WorldInfoPopUp(param1:String)
      {
         super(null,null,null);
         scene = Engine.getMovieClip("GenericTextBoxAnim");
         addChild(scene);
         var _loc2_:MovieClip = scene.mc_content;
         GameWorld.textHandler.setTextField(_loc2_.tf_text,param1);
         setButtonMode(_loc2_.mc_tick,true);
         _loc2_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         remove();
      }
   }
}


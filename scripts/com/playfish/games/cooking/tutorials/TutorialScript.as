package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Rectangle;
   
   public class TutorialScript extends BaseWorld
   {
      
      private static const GREY_FILTER_MATRIX:Array = [0.3,0.3,0.3,0,70,0.3,0.3,0.3,0,70,0.3,0.3,0.3,0,70,0,0,0,1,0];
      
      private var waitTimer:int = -1;
      
      protected var curHelpTextBox:MovieClip;
      
      public function TutorialScript()
      {
         super();
         this.drawPriority = 300000;
         Engine.worldContainer.addObject(this);
      }
      
      public static function disableButton(param1:MovieClip, param2:Boolean = true) : void
      {
         param1.mouseEnabled = false;
         param1.mouseChildren = false;
         if(param2)
         {
            param1.filters = new Array(new ColorMatrixFilter(GREY_FILTER_MATRIX));
         }
         if(param1.indicator)
         {
            param1.removeChild(param1.indicator);
            param1.indicator = null;
         }
      }
      
      public static function enableButton(param1:MovieClip) : void
      {
         param1.mouseEnabled = true;
         param1.mouseChildren = true;
         param1.filters = null;
         var _loc2_:Rectangle = param1.getBounds(null);
         var _loc3_:MovieClip = Engine.getMovieClip("TutArrowAnim");
         _loc3_.y = _loc2_.top;
         param1.indicator = _loc3_;
         param1.addChild(_loc3_);
      }
      
      override public function tick(param1:uint) : void
      {
         if(waitTimer > 0)
         {
            waitTimer -= param1;
            if(waitTimer <= 0)
            {
               waitTimer = -1;
            }
         }
         else
         {
            tickScript(param1);
         }
      }
      
      protected function wait(param1:int) : void
      {
         waitTimer = param1;
      }
      
      public function tickScript(param1:uint) : void
      {
      }
      
      protected function displayHelpTextBox(param1:String, param2:String) : void
      {
         curHelpTextBox = Engine.getMovieClip("HelpPopup");
         var _loc3_:MovieClip = curHelpTextBox.mc_content;
         GameWorld.textHandler.setTextField(_loc3_.tf_title,param1);
         GameWorld.textHandler.setTextField(_loc3_.tf_body,param2,true);
         _loc3_.mc_ok.addEventListener(MouseEvent.CLICK,onHelpTextBoxOKClick);
         var _loc4_:WorldPopUp = new WorldPopUp(curHelpTextBox,_loc3_.mc_ok,null);
         _loc4_.drawPriority = 100;
         _loc4_.show();
      }
      
      public function remove() : void
      {
         Engine.worldContainer.removeObject(this);
      }
      
      private function onHelpTextBoxOKClick(param1:MouseEvent) : void
      {
         param1.currentTarget.removeEventListener(MouseEvent.CLICK,onHelpTextBoxOKClick);
         curHelpTextBox = null;
      }
   }
}


package com.playfish.games.cooking
{
   import com.playfish.games.cooking.ui.WorldPopUp;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class DebugPanel extends WorldPopUp
   {
      
      public static var instance:DebugPanel;
      
      public function DebugPanel(param1:Array)
      {
         var _loc6_:MovieClip = null;
         super(null,null,null);
         var _loc2_:Number = 5;
         var _loc3_:Number = 5;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc6_ = MovieClip(param1[_loc4_].getButton());
            addChild(_loc6_);
            _loc6_.x = _loc3_;
            _loc6_.y = _loc2_;
            _loc2_ += _loc6_.height + 5;
            if(_loc2_ + _loc6_.height >= Engine.STAGE_HEIGHT)
            {
               _loc3_ += _loc6_.width + 5;
               _loc2_ = 5;
            }
            _loc4_++;
         }
         var _loc5_:MovieClip = Engine.getMovieClip("DebugButton");
         _loc5_.tf_text.text = "QUIT";
         _loc5_.tf_text.mouseEnabled = false;
         _loc5_.x = _loc3_;
         _loc5_.y = _loc2_;
         _loc5_.addEventListener(MouseEvent.CLICK,onQuitClick,false,0,true);
         addChild(_loc5_);
         y = 0;
         x = 0;
         instance = this;
      }
      
      private function onQuitClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      override public function remove() : void
      {
         super.remove();
         instance = null;
      }
   }
}


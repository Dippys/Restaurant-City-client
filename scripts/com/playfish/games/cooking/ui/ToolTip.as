package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   
   public class ToolTip extends ToolTipBase
   {
      
      private var horizontal:Boolean;
      
      private var defaultBaseY:Number = 0;
      
      private var forceBelow:Boolean;
      
      private var defaultTextFieldHeight:Number = 0;
      
      public var text:String;
      
      private var defaultBaseHeight:Number = 0;
      
      private var defaultTextFieldY:Number = 0;
      
      public function ToolTip(param1:DisplayObjectContainer, param2:String, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true)
      {
         super(param1,param5);
         this.text = param2;
         this.horizontal = param3;
         this.forceBelow = param4;
      }
      
      override public function getToolTipMC() : MovieClip
      {
         var _loc1_:MovieClip = Engine.getMovieClip("ItemToolTip");
         _loc1_.stop();
         _loc1_.tf_text.mouseEnabled = false;
         defaultTextFieldHeight = _loc1_.tf_text.height;
         defaultBaseHeight = _loc1_.mc_base.height;
         defaultBaseY = _loc1_.mc_base.y;
         defaultTextFieldY = _loc1_.tf_text.y;
         return _loc1_;
      }
      
      override public function refresh() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle = null;
         if(toolTipMC)
         {
            toolTipMC.mc_base.height = defaultBaseHeight;
            toolTipMC.mc_base.y = defaultBaseY;
            toolTipMC.tf_text.height = defaultTextFieldHeight;
            toolTipMC.tf_text.y = defaultTextFieldY;
            toolTipMC.gotoAndStop(1);
            GameWorld.textHandler.setTextField(toolTipMC.tf_text,text,true);
            _loc1_ = Number(toolTipMC.tf_text.textHeight);
            _loc2_ = _loc1_ - defaultTextFieldHeight;
            _loc3_ = parent.getBounds(displayParent);
            _loc4_ = parent.getBounds(displayParent);
            if(!horizontal)
            {
               toolTipMC.tf_text.height = _loc1_ + 20;
               if(forceBelow || _loc4_.top - toolTipMC.height < 0)
               {
                  toolTipMC.gotoAndStop(2);
                  toolTipMC.y = _loc3_.bottom - toolTipMC.getBounds(null).top;
                  toolTipMC.mc_base.height += _loc2_;
                  toolTipMC.mc_base.y += _loc2_ / 2;
               }
               else
               {
                  toolTipMC.y = _loc3_.top;
                  toolTipMC.mc_base.height += _loc2_;
                  toolTipMC.mc_base.y -= _loc2_ / 2;
                  toolTipMC.tf_text.y -= _loc2_;
               }
               toolTipMC.x = _loc3_.x + _loc3_.width / 2;
               _loc5_ = 0;
               if(toolTipMC.x - toolTipMC.width / 2 < Engine.getStageX())
               {
                  _loc5_ = toolTipMC.width / 2 - toolTipMC.x + Engine.getStageX();
               }
               else if(toolTipMC.x + toolTipMC.width / 2 >= Engine.getStageRight())
               {
                  _loc5_ = Engine.getStageRight() - toolTipMC.width / 2 - toolTipMC.x;
               }
               toolTipMC.x += _loc5_;
               toolTipMC.mc_tip.x = -_loc5_;
            }
            else
            {
               _loc6_ = toolTipMC.getBounds(null);
               toolTipMC.gotoAndStop(3);
               if(_loc4_.right + toolTipMC.width < Engine.getStageRight())
               {
                  toolTipMC.x = _loc3_.right + toolTipMC.width / 2;
               }
               else
               {
                  toolTipMC.gotoAndStop(4);
                  toolTipMC.x = _loc3_.left - _loc6_.right;
               }
               toolTipMC.y = _loc3_.top + _loc3_.height / 2 - _loc6_.top - toolTipMC.height / 2;
               toolTipMC.tf_text.height = _loc1_ + 20;
               toolTipMC.mc_base.height += _loc2_;
               toolTipMC.tf_text.y -= _loc2_ / 2;
            }
         }
      }
   }
}


package com.playfish.games.cooking
{
   import flash.display.*;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   
   public class GlowEffect
   {
      
      private var glowColour:int;
      
      private var filterMatrix:Array;
      
      private var target:DisplayObject;
      
      private var flashSpeed:Number;
      
      private var filter:ColorMatrixFilter;
      
      private var glowStep:Number = 0;
      
      private var maxAlpha:Number;
      
      private var filters:Array;
      
      public function GlowEffect(param1:DisplayObject, param2:int = 16777215, param3:Number = 0.1, param4:Number = 0.5)
      {
         super();
         this.target = param1;
         this.glowColour = param2;
         this.flashSpeed = param3;
         this.maxAlpha = Math.min(param4,1);
         filterMatrix = new Array();
         filter = new ColorMatrixFilter();
         filters = [filter];
         onTick(null);
         param1.addEventListener(Event.ENTER_FRAME,onTick,false,0,true);
      }
      
      public function remove() : void
      {
         target.filters = null;
         filter = null;
         filters = null;
         target.removeEventListener(Event.ENTER_FRAME,onTick);
      }
      
      public function onTick(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(filter)
         {
            glowStep += flashSpeed;
            _loc2_ = (Math.sin(glowStep) + 1) / 2 * maxAlpha;
            _loc3_ = 1 - _loc2_;
            _loc4_ = _loc2_ * (glowColour >> 16);
            _loc5_ = _loc2_ * (glowColour >> 8 & 0xFF);
            _loc6_ = _loc2_ * (glowColour & 0xFF);
            filterMatrix[0] = _loc3_;
            filterMatrix[4] = _loc4_;
            filterMatrix[6] = _loc3_;
            filterMatrix[9] = _loc5_;
            filterMatrix[12] = _loc3_;
            filterMatrix[14] = _loc6_;
            filterMatrix[18] = 1;
            filter.matrix = filterMatrix;
            target.filters = filters;
         }
      }
   }
}


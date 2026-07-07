package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class BackgroundLayer extends BaseObject
   {
      
      private var mcWidths:Array = new Array();
      
      private var parallaxLayers:Array = new Array();
      
      private var dividers:Array = new Array();
      
      public function BackgroundLayer()
      {
         super();
      }
      
      public function addLayer(param1:String, param2:Number, param3:Number) : Sprite
      {
         var _loc5_:MovieClip = null;
         var _loc4_:Sprite = new Sprite();
         _loc4_.y = param2;
         _loc5_ = Engine.getMovieClip(param1);
         var _loc6_:int = Math.ceil(GameWorld.CANVAS_WIDTH / _loc5_.width) + 2;
         var _loc7_:Number = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = Engine.getMovieClip(param1);
            _loc5_.x = _loc7_ * _loc5_.width;
            _loc4_.addChild(_loc5_);
            _loc7_++;
         }
         parallaxLayers.push(_loc4_);
         dividers.push(param3);
         mcWidths.push(_loc5_.width);
         addChild(_loc4_);
         return _loc4_;
      }
      
      public function setX(param1:Number) : void
      {
         var _loc2_:Number = 0;
         while(_loc2_ < parallaxLayers.length)
         {
            parallaxLayers[_loc2_].x = param1 / dividers[_loc2_] % mcWidths[_loc2_];
            _loc2_++;
         }
      }
   }
}


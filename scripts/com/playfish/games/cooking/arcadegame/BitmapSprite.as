package com.playfish.games.cooking.arcadegame
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class BitmapSprite
   {
      
      public static const ROTATE_90:int = 1;
      
      public static const ROTATE_180:int = 2;
      
      public static const ROTATE_270:int = 3;
      
      public var frameWidth:int;
      
      public var frame:int;
      
      public var frameHeight:int;
      
      public var frameBitmaps:Array;
      
      public var x:int;
      
      public var y:int;
      
      public function BitmapSprite()
      {
         super();
      }
      
      public static function createFromBitmapSheet(param1:BitmapData, param2:int, param3:int) : BitmapSprite
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:BitmapData = null;
         var _loc4_:BitmapSprite = new BitmapSprite();
         _loc4_.frameWidth = param2;
         _loc4_.frameHeight = param3;
         var _loc5_:int = Math.ceil(param1.width / param2);
         var _loc6_:int = Math.ceil(param1.height / param3);
         _loc4_.frameBitmaps = new Array();
         var _loc9_:int = 0;
         while(_loc9_ < _loc6_)
         {
            _loc7_ = 0;
            _loc10_ = 0;
            while(_loc10_ < _loc5_)
            {
               _loc11_ = new BitmapData(param2,param3,true,0);
               _loc11_.draw(param1,new Matrix(1,0,0,1,-_loc7_,-_loc8_));
               _loc4_.frameBitmaps.push(_loc11_);
               _loc7_ += param2;
               _loc10_++;
            }
            _loc8_ += param3;
            _loc9_++;
         }
         return _loc4_;
      }
      
      public static function isColliding(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         return param1 < param5 + param7 && param1 + param3 > param5 && param2 < param6 + param8 && param2 + param4 > param6;
      }
      
      public function getBitmapDataForFrame(param1:int) : BitmapData
      {
         return frameBitmaps[param1];
      }
      
      public function paint(param1:BitmapData, param2:int, param3:int, param4:int, param5:int = 0) : BitmapData
      {
         var _loc7_:Matrix = null;
         var _loc6_:BitmapData = frameBitmaps[param2];
         if(_loc6_)
         {
            if(param5 != 0)
            {
               switch(param5)
               {
                  case ROTATE_90:
                     _loc7_ = new Matrix(0,1,-1,0,param3 + _loc6_.width,param4);
                     break;
                  case ROTATE_180:
                     _loc7_ = new Matrix(-1,0,0,-1,param3 + _loc6_.width,param4 + _loc6_.height);
                     break;
                  case ROTATE_270:
                     _loc7_ = new Matrix(0,-1,1,0,param3,param4 + _loc6_.height);
               }
            }
            else
            {
               _loc7_ = new Matrix(1,0,0,1,param3,param4);
            }
            param1.draw(_loc6_,_loc7_);
            return _loc6_;
         }
         return null;
      }
   }
}


package com.playfish.games.cooking.arcadegame.cave
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.arcadegame.*;
   import flash.display.*;
   import flash.geom.Rectangle;
   
   public class CaveMap2
   {
      
      private static const SEGMENT_TYPE_SINE:int = 0;
      
      private static const SEGMENT_TYPE_SLOPE:int = 1;
      
      public static const STRIP_WIDTH:int = 20;
      
      public static const STRIP_COLOR:uint = 4283121977;
      
      public static const MIN_GAP_HEIGHT:uint = 80;
      
      public var bottomStripsY:Array = new Array();
      
      public var topStripsY:Array = new Array();
      
      public var caveGame:WorldArcadeCave;
      
      public function CaveMap2(param1:WorldArcadeCave)
      {
         super();
         this.caveGame = param1;
         createSegments(20);
      }
      
      public function paint(param1:BitmapData, param2:Number, param3:Number, param4:int = 0) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc5_:Number = -param2 % STRIP_WIDTH;
         var _loc6_:int = Math.floor(param2 / STRIP_WIDTH);
         var _loc7_:int = int(topStripsY.length);
         while(_loc5_ < param1.width && _loc6_ < _loc7_)
         {
            param1.fillRect(new Rectangle(_loc5_,-param3,STRIP_WIDTH,topStripsY[_loc6_] + param4),STRIP_COLOR);
            _loc8_ = -param3 + bottomStripsY[_loc6_] - param4;
            _loc9_ = param1.height - _loc8_;
            if(_loc9_ > 0)
            {
               param1.fillRect(new Rectangle(_loc5_,_loc8_,STRIP_WIDTH,_loc9_),STRIP_COLOR);
            }
            _loc5_ += STRIP_WIDTH;
            _loc6_++;
         }
      }
      
      private function generateSineSegment(param1:int, param2:int, param3:Number, param4:int, param5:Number, param6:Number, param7:Number) : Array
      {
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc8_:Array = new Array();
         var _loc9_:Array = new Array();
         var _loc10_:int = Math.ceil(param1 / param4);
         var _loc11_:Number = 2 * Math.PI / _loc10_;
         var _loc12_:Number = param6 - Math.sin(param5) * param3;
         var _loc13_:Number = (param7 - param6) / (param4 * _loc10_);
         var _loc14_:int = 0;
         while(_loc14_ < param4)
         {
            _loc15_ = param5;
            _loc16_ = 0;
            while(_loc16_ < _loc10_)
            {
               _loc17_ = _loc12_ + Math.sin(_loc15_) * param3;
               _loc8_.push(_loc17_);
               _loc9_.push(_loc17_ + param2);
               _loc15_ += _loc11_;
               _loc12_ += _loc13_;
               _loc16_++;
            }
            _loc14_++;
         }
         return [_loc8_,_loc9_];
      }
      
      public function checkAndCreateStrips(param1:Number) : void
      {
         var _loc2_:int = Math.ceil(ArcadeGame.GAME_WIDTH / STRIP_WIDTH);
         var _loc3_:int = int(topStripsY.length);
         var _loc4_:int = Math.floor(param1 / STRIP_WIDTH);
         if(_loc3_ < _loc4_ + _loc2_ * 2)
         {
            createSegments(20);
         }
      }
      
      private function createSegments(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc2_:Number = topStripsY.length;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc5_ = int(topStripsY.length);
            _loc6_ = 0;
            if(topStripsY.length > 0)
            {
               _loc6_ = Number(topStripsY[topStripsY.length - 1]);
            }
            _loc7_ = _loc5_ / 10;
            _loc3_ = Math.max(220 - _loc7_,MIN_GAP_HEIGHT);
            _loc3_ = Engine.rnd(_loc3_,_loc3_ + 10);
            if(_loc5_ < 120)
            {
               _loc8_ = Engine.rnd(0,WorldArcadeCave.WINDOW_HEIGHT / 6);
            }
            else
            {
               _loc8_ = Engine.rnd(-WorldArcadeCave.WINDOW_HEIGHT / 4,WorldArcadeCave.WINDOW_HEIGHT * 3 / 4);
            }
            if(_loc3_ + _loc8_ < MIN_GAP_HEIGHT)
            {
               _loc8_ = MIN_GAP_HEIGHT - _loc3_;
            }
            else if(_loc8_ - _loc3_ > WorldArcadeCave.WINDOW_HEIGHT - MIN_GAP_HEIGHT)
            {
               _loc8_ = WorldArcadeCave.WINDOW_HEIGHT - MIN_GAP_HEIGHT + _loc3_;
            }
            _loc9_ = _loc8_ - _loc6_;
            _loc10_ = Math.abs(_loc9_) / 20;
            if(Engine.rnd(0,2) == 0)
            {
               _loc12_ = Math.min(10 + _loc7_,30);
               _loc12_ = Engine.rnd(_loc12_ - 10,_loc12_ + 10);
               if(_loc8_ - _loc12_ + _loc3_ < MIN_GAP_HEIGHT)
               {
                  _loc8_ = MIN_GAP_HEIGHT + _loc12_ - _loc3_;
               }
               else if(_loc8_ + _loc12_ - _loc3_ > WorldArcadeCave.WINDOW_HEIGHT - MIN_GAP_HEIGHT)
               {
                  _loc8_ = WorldArcadeCave.WINDOW_HEIGHT - MIN_GAP_HEIGHT - _loc12_ + _loc3_;
               }
               _loc11_ = generateSineSegment(10 + Engine.rnd(0,10) + _loc10_,_loc3_,_loc12_,1,Engine.rnd(0,2) == 0 ? 0 : Math.PI / 2,_loc6_,_loc8_);
            }
            else
            {
               _loc11_ = generateSlopeSegment(5 + Engine.rnd(0,10) + _loc10_,_loc3_,_loc6_,_loc8_);
            }
            topStripsY = topStripsY.concat(_loc11_[0]);
            bottomStripsY = bottomStripsY.concat(_loc11_[1]);
            _loc4_++;
         }
      }
      
      private function generateSlopeSegment(param1:int, param2:Number, param3:Number, param4:Number) : Array
      {
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Number = (param4 - param3) / param1;
         var _loc8_:Number = param3;
         var _loc9_:int = 0;
         while(_loc9_ < param1)
         {
            _loc5_.push(_loc8_);
            _loc6_.push(_loc8_ + param2);
            _loc8_ += _loc7_;
            _loc9_++;
         }
         return [_loc5_,_loc6_];
      }
   }
}


package away3d.core.draw
{
   import away3d.core.base.*;
   
   public final class ScreenVertex
   {
      
      public var z:Number;
      
      public var vx:Number;
      
      public var vy:Number;
      
      private var my2:Number;
      
      private var dx:Number;
      
      private var dy:Number;
      
      private var faz:Number;
      
      public var vectorInstructionType:String = VectorInstructionType.LINE;
      
      private var mx2:Number;
      
      private var ifmz2:Number;
      
      public var visible:Boolean;
      
      public var x:Number;
      
      public var y:Number;
      
      private var persp:Number;
      
      private var fbz:Number;
      
      public function ScreenVertex(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.visible = false;
      }
      
      public static function median(param1:Number, param2:Number, param3:Array, param4:Array, param5:Number) : void
      {
         var _loc6_:int = param4[param1] * 3;
         var _loc7_:Number = Number(param3[_loc6_]);
         var _loc8_:Number = Number(param3[_loc6_ + 1]);
         var _loc9_:Number = Number(param3[_loc6_ + 2]);
         var _loc10_:int = param4[param2] * 3;
         var _loc11_:Number = Number(param3[_loc10_]);
         var _loc12_:Number = Number(param3[_loc10_ + 1]);
         var _loc13_:Number = Number(param3[_loc10_ + 2]);
         var _loc14_:Number = (_loc9_ + _loc13_) / 2;
         var _loc15_:Number = param5 + _loc9_;
         var _loc16_:Number = param5 + _loc13_;
         var _loc17_:Number = 1 / (param5 + _loc14_) / 2;
         param3[param3.length] = (_loc7_ * _loc15_ + _loc11_ * _loc16_) * _loc17_;
         param3[param3.length] = (_loc8_ * _loc15_ + _loc12_ * _loc16_) * _loc17_;
         param3[param3.length] = _loc14_;
      }
      
      public static function weighted(param1:ScreenVertex, param2:ScreenVertex, param3:Number, param4:Number, param5:Number) : ScreenVertex
      {
         if(param4 == 0 && param3 == 0)
         {
            throw new Error("Zero weights");
         }
         if(param4 == 0)
         {
            return new ScreenVertex(param1.x,param1.y,param1.z);
         }
         if(param3 == 0)
         {
            return new ScreenVertex(param2.x,param2.y,param2.z);
         }
         var _loc6_:Number = param3 + param4;
         var _loc7_:Number = param3 / _loc6_;
         var _loc8_:Number = param4 / _loc6_;
         var _loc9_:Number = param1.x * _loc7_ + param2.x * _loc8_;
         var _loc10_:Number = param1.y * _loc7_ + param2.y * _loc8_;
         var _loc11_:Number = param1.z / param5;
         var _loc12_:Number = param2.z / param5;
         var _loc13_:Number = 1 + _loc11_;
         var _loc14_:Number = 1 + _loc12_;
         var _loc15_:Number = param1.x * _loc13_ - _loc9_ * _loc11_;
         var _loc16_:Number = param2.x * _loc14_ - _loc9_ * _loc12_;
         var _loc17_:Number = param1.y * _loc13_ - _loc10_ * _loc11_;
         var _loc18_:Number = param2.y * _loc14_ - _loc10_ * _loc12_;
         var _loc19_:Number = _loc15_ * _loc18_ - _loc16_ * _loc17_;
         var _loc20_:Number = _loc9_ * _loc18_ - _loc16_ * _loc10_;
         var _loc21_:Number = _loc15_ * _loc10_ - _loc9_ * _loc17_;
         return new ScreenVertex(_loc9_,_loc10_,(_loc20_ * param1.z + _loc21_ * param2.z) / _loc19_);
      }
      
      public static function distanceSqr(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return (param1 - param3) * (param1 - param3) + (param2 - param4) * (param2 - param4);
      }
      
      public function distortSqr(param1:ScreenVertex, param2:Number) : Number
      {
         faz = param2 + z;
         fbz = param2 + z;
         ifmz2 = 2 / (faz + fbz);
         mx2 = (x * faz + param1.x * fbz) * ifmz2;
         my2 = (y * faz + param1.y * fbz) * ifmz2;
         dx = x + param1.x - mx2;
         dy = y + param1.y - my2;
         return 50 * (dx * dx + dy + dy);
      }
      
      public function toString() : String
      {
         return "new ScreenVertex(" + x + ", " + y + ", " + z + ")";
      }
      
      public function distance(param1:ScreenVertex) : Number
      {
         return Math.sqrt((x - param1.x) * (x - param1.x) + (y - param1.y) * (y - param1.y));
      }
   }
}


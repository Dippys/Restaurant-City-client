package away3d.core.math
{
   public final class Matrix3D
   {
      
      private var xx:Number;
      
      private var xy:Number;
      
      private var xz:Number;
      
      private var _right:Number3D = new Number3D();
      
      private var yw:Number;
      
      private var yy:Number;
      
      private var yz:Number;
      
      private var scos:Number;
      
      private var nCos:Number;
      
      private var zw:Number;
      
      private var _up:Number3D = new Number3D();
      
      private var m211:Number;
      
      private var m213:Number;
      
      private var m212:Number;
      
      private var m214:Number;
      
      private var suv:Number;
      
      private var zz:Number;
      
      private var suw:Number;
      
      private var su:Number;
      
      private var sv:Number;
      
      private var m221:Number;
      
      private var m222:Number;
      
      private var m223:Number;
      
      private var m224:Number;
      
      private var sw:Number;
      
      private var d:Number;
      
      private var w:Number;
      
      private var x:Number;
      
      private var y:Number;
      
      private var z:Number;
      
      private var svw:Number;
      
      private var m231:Number;
      
      private var m111:Number;
      
      private var m112:Number;
      
      private var _forward:Number3D = new Number3D();
      
      private var m114:Number;
      
      private var _position:Number3D = new Number3D();
      
      public var tw:Number = 1;
      
      private var m232:Number;
      
      private var m233:Number;
      
      private var m113:Number;
      
      public var swz:Number = 0;
      
      private var nSin:Number;
      
      public var swx:Number = 0;
      
      public var tx:Number = 0;
      
      public var ty:Number = 0;
      
      private var m234:Number;
      
      private var m241:Number;
      
      private var m121:Number;
      
      private var m122:Number;
      
      private var m123:Number;
      
      private var m124:Number;
      
      private var m243:Number;
      
      private var m244:Number;
      
      private var m242:Number;
      
      public var sxx:Number = 1;
      
      public var sxy:Number = 0;
      
      public var sxz:Number = 0;
      
      public var swy:Number = 0;
      
      public var tz:Number = 0;
      
      private var m131:Number;
      
      private var m132:Number;
      
      private var m133:Number;
      
      private var m134:Number;
      
      public var syx:Number = 0;
      
      public var syz:Number = 0;
      
      public var syy:Number = 1;
      
      private var m141:Number;
      
      private var m142:Number;
      
      private var m143:Number;
      
      private var m144:Number;
      
      public var szx:Number = 0;
      
      public var szz:Number = 1;
      
      public var szy:Number = 0;
      
      private var xw:Number;
      
      public function Matrix3D()
      {
         super();
      }
      
      public function get det() : Number
      {
         return (sxx * syy - syx * sxy) * szz - (sxx * szy - szx * sxy) * syz + (syx * szy - szx * syy) * sxz;
      }
      
      public function normalize(param1:Matrix3D) : void
      {
         d = Math.sqrt(sxx * sxx + sxy * sxy + sxz * sxz);
         sxx /= d;
         sxy /= d;
         sxz /= d;
         d = Math.sqrt(syx * syx + syy * syy + syz * syz);
         syx /= d;
         syy /= d;
         syz /= d;
         d = Math.sqrt(szx * szx + szy * szy + szz * szz);
         szx /= d;
         szy /= d;
         szz /= d;
      }
      
      public function get right() : Number3D
      {
         _right.x = sxx;
         _right.y = sxy;
         _right.z = sxz;
         return _right;
      }
      
      public function get position() : Number3D
      {
         _position.x = tx;
         _position.y = ty;
         _position.z = tz;
         return _position;
      }
      
      public function multiply(param1:Matrix3D, param2:Matrix3D) : void
      {
         m111 = param1.sxx;
         m211 = param2.sxx;
         m121 = param1.syx;
         m221 = param2.syx;
         m131 = param1.szx;
         m231 = param2.szx;
         m112 = param1.sxy;
         m212 = param2.sxy;
         m122 = param1.syy;
         m222 = param2.syy;
         m132 = param1.szy;
         m232 = param2.szy;
         m113 = param1.sxz;
         m213 = param2.sxz;
         m123 = param1.syz;
         m223 = param2.syz;
         m133 = param1.szz;
         m233 = param2.szz;
         m114 = param1.tx;
         m214 = param2.tx;
         m124 = param1.ty;
         m224 = param2.ty;
         m134 = param1.tz;
         m234 = param2.tz;
         sxx = m111 * m211 + m112 * m221 + m113 * m231;
         sxy = m111 * m212 + m112 * m222 + m113 * m232;
         sxz = m111 * m213 + m112 * m223 + m113 * m233;
         tx = m111 * m214 + m112 * m224 + m113 * m234 + m114;
         syx = m121 * m211 + m122 * m221 + m123 * m231;
         syy = m121 * m212 + m122 * m222 + m123 * m232;
         syz = m121 * m213 + m122 * m223 + m123 * m233;
         ty = m121 * m214 + m122 * m224 + m123 * m234 + m124;
         szx = m131 * m211 + m132 * m221 + m133 * m231;
         szy = m131 * m212 + m132 * m222 + m133 * m232;
         szz = m131 * m213 + m132 * m223 + m133 * m233;
         tz = m131 * m214 + m132 * m224 + m133 * m234 + m134;
      }
      
      public function inverse(param1:Matrix3D) : void
      {
         d = param1.det;
         if(Math.abs(d) < 0.001)
         {
            return;
         }
         d = 1 / d;
         m111 = param1.sxx;
         m121 = param1.syx;
         m131 = param1.szx;
         m112 = param1.sxy;
         m122 = param1.syy;
         m132 = param1.szy;
         m113 = param1.sxz;
         m123 = param1.syz;
         m133 = param1.szz;
         m114 = param1.tx;
         m124 = param1.ty;
         m134 = param1.tz;
         sxx = d * (m122 * m133 - m132 * m123);
         sxy = -d * (m112 * m133 - m132 * m113);
         sxz = d * (m112 * m123 - m122 * m113);
         tx = -d * (m112 * (m123 * m134 - m133 * m124) - m122 * (m113 * m134 - m133 * m114) + m132 * (m113 * m124 - m123 * m114));
         syx = -d * (m121 * m133 - m131 * m123);
         syy = d * (m111 * m133 - m131 * m113);
         syz = -d * (m111 * m123 - m121 * m113);
         ty = d * (m111 * (m123 * m134 - m133 * m124) - m121 * (m113 * m134 - m133 * m114) + m131 * (m113 * m124 - m123 * m114));
         szx = d * (m121 * m132 - m131 * m122);
         szy = -d * (m111 * m132 - m131 * m112);
         szz = d * (m111 * m122 - m121 * m112);
         tz = -d * (m111 * (m122 * m134 - m132 * m124) - m121 * (m112 * m134 - m132 * m114) + m131 * (m112 * m124 - m122 * m114));
      }
      
      public function set up(param1:Number3D) : void
      {
         this.syx = param1.x;
         this.syy = param1.y;
         this.syz = param1.z;
      }
      
      public function set right(param1:Number3D) : void
      {
         this.sxx = param1.x;
         this.sxy = param1.y;
         this.sxz = param1.z;
      }
      
      public function multiply4x3(param1:Matrix3D, param2:Matrix3D) : void
      {
         m111 = param1.sxx;
         m211 = param2.sxx;
         m121 = param1.syx;
         m221 = param2.syx;
         m131 = param1.szx;
         m231 = param2.szx;
         m112 = param1.sxy;
         m212 = param2.sxy;
         m122 = param1.syy;
         m222 = param2.syy;
         m132 = param1.szy;
         m232 = param2.szy;
         m113 = param1.sxz;
         m213 = param2.sxz;
         m123 = param1.syz;
         m223 = param2.syz;
         m133 = param1.szz;
         m233 = param2.szz;
         m114 = param1.tx;
         m214 = param2.tx;
         m124 = param1.ty;
         m224 = param2.ty;
         m134 = param1.tz;
         m234 = param2.tz;
         m141 = param1.swx;
         m241 = param2.swx;
         m142 = param1.swy;
         m242 = param2.swy;
         m143 = param1.swz;
         m243 = param2.swz;
         m144 = param1.tw;
         m244 = param2.tw;
         sxx = m111 * m211 + m112 * m221 + m113 * m231;
         sxy = m111 * m212 + m112 * m222 + m113 * m232;
         sxz = m111 * m213 + m112 * m223 + m113 * m233;
         tx = m111 * m214 + m112 * m224 + m113 * m234 + m114;
         syx = m121 * m211 + m122 * m221 + m123 * m231;
         syy = m121 * m212 + m122 * m222 + m123 * m232;
         syz = m121 * m213 + m122 * m223 + m123 * m233;
         ty = m121 * m214 + m122 * m224 + m123 * m234 + m124;
         szx = m131 * m211 + m132 * m221 + m133 * m231;
         szy = m131 * m212 + m132 * m222 + m133 * m232;
         szz = m131 * m213 + m132 * m223 + m133 * m233;
         tz = m131 * m214 + m132 * m224 + m133 * m234 + m134;
         swx = m141 * m211 + m142 * m221 + m143 * m231;
         swy = m141 * m212 + m142 * m222 + m143 * m232;
         swz = m141 * m213 + m142 * m223 + m143 * m233;
         tw = m141 * m214 + m142 * m224 + m143 * m234 + m144;
      }
      
      public function multiplyVector3x3(param1:Number3D) : void
      {
         var _loc2_:Number = param1.x;
         var _loc3_:Number = param1.y;
         var _loc4_:Number = param1.z;
         param1.x = _loc2_ * sxx + _loc3_ * sxy + _loc4_ * sxz;
         param1.y = _loc2_ * syx + _loc3_ * syy + _loc4_ * syz;
         param1.z = _loc2_ * szx + _loc3_ * szy + _loc4_ * szz;
      }
      
      public function multiply4x4(param1:Matrix3D, param2:Matrix3D) : void
      {
         m111 = param1.sxx;
         m211 = param2.sxx;
         m121 = param1.syx;
         m221 = param2.syx;
         m131 = param1.szx;
         m231 = param2.szx;
         m141 = param1.swx;
         m241 = param2.swx;
         m112 = param1.sxy;
         m212 = param2.sxy;
         m122 = param1.syy;
         m222 = param2.syy;
         m132 = param1.szy;
         m232 = param2.szy;
         m142 = param1.swy;
         m242 = param2.swy;
         m113 = param1.sxz;
         m213 = param2.sxz;
         m123 = param1.syz;
         m223 = param2.syz;
         m133 = param1.szz;
         m233 = param2.szz;
         m143 = param1.swz;
         m243 = param2.swz;
         m114 = param1.tx;
         m214 = param2.tx;
         m124 = param1.ty;
         m224 = param2.ty;
         m134 = param1.tz;
         m234 = param2.tz;
         m144 = param1.tw;
         m244 = param2.tw;
         sxx = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
         sxy = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
         sxz = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
         tx = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
         syx = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
         syy = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
         syz = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
         ty = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
         szx = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
         szy = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
         szz = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
         tz = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
         swx = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
         swy = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
         swz = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
         tw = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
      }
      
      public function scale(param1:Matrix3D, param2:Number, param3:Number, param4:Number) : void
      {
         sxx = param1.sxx * param2;
         syx = param1.syx * param2;
         szx = param1.szx * param2;
         sxy = param1.sxy * param3;
         syy = param1.syy * param3;
         szy = param1.szy * param3;
         sxz = param1.sxz * param4;
         syz = param1.syz * param4;
         szz = param1.szz * param4;
      }
      
      public function perspectiveProjectionMatrix(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = param1 / 2 * (Math.PI / 180);
         var _loc6_:Number = Math.tan(_loc5_);
         var _loc7_:Number = 1 / _loc6_;
         sxx = _loc7_ / param2;
         sxy = sxz = tx = 0;
         syy = _loc7_;
         syx = syz = ty = 0;
         szx = szy = 0;
         szz = -((param3 + param4) / (param3 - param4));
         tz = 2 * param4 * param3 / (param3 - param4);
         swx = swy = tw = 0;
         swz = 1;
      }
      
      public function clone(param1:Matrix3D) : Matrix3D
      {
         sxx = param1.sxx;
         sxy = param1.sxy;
         sxz = param1.sxz;
         tx = param1.tx;
         syx = param1.syx;
         syy = param1.syy;
         syz = param1.syz;
         ty = param1.ty;
         szx = param1.szx;
         szy = param1.szy;
         szz = param1.szz;
         tz = param1.tz;
         swx = param1.swx;
         swy = param1.swy;
         swz = param1.swz;
         tw = param1.tw;
         return param1;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += int(sxx * 1000) / 1000 + "\t\t" + int(sxy * 1000) / 1000 + "\t\t" + int(sxz * 1000) / 1000 + "\t\t" + int(tx * 1000) / 1000 + "\n";
         _loc1_ += int(syx * 1000) / 1000 + "\t\t" + int(syy * 1000) / 1000 + "\t\t" + int(syz * 1000) / 1000 + "\t\t" + int(ty * 1000) / 1000 + "\n";
         _loc1_ += int(szx * 1000) / 1000 + "\t\t" + int(szy * 1000) / 1000 + "\t\t" + int(szz * 1000) / 1000 + "\t\t" + int(tz * 1000) / 1000 + "\n";
         return _loc1_ + (int(swx * 1000) / 1000 + "\t\t" + int(swy * 1000) / 1000 + "\t\t" + int(swz * 1000) / 1000 + "\t\t" + int(tw * 1000) / 1000 + "\n");
      }
      
      public function copy3x3(param1:Matrix3D) : Matrix3D
      {
         sxx = param1.sxx;
         sxy = param1.sxy;
         sxz = param1.sxz;
         syx = param1.syx;
         syy = param1.syy;
         syz = param1.syz;
         szx = param1.szx;
         szy = param1.szy;
         szz = param1.szz;
         return this;
      }
      
      public function clear() : void
      {
         tx = sxy = sxz = syz = ty = syz = szx = szy = tz = 0;
         sxx = syy = szz = 1;
      }
      
      public function scaleMatrix(param1:Number, param2:Number, param3:Number) : void
      {
         tx = sxy = sxz = 0;
         syz = ty = syz = 0;
         szx = szy = tz = 0;
         sxx = param1;
         syy = param2;
         szz = param3;
      }
      
      public function get up() : Number3D
      {
         _up.x = syx;
         _up.y = syy;
         _up.z = syz;
         return _up;
      }
      
      public function inverse4x4(param1:Matrix3D) : void
      {
         d = param1.det4x4;
         if(Math.abs(d) < 0.001)
         {
            return;
         }
         d = 1 / d;
         m111 = param1.sxx;
         m121 = param1.syx;
         m131 = param1.szx;
         m141 = param1.swx;
         m112 = param1.sxy;
         m122 = param1.syy;
         m132 = param1.szy;
         m142 = param1.swy;
         m113 = param1.sxz;
         m123 = param1.syz;
         m133 = param1.szz;
         m143 = param1.swz;
         m114 = param1.tx;
         m124 = param1.ty;
         m134 = param1.tz;
         m144 = param1.tw;
         sxx = d * (m122 * (m133 * m144 - m143 * m134) - m132 * (m123 * m144 - m143 * m124) + m142 * (m123 * m134 - m133 * m124));
         sxy = -d * (m112 * (m133 * m144 - m143 * m134) - m132 * (m113 * m144 - m143 * m114) + m142 * (m113 * m134 - m133 * m114));
         sxz = d * (m112 * (m123 * m144 - m143 * m124) - m122 * (m113 * m144 - m143 * m114) + m142 * (m113 * m124 - m123 * m114));
         tx = -d * (m112 * (m123 * m134 - m133 * m124) - m122 * (m113 * m134 - m133 * m114) + m132 * (m113 * m124 - m123 * m114));
         syx = -d * (m121 * (m133 * m144 - m143 * m134) - m131 * (m123 * m144 - m143 * m124) + m141 * (m123 * m134 - m133 * m124));
         syy = d * (m111 * (m133 * m144 - m143 * m134) - m131 * (m113 * m144 - m143 * m114) + m141 * (m113 * m134 - m133 * m114));
         syz = -d * (m111 * (m123 * m144 - m143 * m124) - m121 * (m113 * m144 - m143 * m114) + m141 * (m113 * m124 - m123 * m114));
         ty = d * (m111 * (m123 * m134 - m133 * m124) - m121 * (m113 * m134 - m133 * m114) + m131 * (m113 * m124 - m123 * m114));
         szx = d * (m121 * (m132 * m144 - m142 * m134) - m131 * (m122 * m144 - m142 * m124) + m141 * (m122 * m134 - m132 * m124));
         szy = -d * (m111 * (m132 * m144 - m142 * m134) - m131 * (m112 * m144 - m142 * m114) + m141 * (m112 * m134 - m132 * m114));
         szz = d * (m111 * (m122 * m144 - m142 * m124) - m121 * (m112 * m144 - m142 * m114) + m141 * (m112 * m124 - m122 * m114));
         tz = -d * (m111 * (m122 * m134 - m132 * m124) - m121 * (m112 * m134 - m132 * m114) + m131 * (m112 * m124 - m122 * m114));
         swx = -d * (m121 * (m132 * m143 - m142 * m133) - m131 * (m122 * m143 - m142 * m123) + m141 * (m122 * m133 - m132 * m123));
         swy = d * (m111 * (m132 * m143 - m142 * m133) - m131 * (m112 * m143 - m142 * m113) + m141 * (m112 * m133 - m132 * m113));
         swz = -d * (m111 * (m122 * m143 - m142 * m123) - m121 * (m112 * m143 - m142 * m113) + m141 * (m112 * m123 - m122 * m113));
         tw = d * (m111 * (m122 * m133 - m132 * m123) - m121 * (m112 * m133 - m132 * m113) + m131 * (m112 * m123 - m122 * m113));
      }
      
      public function multiply3x3(param1:Matrix3D, param2:Matrix3D) : void
      {
         m111 = param1.sxx;
         m211 = param2.sxx;
         m121 = param1.syx;
         m221 = param2.syx;
         m131 = param1.szx;
         m231 = param2.szx;
         m112 = param1.sxy;
         m212 = param2.sxy;
         m122 = param1.syy;
         m222 = param2.syy;
         m132 = param1.szy;
         m232 = param2.szy;
         m113 = param1.sxz;
         m213 = param2.sxz;
         m123 = param1.syz;
         m223 = param2.syz;
         m133 = param1.szz;
         m233 = param2.szz;
         sxx = m111 * m211 + m112 * m221 + m113 * m231;
         sxy = m111 * m212 + m112 * m222 + m113 * m232;
         sxz = m111 * m213 + m112 * m223 + m113 * m233;
         syx = m121 * m211 + m122 * m221 + m123 * m231;
         syy = m121 * m212 + m122 * m222 + m123 * m232;
         syz = m121 * m213 + m122 * m223 + m123 * m233;
         szx = m131 * m211 + m132 * m221 + m133 * m231;
         szy = m131 * m212 + m132 * m222 + m133 * m232;
         szz = m131 * m213 + m132 * m223 + m133 * m233;
         tx = param1.tx;
         ty = param1.ty;
         tz = param1.tz;
      }
      
      public function orthographicProjectionMatrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         sxx = 2 / (param2 - param1);
         sxy = sxz = 0;
         tx = (param2 + param1) / (param2 - param1);
         syy = 2 / (param4 - param3);
         syx = syz = 0;
         ty = (param4 + param3) / (param4 - param3);
         szx = szy = 0;
         szz = -2 / (param6 - param5);
         tz = (param6 + param5) / (param6 - param5);
         swx = swy = swz = 0;
         tw = 1;
         var _loc7_:Matrix3D = new Matrix3D();
         _loc7_.scaleMatrix(1,1,-1);
         this.multiply(_loc7_,this);
      }
      
      public function translationMatrix(param1:Number, param2:Number, param3:Number) : void
      {
         sxx = syy = szz = 1;
         sxy = sxz = syz = syz = szx = szy = 0;
         tx = param1;
         ty = param2;
         tz = param3;
      }
      
      public function quaternion2matrix(param1:Quaternion) : void
      {
         x = param1.x;
         y = param1.y;
         z = param1.z;
         w = param1.w;
         xx = x * x;
         xy = x * y;
         xz = x * z;
         xw = x * w;
         yy = y * y;
         yz = y * z;
         yw = y * w;
         zz = z * z;
         zw = z * w;
         sxx = 1 - 2 * (yy + zz);
         sxy = 2 * (xy - zw);
         sxz = 2 * (xz + yw);
         syx = 2 * (xy + zw);
         syy = 1 - 2 * (xx + zz);
         syz = 2 * (yz - xw);
         szx = 2 * (xz - yw);
         szy = 2 * (yz + xw);
         szz = 1 - 2 * (xx + yy);
      }
      
      public function get forward() : Number3D
      {
         _forward.x = szx;
         _forward.y = szy;
         _forward.z = szz;
         return _forward;
      }
      
      public function set forward(param1:Number3D) : void
      {
         this.szx = param1.x;
         this.szy = param1.y;
         this.szz = param1.z;
      }
      
      public function rotationMatrix(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         nCos = Math.cos(param4);
         nSin = Math.sin(param4);
         scos = 1 - nCos;
         suv = param1 * param2 * scos;
         svw = param2 * param3 * scos;
         suw = param1 * param3 * scos;
         sw = nSin * param3;
         sv = nSin * param2;
         su = nSin * param1;
         sxx = nCos + param1 * param1 * scos;
         sxy = -sw + suv;
         sxz = sv + suw;
         syx = sw + suv;
         syy = nCos + param2 * param2 * scos;
         syz = -su + svw;
         szx = -sv + suw;
         szy = su + svw;
         szz = nCos + param3 * param3 * scos;
      }
      
      public function compare(param1:Matrix3D) : Boolean
      {
         if(sxx != param1.sxx || sxy != param1.sxy || sxz != param1.sxz || tx != param1.tx || syx != param1.syx || syy != param1.syy || syz != param1.syz || ty != param1.ty || szx != param1.szx || szy != param1.szy || szz != param1.szz || tz != param1.tz)
         {
            return false;
         }
         return true;
      }
      
      public function array2matrix(param1:Array, param2:Boolean, param3:Number) : void
      {
         if(param1.length >= 12)
         {
            if(param2)
            {
               sxx = param1[0];
               sxy = -param1[1];
               sxz = -param1[2];
               tx = -param1[3] * param3;
               syx = -param1[4];
               syy = param1[5];
               syz = param1[6];
               ty = param1[7] * param3;
               szx = -param1[8];
               szy = param1[9];
               szz = param1[10];
               tz = param1[11] * param3;
            }
            else
            {
               sxx = param1[0];
               sxz = param1[1];
               sxy = param1[2];
               tx = param1[3] * param3;
               szx = param1[4];
               szz = param1[5];
               szy = param1[6];
               tz = param1[7] * param3;
               syx = param1[8];
               syz = param1[9];
               syy = param1[10];
               ty = param1[11] * param3;
            }
         }
         if(param1.length >= 16)
         {
            swx = param1[12];
            swy = param1[13];
            swz = param1[14];
            tw = param1[15];
         }
         else
         {
            swx = swy = swz = 0;
            tw = 1;
         }
      }
      
      public function get det4x4() : Number
      {
         return (sxx * syy - syx * sxy) * (szz * tw - swz * tz) - (sxx * szy - szx * sxy) * (syz * tw - swz * ty) + (sxx * swy - swx * sxy) * (syz * tz - szz * ty) + (syx * szy - szx * syy) * (sxz * tw - swz * tx) - (syx * swy - swx * syy) * (sxz * tz - szz * tx) + (szx * swy - swx * szy) * (sxz * ty - syz * tx);
      }
   }
}


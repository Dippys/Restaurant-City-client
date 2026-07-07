package away3d.core.math
{
   public final class Number3D
   {
      
      public static var FORWARD:Number3D = new Number3D(0,0,1);
      
      public static var BACKWARD:Number3D = new Number3D(0,0,-1);
      
      public static var LEFT:Number3D = new Number3D(-1,0,0);
      
      public static var RIGHT:Number3D = new Number3D(1,0,0);
      
      public static var UP:Number3D = new Number3D(0,1,0);
      
      public static var DOWN:Number3D = new Number3D(0,-1,0);
      
      private var vy:Number;
      
      private var num:Number3D;
      
      private var mod:Number;
      
      private var vx:Number;
      
      private var vz:Number;
      
      private const MathPI:Number = 3.141592653589793;
      
      private var m1:Matrix3D;
      
      private var dist:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Number3D(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Boolean = false)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
         if(param4)
         {
            normalize();
         }
      }
      
      public static function getInterpolated(param1:Number3D, param2:Number3D, param3:Number) : Number3D
      {
         var _loc4_:Number3D = new Number3D();
         _loc4_.sub(param1,param2);
         _loc4_.scale(_loc4_,param3);
         _loc4_.add(_loc4_,param2);
         return _loc4_;
      }
      
      public function sub(param1:Number3D, param2:Number3D) : void
      {
         x = param1.x - param2.x;
         y = param1.y - param2.y;
         z = param1.z - param2.z;
      }
      
      public function interpolate(param1:Number3D, param2:Number) : void
      {
         var _loc3_:Number3D = new Number3D();
         _loc3_.sub(param1,this);
         _loc3_.scale(_loc3_,param2);
         add(this,_loc3_);
      }
      
      public function cross(param1:Number3D, param2:Number3D) : void
      {
         if(this == param1 || this == param2)
         {
            throw new Error("resultant cross product cannot be the same instance as an input");
         }
         x = param2.y * param1.z - param2.z * param1.y;
         y = param2.z * param1.x - param2.x * param1.z;
         z = param2.x * param1.y - param2.y * param1.x;
      }
      
      public function scale(param1:Number3D, param2:Number) : void
      {
         x = param1.x * param2;
         y = param1.y * param2;
         z = param1.z * param2;
      }
      
      public function toString() : String
      {
         return "x:" + x + " y:" + y + " z:" + z;
      }
      
      public function dot(param1:Number3D) : Number
      {
         return x * param1.x + y * param1.y + z * param1.z;
      }
      
      public function normalize(param1:Number = 1) : void
      {
         mod = modulo / param1;
         if(mod != 0 && mod != 1)
         {
            x /= mod;
            y /= mod;
            z /= mod;
         }
      }
      
      public function quaternion2euler(param1:Quaternion) : void
      {
         var _loc2_:Number = param1.x * param1.y + param1.z * param1.w;
         if(_loc2_ > 0.499)
         {
            x = 2 * Math.atan2(param1.x,param1.w);
            y = Math.PI / 2;
            z = 0;
            return;
         }
         if(_loc2_ < -0.499)
         {
            x = -2 * Math.atan2(param1.x,param1.w);
            y = -Math.PI / 2;
            z = 0;
            return;
         }
         var _loc3_:Number = param1.x * param1.x;
         var _loc4_:Number = param1.y * param1.y;
         var _loc5_:Number = param1.z * param1.z;
         x = Math.atan2(2 * param1.y * param1.w - 2 * param1.x * param1.z,1 - 2 * _loc4_ - 2 * _loc5_);
         y = Math.asin(2 * _loc2_);
         z = Math.atan2(2 * param1.x * param1.w - 2 * param1.y * param1.z,1 - 2 * _loc3_ - 2 * _loc5_);
      }
      
      public function matrix2scale(param1:Matrix3D) : void
      {
         x = Math.sqrt(param1.sxx * param1.sxx + param1.syx * param1.syx + param1.szx * param1.szx);
         y = Math.sqrt(param1.sxy * param1.sxy + param1.syy * param1.syy + param1.szy * param1.szy);
         z = Math.sqrt(param1.sxz * param1.sxz + param1.syz * param1.syz + param1.szz * param1.szz);
      }
      
      public function matrix2euler(param1:Matrix3D) : void
      {
         if(!m1)
         {
            m1 = new Matrix3D();
         }
         x = -Math.atan2(param1.szy,param1.szz);
         m1.rotationMatrix(1,0,0,x);
         m1.multiply(param1,m1);
         var _loc2_:Number = Math.sqrt(m1.sxx * m1.sxx + m1.syx * m1.syx);
         y = Math.atan2(-m1.szx,_loc2_);
         z = Math.atan2(-m1.sxy,m1.syy);
         if(Math.round(z / MathPI) == 1)
         {
            if(y > 0)
            {
               y = -(y - MathPI);
            }
            else
            {
               y = -(y + MathPI);
            }
            z -= MathPI;
            if(x > 0)
            {
               x -= MathPI;
            }
            else
            {
               x += MathPI;
            }
         }
         else if(Math.round(z / MathPI) == -1)
         {
            if(y > 0)
            {
               y = -(y - MathPI);
            }
            else
            {
               y = -(y + MathPI);
            }
            z += MathPI;
            if(x > 0)
            {
               x -= MathPI;
            }
            else
            {
               x += MathPI;
            }
         }
         else if(Math.round(x / MathPI) == 1)
         {
            if(y > 0)
            {
               y = -(y - MathPI);
            }
            else
            {
               y = -(y + MathPI);
            }
            x -= MathPI;
            if(z > 0)
            {
               z -= MathPI;
            }
            else
            {
               z += MathPI;
            }
         }
         else if(Math.round(x / MathPI) == -1)
         {
            if(y > 0)
            {
               y = -(y - MathPI);
            }
            else
            {
               y = -(y + MathPI);
            }
            x += MathPI;
            if(z > 0)
            {
               z -= MathPI;
            }
            else
            {
               z += MathPI;
            }
         }
      }
      
      public function rotate(param1:Number3D, param2:Matrix3D) : void
      {
         vx = param1.x;
         vy = param1.y;
         vz = param1.z;
         x = vx * param2.sxx + vy * param2.sxy + vz * param2.sxz;
         y = vx * param2.syx + vy * param2.syy + vz * param2.syz;
         z = vx * param2.szx + vy * param2.szy + vz * param2.szz;
      }
      
      public function clone(param1:Number3D) : void
      {
         x = param1.x;
         y = param1.y;
         z = param1.z;
      }
      
      public function closestPointOnPlane(param1:Number3D, param2:Number3D, param3:Number3D) : Number3D
      {
         if(!num)
         {
            num = new Number3D();
         }
         num.sub(param1,param2);
         dist = param3.dot(num);
         num.scale(param3,dist);
         num.sub(param1,num);
         return num;
      }
      
      public function add(param1:Number3D, param2:Number3D) : void
      {
         x = param1.x + param2.x;
         y = param1.y + param2.y;
         z = param1.z + param2.z;
      }
      
      public function getAngle(param1:Number3D = null) : Number
      {
         if(param1 == null)
         {
            param1 = new Number3D();
         }
         return Math.acos(dot(param1) / (modulo * param1.modulo));
      }
      
      public function distance(param1:Number3D) : Number
      {
         return Math.sqrt((x - param1.x) * (x - param1.x) + (y - param1.y) * (y - param1.y) + (z - param1.z) * (z - param1.z));
      }
      
      public function get modulo() : Number
      {
         return Math.sqrt(x * x + y * y + z * z);
      }
      
      public function transform(param1:Number3D, param2:Matrix3D) : void
      {
         vx = param1.x;
         vy = param1.y;
         vz = param1.z;
         x = vx * param2.sxx + vy * param2.sxy + vz * param2.sxz + param2.tx;
         y = vx * param2.syx + vy * param2.syy + vz * param2.syz + param2.ty;
         z = vx * param2.szx + vy * param2.szy + vz * param2.szz + param2.tz;
      }
      
      public function get modulo2() : Number
      {
         return x * x + y * y + z * z;
      }
      
      public function equals(param1:Number3D) : Boolean
      {
         return param1.x == x && param1.y == y && param1.z == z;
      }
   }
}


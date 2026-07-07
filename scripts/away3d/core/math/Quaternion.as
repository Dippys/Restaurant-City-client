package away3d.core.math
{
   public final class Quaternion
   {
      
      private var fSinYaw:Number;
      
      private var fCosYaw:Number;
      
      private var z2:Number;
      
      public var z:Number;
      
      private var fCosPitch:Number;
      
      private var w1:Number;
      
      private var w2:Number;
      
      private var cos_a:Number;
      
      private var fSinRoll:Number;
      
      private var x1:Number;
      
      private var x2:Number;
      
      private var sin_a:Number;
      
      private var fCosPitchCosYaw:Number;
      
      private var fSinPitch:Number;
      
      private var y1:Number;
      
      private var y2:Number;
      
      private var fCosRoll:Number;
      
      public var w:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      private var fSinPitchSinYaw:Number;
      
      private var z1:Number;
      
      public function Quaternion()
      {
         super();
      }
      
      public function normalize(param1:Number = 1) : void
      {
         var _loc2_:Number = magnitude * param1;
         x /= _loc2_;
         y /= _loc2_;
         z /= _loc2_;
         w /= _loc2_;
      }
      
      public function axis2quaternion(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         sin_a = Math.sin(param4 / 2);
         cos_a = Math.cos(param4 / 2);
         this.x = param1 * sin_a;
         this.y = param2 * sin_a;
         this.z = param3 * sin_a;
         w = cos_a;
         normalize();
      }
      
      public function get magnitude() : Number
      {
         return Math.sqrt(w * w + x * x + y * y + z * z);
      }
      
      public function multiply(param1:Quaternion, param2:Quaternion) : void
      {
         w1 = param1.w;
         x1 = param1.x;
         y1 = param1.y;
         z1 = param1.z;
         w2 = param2.w;
         x2 = param2.x;
         y2 = param2.y;
         z2 = param2.z;
         w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2;
         x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2;
         y = w1 * y2 + y1 * w2 + z1 * x2 - x1 * z2;
         z = w1 * z2 + z1 * w2 + x1 * y2 - y1 * x2;
      }
      
      public function euler2quaternion(param1:Number, param2:Number, param3:Number) : void
      {
         fSinPitch = Math.sin(param1 * 0.5);
         fCosPitch = Math.cos(param1 * 0.5);
         fSinYaw = Math.sin(param2 * 0.5);
         fCosYaw = Math.cos(param2 * 0.5);
         fSinRoll = Math.sin(param3 * 0.5);
         fCosRoll = Math.cos(param3 * 0.5);
         fCosPitchCosYaw = fCosPitch * fCosYaw;
         fSinPitchSinYaw = fSinPitch * fSinYaw;
         x = fSinRoll * fCosPitchCosYaw - fCosRoll * fSinPitchSinYaw;
         y = fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw;
         z = fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw;
         w = fCosRoll * fCosPitchCosYaw + fSinRoll * fSinPitchSinYaw;
      }
      
      public function toString() : String
      {
         return "{x:" + x + " y:" + y + " z:" + z + " w:" + w + "}";
      }
   }
}


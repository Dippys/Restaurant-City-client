package away3d.core.geom
{
   import away3d.core.base.Vertex;
   import away3d.core.math.Matrix3D;
   import away3d.core.math.Number3D;
   
   public class Plane3D
   {
      
      public static const FRONT:int = 1;
      
      public static const BACK:int = -1;
      
      public static const INTERSECT:int = 0;
      
      public static const EPSILON:Number = 0.001;
      
      public var a:Number;
      
      public var c:Number;
      
      public var b:Number;
      
      public var d:Number;
      
      private var _point:Number3D = new Number3D();
      
      private var _len:Number;
      
      public function Plane3D(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         this.a = param1;
         this.b = param2;
         this.c = param3;
         this.d = param4;
      }
      
      public function getIntersectionLine(param1:Vertex, param2:Vertex) : Vertex
      {
         var _loc3_:Number = _point.x * param1.x + _point.y * param1.y + _point.z * param1.z - d;
         var _loc4_:Number = _point.x * param2.x + _point.y * param2.y + _point.z * param2.z - d;
         var _loc5_:Number = _loc4_ / (_loc4_ - _loc3_);
         return new Vertex(param2.x + (param1.x - param2.x) * _loc5_,param2.y + (param1.y - param2.y) * _loc5_,param2.z + (param1.z - param2.z) * _loc5_);
      }
      
      public function fromNormalAndPoint(param1:Number3D, param2:Number3D) : void
      {
         a = param1.x;
         b = param1.y;
         c = param1.z;
         d = -(a * param2.x + b * param2.y + c * param2.z);
         _point = param1;
      }
      
      public function normalize() : Plane3D
      {
         var _loc1_:Number = Math.sqrt(a * a + b * b + c * c);
         a /= _loc1_;
         b /= _loc1_;
         c /= _loc1_;
         d /= _loc1_;
         return this;
      }
      
      public function classifyPoint(param1:Number3D) : int
      {
         var _loc2_:Number = a * param1.x + b * param1.y + c * param1.z + d;
         if(_loc2_ > -EPSILON && _loc2_ < EPSILON)
         {
            return Plane3D.INTERSECT;
         }
         if(_loc2_ < 0)
         {
            return Plane3D.BACK;
         }
         if(_loc2_ > 0)
         {
            return Plane3D.FRONT;
         }
         return Plane3D.INTERSECT;
      }
      
      public function from3vertices(param1:Vertex, param2:Vertex, param3:Vertex) : void
      {
         var _loc4_:Number = param2.x - param1.x;
         var _loc5_:Number = param2.y - param1.y;
         var _loc6_:Number = param2.z - param1.z;
         var _loc7_:Number = param3.x - param1.x;
         var _loc8_:Number = param3.y - param1.y;
         var _loc9_:Number = param3.z - param1.z;
         a = _loc5_ * _loc9_ - _loc6_ * _loc8_;
         b = _loc6_ * _loc7_ - _loc4_ * _loc9_;
         c = _loc4_ * _loc8_ - _loc5_ * _loc7_;
         d = -(a * param1.x + b * param1.y + c * param1.z);
      }
      
      public function closestPointFrom(param1:Number3D) : Number3D
      {
         var _loc2_:Number3D = null;
         _point.x = 0;
         _point.y = 0;
         if(c != 0)
         {
            _point.z = -d / c;
         }
         else
         {
            _point.z = -d / b;
         }
         _loc2_ = new Number3D();
         _loc2_.sub(param1,_point);
         var _loc3_:Number = a * _point.x + b * _point.y + c * _point.z;
         _loc2_.x -= _loc3_ * a;
         _loc2_.y -= _loc3_ * b;
         _loc2_.z -= _loc3_ * c;
         return _loc2_;
      }
      
      public function distance(param1:Number3D) : Number
      {
         _len = a * param1.x + b * param1.y + c * param1.z + d;
         if(_len > -EPSILON && _len < EPSILON)
         {
            _len = 0;
         }
         return _len;
      }
      
      public function getIntersectionLineNumbers(param1:Number3D, param2:Number3D) : Number3D
      {
         var _loc3_:Number = _point.x * param1.x + _point.y * param1.y + _point.z * param1.z - d;
         var _loc4_:Number = _point.x * param2.x + _point.y * param2.y + _point.z * param2.z - d;
         var _loc5_:Number = _loc4_ / (_loc4_ - _loc3_);
         return new Number3D(param2.x + (param1.x - param2.x) * _loc5_,param2.y + (param1.y - param2.y) * _loc5_,param2.z + (param1.z - param2.z) * _loc5_);
      }
      
      public function transform(param1:Matrix3D) : void
      {
         var _loc2_:Number = a;
         var _loc3_:Number = b;
         var _loc4_:Number = c;
         var _loc5_:Number = d;
         a = _loc2_ * param1.sxx + _loc3_ * param1.syx + _loc4_ * param1.szx + _loc5_ * param1.swx;
         b = _loc2_ * param1.sxy + _loc3_ * param1.syy + _loc4_ * param1.szy + _loc5_ * param1.swy;
         c = _loc2_ * param1.sxz + _loc3_ * param1.syz + _loc4_ * param1.szz + _loc5_ * param1.swz;
         d = _loc2_ * param1.tx + _loc3_ * param1.ty + _loc4_ * param1.tz + _loc5_ * param1.tw;
         normalize();
      }
      
      public function from3points(param1:Number3D, param2:Number3D, param3:Number3D) : void
      {
         var _loc4_:Number = param2.x - param1.x;
         var _loc5_:Number = param2.y - param1.y;
         var _loc6_:Number = param2.z - param1.z;
         var _loc7_:Number = param3.x - param1.x;
         var _loc8_:Number = param3.y - param1.y;
         var _loc9_:Number = param3.z - param1.z;
         a = _loc5_ * _loc9_ - _loc6_ * _loc8_;
         b = _loc6_ * _loc7_ - _loc4_ * _loc9_;
         c = _loc4_ * _loc8_ - _loc5_ * _loc7_;
         d = -(a * param1.x + b * param1.y + c * param1.z);
      }
   }
}


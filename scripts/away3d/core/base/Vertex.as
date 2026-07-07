package away3d.core.base
{
   import away3d.arcane;
   import away3d.core.draw.ScreenVertex;
   import away3d.core.math.Matrix3D;
   import away3d.core.math.Number3D;
   import away3d.core.utils.ValueObject;
   
   use namespace arcane;
   
   public class Vertex extends ValueObject
   {
      
      arcane var _x:Number;
      
      arcane var _z:Number;
      
      private var _position:Number3D = new Number3D();
      
      public var parents:Array = [];
      
      private var _vertexDirty:Boolean;
      
      arcane var _index:int;
      
      public var extra:Object;
      
      private var _positionDirty:Boolean;
      
      public var geometry:Geometry;
      
      arcane var _y:Number;
      
      private var _persp:Number;
      
      public function Vertex(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         arcane::_x = param1;
         arcane::_y = param2;
         arcane::_z = param3;
         _positionDirty = true;
      }
      
      public static function median(param1:Vertex, param2:Vertex) : Vertex
      {
         return new Vertex((param1._x + param2._x) / 2,(param1._y + param2._y) / 2,(param1._z + param2._z) / 2);
      }
      
      public static function weighted(param1:Vertex, param2:Vertex, param3:Number, param4:Number) : Vertex
      {
         var _loc5_:Number = param3 + param4;
         var _loc6_:Number = param3 / _loc5_;
         var _loc7_:Number = param4 / _loc5_;
         return new Vertex(param1._x * _loc6_ + param2._x * _loc7_,param1._y * _loc6_ + param2._y * _loc7_,param1._z * _loc6_ + param2._z * _loc7_);
      }
      
      public static function distanceSqr(param1:Vertex, param2:Vertex) : Number
      {
         return (param1._x + param2._x) * (param1._x + param2._x) + (param1._y + param2._y) * (param1._y + param2._y) + (param1._z + param2._z) * (param1._z + param2._z);
      }
      
      public function set y(param1:Number) : void
      {
         if(_y == param1)
         {
            return;
         }
         _y = param1;
         _positionDirty = true;
      }
      
      public function set z(param1:Number) : void
      {
         if(_z == param1)
         {
            return;
         }
         _z = param1;
         _positionDirty = true;
      }
      
      override public function toString() : String
      {
         return "new Vertex(" + _x + ", " + _y + ", " + _z + ")";
      }
      
      public function get y() : Number
      {
         if(_positionDirty)
         {
            updatePosition();
         }
         return _y;
      }
      
      private function updatePosition() : void
      {
         var _loc1_:Element = null;
         _positionDirty = false;
         for each(_loc1_ in parents)
         {
            _loc1_.vertexDirty = true;
         }
         _vertexDirty = true;
         _position.x = _x;
         _position.y = _y;
         _position.z = _z;
      }
      
      public function reset() : void
      {
         _x = 0;
         _y = 0;
         _z = 0;
         _positionDirty = true;
      }
      
      arcane function getVertexDirty() : Boolean
      {
         if(_positionDirty)
         {
            updatePosition();
         }
         if(_vertexDirty)
         {
            _vertexDirty = false;
            return true;
         }
         return false;
      }
      
      public function get z() : Number
      {
         if(_positionDirty)
         {
            updatePosition();
         }
         return _z;
      }
      
      public function clone() : Vertex
      {
         return new Vertex(_x,_y,_z);
      }
      
      public function add(param1:Number3D) : void
      {
         _x += param1.x;
         _y += param1.y;
         _z += param1.z;
         _positionDirty = true;
      }
      
      public function adjust(param1:Number, param2:Number, param3:Number, param4:Number = 1) : void
      {
         setValue(_x * (1 - param4) + param1 * param4,_y * (1 - param4) + param2 * param4,_z * (1 - param4) + param3 * param4);
      }
      
      public function get position() : Number3D
      {
         if(_positionDirty)
         {
            updatePosition();
         }
         return _position;
      }
      
      public function transform(param1:Matrix3D) : void
      {
         setValue(_x * param1.sxx + _y * param1.sxy + _z * param1.sxz + param1.tx,_x * param1.syx + _y * param1.syy + _z * param1.syz + param1.ty,_x * param1.szx + _y * param1.szy + _z * param1.szz + param1.tz);
      }
      
      public function setValue(param1:Number, param2:Number, param3:Number) : void
      {
         _x = param1;
         _y = param2;
         _z = param3;
         _positionDirty = true;
      }
      
      public function set x(param1:Number) : void
      {
         if(_x == param1)
         {
            return;
         }
         _x = param1;
         _positionDirty = true;
      }
      
      public function get x() : Number
      {
         if(_positionDirty)
         {
            updatePosition();
         }
         return _x;
      }
      
      public function perspective(param1:Number) : ScreenVertex
      {
         _persp = 1 / (1 + _z / param1);
         return new ScreenVertex(_x * _persp,_y * _persp,_z);
      }
   }
}


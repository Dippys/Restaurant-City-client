package away3d.core.base
{
   import away3d.arcane;
   import away3d.core.utils.*;
   import away3d.events.*;
   import away3d.materials.*;
   import flash.events.Event;
   
   use namespace arcane;
   
   public class Segment extends Element
   {
      
      arcane var _material:ISegmentMaterial;
      
      private var _index:int;
      
      arcane var _v0:Vertex;
      
      arcane var _v1:Vertex;
      
      private var _vertices:Array = new Array();
      
      private var _commands:Array = new Array();
      
      public var segmentVO:SegmentVO = new SegmentVO();
      
      public function Segment(param1:Vertex, param2:Vertex, param3:ISegmentMaterial = null)
      {
         super();
         this.v0 = param1;
         this.v1 = param2;
         this.material = param3;
         vertexDirty = true;
      }
      
      override public function get minY() : Number
      {
         if(_v0._y < _v1._y)
         {
            return _v0._y;
         }
         return _v1._y;
      }
      
      override public function get commands() : Array
      {
         return _commands;
      }
      
      public function curveTo(param1:Vertex, param2:Vertex) : void
      {
         addVertexAt(_vertices.length,param1,"C");
         addVertexAt(_vertices.length,param2,"P");
      }
      
      override public function get minX() : Number
      {
         if(_v0._x < _v1._x)
         {
            return _v0._x;
         }
         return _v1._x;
      }
      
      public function lineTo(param1:Vertex) : void
      {
         addVertexAt(_vertices.length,param1,"L");
      }
      
      public function set material(param1:ISegmentMaterial) : void
      {
         if(param1 == _material)
         {
            return;
         }
         if(_material != null && Boolean(parent))
         {
            parent.removeMaterial(this,_material);
         }
         _material = segmentVO.material = param1;
         if(_material != null && Boolean(parent))
         {
            parent.addMaterial(this,_material);
         }
      }
      
      override public function get maxX() : Number
      {
         if(_v0._x > _v1._x)
         {
            return _v0._x;
         }
         return _v1._x;
      }
      
      override public function get minZ() : Number
      {
         if(_v0._z < _v1._z)
         {
            return _v0._z;
         }
         return _v1._z;
      }
      
      private function onVertexValueChange(param1:Event) : void
      {
         notifyVertexValueChange();
      }
      
      override public function get radius2() : Number
      {
         var _loc1_:Number = _v0._x * _v0._x + _v0._y * _v0._y + _v0._z * _v0._z;
         var _loc2_:Number = _v1._x * _v1._x + _v1._y * _v1._y + _v1._z * _v1._z;
         if(_loc1_ > _loc2_)
         {
            return _loc1_;
         }
         return _loc2_;
      }
      
      public function get material() : ISegmentMaterial
      {
         return _material;
      }
      
      public function moveTo(param1:Vertex) : void
      {
         addVertexAt(_vertices.length,param1,"M");
      }
      
      public function set v0(param1:Vertex) : void
      {
         addVertexAt(0,param1,"M");
      }
      
      override public function get maxY() : Number
      {
         if(_v0._y > _v1._y)
         {
            return _v0._y;
         }
         return _v1._y;
      }
      
      public function set v1(param1:Vertex) : void
      {
         addVertexAt(1,param1,"L");
      }
      
      private function addVertexAt(param1:uint, param2:Vertex, param3:String) : void
      {
         if(Boolean(_vertices[param1]) && _vertices[param1] == param2)
         {
            return;
         }
         if(_vertices[param1])
         {
            _index = _vertices[param1].parents.indexOf(this);
            if(_index != -1)
            {
               _vertices[param1].parents.splice(_index,1);
            }
         }
         _commands[param1] = segmentVO.commands[param1] = param3;
         _vertices[param1] = segmentVO.vertices[param1] = param2;
         if(param1 == 0)
         {
            _v0 = segmentVO.v0 = param2;
         }
         else if(param1 == 1)
         {
            _v1 = segmentVO.v1 = param2;
         }
         param2.parents.push(this);
         vertexDirty = true;
      }
      
      override public function get vertices() : Array
      {
         return _vertices;
      }
      
      public function get v0() : Vertex
      {
         return _v0;
      }
      
      public function get v1() : Vertex
      {
         return _v1;
      }
      
      override public function get maxZ() : Number
      {
         if(_v0._z > _v1._z)
         {
            return _v0._z;
         }
         return _v1._z;
      }
   }
}


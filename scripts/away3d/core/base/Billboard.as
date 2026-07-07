package away3d.core.base
{
   import away3d.arcane;
   import away3d.core.utils.*;
   import away3d.events.*;
   import away3d.materials.*;
   
   use namespace arcane;
   
   public class Billboard extends Element
   {
      
      arcane var _vertex:Vertex;
      
      private var _height:Number;
      
      private var _width:Number;
      
      arcane var _material:IBillboardMaterial;
      
      private var _scaling:Number;
      
      private var _index:int;
      
      private var _vertices:Array = new Array();
      
      private var _commands:Array = new Array();
      
      private var _rotation:Number;
      
      public var billboardVO:BillboardVO = new BillboardVO();
      
      public function Billboard(param1:Vertex, param2:IBillboardMaterial = null, param3:Number = 10, param4:Number = 10, param5:Number = 0, param6:Number = 1)
      {
         super();
         this.vertex = param1;
         this.material = param2;
         this.width = param3;
         this.height = param4;
         this.rotation = param5;
         this.scaling = param6;
         billboardVO.billboard = this;
         vertexDirty = true;
      }
      
      public function get y() : Number
      {
         return _vertex.y;
      }
      
      public function get z() : Number
      {
         return _vertex.z;
      }
      
      public function set width(param1:Number) : void
      {
         if(_width == param1)
         {
            return;
         }
         _width = billboardVO.width = param1;
         notifyMappingChange();
      }
      
      public function set vertex(param1:Vertex) : void
      {
         if(param1 == _vertex)
         {
            return;
         }
         if(_vertex)
         {
            _index = _vertex.parents.indexOf(this);
            if(_index != -1)
            {
               _vertex.parents.splice(_index,1);
            }
         }
         _commands[0] = billboardVO.command = "M";
         _vertices[0] = _vertex = billboardVO.vertex = param1;
         if(_vertex)
         {
            _vertex.parents.push(this);
         }
         vertexDirty = true;
      }
      
      public function set x(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(x)");
         }
         if(_vertex.x == param1)
         {
            return;
         }
         if(param1 == Infinity)
         {
            Debug.warning("x == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("x == -Infinity");
         }
         _vertex.x = param1;
      }
      
      public function set height(param1:Number) : void
      {
         if(_height == param1)
         {
            return;
         }
         _height = billboardVO.height = param1;
         notifyMappingChange();
      }
      
      public function get scaling() : Number
      {
         return _scaling;
      }
      
      override public function get commands() : Array
      {
         return _commands;
      }
      
      public function get width() : Number
      {
         return _width;
      }
      
      override public function get minY() : Number
      {
         return _vertex._y;
      }
      
      override public function get radius2() : Number
      {
         return 0;
      }
      
      override public function get maxX() : Number
      {
         return _vertex._x;
      }
      
      public function set scaling(param1:Number) : void
      {
         if(_scaling == param1)
         {
            return;
         }
         _scaling = billboardVO.scaling = param1;
         notifyMappingChange();
      }
      
      public function get vertex() : Vertex
      {
         return _vertex;
      }
      
      override public function get minX() : Number
      {
         return _vertex._x;
      }
      
      override public function get minZ() : Number
      {
         return _vertex._z;
      }
      
      public function get material() : IBillboardMaterial
      {
         return _material;
      }
      
      public function set y(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(y)");
         }
         if(_vertex.y == param1)
         {
            return;
         }
         if(param1 == Infinity)
         {
            Debug.warning("y == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("y == -Infinity");
         }
         _vertex.y = param1;
      }
      
      public function set z(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(z)");
         }
         if(_vertex.z == param1)
         {
            return;
         }
         if(param1 == Infinity)
         {
            Debug.warning("z == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("z == -Infinity");
         }
         _vertex.z = param1;
      }
      
      override public function get maxY() : Number
      {
         return _vertex._y;
      }
      
      public function get height() : Number
      {
         return _width;
      }
      
      public function get x() : Number
      {
         return _vertex.x;
      }
      
      override public function get vertices() : Array
      {
         return _vertices;
      }
      
      public function set material(param1:IBillboardMaterial) : void
      {
         if(_material == param1)
         {
            return;
         }
         if(_material != null && Boolean(parent))
         {
            parent.removeMaterial(this,_material);
         }
         _material = billboardVO.material = param1;
         if(_material != null && Boolean(parent))
         {
            parent.addMaterial(this,_material);
         }
      }
      
      public function set rotation(param1:Number) : void
      {
         if(_rotation == param1)
         {
            return;
         }
         _rotation = billboardVO.rotation = param1;
         notifyMappingChange();
      }
      
      override public function get maxZ() : Number
      {
         return _vertex._z;
      }
      
      public function get rotation() : Number
      {
         return _rotation;
      }
   }
}


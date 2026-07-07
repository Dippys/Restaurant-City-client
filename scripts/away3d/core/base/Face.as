package away3d.core.base
{
   import away3d.arcane;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import away3d.materials.*;
   import flash.events.Event;
   
   use namespace arcane;
   
   public class Face extends Element
   {
      
      arcane var _material:ITriangleMaterial;
      
      private var _drawingCommands:Array = new Array();
      
      private var _normal:Number3D = new Number3D();
      
      private var _lastAddedVertex:Vertex;
      
      arcane var _v0:Vertex;
      
      arcane var _v1:Vertex;
      
      arcane var _v2:Vertex;
      
      arcane var _back:ITriangleMaterial;
      
      private var _index:int;
      
      private var _areaDirty:Boolean;
      
      public var faceVO:FaceVO = new FaceVO();
      
      private var _b:Number;
      
      private var _vertices:Array = new Array();
      
      private var _a:Number;
      
      private var _c:Number;
      
      private var _normalDirty:Boolean;
      
      private var _commands:Array = new Array();
      
      arcane var _uv0:UV;
      
      arcane var _uv1:UV;
      
      arcane var _uv2:UV;
      
      private var _area:Number;
      
      private var _s:Number;
      
      public function Face(param1:Vertex = null, param2:Vertex = null, param3:Vertex = null, param4:ITriangleMaterial = null, param5:UV = null, param6:UV = null, param7:UV = null)
      {
         super();
         if(param1)
         {
            this.v0 = param1;
         }
         if(param2)
         {
            this.v1 = param2;
         }
         if(param3)
         {
            this.v2 = param3;
         }
         this.material = param4;
         this.uv0 = param5;
         this.uv1 = param6;
         this.uv2 = param7;
         faceVO.face = this;
         vertexDirty = true;
      }
      
      public function get uvs() : Array
      {
         return [_uv0,_uv1,_uv2];
      }
      
      public function get v1() : Vertex
      {
         return _v1;
      }
      
      override public function get maxX() : Number
      {
         if(_v0._x > _v1._x)
         {
            if(_v0._x > _v2._x)
            {
               return _v0._x;
            }
            return _v2._x;
         }
         if(_v1._x > _v2._x)
         {
            return _v1._x;
         }
         return _v2._x;
      }
      
      public function set uv2(param1:UV) : void
      {
         if(param1 == _uv2)
         {
            return;
         }
         if(_uv2 != null)
         {
            if(_uv2 != _uv1 && _uv2 != _uv0)
            {
               _uv2.removeOnChange(onUVChange);
            }
         }
         _uv2 = faceVO.uv2 = param1;
         if(_uv2 != null)
         {
            if(_uv2 != _uv1 && _uv2 != _uv0)
            {
               _uv2.addOnChange(onUVChange);
            }
         }
         notifyMappingChange();
      }
      
      override public function get maxZ() : Number
      {
         if(_v0._z > _v1._z)
         {
            if(_v0._z > _v2._z)
            {
               return _v0._z;
            }
            return _v2._z;
         }
         if(_v1._z > _v2._z)
         {
            return _v1._z;
         }
         return _v2._z;
      }
      
      override public function get commands() : Array
      {
         return _commands;
      }
      
      public function get back() : ITriangleMaterial
      {
         return _back;
      }
      
      public function clone() : Face
      {
         var _loc2_:uint = 0;
         var _loc3_:DrawingCommand = null;
         var _loc1_:Face = new Face();
         while(_loc2_ < drawingCommands.length)
         {
            _loc3_ = drawingCommands[_loc2_];
            switch(_loc3_.type)
            {
               case DrawingCommand.MOVE:
                  _loc1_.moveTo(_loc3_.pEnd.x,_loc3_.pEnd.y,_loc3_.pEnd.z);
                  break;
               case DrawingCommand.LINE:
                  _loc1_.lineTo(_loc3_.pEnd.x,_loc3_.pEnd.y,_loc3_.pEnd.z);
                  break;
               case DrawingCommand.CURVE:
                  _loc1_.curveTo(_loc3_.pControl.x,_loc3_.pControl.y,_loc3_.pControl.z,_loc3_.pEnd.x,_loc3_.pEnd.y,_loc3_.pEnd.z);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function onUVChange(param1:Event) : void
      {
         notifyMappingChange();
      }
      
      public function set back(param1:ITriangleMaterial) : void
      {
         if(param1 == _back)
         {
            return;
         }
         if(_back != null)
         {
            parent.removeMaterial(this,_back);
         }
         _back = faceVO.back = param1;
         if(_back != null)
         {
            parent.addMaterial(this,_back);
         }
         notifyMappingChange();
      }
      
      public function lineTo(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Vertex = new Vertex(param1,param2,param3);
         addVertexAt(_vertices.length,_loc4_,DrawingCommand.LINE);
         _drawingCommands.push(new DrawingCommand(DrawingCommand.LINE,_lastAddedVertex,null,_loc4_));
         _lastAddedVertex = _loc4_;
      }
      
      private function updateNormal() : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         _normalDirty = false;
         var _loc1_:Number = _v1.x - _v0.x;
         var _loc2_:Number = _v1.y - _v0.y;
         var _loc3_:Number = _v1.z - _v0.z;
         var _loc4_:Number = _v2.x - _v0.x;
         var _loc5_:Number = _v2.y - _v0.y;
         var _loc6_:Number = _v2.z - _v0.z;
         var _loc7_:Number = _loc2_ * _loc6_ - _loc3_ * _loc5_;
         var _loc8_:Number = _loc3_ * _loc4_ - _loc1_ * _loc6_;
         _loc9_ = _loc1_ * _loc5_ - _loc2_ * _loc4_;
         _loc10_ = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_ + _loc9_ * _loc9_);
         _normal.x = _loc7_ / _loc10_;
         _normal.y = _loc8_ / _loc10_;
         _normal.z = _loc9_ / _loc10_;
      }
      
      public function scaleAboutCenter(param1:Number) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:DrawingCommand = null;
         var _loc11_:Number3D = null;
         var _loc12_:Number3D = null;
         var _loc2_:Number = Number.MAX_VALUE;
         var _loc3_:Number = -Number.MAX_VALUE;
         var _loc4_:Number = Number.MAX_VALUE;
         var _loc5_:Number = -Number.MAX_VALUE;
         var _loc6_:Number = Number.MAX_VALUE;
         var _loc7_:Number = -Number.MAX_VALUE;
         _loc8_ = 0;
         while(_loc8_ < drawingCommands.length)
         {
            _loc9_ = drawingCommands[_loc8_];
            if(_loc9_.pControl)
            {
               if(_loc9_.pControl.x < _loc2_)
               {
                  _loc2_ = _loc9_.pControl.x;
               }
               if(_loc9_.pControl.x > _loc3_)
               {
                  _loc3_ = _loc9_.pControl.x;
               }
               if(_loc9_.pControl.y < _loc4_)
               {
                  _loc4_ = _loc9_.pControl.y;
               }
               if(_loc9_.pControl.y > _loc5_)
               {
                  _loc5_ = _loc9_.pControl.y;
               }
               if(_loc9_.pControl.z < _loc6_)
               {
                  _loc6_ = _loc9_.pControl.z;
               }
               if(_loc9_.pControl.z > _loc7_)
               {
                  _loc7_ = _loc9_.pControl.z;
               }
            }
            if(_loc9_.pEnd)
            {
               if(_loc9_.pEnd.x < _loc2_)
               {
                  _loc2_ = _loc9_.pEnd.x;
               }
               if(_loc9_.pEnd.x > _loc3_)
               {
                  _loc3_ = _loc9_.pEnd.x;
               }
               if(_loc9_.pEnd.y < _loc4_)
               {
                  _loc4_ = _loc9_.pEnd.y;
               }
               if(_loc9_.pEnd.y > _loc5_)
               {
                  _loc5_ = _loc9_.pEnd.y;
               }
               if(_loc9_.pEnd.z < _loc6_)
               {
                  _loc6_ = _loc9_.pEnd.z;
               }
               if(_loc9_.pEnd.z > _loc7_)
               {
                  _loc7_ = _loc9_.pEnd.z;
               }
            }
            _loc8_++;
         }
         var _loc10_:Number3D = new Number3D((_loc3_ + _loc2_) / 2,(_loc5_ + _loc4_) / 2,(_loc7_ + _loc6_) / 2);
         _loc8_ = 0;
         while(_loc8_ < drawingCommands.length)
         {
            _loc9_ = drawingCommands[_loc8_];
            if(_loc9_.pControl)
            {
               _loc11_ = new Number3D(_loc9_.pControl.x,_loc9_.pControl.y,_loc9_.pControl.z);
               _loc11_.sub(_loc11_,_loc10_);
               _loc11_.scale(_loc11_,param1);
               _loc9_.pControl.x = _loc10_.x + _loc11_.x;
               _loc9_.pControl.y = _loc10_.y + _loc11_.y;
               _loc9_.pControl.z = _loc10_.z + _loc11_.z;
            }
            if(_loc9_.pEnd)
            {
               _loc12_ = new Number3D(_loc9_.pEnd.x,_loc9_.pEnd.y,_loc9_.pEnd.z);
               _loc12_.sub(_loc12_,_loc10_);
               _loc12_.scale(_loc12_,param1);
               _loc9_.pEnd.x = _loc10_.x + _loc12_.x;
               _loc9_.pEnd.y = _loc10_.y + _loc12_.y;
               _loc9_.pEnd.z = _loc10_.z + _loc12_.z;
            }
            _loc8_++;
         }
      }
      
      public function get area() : Number
      {
         if(vertexDirty)
         {
            updateVertex();
         }
         if(_areaDirty)
         {
            updateArea();
         }
         return _area;
      }
      
      public function get normal() : Number3D
      {
         if(vertexDirty)
         {
            updateVertex();
         }
         if(_normalDirty)
         {
            updateNormal();
         }
         return _normal;
      }
      
      public function get material() : ITriangleMaterial
      {
         return _material;
      }
      
      override public function get minX() : Number
      {
         if(_v0._x < _v1._x)
         {
            if(_v0._x < _v2._x)
            {
               return _v0._x;
            }
            return _v2._x;
         }
         if(_v1._x < _v2._x)
         {
            return _v1._x;
         }
         return _v2._x;
      }
      
      public function invert() : void
      {
         faceVO.v2 = this._v1;
         faceVO.v1 = this._v2;
         faceVO.uv2 = this._uv1;
         faceVO.uv1 = this._uv2;
         this._v1 = faceVO.v1;
         this._v2 = faceVO.v2;
         this._uv1 = faceVO.uv1;
         this._uv2 = faceVO.uv2;
         vertexDirty = true;
         notifyMappingChange();
      }
      
      public function offset(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:DrawingCommand = null;
         while(_loc4_ < drawingCommands.length)
         {
            _loc5_ = drawingCommands[_loc4_];
            if(_loc5_.pControl)
            {
               _loc5_.pControl.x += param1;
               _loc5_.pControl.y += param2;
               _loc5_.pControl.z += param3;
            }
            if(_loc5_.pEnd)
            {
               _loc5_.pEnd.x += param1;
               _loc5_.pEnd.y += param2;
               _loc5_.pEnd.z += param3;
            }
            _loc4_++;
         }
      }
      
      public function moveTo(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Vertex = new Vertex(param1,param2,param3);
         addVertexAt(_vertices.length,_loc4_,DrawingCommand.MOVE);
         _drawingCommands.push(new DrawingCommand(DrawingCommand.MOVE,_lastAddedVertex,null,_loc4_));
         _lastAddedVertex = _loc4_;
      }
      
      public function get uv0() : UV
      {
         return _uv0;
      }
      
      public function get uv2() : UV
      {
         return _uv2;
      }
      
      public function get uv1() : UV
      {
         return _uv1;
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
         _commands[param1] = faceVO.commands[param1] = param3;
         _vertices[param1] = faceVO.vertices[param1] = param2;
         if(param1 == 0)
         {
            _v0 = faceVO.v0 = param2;
         }
         else if(param1 == 1)
         {
            _v1 = faceVO.v1 = param2;
         }
         else if(param1 == 2)
         {
            _v2 = faceVO.v2 = param2;
         }
         if(param1 == 2)
         {
            if(-0.5 * (_v0.x * (_v2.y - _v1.y) + _v1.x * (_v0.y - _v2.y) + _v2.x * (_v1.y - _v0.y)) < 0)
            {
               faceVO.reverseArea = true;
            }
         }
         param2._index = param1;
         param2.parents.push(this);
         vertexDirty = true;
      }
      
      override public function get radius2() : Number
      {
         var _loc1_:Number = _v0._x * _v0._x + _v0._y * _v0._y + _v0._z * _v0._z;
         var _loc2_:Number = _v1._x * _v1._x + _v1._y * _v1._y + _v1._z * _v1._z;
         var _loc3_:Number = _v2._x * _v2._x + _v2._y * _v2._y + _v2._z * _v2._z;
         if(_loc1_ > _loc2_)
         {
            if(_loc1_ > _loc3_)
            {
               return _loc1_;
            }
            return _loc3_;
         }
         if(_loc2_ > _loc3_)
         {
            return _loc2_;
         }
         return _loc3_;
      }
      
      override public function get minY() : Number
      {
         if(_v0._y < _v1._y)
         {
            if(_v0._y < _v2._y)
            {
               return _v0._y;
            }
            return _v2._y;
         }
         if(_v1._y < _v2._y)
         {
            return _v1._y;
         }
         return _v2._y;
      }
      
      public function curveTo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc7_:Vertex = new Vertex(param1,param2,param3);
         var _loc8_:Vertex = new Vertex(param4,param5,param6);
         addVertexAt(_vertices.length,_loc7_,DrawingCommand.CURVE);
         addVertexAt(_vertices.length,_loc8_,"P");
         _drawingCommands.push(new DrawingCommand(DrawingCommand.CURVE,_lastAddedVertex,_loc7_,_loc8_));
         _lastAddedVertex = _loc8_;
      }
      
      private function updateVertex() : void
      {
         vertexDirty = false;
         _normalDirty = true;
         _areaDirty = true;
      }
      
      override public function get minZ() : Number
      {
         if(_v0._z < _v1._z)
         {
            if(_v0._z < _v2._z)
            {
               return _v0._z;
            }
            return _v2._z;
         }
         if(_v1._z < _v2._z)
         {
            return _v1._z;
         }
         return _v2._z;
      }
      
      public function set normalDirty(param1:Boolean) : void
      {
         vertexDirty = param1;
      }
      
      public function set uv0(param1:UV) : void
      {
         if(param1 == _uv0)
         {
            return;
         }
         if(_uv0 != null)
         {
            if(_uv0 != _uv1 && _uv0 != _uv2)
            {
               _uv0.removeOnChange(onUVChange);
            }
         }
         _uv0 = faceVO.uv0 = param1;
         if(_uv0 != null)
         {
            if(_uv0 != _uv1 && _uv0 != _uv2)
            {
               _uv0.addOnChange(onUVChange);
            }
         }
         notifyMappingChange();
      }
      
      public function set material(param1:ITriangleMaterial) : void
      {
         if(param1 == _material)
         {
            return;
         }
         if(_material != null && Boolean(parent))
         {
            parent.removeMaterial(this,_material);
         }
         _material = faceVO.material = param1;
         if(_material != null && Boolean(parent))
         {
            parent.addMaterial(this,_material);
         }
         notifyMappingChange();
      }
      
      public function set uv1(param1:UV) : void
      {
         if(param1 == _uv1)
         {
            return;
         }
         if(_uv1 != null)
         {
            if(_uv1 != _uv0 && _uv1 != _uv2)
            {
               _uv1.removeOnChange(onUVChange);
            }
         }
         _uv1 = faceVO.uv1 = param1;
         if(_uv1 != null)
         {
            if(_uv1 != _uv0 && _uv1 != _uv2)
            {
               _uv1.addOnChange(onUVChange);
            }
         }
         notifyMappingChange();
      }
      
      override public function get maxY() : Number
      {
         if(_v0._y > _v1._y)
         {
            if(_v0._y > _v2._y)
            {
               return _v0._y;
            }
            return _v2._y;
         }
         if(_v1._y > _v2._y)
         {
            return _v1._y;
         }
         return _v2._y;
      }
      
      private function updateArea() : void
      {
         _a = v0.position.distance(v1.position);
         _b = v1.position.distance(v2.position);
         _c = v2.position.distance(v0.position);
         _s = (_a + _b + _c) / 2;
         _area = Math.sqrt(_s * (_s - _a) * (_s - _b) * (_s - _c));
      }
      
      public function set v2(param1:Vertex) : void
      {
         addVertexAt(2,param1,"L");
      }
      
      override public function get vertices() : Array
      {
         return _vertices;
      }
      
      public function get v0() : Vertex
      {
         return _v0;
      }
      
      public function set v0(param1:Vertex) : void
      {
         addVertexAt(0,param1,"M");
      }
      
      public function get v2() : Vertex
      {
         return _v2;
      }
      
      public function set v1(param1:Vertex) : void
      {
         addVertexAt(1,param1,"L");
      }
      
      public function get drawingCommands() : Array
      {
         return _drawingCommands;
      }
   }
}


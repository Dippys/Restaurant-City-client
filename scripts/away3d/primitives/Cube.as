package away3d.primitives
{
   import away3d.arcane;
   import away3d.core.base.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import away3d.materials.*;
   import away3d.primitives.data.*;
   
   use namespace arcane;
   
   public class Cube extends AbstractPrimitive
   {
      
      private var _cubeMaterials:CubeMaterialsData;
      
      private var _backFaces:Array;
      
      private var _leftFaces:Array;
      
      private var _bottomFaces:Array;
      
      private var _rightFaces:Array;
      
      private var _segmentsH:int;
      
      private var _frontFaces:Array;
      
      private var _offset:Number = 0;
      
      private var _segmentsW:int;
      
      private var _topFaces:Array;
      
      private var _depth:Number;
      
      private var _height:Number;
      
      private var _width:Number;
      
      private var _cubeFaceArray:Array;
      
      private var _flip:Boolean;
      
      private var _map6:Boolean;
      
      private var _dbu:Array;
      
      private var _dbv:Array;
      
      public function Cube(param1:Object = null)
      {
         super(param1);
         _width = ini.getNumber("width",100,{"min":0});
         _height = ini.getNumber("height",100,{"min":0});
         _depth = ini.getNumber("depth",100,{"min":0});
         _flip = ini.getBoolean("flip",false);
         _cubeMaterials = ini.getCubeMaterials("faces");
         _segmentsW = ini.getInt("segmentsW",1,{"min":1});
         _segmentsH = ini.getInt("segmentsH",1,{"min":1});
         _map6 = ini.getBoolean("map6",false);
         if(!_cubeMaterials)
         {
            _cubeMaterials = ini.getCubeMaterials("cubeMaterials");
         }
         if(!_cubeMaterials)
         {
            _cubeMaterials = new CubeMaterialsData();
         }
         _cubeMaterials.addOnMaterialChange(onCubeMaterialChange);
         type = "Cube";
         url = "primitive";
      }
      
      public function set depth(param1:Number) : void
      {
         if(_depth == param1)
         {
            return;
         }
         _depth = param1;
         _primitiveDirty = true;
      }
      
      private function onCubeMaterialChange(param1:MaterialEvent) : void
      {
         var _loc2_:Face = null;
         switch(param1.extra)
         {
            case "left":
               _cubeFaceArray = _leftFaces;
               break;
            case "right":
               _cubeFaceArray = _rightFaces;
               break;
            case "bottom":
               _cubeFaceArray = _bottomFaces;
               break;
            case "top":
               _cubeFaceArray = _topFaces;
               break;
            case "front":
               _cubeFaceArray = _frontFaces;
               break;
            case "back":
               _cubeFaceArray = _backFaces;
         }
         for each(_loc2_ in _cubeFaceArray)
         {
            _loc2_.material = param1.material as ITriangleMaterial;
         }
      }
      
      private function makeUV(param1:Number, param2:Number) : UV
      {
         var _loc3_:int = 0;
         while(_loc3_ < _dbu.length)
         {
            if(_dbu[_loc3_].u == param1 && _dbu[_loc3_].v == param2)
            {
               return _dbu[_loc3_];
            }
            _loc3_++;
         }
         var _loc4_:UV = createUV(param1,param2);
         _dbu[_dbu.length] = _loc4_;
         return _loc4_;
      }
      
      public function set width(param1:Number) : void
      {
         if(_width == param1)
         {
            return;
         }
         _width = param1;
         _primitiveDirty = true;
      }
      
      public function get height() : Number
      {
         return _height;
      }
      
      override protected function buildPrimitive() : void
      {
         var _loc6_:int = 0;
         var _loc7_:Vertex = null;
         var _loc8_:Vertex = null;
         var _loc9_:Vertex = null;
         var _loc10_:UV = null;
         var _loc11_:UV = null;
         var _loc12_:UV = null;
         var _loc13_:Face = null;
         super.buildPrimitive();
         _leftFaces = [];
         _rightFaces = [];
         _bottomFaces = [];
         _topFaces = [];
         _frontFaces = [];
         _backFaces = [];
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Number = _width * 0.5;
         var _loc4_:Number = _height * 0.5;
         var _loc5_:Number = _depth * 0.5;
         _dbv = [];
         _dbu = [];
         var _loc14_:Number = _width / _segmentsW;
         _loc6_ = 0;
         while(_loc6_ <= _segmentsW)
         {
            _loc1_[_loc6_] = createVertex(-_loc3_ + _loc6_ * _loc14_,_loc4_,-_loc5_);
            _loc2_[_loc6_] = createVertex(-_loc3_ + _loc6_ * _loc14_,-_loc4_,-_loc5_);
            _loc6_++;
         }
         buildSide([_loc2_,_loc1_],_cubeMaterials.back,_backFaces,"b");
         _loc2_ = [];
         _loc1_ = [];
         var _loc15_:Number = _map6 ? _offset : 0;
         var _loc16_:Number = _map6 ? 0.5 : 0;
         _loc6_ = 0;
         while(_loc6_ < _backFaces.length)
         {
            _loc13_ = _backFaces[_loc6_];
            _loc7_ = makeVertex(_loc13_.v0.x,_loc13_.v0.y,-_loc13_.v0.z);
            _loc8_ = makeVertex(_loc13_.v1.x,_loc13_.v1.y,-_loc13_.v1.z);
            _loc9_ = makeVertex(_loc13_.v2.x,_loc13_.v2.y,-_loc13_.v2.z);
            _loc10_ = makeUV(1 - (_loc13_.uv0.u + _loc15_),_loc13_.uv0.v + _loc16_);
            _loc11_ = makeUV(1 - (_loc13_.uv1.u + _loc15_),_loc13_.uv1.v + _loc16_);
            _loc12_ = makeUV(1 - (_loc13_.uv2.u + _loc15_),_loc13_.uv2.v + _loc16_);
            addFace(createFace(_loc8_,_loc7_,_loc9_,_cubeMaterials.front,_loc11_,_loc10_,_loc12_));
            _frontFaces.push(faces[faces.length - 1]);
            _loc6_++;
         }
         _loc14_ = _depth / _segmentsW;
         _loc6_ = 0;
         while(_loc6_ <= _segmentsW)
         {
            _loc1_[_loc6_] = makeVertex(_loc3_,_loc4_,-_loc5_ + _loc6_ * _loc14_);
            _loc2_[_loc6_] = makeVertex(_loc3_,-_loc4_,-_loc5_ + _loc6_ * _loc14_);
            _loc6_++;
         }
         buildSide([_loc2_,_loc1_],_cubeMaterials.left,_leftFaces,"l");
         _loc1_ = [];
         _loc2_ = [];
         _loc15_ = _map6 ? 0.5 : 0;
         _loc6_ = 0;
         while(_loc6_ < _leftFaces.length)
         {
            _loc13_ = _leftFaces[_loc6_];
            _loc7_ = makeVertex(-_loc13_.v0.x,_loc13_.v0.y,_loc13_.v0.z);
            _loc8_ = makeVertex(-_loc13_.v1.x,_loc13_.v1.y,_loc13_.v1.z);
            _loc9_ = makeVertex(-_loc13_.v2.x,_loc13_.v2.y,_loc13_.v2.z);
            _loc10_ = makeUV(1 - _loc13_.uv0.u,_loc13_.uv0.v);
            _loc11_ = makeUV(1 - _loc13_.uv1.u,_loc13_.uv1.v);
            _loc12_ = makeUV(1 - _loc13_.uv2.u,_loc13_.uv2.v);
            addFace(createFace(_loc8_,_loc7_,_loc9_,_cubeMaterials.right,_loc11_,_loc10_,_loc12_));
            _rightFaces.push(faces[faces.length - 1]);
            _loc6_++;
         }
         _loc14_ = _map6 ? _depth / _segmentsW : _width / _segmentsW;
         _loc6_ = 0;
         while(_loc6_ <= _segmentsW)
         {
            if(_map6)
            {
               _loc1_[_loc6_] = makeVertex(-_loc3_,_loc4_,_loc5_ - _loc6_ * _loc14_);
               _loc2_[_loc6_] = makeVertex(_loc3_,_loc4_,_loc5_ - _loc6_ * _loc14_);
            }
            else
            {
               _loc1_[_loc6_] = makeVertex(_loc3_ - _loc6_ * _loc14_,_loc4_,_loc5_);
               _loc2_[_loc6_] = makeVertex(_loc3_ - _loc6_ * _loc14_,_loc4_,-_loc5_);
            }
            _loc6_++;
         }
         buildSide([_loc1_,_loc2_],_cubeMaterials.top,_topFaces,"t");
         _loc15_ = _map6 ? _offset : 0;
         _loc6_ = 0;
         while(_loc6_ < _topFaces.length)
         {
            _loc13_ = _topFaces[_loc6_];
            _loc7_ = makeVertex(_loc13_.v0.x,-_loc13_.v0.y,_loc13_.v0.z);
            _loc8_ = makeVertex(_loc13_.v1.x,-_loc13_.v1.y,_loc13_.v1.z);
            _loc9_ = makeVertex(_loc13_.v2.x,-_loc13_.v2.y,_loc13_.v2.z);
            _loc10_ = makeUV(1 - _loc13_.uv0.u + _loc15_,_loc13_.uv0.v);
            _loc11_ = makeUV(1 - _loc13_.uv1.u + _loc15_,_loc13_.uv1.v);
            _loc12_ = makeUV(1 - _loc13_.uv2.u + _loc15_,_loc13_.uv2.v);
            addFace(createFace(_loc8_,_loc7_,_loc9_,_cubeMaterials.bottom,_loc11_,_loc10_,_loc12_));
            _bottomFaces.push(faces[faces.length - 1]);
            _loc6_++;
         }
         _loc1_ = _loc2_ = _dbv = _dbu = null;
      }
      
      public function get segmentsH() : Number
      {
         return _segmentsH;
      }
      
      public function set map6(param1:Boolean) : void
      {
         _map6 = param1;
      }
      
      public function get segmentsW() : Number
      {
         return _segmentsW;
      }
      
      private function makeVertex(param1:Number, param2:Number, param3:Number) : Vertex
      {
         var _loc4_:int = 0;
         while(_loc4_ < _dbv.length)
         {
            if(_dbv[_loc4_].x == param1 && _dbv[_loc4_].y == param2 && _dbv[_loc4_].z == param3)
            {
               return _dbv[_loc4_];
            }
            _loc4_++;
         }
         var _loc5_:Vertex = createVertex(param1,param2,param3);
         _dbv[_dbv.length] = _loc5_;
         return _loc5_;
      }
      
      private function generateFaces(param1:Array, param2:Array, param3:Number, param4:int, param5:ITriangleMaterial, param6:Array, param7:String) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:UV = null;
         var _loc15_:UV = null;
         var _loc16_:UV = null;
         var _loc17_:UV = null;
         var _loc18_:Vertex = null;
         var _loc19_:Vertex = null;
         var _loc20_:Vertex = null;
         var _loc21_:Vertex = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc8_:Array = [];
         var _loc24_:int = 0;
         var _loc25_:Number = 0;
         var _loc26_:Number = 1 / (param1.length - 1);
         var _loc27_:Number = 0;
         var _loc28_:Number = 0;
         _loc9_ = 0;
         while(_loc9_ < param1.length)
         {
            _loc11_ = (param2[_loc9_].x - param1[_loc9_].x) / _segmentsH;
            _loc12_ = (param2[_loc9_].y - param1[_loc9_].y) / _segmentsH;
            _loc13_ = (param2[_loc9_].z - param1[_loc9_].z) / _segmentsH;
            _loc10_ = 0;
            while(_loc10_ < _segmentsH + 1)
            {
               _loc8_.push(makeVertex(param1[_loc9_].x + _loc11_ * _loc10_,param1[_loc9_].y + _loc12_ * _loc10_,param1[_loc9_].z + _loc13_ * _loc10_));
               _loc10_++;
            }
            _loc9_++;
         }
         _loc9_ = 0;
         while(_loc9_ < param1.length - 1)
         {
            _loc22_ = _loc25_;
            _loc23_ = _loc25_ += _loc26_;
            if(_map6)
            {
               switch(param7)
               {
                  case "b":
                     _loc22_ *= _offset;
                     _loc23_ *= _offset;
                     break;
                  case "l":
                     _loc22_ *= _offset;
                     _loc23_ *= _offset;
                     break;
                  default:
                     _loc22_ = _loc22_ * _offset + _offset;
                     _loc23_ = _loc23_ * _offset + _offset;
               }
            }
            _loc10_ = 0;
            while(_loc10_ < _segmentsH)
            {
               _loc27_ = param3 + _loc10_ / _segmentsH / param4;
               _loc28_ = param3 + (_loc10_ + 1) / _segmentsH / param4;
               if(_map6)
               {
                  switch(param7)
                  {
                     case "b":
                        _loc27_ *= 0.5;
                        _loc28_ *= 0.5;
                        break;
                     case "l":
                        _loc27_ = _loc27_ * 0.5 + 0.5;
                        _loc28_ = _loc28_ * 0.5 + 0.5;
                        break;
                     case "t":
                        _loc27_ *= 0.5;
                        _loc28_ *= 0.5;
                  }
               }
               _loc14_ = makeUV(_loc22_,_loc27_);
               _loc15_ = makeUV(_loc22_,_loc28_);
               _loc16_ = makeUV(_loc23_,_loc28_);
               _loc17_ = makeUV(_loc23_,_loc27_);
               _loc18_ = _loc8_[_loc24_ + _loc10_];
               _loc19_ = _loc8_[_loc24_ + _loc10_ + 1];
               _loc20_ = _loc8_[_loc24_ + _loc10_ + (_segmentsH + 2)];
               _loc21_ = _loc8_[_loc24_ + _loc10_ + (_segmentsH + 1)];
               if(_flip)
               {
                  addFace(createFace(_loc18_,_loc19_,_loc20_,param5,_loc14_,_loc15_,_loc16_));
                  addFace(createFace(_loc18_,_loc20_,_loc21_,param5,_loc14_,_loc16_,_loc17_));
               }
               else
               {
                  addFace(createFace(_loc19_,_loc18_,_loc20_,param5,_loc15_,_loc14_,_loc16_));
                  addFace(createFace(_loc20_,_loc18_,_loc21_,param5,_loc16_,_loc14_,_loc17_));
               }
               param6.push(faces[faces.length - 2],faces[faces.length - 1]);
               _loc10_++;
            }
            _loc24_ += _segmentsH + 1;
            _loc9_++;
         }
      }
      
      public function get depth() : Number
      {
         return _depth;
      }
      
      public function get width() : Number
      {
         return _width;
      }
      
      public function set height(param1:Number) : void
      {
         if(_height == param1)
         {
            return;
         }
         _height = param1;
         _primitiveDirty = true;
      }
      
      public function set segmentsH(param1:Number) : void
      {
         if(_segmentsH == param1)
         {
            return;
         }
         _segmentsH = param1;
         _primitiveDirty = true;
      }
      
      public function get map6() : Boolean
      {
         return _map6;
      }
      
      public function set flip(param1:Boolean) : void
      {
         _flip = param1;
      }
      
      private function buildSide(param1:Array, param2:ITriangleMaterial, param3:Array, param4:String) : void
      {
         var _loc5_:int = param1.length - 1;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            generateFaces(param1[_loc6_],param1[_loc6_ + 1],1 / _loc5_ * _loc6_,_loc5_,param2,param3,param4);
            _loc6_++;
         }
      }
      
      public function get flip() : Boolean
      {
         return _flip;
      }
      
      public function set segmentsW(param1:Number) : void
      {
         if(_segmentsW == param1)
         {
            return;
         }
         _segmentsW = param1;
         _primitiveDirty = true;
      }
      
      public function set cubeMaterials(param1:CubeMaterialsData) : void
      {
         if(_cubeMaterials == param1)
         {
            return;
         }
         if(_cubeMaterials)
         {
            _cubeMaterials.addOnMaterialChange(onCubeMaterialChange);
         }
         _cubeMaterials = param1;
         _cubeMaterials.addOnMaterialChange(onCubeMaterialChange);
      }
      
      public function get cubeMaterials() : CubeMaterialsData
      {
         return _cubeMaterials;
      }
   }
}


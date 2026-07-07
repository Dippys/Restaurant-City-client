package away3d.materials
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import flash.display.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class TransformBitmapMaterial extends BitmapMaterial implements ITriangleMaterial, IUVMaterial
   {
      
      private var _u0:Number;
      
      private var _u1:Number;
      
      private var _invtexturemapping:Matrix;
      
      private var py:Number;
      
      private var _u2:Number;
      
      private var px:Number;
      
      private var line:Point = new Point();
      
      private var _v0:Number;
      
      private var _v1:Number;
      
      private var _v2:Number;
      
      private var v0x:Number;
      
      private var v0y:Number;
      
      private var v0z:Number;
      
      private var dot:Number;
      
      private var normalR:Number3D = new Number3D();
      
      private var v1x:Number;
      
      private var v1y:Number;
      
      private var v1z:Number;
      
      private var flag:Boolean;
      
      private var _scaleX:Number = 1;
      
      private var mPoint1:Point = new Point();
      
      private var mPoint2:Point = new Point();
      
      private var mPoint3:Point = new Point();
      
      private var mPoint4:Point = new Point();
      
      private var t:Matrix;
      
      private var _scaleY:Number = 1;
      
      private var x:Number;
      
      private var y:Number;
      
      private var v0:Number3D = new Number3D();
      
      private var v1:Number3D = new Number3D();
      
      private var v2y:Number;
      
      private var v2z:Number;
      
      private var v2x:Number;
      
      private var _projectionDirty:Boolean;
      
      private var mapa:Number;
      
      private var mapb:Number;
      
      private var mapc:Number;
      
      private var mapd:Number;
      
      private var v2:Number3D = new Number3D();
      
      private var _throughProjection:Boolean;
      
      private var point1:Point;
      
      private var point3:Point;
      
      private var fPoint1:Point = new Point();
      
      private var fPoint2:Point = new Point();
      
      private var DOWN:Number3D = new Number3D(0,-1,0);
      
      private var zero:Number;
      
      private var fPoint3:Point = new Point();
      
      private var _globalProjection:Boolean;
      
      private var sign:Number;
      
      private var point2:Point;
      
      private var _N:Number3D = new Number3D();
      
      private var _projectionVector:Number3D;
      
      private var _M:Number3D = new Number3D();
      
      private var faceVO:FaceVO;
      
      private var _rotation:Number = 0;
      
      private var maptx:Number;
      
      private var mapty:Number;
      
      private var _transformDirty:Boolean;
      
      private var _offsetX:Number = 0;
      
      private var _offsetY:Number = 0;
      
      arcane var _transform:Matrix = new Matrix();
      
      private var RIGHT:Number3D = new Number3D(1,0,0);
      
      public function TransformBitmapMaterial(param1:BitmapData, param2:Object = null)
      {
         super(param1,param2);
         transform = ini.getObject("transform",Matrix) as Matrix;
         scaleX = ini.getNumber("scaleX",_scaleX);
         scaleY = ini.getNumber("scaleY",_scaleY);
         offsetX = ini.getNumber("offsetX",_offsetX);
         offsetY = ini.getNumber("offsetY",_offsetY);
         rotation = ini.getNumber("rotation",_rotation);
         projectionVector = ini.getObject("projectionVector",Number3D) as Number3D;
         throughProjection = ini.getBoolean("throughProjection",true);
         globalProjection = ini.getBoolean("globalProjection",false);
      }
      
      public function set throughProjection(param1:Boolean) : void
      {
         _throughProjection = param1;
         _projectionDirty = true;
      }
      
      public function set rotation(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(rotation)");
         }
         if(param1 == Infinity)
         {
            Debug.warning("rotation == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("rotation == -Infinity");
         }
         _rotation = param1;
         _transformDirty = true;
      }
      
      private function findSeparatingAxis(param1:Array, param2:Array) : Boolean
      {
         if(checkEdge(param1,param2))
         {
            return true;
         }
         if(checkEdge(param2,param1))
         {
            return true;
         }
         return false;
      }
      
      override public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
         _graphics = null;
         if(_colorTransformDirty)
         {
            updateColorTransform();
         }
         if(_bitmapDirty)
         {
            updateRenderBitmap();
         }
         if(_projectionDirty || _transformDirty)
         {
            invalidateFaces();
         }
         if(_transformDirty)
         {
            updateTransform();
         }
         if(_materialDirty || _blendModeDirty)
         {
            clearFaces();
         }
         _projectionDirty = false;
         _blendModeDirty = false;
      }
      
      public function get throughProjection() : Boolean
      {
         return _throughProjection;
      }
      
      public function get offsetY() : Number
      {
         return _offsetY;
      }
      
      public function get offsetX() : Number
      {
         return _offsetX;
      }
      
      override public function getPixel32(param1:Number, param2:Number) : uint
      {
         if(_transform)
         {
            x = param1 * _bitmap.width;
            y = (1 - param2) * _bitmap.height;
            t = _transform.clone();
            t.invert();
            if(repeat)
            {
               px = (x * t.a + y * t.c + t.tx) % _bitmap.width;
               py = (x * t.b + y * t.d + t.ty) % _bitmap.height;
               if(px < 0)
               {
                  px += _bitmap.width;
               }
               if(py < 0)
               {
                  py += _bitmap.height;
               }
               return _bitmap.getPixel32(px,py);
            }
            return _bitmap.getPixel32(x * t.a + y * t.c + t.tx,x * t.b + y * t.d + t.ty);
         }
         return super.getPixel32(param1,param2);
      }
      
      public function set offsetX(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(offsetX)");
         }
         if(param1 == Infinity)
         {
            Debug.warning("offsetX == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("offsetX == -Infinity");
         }
         _offsetX = param1;
         _transformDirty = true;
      }
      
      public function set offsetY(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(offsetY)");
         }
         if(param1 == Infinity)
         {
            Debug.warning("offsetY == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("offsetY == -Infinity");
         }
         _offsetY = param1;
         _transformDirty = true;
      }
      
      public function get scaleY() : Number
      {
         return _scaleY;
      }
      
      public function get scaleX() : Number
      {
         return _scaleX;
      }
      
      public function get globalProjection() : Boolean
      {
         return _globalProjection;
      }
      
      public function get projectionVector() : Number3D
      {
         return _projectionVector;
      }
      
      public function get transform() : Matrix
      {
         return _transform;
      }
      
      private function projectUV(param1:DrawTriangle) : Matrix
      {
         faceVO = param1.faceVO;
         if(globalProjection)
         {
            v0.transform(faceVO.v0.position,param1.source.sceneTransform);
            v1.transform(faceVO.v1.position,param1.source.sceneTransform);
            v2.transform(faceVO.v2.position,param1.source.sceneTransform);
         }
         else
         {
            v0 = faceVO.v0.position;
            v1 = faceVO.v1.position;
            v2 = faceVO.v2.position;
         }
         v0x = v0.x;
         v0y = v0.y;
         v0z = v0.z;
         v1x = v1.x;
         v1y = v1.y;
         v1z = v1.z;
         v2x = v2.x;
         v2y = v2.y;
         v2z = v2.z;
         _u0 = v0x * _N.x + v0y * _N.y + v0z * _N.z;
         _u1 = v1x * _N.x + v1y * _N.y + v1z * _N.z;
         _u2 = v2x * _N.x + v2y * _N.y + v2z * _N.z;
         _v0 = v0x * _M.x + v0y * _M.y + v0z * _M.z;
         _v1 = v1x * _M.x + v1y * _M.y + v1z * _M.z;
         _v2 = v2x * _M.x + v2y * _M.y + v2z * _M.z;
         if(_u0 == _u1 && _v0 == _v1 || _u0 == _u2 && _v0 == _v2)
         {
            if(_u0 > 0.05)
            {
               _u0 -= 0.05;
            }
            else
            {
               _u0 += 0.05;
            }
            if(_v0 > 0.07)
            {
               _v0 -= 0.07;
            }
            else
            {
               _v0 += 0.07;
            }
         }
         if(_u2 == _u1 && _v2 == _v1)
         {
            if(_u2 > 0.04)
            {
               _u2 -= 0.04;
            }
            else
            {
               _u2 += 0.04;
            }
            if(_v2 > 0.06)
            {
               _v2 -= 0.06;
            }
            else
            {
               _v2 += 0.06;
            }
         }
         t = new Matrix(_u1 - _u0,_v1 - _v0,_u2 - _u0,_v2 - _v0,_u0,_v0);
         t.invert();
         return t;
      }
      
      private function getContainerPoints(param1:Rectangle) : Array
      {
         return [param1.topLeft,new Point(param1.top,param1.right),param1.bottomRight,new Point(param1.bottom,param1.left)];
      }
      
      override protected function getMapping(param1:DrawTriangle) : Matrix
      {
         if(param1.generated)
         {
            if(projectionVector)
            {
               _texturemapping = projectUV(param1);
            }
            else
            {
               _texturemapping = param1.transformUV(this).clone();
               _texturemapping.invert();
            }
            if(_transform)
            {
               _mapping = _transform.clone();
               _mapping.concat(_texturemapping);
            }
            else
            {
               _mapping = _texturemapping;
            }
            return _mapping;
         }
         _faceMaterialVO = getFaceMaterialVO(param1.faceVO,param1.source);
         if(!_faceMaterialVO.invalidated)
         {
            return _faceMaterialVO.texturemapping;
         }
         _faceMaterialVO.invalidated = false;
         if(projectionVector)
         {
            _texturemapping = projectUV(param1);
         }
         else
         {
            _texturemapping = param1.transformUV(this).clone();
            _texturemapping.invert();
         }
         if(_transform)
         {
            _faceMaterialVO.texturemapping = _transform.clone();
            _faceMaterialVO.texturemapping.concat(_texturemapping);
            return _faceMaterialVO.texturemapping;
         }
         return _faceMaterialVO.texturemapping = _texturemapping;
      }
      
      private function getMappingPoints(param1:Matrix) : Array
      {
         mapa = param1.a * width;
         mapb = param1.b * width;
         mapc = param1.c * height;
         mapd = param1.d * height;
         maptx = param1.tx;
         mapty = param1.ty;
         mPoint1.x = maptx;
         mPoint1.y = mapty;
         mPoint2.x = maptx + mapc;
         mPoint2.y = mapty + mapd;
         mPoint3.x = maptx + mapa + mapc;
         mPoint3.y = mapty + mapb + mapd;
         mPoint4.x = maptx + mapa;
         mPoint4.y = mapty + mapb;
         return [mPoint1,mPoint2,mPoint3,mPoint4];
      }
      
      private function getFacePoints(param1:Matrix) : Array
      {
         fPoint1.x = _u0 = param1.tx;
         fPoint2.x = param1.a + _u0;
         fPoint3.x = param1.c + _u0;
         fPoint1.y = _v0 = param1.ty;
         fPoint2.y = param1.b + _v0;
         fPoint3.y = param1.d + _v0;
         return [fPoint1,fPoint2,fPoint3];
      }
      
      public function set globalProjection(param1:Boolean) : void
      {
         _globalProjection = param1;
         _projectionDirty = true;
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(scaleY)");
         }
         if(param1 == Infinity)
         {
            Debug.warning("scaleY == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("scaleY == -Infinity");
         }
         if(param1 == 0)
         {
            Debug.warning("scaleY == 0");
         }
         _scaleY = param1;
         _transformDirty = true;
      }
      
      private function updateTransform() : void
      {
         _transformDirty = false;
         if(_scaleX == 1 && _scaleY == 1 && _offsetX == 0 && _offsetY == 0 && _rotation == 0)
         {
            _transform = null;
         }
         else
         {
            _transform = new Matrix();
            _transform.scale(_scaleX,_scaleY);
            _transform.rotate(_rotation);
            _transform.translate(_offsetX,_offsetY);
         }
         _materialDirty = true;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(scaleX)");
         }
         if(param1 == Infinity)
         {
            Debug.warning("scaleX == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("scaleX == -Infinity");
         }
         if(param1 == 0)
         {
            Debug.warning("scaleX == 0");
         }
         _scaleX = param1;
         _transformDirty = true;
      }
      
      public function get rotation() : Number
      {
         return _rotation;
      }
      
      override public function renderTriangle(param1:DrawTriangle) : void
      {
         if(Boolean(_projectionVector) && !throughProjection)
         {
            if(globalProjection)
            {
               normalR.rotate(param1.faceVO.face.normal,param1.source.sceneTransform);
               if(normalR.dot(_projectionVector) < 0)
               {
                  return;
               }
            }
            else if(param1.faceVO.face.normal.dot(_projectionVector) < 0)
            {
               return;
            }
         }
         super.renderTriangle(param1);
      }
      
      public function set transform(param1:Matrix) : void
      {
         _transform = param1;
         if(_transform)
         {
            _rotation = Math.atan2(_transform.b,_transform.a);
            _scaleX = _transform.a / Math.cos(_rotation);
            _scaleY = _transform.d / Math.cos(_rotation);
            _offsetX = _transform.tx;
            _offsetY = _transform.ty;
         }
         else
         {
            _scaleX = _scaleY = 1;
            _offsetX = _offsetY = _rotation = 0;
         }
      }
      
      public function set projectionVector(param1:Number3D) : void
      {
         _projectionVector = param1;
         if(_projectionVector)
         {
            _N.cross(_projectionVector,DOWN);
            if(!_N.modulo)
            {
               _N = RIGHT;
            }
            _M.cross(_N,_projectionVector);
            _N.cross(_M,_projectionVector);
            _N.normalize();
            _M.normalize();
         }
         _projectionDirty = true;
      }
      
      private function checkEdge(param1:Array, param2:Array) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:Point = null;
         var _loc3_:int = int(param1.length);
         for(_loc4_ in param1)
         {
            point2 = param1[_loc4_];
            if(int(_loc4_) == 0)
            {
               point1 = param1[_loc3_ - 1];
               point3 = param1[_loc3_ - 2];
            }
            else
            {
               point1 = param1[int(_loc4_) - 1];
               if(int(_loc4_) == 1)
               {
                  point3 = param1[_loc3_ - 1];
               }
               else
               {
                  point3 = param1[int(_loc4_) - 2];
               }
            }
            line.x = point2.y - point1.y;
            line.y = point1.x - point2.x;
            zero = point1.x * line.x + point1.y * line.y;
            sign = zero - point3.x * line.x - point3.y * line.y;
            flag = true;
            for each(_loc5_ in param2)
            {
               dot = _loc5_.x * line.x + _loc5_.y * line.y;
               if(zero * sign > dot * sign)
               {
                  flag = false;
                  break;
               }
            }
            if(flag)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function renderBitmapLayer(param1:DrawTriangle, param2:Rectangle, param3:FaceMaterialVO) : FaceMaterialVO
      {
         if(_transform)
         {
            _mapping = _transform.clone();
         }
         else
         {
            _mapping = new Matrix();
         }
         if(!_projectionVector)
         {
            renderSource(param1.source,param2,_mapping);
         }
         _faceMaterialVO = getFaceMaterialVO(param1.faceVO);
         if(param3.resized)
         {
            param3.resized = false;
            _faceMaterialVO.resized = true;
         }
         _faceMaterialVO.invtexturemapping = param3.invtexturemapping;
         if(param3.updated || _faceMaterialVO.invalidated || _faceMaterialVO.updated)
         {
            param3.updated = false;
            _bitmapRect = param1.faceVO.bitmapRect;
            if(_faceMaterialVO.invalidated)
            {
               _faceMaterialVO.invalidated = false;
            }
            else
            {
               _faceMaterialVO.updated = true;
            }
            _faceMaterialVO.bitmap = param3.bitmap.clone();
            if(_projectionVector)
            {
               _invtexturemapping = _faceMaterialVO.invtexturemapping;
               _mapping.concat(projectUV(param1));
               _mapping.concat(_invtexturemapping);
               normalR.clone(param1.faceVO.face.normal);
               if(_globalProjection)
               {
                  normalR.rotate(normalR,param1.source.sceneTransform);
               }
               if((throughProjection || normalR.dot(_projectionVector) >= 0) && (repeat || !findSeparatingAxis(getFacePoints(_invtexturemapping),getMappingPoints(_mapping))))
               {
                  if(_faceMaterialVO.cleared)
                  {
                     _faceMaterialVO.bitmap = param3.bitmap.clone();
                  }
                  _faceMaterialVO.cleared = false;
                  _faceMaterialVO.updated = true;
                  _graphics = _s.graphics;
                  _graphics.clear();
                  _graphics.beginBitmapFill(_bitmap,_mapping,repeat,smooth);
                  _graphics.drawRect(0,0,_bitmapRect.width,_bitmapRect.height);
                  _graphics.endFill();
                  _faceMaterialVO.bitmap.draw(_s,null,_colorTransform,_blendMode,_faceMaterialVO.bitmap.rect);
               }
            }
            else if(repeat && !findSeparatingAxis(getContainerPoints(param2),getMappingPoints(_mapping)))
            {
               _faceMaterialVO.cleared = false;
               _faceMaterialVO.updated = true;
               _faceMaterialVO.bitmap.copyPixels(_sourceVO.bitmap,_bitmapRect,_zeroPoint,null,null,true);
            }
         }
         return _faceMaterialVO;
      }
   }
}


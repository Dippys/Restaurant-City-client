package away3d.materials
{
   import away3d.arcane;
   import away3d.cameras.lenses.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.clip.*;
   import away3d.core.draw.*;
   import away3d.core.math.*;
   import away3d.core.render.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class BitmapMaterial extends EventDispatcher implements ITriangleMaterial, IUVMaterial, ILayerMaterial, IBillboardMaterial
   {
      
      arcane var _green:Number = 1;
      
      arcane var _blendMode:String;
      
      arcane var _bitmapDirty:Boolean;
      
      private var ai:Number;
      
      private var ax:Number;
      
      private var ay:Number;
      
      private var az:Number;
      
      arcane var _renderBitmap:BitmapData;
      
      private var bi:Number;
      
      arcane var _zeroPoint:Point = new Point(0,0);
      
      private var mcax:Number;
      
      arcane var _bitmap:BitmapData;
      
      private var mcaz:Number;
      
      private var mcay:Number;
      
      private var bx:Number;
      
      private var by:Number;
      
      private var bz:Number;
      
      arcane var _alpha:Number = 1;
      
      arcane var _color:uint = 16777215;
      
      private var ci:Number;
      
      private var cx:Number;
      
      private var cy:Number;
      
      private var cz:Number;
      
      private var x:Number;
      
      private var y:Number;
      
      arcane var _faceMaterialVO:FaceMaterialVO;
      
      private var dmax:Number;
      
      private var _nn:Number3D = new Number3D();
      
      private var _shape:Shape;
      
      private var _screenVertices:Array;
      
      arcane var _blendModeDirty:Boolean;
      
      private var _repeat:Boolean;
      
      private var mbcx:Number;
      
      private var mbcy:Number;
      
      private var mbcz:Number;
      
      private var _smooth:Boolean;
      
      private var _sv0x:Number;
      
      private var index:int;
      
      private var focus:Number;
      
      private var _sv0y:Number;
      
      private var _sv1x:Number;
      
      private var maby:Number;
      
      private var dsab:Number;
      
      arcane var _faceDictionary:Dictionary = new Dictionary(true);
      
      private var mabz:Number;
      
      private var dcax:Number;
      
      private var _showNormals:Boolean;
      
      private var _sv1y:Number;
      
      arcane var _materialDirty:Boolean;
      
      private var dcay:Number;
      
      private var mabx:Number;
      
      private var _precision:Number;
      
      private var _near:Number;
      
      private var dsbc:Number;
      
      private var faz:Number;
      
      private var dsca:Number;
      
      private var _screenCommands:Array;
      
      arcane var _blue:Number = 1;
      
      private var fbz:Number;
      
      arcane var _colorTransformDirty:Boolean;
      
      arcane var _bitmapRect:Rectangle;
      
      private var _debug:Boolean;
      
      arcane var _session:AbstractRenderSession;
      
      private var map:Matrix = new Matrix();
      
      private var fcz:Number;
      
      arcane var _colorTransform:ColorTransform;
      
      arcane var _texturemapping:Matrix;
      
      arcane var _sourceVO:FaceMaterialVO;
      
      private var _materialupdated:MaterialEvent;
      
      private var dbcx:Number;
      
      private var dbcy:Number;
      
      private var _view:View3D;
      
      arcane var _mapping:Matrix;
      
      private var dabx:Number;
      
      private var _screenIndices:Array;
      
      private var daby:Number;
      
      arcane var _id:int;
      
      arcane var _red:Number = 1;
      
      arcane var _graphics:Graphics;
      
      protected var ini:Init;
      
      arcane var _s:Shape = new Shape();
      
      public function BitmapMaterial(param1:BitmapData, param2:Object = null)
      {
         super();
         arcane::_bitmap = param1;
         ini = Init.parse(param2);
         smooth = ini.getBoolean("smooth",false);
         debug = ini.getBoolean("debug",false);
         repeat = ini.getBoolean("repeat",false);
         precision = ini.getNumber("precision",0);
         arcane::_blendMode = ini.getString("blendMode",BlendMode.NORMAL);
         alpha = ini.getNumber("alpha",arcane::_alpha,{
            "min":0,
            "max":1
         });
         color = ini.getColor("color",arcane::_color);
         colorTransform = ini.getObject("colorTransform",ColorTransform) as ColorTransform;
         showNormals = ini.getBoolean("showNormals",false);
         arcane::_colorTransformDirty = true;
      }
      
      public function get debug() : Boolean
      {
         return _debug;
      }
      
      public function set bitmap(param1:BitmapData) : void
      {
         _bitmap = param1;
         _bitmapDirty = true;
      }
      
      public function renderBillboard(param1:DrawBillboard) : void
      {
         param1.source.session.renderBillboardBitmap(_renderBitmap,param1,smooth);
      }
      
      public function get visible() : Boolean
      {
         return _alpha > 0;
      }
      
      public function get precision() : Number
      {
         return _precision;
      }
      
      arcane function notifyMaterialUpdate() : void
      {
         _materialDirty = false;
         if(!hasEventListener(MaterialEvent.MATERIAL_UPDATED))
         {
            return;
         }
         if(_materialupdated == null)
         {
            _materialupdated = new MaterialEvent(MaterialEvent.MATERIAL_UPDATED,this);
         }
         dispatchEvent(_materialupdated);
      }
      
      protected function getMapping(param1:DrawTriangle) : Matrix
      {
         if(param1.generated)
         {
            _texturemapping = param1.transformUV(this).clone();
            _texturemapping.invert();
            return _texturemapping;
         }
         _faceMaterialVO = getFaceMaterialVO(param1.faceVO);
         if(!_faceMaterialVO.invalidated)
         {
            return _faceMaterialVO.texturemapping;
         }
         _faceMaterialVO.invalidated = false;
         _texturemapping = param1.transformUV(this).clone();
         _texturemapping.invert();
         return _faceMaterialVO.texturemapping = _texturemapping;
      }
      
      public function set colorTransform(param1:ColorTransform) : void
      {
         _colorTransform = param1;
         if(_colorTransform)
         {
            _red = _colorTransform.redMultiplier;
            _green = _colorTransform.greenMultiplier;
            _blue = _colorTransform.blueMultiplier;
            _alpha = _colorTransform.alphaMultiplier;
            _color = (_red * 255 << 16) + (_green * 255 << 8) + _blue * 255;
         }
         _colorTransformDirty = true;
      }
      
      protected function updateColorTransform() : void
      {
         _colorTransformDirty = false;
         _bitmapDirty = true;
         _materialDirty = true;
         if(_alpha == 1 && _color == 16777215)
         {
            _renderBitmap = _bitmap;
            if(!_colorTransform || !_colorTransform.redOffset && !_colorTransform.greenOffset && !_colorTransform.blueOffset)
            {
               _colorTransform = null;
               return;
            }
         }
         else if(!_colorTransform)
         {
            _colorTransform = new ColorTransform();
         }
         _colorTransform.redMultiplier = _red;
         _colorTransform.greenMultiplier = _green;
         _colorTransform.blueMultiplier = _blue;
         _colorTransform.alphaMultiplier = _alpha;
         if(_alpha == 0)
         {
            _renderBitmap = null;
            return;
         }
      }
      
      public function set debug(param1:Boolean) : void
      {
         if(_debug == param1)
         {
            return;
         }
         _debug = param1;
         _materialDirty = true;
      }
      
      public function get showNormals() : Boolean
      {
         return _showNormals;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(_alpha == param1)
         {
            return;
         }
         _alpha = param1;
         _colorTransformDirty = true;
      }
      
      public function set color(param1:uint) : void
      {
         if(_color == param1)
         {
            return;
         }
         _color = param1;
         _red = ((_color & 0xFF0000) >> 16) / 255;
         _green = ((_color & 0xFF00) >> 8) / 255;
         _blue = (_color & 0xFF) / 255;
         _colorTransformDirty = true;
      }
      
      public function set precision(param1:Number) : void
      {
         _precision = param1 * param1 * 1.4;
         _materialDirty = true;
      }
      
      public function updateMaterial(param1:Object3D, param2:View3D) : void
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
         if(_materialDirty || _blendModeDirty)
         {
            clearFaces(param1,param2);
         }
         _blendModeDirty = false;
      }
      
      private function renderRec(param1:Number, param2:Number) : void
      {
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc3_:int = int(_screenIndices[param1]);
         ai = _loc3_ * 3;
         ax = _screenVertices[ai];
         ay = _screenVertices[ai + 1];
         az = _screenVertices[ai + 2];
         var _loc4_:int = int(_screenIndices[param1 + 1]);
         bi = _loc4_ * 3;
         bx = _screenVertices[bi];
         by = _screenVertices[bi + 1];
         bz = _screenVertices[bi + 2];
         var _loc5_:int = int(_screenIndices[param1 + 2]);
         ci = _loc5_ * 3;
         cx = _screenVertices[ci];
         cy = _screenVertices[ci + 1];
         cz = _screenVertices[ci + 2];
         if(!(_view.screenClipping is FrustumClipping) && !_view.screenClipping.rect(Math.min(ax,Math.min(bx,cx)),Math.min(ay,Math.min(by,cy)),Math.max(ax,Math.max(bx,cx)),Math.max(ay,Math.max(by,cy))))
         {
            return;
         }
         if(_view.screenClipping is RectangleClipping && (az < _near || bz < _near || cz < _near))
         {
            return;
         }
         if(index >= 1000 || focus == Infinity || Math.max(Math.max(ax,bx),cx) - Math.min(Math.min(ax,bx),cx) < 10 || Math.max(Math.max(ay,by),cy) - Math.min(Math.min(ay,by),cy) < 10)
         {
            _session.renderTriangleBitmap(_renderBitmap,map,_screenVertices,_screenIndices,param1,param2,smooth,repeat,_graphics);
            if(debug)
            {
               _session.renderTriangleLine(1,65280,1,_screenVertices,_screenCommands,_screenIndices,param1,param2);
            }
            return;
         }
         faz = focus + az;
         fbz = focus + bz;
         fcz = focus + cz;
         mabz = 2 / (faz + fbz);
         mbcz = 2 / (fbz + fcz);
         mcaz = 2 / (fcz + faz);
         dabx = ax + bx - (mabx = (ax * faz + bx * fbz) * mabz);
         daby = ay + by - (maby = (ay * faz + by * fbz) * mabz);
         dbcx = bx + cx - (mbcx = (bx * fbz + cx * fcz) * mbcz);
         dbcy = by + cy - (mbcy = (by * fbz + cy * fcz) * mbcz);
         dcax = cx + ax - (mcax = (cx * fcz + ax * faz) * mcaz);
         dcay = cy + ay - (mcay = (cy * fcz + ay * faz) * mcaz);
         dsab = dabx * dabx + daby * daby;
         dsbc = dbcx * dbcx + dbcy * dbcy;
         dsca = dcax * dcax + dcay * dcay;
         if(dsab <= precision && dsca <= precision && dsbc <= precision)
         {
            _session.renderTriangleBitmap(_renderBitmap,map,_screenVertices,_screenIndices,param1,param2,smooth,repeat,_graphics);
            if(debug)
            {
               _session.renderTriangleLine(1,65280,1,_screenVertices,_screenCommands,_screenIndices,param1,param2);
            }
            return;
         }
         var _loc6_:Number = map.a;
         var _loc7_:Number = map.b;
         var _loc8_:Number = map.c;
         var _loc9_:Number = map.d;
         var _loc10_:Number = map.tx;
         var _loc11_:Number = map.ty;
         ++index;
         _loc14_ = _screenVertices.length / 3;
         _screenVertices[_screenVertices.length] = mbcx / 2;
         _screenVertices[_screenVertices.length] = mbcy / 2;
         _screenVertices[_screenVertices.length] = (bz + cz) / 2;
         if(dsab > precision && dsca > precision && dsbc > precision)
         {
            index += 2;
            _loc12_ = _screenVertices.length / 3;
            _screenVertices[_screenVertices.length] = mabx / 2;
            _screenVertices[_screenVertices.length] = maby / 2;
            _screenVertices[_screenVertices.length] = (az + bz) / 2;
            _loc13_ = _screenVertices.length / 3;
            _screenVertices[_screenVertices.length] = mcax / 2;
            _screenVertices[_screenVertices.length] = mcay / 2;
            _screenVertices[_screenVertices.length] = (cz + az) / 2;
            var _loc15_:Number;
            _screenIndices[_loc15_ = param1 = _screenIndices.length] = _loc3_;
            _screenIndices[_screenIndices.length] = _loc12_;
            _screenIndices[_screenIndices.length] = _loc13_;
            param2 = _screenIndices.length;
            map.a = _loc6_ = _loc6_ * 2;
            map.b = _loc7_ = _loc7_ * 2;
            map.c = _loc8_ = _loc8_ * 2;
            map.d = _loc9_ = _loc9_ * 2;
            map.tx = _loc10_ = _loc10_ * 2;
            map.ty = _loc11_ = _loc11_ * 2;
            renderRec(param1,param2);
            var _loc16_:Number;
            _screenIndices[_loc16_ = param1 = _screenIndices.length] = _loc12_;
            _screenIndices[_screenIndices.length] = _loc4_;
            _screenIndices[_screenIndices.length] = _loc14_;
            param2 = _screenIndices.length;
            map.a = _loc6_;
            map.b = _loc7_;
            map.c = _loc8_;
            map.d = _loc9_;
            map.tx = _loc10_ - 1;
            map.ty = _loc11_;
            renderRec(param1,param2);
            var _loc17_:Number;
            _screenIndices[_loc17_ = param1 = _screenIndices.length] = _loc13_;
            _screenIndices[_screenIndices.length] = _loc14_;
            _screenIndices[_screenIndices.length] = _loc5_;
            param2 = _screenIndices.length;
            map.a = _loc6_;
            map.b = _loc7_;
            map.c = _loc8_;
            map.d = _loc9_;
            map.tx = _loc10_;
            map.ty = _loc11_ - 1;
            renderRec(param1,param2);
            var _loc18_:Number;
            _screenIndices[_loc18_ = param1 = _screenIndices.length] = _loc14_;
            _screenIndices[_screenIndices.length] = _loc13_;
            _screenIndices[_screenIndices.length] = _loc12_;
            param2 = _screenIndices.length;
            map.a = -_loc6_;
            map.b = -_loc7_;
            map.c = -_loc8_;
            map.d = -_loc9_;
            map.tx = 1 - _loc10_;
            map.ty = 1 - _loc11_;
            renderRec(param1,param2);
            return;
         }
         dmax = Math.max(dsab,Math.max(dsca,dsbc));
         if(dsab == dmax)
         {
            ++index;
            _loc12_ = _screenVertices.length / 3;
            _screenVertices[_screenVertices.length] = mabx / 2;
            _screenVertices[_screenVertices.length] = maby / 2;
            _screenVertices[_screenVertices.length] = (az + bz) / 2;
            _screenIndices[_loc15_ = param1 = _screenIndices.length] = _loc3_;
            _screenIndices[_screenIndices.length] = _loc12_;
            _screenIndices[_screenIndices.length] = _loc5_;
            param2 = _screenIndices.length;
            map.a = _loc6_ = _loc6_ * 2;
            map.c = _loc8_ = _loc8_ * 2;
            map.tx = _loc10_ = _loc10_ * 2;
            renderRec(param1,param2);
            _screenIndices[_loc16_ = param1 = _screenIndices.length] = _loc12_;
            _screenIndices[_screenIndices.length] = _loc4_;
            _screenIndices[_screenIndices.length] = _loc5_;
            param2 = _screenIndices.length;
            map.a = _loc6_ + _loc7_;
            map.b = _loc7_;
            map.c = _loc8_ + _loc9_;
            map.d = _loc9_;
            map.tx = _loc10_ + _loc11_ - 1;
            map.ty = _loc11_;
            renderRec(param1,param2);
            return;
         }
         if(dsca == dmax)
         {
            ++index;
            _loc13_ = _screenVertices.length / 3;
            _screenVertices[_screenVertices.length] = mcax / 2;
            _screenVertices[_screenVertices.length] = mcay / 2;
            _screenVertices[_screenVertices.length] = (cz + az) / 2;
            _screenIndices[_loc15_ = param1 = _screenIndices.length] = _loc3_;
            _screenIndices[_screenIndices.length] = _loc4_;
            _screenIndices[_screenIndices.length] = _loc13_;
            param2 = _screenIndices.length;
            map.b = _loc7_ = _loc7_ * 2;
            map.d = _loc9_ = _loc9_ * 2;
            map.ty = _loc11_ = _loc11_ * 2;
            renderRec(param1,param2);
            _screenIndices[_loc16_ = param1 = _screenIndices.length] = _loc13_;
            _screenIndices[_screenIndices.length] = _loc4_;
            _screenIndices[_screenIndices.length] = _loc5_;
            param2 = _screenIndices.length;
            map.a = _loc6_;
            map.b = _loc7_ + _loc6_;
            map.c = _loc8_;
            map.d = _loc9_ + _loc8_;
            map.tx = _loc10_;
            map.ty = _loc11_ + _loc10_ - 1;
            renderRec(param1,param2);
            return;
         }
         _screenIndices[_loc15_ = param1 = _screenIndices.length] = _loc3_;
         _screenIndices[_screenIndices.length] = _loc4_;
         _screenIndices[_screenIndices.length] = _loc14_;
         param2 = _screenIndices.length;
         map.a = _loc6_ - _loc7_;
         map.b = _loc7_ * 2;
         map.c = _loc8_ - _loc9_;
         map.d = _loc9_ * 2;
         map.tx = _loc10_ - _loc11_;
         map.ty = _loc11_ * 2;
         renderRec(param1,param2);
         _screenIndices[_loc16_ = param1 = _screenIndices.length] = _loc3_;
         _screenIndices[_screenIndices.length] = _loc14_;
         _screenIndices[_screenIndices.length] = _loc5_;
         param2 = _screenIndices.length;
         map.a = _loc6_ * 2;
         map.b = _loc7_ - _loc6_;
         map.c = _loc8_ * 2;
         map.d = _loc9_ - _loc8_;
         map.tx = _loc10_ * 2;
         map.ty = _loc11_ - _loc10_;
         renderRec(param1,param2);
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get height() : Number
      {
         return _bitmap.height;
      }
      
      public function get bitmap() : BitmapData
      {
         return _bitmap;
      }
      
      public function getPixel32(param1:Number, param2:Number) : uint
      {
         if(repeat)
         {
            x = param1 % 1;
            y = 1 - param2 % 1;
         }
         else
         {
            x = param1;
            y = 1 - param2;
         }
         return _bitmap.getPixel32(x * _bitmap.width,y * _bitmap.height);
      }
      
      public function set blendMode(param1:String) : void
      {
         if(_blendMode == param1)
         {
            return;
         }
         _blendMode = param1;
         _blendModeDirty = true;
      }
      
      public function removeOnMaterialUpdate(param1:Function) : void
      {
         removeEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false);
      }
      
      public function invalidateFaces(param1:Object3D = null, param2:View3D = null) : void
      {
         var _loc3_:FaceMaterialVO = null;
         _materialDirty = true;
         for each(_loc3_ in _faceDictionary)
         {
            _loc3_.invalidated = true;
         }
      }
      
      public function set repeat(param1:Boolean) : void
      {
         if(_repeat == param1)
         {
            return;
         }
         _repeat = param1;
         _materialDirty = true;
      }
      
      public function get colorTransform() : ColorTransform
      {
         return _colorTransform;
      }
      
      public function addOnMaterialUpdate(param1:Function) : void
      {
         addEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false,0,true);
      }
      
      arcane function renderSource(param1:Object3D, param2:Rectangle, param3:Matrix) : void
      {
         if(!(_sourceVO = _faceDictionary[param1]))
         {
            _sourceVO = _faceDictionary[param1] = new FaceMaterialVO();
         }
         _sourceVO.resize(param2.width,param2.height);
         if(_sourceVO.invalidated || _sourceVO.updated)
         {
            param3.scale(param2.width / width,param2.height / height);
            _sourceVO.invalidated = false;
            _sourceVO.cleared = false;
            _sourceVO.updated = false;
            if(param3.a == 1 && param3.d == 1 && param3.b == 0 && param3.c == 0 && param3.tx == 0 && param3.ty == 0)
            {
               _sourceVO.bitmap.copyPixels(_bitmap,param2,_zeroPoint);
            }
            else
            {
               _graphics = _s.graphics;
               _graphics.clear();
               _graphics.beginBitmapFill(_bitmap,param3,repeat,smooth);
               _graphics.drawRect(0,0,param2.width,param2.height);
               _graphics.endFill();
               _sourceVO.bitmap.draw(_s,null,_colorTransform,_blendMode,_sourceVO.bitmap.rect);
            }
         }
      }
      
      public function getFaceMaterialVO(param1:FaceVO, param2:Object3D = null, param3:View3D = null) : FaceMaterialVO
      {
         if(_faceMaterialVO = _faceDictionary[param1])
         {
            return _faceMaterialVO;
         }
         return _faceDictionary[param1] = new FaceMaterialVO();
      }
      
      public function renderLayer(param1:DrawTriangle, param2:Sprite, param3:int) : int
      {
         if(blendMode == BlendMode.NORMAL)
         {
            _graphics = param2.graphics;
         }
         else
         {
            _session = param1.source.session;
            _shape = _session.getShape(this,param3++,param2);
            _shape.blendMode = _blendMode;
            _graphics = _shape.graphics;
         }
         renderTriangle(param1);
         return param3;
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         if(_smooth == param1)
         {
            return;
         }
         _smooth = param1;
         _materialDirty = true;
      }
      
      public function set showNormals(param1:Boolean) : void
      {
         if(_showNormals == param1)
         {
            return;
         }
         _showNormals = param1;
         _materialDirty = true;
      }
      
      public function clearFaces(param1:Object3D = null, param2:View3D = null) : void
      {
         var _loc3_:FaceMaterialVO = null;
         notifyMaterialUpdate();
         for each(_loc3_ in _faceDictionary)
         {
            if(!_loc3_.cleared)
            {
               _loc3_.clear();
            }
         }
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function get blendMode() : String
      {
         return _blendMode;
      }
      
      public function get repeat() : Boolean
      {
         return _repeat;
      }
      
      public function get smooth() : Boolean
      {
         return _smooth;
      }
      
      public function renderTriangle(param1:DrawTriangle) : void
      {
         _mapping = getMapping(param1);
         _session = param1.source.session;
         _screenCommands = param1.screenCommands;
         _screenVertices = param1.screenVertices;
         _screenIndices = param1.screenIndices;
         _view = param1.view;
         _near = _view.camera.lens.near;
         if(precision)
         {
            if(_view.camera.lens is ZoomFocusLens)
            {
               focus = param1.view.camera.focus;
            }
            else
            {
               focus = 0;
            }
            map.a = _mapping.a;
            map.b = _mapping.b;
            map.c = _mapping.c;
            map.d = _mapping.d;
            map.tx = _mapping.tx;
            map.ty = _mapping.ty;
            index = 0;
            renderRec(param1.startIndex,param1.endIndex);
         }
         else
         {
            _session.renderTriangleBitmap(_renderBitmap,_mapping,_screenVertices,_screenIndices,param1.startIndex,param1.endIndex,smooth,repeat,_graphics);
         }
         if(debug)
         {
            _session.renderTriangleLine(0,255,1,_screenVertices,param1.screenCommands,_screenIndices,param1.startIndex,param1.endIndex);
         }
         if(showNormals)
         {
            _nn.rotate(param1.faceVO.face.normal,param1.view.cameraVarsStore.viewTransformDictionary[param1.source]);
            _sv0x = (param1.v0x + param1.v1x + param1.v2x) / 3;
            _sv0y = (param1.v0y + param1.v1y + param1.v2y) / 3;
            _sv1x = _sv0x - 30 * _nn.x;
            _sv1y = _sv0y - 30 * _nn.y;
            _session.renderLine(_sv0x,_sv0y,_sv1x,_sv1y,0,16711935,1);
         }
      }
      
      public function get width() : Number
      {
         return _bitmap.width;
      }
      
      protected function updateRenderBitmap() : void
      {
         _bitmapDirty = false;
         if(_colorTransform)
         {
            if(!_bitmap.transparent && _alpha != 1)
            {
               _renderBitmap = new BitmapData(_bitmap.width,_bitmap.height,true);
               _renderBitmap.draw(_bitmap);
            }
            else
            {
               _renderBitmap = _bitmap.clone();
            }
            _renderBitmap.colorTransform(_renderBitmap.rect,_colorTransform);
         }
         else
         {
            _renderBitmap = _bitmap;
         }
         invalidateFaces();
      }
      
      public function renderBitmapLayer(param1:DrawTriangle, param2:Rectangle, param3:FaceMaterialVO) : FaceMaterialVO
      {
         renderSource(param1.source,param2,new Matrix());
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
            _faceMaterialVO.invalidated = false;
            _faceMaterialVO.cleared = false;
            _faceMaterialVO.updated = true;
            _faceMaterialVO.bitmap = param3.bitmap.clone();
            _faceMaterialVO.bitmap.copyPixels(_sourceVO.bitmap,param1.faceVO.bitmapRect,_zeroPoint,null,null,true);
         }
         return _faceMaterialVO;
      }
   }
}


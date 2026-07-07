package away3d.materials
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.render.*;
   import away3d.core.utils.*;
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class WhiteShadingBitmapMaterial extends CenterLightingMaterial implements IUVMaterial
   {
      
      private var colorTransform:ColorMatrixFilter = new ColorMatrixFilter();
      
      private var step:int = 1;
      
      private var _bitmap:BitmapData;
      
      private var br:Number;
      
      private var cache:Dictionary;
      
      private var blackrender:Boolean;
      
      public var repeat:Boolean;
      
      private var mapping:Matrix;
      
      private var bitmapPoint:Point = new Point(0,0);
      
      private var whitek:Number = 0.2;
      
      public var smooth:Boolean;
      
      private var _faceDictionary:Dictionary = new Dictionary(true);
      
      private var _texturemapping:Matrix;
      
      private var _faceMaterialVO:FaceMaterialVO;
      
      private var whiterender:Boolean;
      
      public function WhiteShadingBitmapMaterial(param1:BitmapData, param2:Object = null)
      {
         _bitmap = param1;
         super(param2);
         smooth = ini.getBoolean("smooth",false);
         repeat = ini.getBoolean("repeat",false);
         if(!CacheStore.whiteShadingCache[_bitmap])
         {
            CacheStore.whiteShadingCache[_bitmap] = new Dictionary(true);
         }
         cache = CacheStore.whiteShadingCache[_bitmap];
      }
      
      override public function get visible() : Boolean
      {
         return true;
      }
      
      public function get width() : Number
      {
         return _bitmap.width;
      }
      
      public function getFaceMaterialVO(param1:FaceVO, param2:Object3D = null, param3:View3D = null) : FaceMaterialVO
      {
         if(_faceMaterialVO = _faceDictionary[param1])
         {
            return _faceMaterialVO;
         }
         return _faceDictionary[param1] = new FaceMaterialVO();
      }
      
      override public function clearFaces(param1:Object3D = null, param2:View3D = null) : void
      {
         var _loc3_:FaceMaterialVO = null;
         for each(_loc3_ in _faceDictionary)
         {
            if(!_loc3_.cleared)
            {
               _loc3_.clear();
            }
         }
      }
      
      protected function getMapping(param1:DrawTriangle) : Matrix
      {
         if(param1.generated)
         {
            _texturemapping = param1.transformUV(this).clone();
            _texturemapping.invert();
            return _texturemapping;
         }
         _faceMaterialVO = getFaceMaterialVO(param1.faceVO,param1.source,param1.view);
         if(!_faceMaterialVO.invalidated)
         {
            return _faceMaterialVO.texturemapping;
         }
         _texturemapping = param1.transformUV(this).clone();
         _texturemapping.invert();
         return _faceMaterialVO.texturemapping = _texturemapping;
      }
      
      public function get height() : Number
      {
         return _bitmap.height;
      }
      
      public function getPixel32(param1:Number, param2:Number) : uint
      {
         return _bitmap.getPixel32(param1 * _bitmap.width,(1 - param2) * _bitmap.height);
      }
      
      public function get bitmap() : BitmapData
      {
         return _bitmap;
      }
      
      public function doubleStepTo(param1:int) : void
      {
         if(step < param1)
         {
            step *= 2;
         }
      }
      
      private function ladder(param1:Number) : Number
      {
         if(param1 < 1 / 255)
         {
            return 0;
         }
         if(param1 > 255)
         {
            param1 = 255;
         }
         return Math.exp(Math.round(Math.log(param1) * step) / step);
      }
      
      override protected function renderTri(param1:DrawTriangle, param2:AbstractRenderSession, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:BitmapData = null;
         br = (param3 + param4 + param5 + param6 + param7 + param8 + param9 + param10 + param11) / 3;
         mapping = getMapping(param1);
         if(br < 1 && (blackrender || step < 16 && !_bitmap.transparent))
         {
            param2.renderTriangleBitmap(_bitmap,mapping,param1.screenVertices,param1.screenIndices,param1.startIndex,param1.endIndex,smooth,repeat);
            param2.renderTriangleColor(0,1 - br,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex);
         }
         else if(br > 1 && whiterender)
         {
            param2.renderTriangleBitmap(_bitmap,mapping,param1.screenVertices,param1.screenIndices,param1.startIndex,param1.endIndex,smooth,repeat);
            param2.renderTriangleColor(16777215,(br - 1) * whitek,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex);
         }
         else
         {
            if(step < 64)
            {
               if(Math.random() < 0.01)
               {
                  doubleStepTo(64);
               }
            }
            _loc12_ = ladder(br);
            _loc13_ = cache[_loc12_];
            if(_loc13_ == null)
            {
               _loc13_ = new BitmapData(_bitmap.width,_bitmap.height,true,0);
               colorTransform.matrix = [_loc12_,0,0,0,0,0,_loc12_,0,0,0,0,0,_loc12_,0,0,0,0,0,1,0];
               _loc13_.applyFilter(_bitmap,_loc13_.rect,bitmapPoint,colorTransform);
               cache[_loc12_] = _loc13_;
            }
            param2.renderTriangleBitmap(_loc13_,mapping,param1.screenVertices,param1.screenIndices,param1.startIndex,param1.endIndex,smooth,repeat);
         }
      }
      
      public function invalidateFaces(param1:Object3D = null, param2:View3D = null) : void
      {
         var _loc3_:FaceMaterialVO = null;
         for each(_loc3_ in _faceDictionary)
         {
            _loc3_.invalidated = true;
         }
      }
   }
}


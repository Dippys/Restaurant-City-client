package away3d.materials
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class BitmapMaterialContainer extends BitmapMaterial implements ITriangleMaterial, ILayerMaterial
   {
      
      private var _faceHeight:int;
      
      private var _height:Number;
      
      private var _width:Number;
      
      public var transparent:Boolean;
      
      private var _fMaterialVO:FaceMaterialVO;
      
      private var _faceWidth:int;
      
      protected var materials:Array;
      
      private var _faceVO:FaceVO;
      
      private var _containerDictionary:Dictionary;
      
      private var _cacheDictionary:Dictionary;
      
      private var _containerVO:FaceMaterialVO;
      
      public function BitmapMaterialContainer(param1:int, param2:int, param3:Object = null)
      {
         var _loc4_:ILayerMaterial = null;
         _containerDictionary = new Dictionary(true);
         _cacheDictionary = new Dictionary(true);
         super(new BitmapData(param1,param2,true,16777215),param3);
         materials = ini.getArray("materials");
         _width = param1;
         _height = param2;
         arcane::_bitmapRect = new Rectangle(0,0,_width,_height);
         for each(_loc4_ in materials)
         {
            _loc4_.addOnMaterialUpdate(onMaterialUpdate);
         }
         transparent = ini.getBoolean("transparent",true);
      }
      
      override public function renderBitmapLayer(param1:DrawTriangle, param2:Rectangle, param3:FaceMaterialVO) : FaceMaterialVO
      {
         var _loc4_:ILayerMaterial = null;
         _faceMaterialVO = getFaceMaterialVO(param1.faceVO);
         _faceWidth = param1.faceVO.bitmapRect.width;
         _faceHeight = param1.faceVO.bitmapRect.height;
         if(!(_containerVO = _containerDictionary[param1]))
         {
            _containerVO = _containerDictionary[param1] = new FaceMaterialVO();
         }
         if(param3.resized)
         {
            param3.resized = false;
            _containerVO.resize(_faceWidth,_faceHeight,transparent);
         }
         for each(_loc4_ in materials)
         {
            _containerVO = _loc4_.renderBitmapLayer(param1,param2,_containerVO);
         }
         if(param3.updated || _containerVO.updated)
         {
            param3.updated = false;
            _containerVO.updated = false;
            _faceMaterialVO.invalidated = false;
            _faceMaterialVO.cleared = false;
            _faceMaterialVO.updated = true;
            _faceMaterialVO.bitmap = param3.bitmap.clone();
            _faceMaterialVO.bitmap.lock();
            _sourceVO = _faceMaterialVO;
            if(_blendMode == BlendMode.NORMAL && !_colorTransform)
            {
               _faceMaterialVO.bitmap.copyPixels(_containerVO.bitmap,_containerVO.bitmap.rect,_zeroPoint,null,null,true);
            }
            else
            {
               _faceMaterialVO.bitmap.draw(_containerVO.bitmap,null,_colorTransform,_blendMode);
            }
         }
         return _faceMaterialVO;
      }
      
      public function removeMaterial(param1:ILayerMaterial) : void
      {
         var _loc2_:int = materials.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         param1.removeOnMaterialUpdate(onMaterialUpdate);
         materials.splice(_loc2_,1);
         _materialDirty = true;
      }
      
      private function onMaterialUpdate(param1:MaterialEvent) : void
      {
         _materialDirty = true;
      }
      
      override public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
         var _loc3_:ILayerMaterial = null;
         for each(_loc3_ in materials)
         {
            _loc3_.updateMaterial(param1,param2);
         }
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
            clearFaces();
         }
         _blendModeDirty = false;
      }
      
      override protected function getMapping(param1:DrawTriangle) : Matrix
      {
         var _loc2_:ILayerMaterial = null;
         _faceVO = param1.faceVO;
         _faceMaterialVO = getFaceMaterialVO(param1.faceVO,param1.source,param1.view);
         if(param1.generated || _faceMaterialVO.invalidated || _faceMaterialVO.updated)
         {
            _faceMaterialVO.updated = true;
            _faceMaterialVO.cleared = false;
            if(_faceMaterialVO.invalidated)
            {
               _faceMaterialVO.invalidated = false;
               _faceVO.bitmapRect = new Rectangle(int(_width * _faceVO.minU),int(_height * (1 - _faceVO.maxV)),int(_width * (_faceVO.maxU - _faceVO.minU) + 2),int(_height * (_faceVO.maxV - _faceVO.minV) + 2));
               _faceWidth = _faceVO.bitmapRect.width;
               _faceHeight = _faceVO.bitmapRect.height;
               _faceMaterialVO.invtexturemapping = param1.transformUV(this).clone();
               _faceMaterialVO.texturemapping = _faceMaterialVO.invtexturemapping.clone();
               _faceMaterialVO.texturemapping.invert();
               _faceMaterialVO.resize(_faceWidth,_faceHeight,transparent);
            }
            _fMaterialVO = _faceMaterialVO;
            for each(_loc2_ in materials)
            {
               _fMaterialVO = _loc2_.renderBitmapLayer(param1,_bitmapRect,_fMaterialVO);
            }
            _renderBitmap = _cacheDictionary[_faceVO] = _fMaterialVO.bitmap;
            _fMaterialVO.updated = false;
            return _faceMaterialVO.texturemapping;
         }
         _renderBitmap = _cacheDictionary[_faceVO];
         if(_faceMaterialVO.invalidated)
         {
            _faceMaterialVO.invalidated = false;
            _faceMaterialVO.invtexturemapping = param1.transformUV(this).clone();
            _faceMaterialVO.texturemapping = _faceMaterialVO.invtexturemapping.clone();
            _faceMaterialVO.texturemapping.invert();
         }
         return _faceMaterialVO.texturemapping;
      }
      
      override public function renderLayer(param1:DrawTriangle, param2:Sprite, param3:int) : int
      {
         throw new Error("Not implemented");
      }
      
      override protected function updateRenderBitmap() : void
      {
         _bitmapDirty = false;
         invalidateFaces();
         _materialDirty = true;
      }
      
      public function clearMaterials() : void
      {
         var _loc1_:* = int(materials.length);
         while(_loc1_--)
         {
            removeMaterial(materials[_loc1_]);
         }
      }
      
      public function addMaterial(param1:ILayerMaterial) : void
      {
         param1.addOnMaterialUpdate(onMaterialUpdate);
         materials.push(param1);
         _materialDirty = true;
      }
   }
}


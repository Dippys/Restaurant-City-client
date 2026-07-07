package away3d.materials.shaders
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.light.DirectionalLight;
   import away3d.core.math.*;
   import away3d.core.render.*;
   import away3d.core.utils.*;
   import flash.display.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class DiffusePhongShader extends AbstractShader
   {
      
      private var _diffuseTransform:away3d.core.math.Matrix3D;
      
      private var _normal2z:Number;
      
      private var _normal1z:Number;
      
      private var _normal0z:Number;
      
      private var _szx:Number;
      
      private var _szy:Number;
      
      private var _szz:Number;
      
      private var eTriConst:Number = 162.97466172610083;
      
      public function DiffusePhongShader(param1:Object = null)
      {
         super(param1);
      }
      
      override public function renderLayer(param1:DrawTriangle, param2:Sprite, param3:int) : int
      {
         var _loc5_:DirectionalLight = null;
         super.renderLayer(param1,param2,param3);
         var _loc4_:Array = _lights.directionals;
         for each(_loc5_ in _loc4_)
         {
            if(_lights.numLights > 1)
            {
               _shape = _session.getLightShape(this,param3++,param2,_loc5_);
               _shape.blendMode = blendMode;
               _graphics = _shape.graphics;
            }
            else
            {
               _graphics = param2.graphics;
            }
            _diffuseTransform = _loc5_.diffuseTransform[_source];
            _n0 = _source.geometry.getVertexNormal(_face.v0);
            _n1 = _source.geometry.getVertexNormal(_face.v1);
            _n2 = _source.geometry.getVertexNormal(_face.v2);
            _szx = _diffuseTransform.szx;
            _szy = _diffuseTransform.szy;
            _szz = _diffuseTransform.szz;
            _normal0z = _n0.x * _szx + _n0.y * _szy + _n0.z * _szz;
            _normal1z = _n1.x * _szx + _n1.y * _szy + _n1.z * _szz;
            _normal2z = _n2.x * _szx + _n2.y * _szy + _n2.z * _szz;
            eTri0x = eTriConst * Math.acos(_normal0z);
            _mapping.a = eTriConst * Math.acos(_normal1z) - eTri0x;
            _mapping.b = 127;
            _mapping.c = eTriConst * Math.acos(_normal2z) - eTri0x;
            _mapping.d = 255;
            _mapping.tx = eTri0x;
            _mapping.ty = 0;
            _mapping.invert();
            _source.session.renderTriangleBitmap(_loc5_.ambientDiffuseBitmap,_mapping,param1.screenVertices,param1.screenIndices,param1.startIndex,param1.endIndex,smooth,false,_graphics);
         }
         if(debug)
         {
            _source.session.renderTriangleLine(0,255,1,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex);
         }
         return param3;
      }
      
      override public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
         var _loc4_:DirectionalLight = null;
         var _loc3_:Array = param1.lightarray.directionals;
         for each(_loc4_ in _loc3_)
         {
            if(!_loc4_.diffuseTransform[param1] || Boolean(param2.scene.updatedObjects[param1]))
            {
               _loc4_.setDiffuseTransform(param1);
               clearFaces(param1,param2);
            }
         }
      }
      
      protected function clearFaces(param1:Object3D, param2:View3D) : void
      {
         var _loc3_:FaceMaterialVO = null;
         notifyMaterialUpdate();
         for each(_loc3_ in _faceDictionary)
         {
            if(param1 == _loc3_.source)
            {
               if(!_loc3_.cleared)
               {
                  _loc3_.clear();
               }
               _loc3_.invalidated = true;
            }
         }
      }
      
      override protected function renderShader(param1:DrawTriangle) : void
      {
         var _loc3_:DirectionalLight = null;
         _faceVO = param1.faceVO;
         _n0 = _source.geometry.getVertexNormal(_face.v0);
         _n1 = _source.geometry.getVertexNormal(_face.v1);
         _n2 = _source.geometry.getVertexNormal(_face.v2);
         var _loc2_:Array = _source.lightarray.directionals;
         for each(_loc3_ in _loc2_)
         {
            _diffuseTransform = _loc3_.diffuseTransform[_source];
            _szx = _diffuseTransform.szx;
            _szy = _diffuseTransform.szy;
            _szz = _diffuseTransform.szz;
            _normal0z = _n0.x * _szx + _n0.y * _szy + _n0.z * _szz;
            _normal1z = _n1.x * _szx + _n1.y * _szy + _n1.z * _szz;
            _normal2z = _n2.x * _szx + _n2.y * _szy + _n2.z * _szz;
            if(_normal0z > 0 || _normal1z > 0 || _normal2z > 0)
            {
               eTri0x = eTriConst * Math.acos(_normal0z);
               if(_faceMaterialVO.cleared && !_parentFaceMaterialVO.updated)
               {
                  _faceMaterialVO.bitmap = _parentFaceMaterialVO.bitmap.clone();
                  _faceMaterialVO.bitmap.lock();
               }
               _faceMaterialVO.cleared = false;
               _faceMaterialVO.updated = true;
               _mapping.a = eTriConst * Math.acos(_normal1z) - eTri0x;
               _mapping.b = 127;
               _mapping.c = eTriConst * Math.acos(_normal2z) - eTri0x;
               _mapping.d = 255;
               _mapping.tx = eTri0x;
               _mapping.ty = 0;
               _mapping.invert();
               _mapping.concat(_faceMaterialVO.invtexturemapping);
               _graphics = _s.graphics;
               _graphics.clear();
               _graphics.beginBitmapFill(_loc3_.diffuseBitmap,_mapping,false,smooth);
               _graphics.drawRect(0,0,_bitmapRect.width,_bitmapRect.height);
               _graphics.endFill();
               _faceMaterialVO.bitmap.draw(_s,null,null,blendMode);
            }
         }
      }
   }
}


package away3d.materials.shaders
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.light.DirectionalLight;
   import away3d.core.math.Matrix3D;
   import away3d.core.math.Number3D;
   import away3d.core.render.*;
   import away3d.core.utils.*;
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class SpecularPhongShader extends AbstractShader
   {
      
      private var specVal1:Number;
      
      private var specVal2:Number;
      
      private var specVal3:Number;
      
      private var _syx:Number;
      
      private var _syy:Number;
      
      private var _syz:Number;
      
      private var _specular:Number;
      
      private var _szx:Number;
      
      private var _szy:Number;
      
      private var _szz:Number;
      
      private var _nFaceTransZ:Number;
      
      private var _shininess:Number;
      
      private var coeff1:Number;
      
      private var coeff2:Number;
      
      private var coeff3:Number;
      
      private var _specMin:Number;
      
      private var specValFace:Number;
      
      private var _specColor:ColorTransform;
      
      private var _specularTransform:away3d.core.math.Matrix3D;
      
      private var _nFace:Number3D;
      
      private var _sxx:Number;
      
      private var _sxy:Number;
      
      private var _sxz:Number;
      
      public function SpecularPhongShader(param1:Object = null)
      {
         super(param1);
         shininess = ini.getNumber("shininess",20);
         specular = ini.getNumber("specular",1);
      }
      
      public function set specular(param1:Number) : void
      {
         _specular = param1;
         _specColor = new ColorTransform(_specular,_specular,_specular,1,0,0,0,0);
      }
      
      override public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
         var _loc4_:DirectionalLight = null;
         var _loc3_:Array = param1.lightarray.directionals;
         for each(_loc4_ in _loc3_)
         {
            if(!_loc4_.specularTransform[param1])
            {
               _loc4_.specularTransform[param1] = new Dictionary(true);
            }
            if(Boolean(!_loc4_.specularTransform[param1][param2]) || Boolean(param2.scene.updatedObjects[param1]) || param2.updated)
            {
               _loc4_.setSpecularTransform(param1,param2);
               clearFaces(param1,param2);
            }
         }
      }
      
      public function set shininess(param1:Number) : void
      {
         _shininess = param1;
         _specMin = Math.pow(0.8,_shininess / 20);
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
            _specularTransform = _loc3_.specularTransform[_source][_view];
            _nFace = _face.normal;
            _szx = _specularTransform.szx;
            _szy = _specularTransform.szy;
            _szz = _specularTransform.szz;
            specVal1 = Math.pow(_n0.x * _szx + _n0.y * _szy + _n0.z * _szz,_shininess / 20);
            specVal2 = Math.pow(_n1.x * _szx + _n1.y * _szy + _n1.z * _szz,_shininess / 20);
            specVal3 = Math.pow(_n2.x * _szx + _n2.y * _szy + _n2.z * _szz,_shininess / 20);
            specValFace = Math.pow(_nFaceTransZ = _nFace.x * _szx + _nFace.y * _szy + _nFace.z * _szz,_shininess / 20);
            if(_nFaceTransZ > 0 && (specValFace > _specMin || specVal1 > _specMin || specVal2 > _specMin || specVal3 > _specMin || _nFace.dot(_n0) < 0.8 || _nFace.dot(_n1) < 0.8 || _nFace.dot(_n2) < 0.8))
            {
               if(_faceMaterialVO.cleared && !_parentFaceMaterialVO.updated)
               {
                  _faceMaterialVO.bitmap = _parentFaceMaterialVO.bitmap.clone();
                  _faceMaterialVO.bitmap.lock();
               }
               _faceMaterialVO.cleared = false;
               _faceMaterialVO.updated = true;
               _sxx = _specularTransform.sxx;
               _sxy = _specularTransform.sxy;
               _sxz = _specularTransform.sxz;
               _syx = _specularTransform.syx;
               _syy = _specularTransform.syy;
               _syz = _specularTransform.syz;
               eTri0x = _n0.x * _sxx + _n0.y * _sxy + _n0.z * _sxz;
               eTri0y = _n0.x * _syx + _n0.y * _syy + _n0.z * _syz;
               eTri1x = _n1.x * _sxx + _n1.y * _sxy + _n1.z * _sxz;
               eTri1y = _n1.x * _syx + _n1.y * _syy + _n1.z * _syz;
               eTri2x = _n2.x * _sxx + _n2.y * _sxy + _n2.z * _sxz;
               eTri2y = _n2.x * _syx + _n2.y * _syy + _n2.z * _syz;
               coeff1 = 255 * Math.acos(specVal1) / Math.sqrt(eTri0x * eTri0x + eTri0y * eTri0y);
               coeff2 = 255 * Math.acos(specVal2) / Math.sqrt(eTri1x * eTri1x + eTri1y * eTri1y);
               coeff3 = 255 * Math.acos(specVal3) / Math.sqrt(eTri2x * eTri2x + eTri2y * eTri2y);
               eTri0x *= coeff1;
               eTri0y *= coeff1;
               eTri1x *= coeff2;
               eTri1y *= coeff2;
               eTri2x *= coeff3;
               eTri2y *= coeff3;
               if(eTri1x == eTri0x && eTri1y == eTri0y)
               {
                  eTri1x += 0.1;
                  eTri1y += 0.1;
               }
               if(eTri2x == eTri1x && eTri2y == eTri1y)
               {
                  eTri2x += 0.1;
                  eTri2y += 0.1;
               }
               if(eTri0x == eTri2x && eTri0y == eTri2y)
               {
                  eTri0x += 0.1;
                  eTri0y += 0.1;
               }
               _mapping.a = eTri1x - eTri0x;
               _mapping.b = eTri1y - eTri0y;
               _mapping.c = eTri2x - eTri0x;
               _mapping.d = eTri2y - eTri0y;
               _mapping.tx = eTri0x + 255;
               _mapping.ty = eTri0y + 255;
               _mapping.invert();
               _mapping.concat(_faceMaterialVO.invtexturemapping);
               _graphics = _s.graphics;
               _graphics.clear();
               _graphics.beginBitmapFill(_loc3_.specularBitmap,_mapping,false,smooth);
               _graphics.drawRect(0,0,_bitmapRect.width,_bitmapRect.height);
               _graphics.endFill();
               _faceMaterialVO.bitmap.draw(_s,null,_specColor,blendMode);
            }
         }
      }
      
      public function get specular() : Number
      {
         return _specular;
      }
      
      public function get shininess() : Number
      {
         return _shininess;
      }
      
      override public function renderLayer(param1:DrawTriangle, param2:Sprite, param3:int) : int
      {
         var _loc5_:DirectionalLight = null;
         super.renderLayer(param1,param2,param3);
         var _loc4_:Array = _lights.directionals;
         for each(_loc5_ in _loc4_)
         {
            _specularTransform = _loc5_.specularTransform[_source][_view];
            _n0 = _source.geometry.getVertexNormal(_face.v0);
            _n1 = _source.geometry.getVertexNormal(_face.v1);
            _n2 = _source.geometry.getVertexNormal(_face.v2);
            _nFace = _face.normal;
            _szx = _specularTransform.szx;
            _szy = _specularTransform.szy;
            _szz = _specularTransform.szz;
            specVal1 = Math.pow(_n0.x * _szx + _n0.y * _szy + _n0.z * _szz,_shininess / 20);
            specVal2 = Math.pow(_n1.x * _szx + _n1.y * _szy + _n1.z * _szz,_shininess / 20);
            specVal3 = Math.pow(_n2.x * _szx + _n2.y * _szy + _n2.z * _szz,_shininess / 20);
            specValFace = Math.pow(_nFaceTransZ = _nFace.x * _szx + _nFace.y * _szy + _nFace.z * _szz,_shininess / 20);
            _shape = _session.getLightShape(this,param3++,param2,_loc5_);
            _shape.blendMode = blendMode;
            _shape.transform.colorTransform = _specColor;
            _graphics = _shape.graphics;
            if(_nFaceTransZ > 0 && (specValFace > _specMin || specVal1 > _specMin || specVal2 > _specMin || specVal3 > _specMin || _nFace.dot(_n0) < 0.8 || _nFace.dot(_n1) < 0.8 || _nFace.dot(_n2) < 0.8))
            {
               _sxx = _specularTransform.sxx;
               _sxy = _specularTransform.sxy;
               _sxz = _specularTransform.sxz;
               _syx = _specularTransform.syx;
               _syy = _specularTransform.syy;
               _syz = _specularTransform.syz;
               eTri0x = _n0.x * _sxx + _n0.y * _sxy + _n0.z * _sxz;
               eTri0y = _n0.x * _syx + _n0.y * _syy + _n0.z * _syz;
               eTri1x = _n1.x * _sxx + _n1.y * _sxy + _n1.z * _sxz;
               eTri1y = _n1.x * _syx + _n1.y * _syy + _n1.z * _syz;
               eTri2x = _n2.x * _sxx + _n2.y * _sxy + _n2.z * _sxz;
               eTri2y = _n2.x * _syx + _n2.y * _syy + _n2.z * _syz;
               coeff1 = 255 * Math.acos(specVal1) / Math.sqrt(eTri0x * eTri0x + eTri0y * eTri0y);
               coeff2 = 255 * Math.acos(specVal2) / Math.sqrt(eTri1x * eTri1x + eTri1y * eTri1y);
               coeff3 = 255 * Math.acos(specVal3) / Math.sqrt(eTri2x * eTri2x + eTri2y * eTri2y);
               eTri0x *= coeff1;
               eTri0y *= coeff1;
               eTri1x *= coeff2;
               eTri1y *= coeff2;
               eTri2x *= coeff3;
               eTri2y *= coeff3;
               if(eTri1x == eTri0x && eTri1y == eTri0y)
               {
                  eTri1x += 0.1;
                  eTri1y += 0.1;
               }
               if(eTri2x == eTri1x && eTri2y == eTri1y)
               {
                  eTri2x += 0.1;
                  eTri2y += 0.1;
               }
               if(eTri0x == eTri2x && eTri0y == eTri2y)
               {
                  eTri0x += 0.1;
                  eTri0y += 0.1;
               }
               _mapping.a = eTri1x - eTri0x;
               _mapping.b = eTri1y - eTri0y;
               _mapping.c = eTri2x - eTri0x;
               _mapping.d = eTri2y - eTri0y;
               _mapping.tx = eTri0x + 255;
               _mapping.ty = eTri0y + 255;
               _mapping.invert();
               _source.session.renderTriangleBitmap(_loc5_.specularBitmap,_mapping,param1.screenVertices,param1.screenIndices,param1.startIndex,param1.endIndex,smooth,false,_graphics);
            }
            else
            {
               _source.session.renderTriangleColor(0,1,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex,_graphics);
            }
         }
         if(debug)
         {
            _source.session.renderTriangleLine(0,255,1,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex);
         }
         return param3;
      }
      
      protected function clearFaces(param1:Object3D, param2:View3D) : void
      {
         var _loc3_:FaceMaterialVO = null;
         notifyMaterialUpdate();
         for each(_loc3_ in _faceDictionary)
         {
            if(param1 == _loc3_.source && param2 == _loc3_.view)
            {
               if(!_loc3_.cleared)
               {
                  _loc3_.clear();
               }
            }
         }
      }
   }
}


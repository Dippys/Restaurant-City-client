package away3d.materials.shaders
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.light.*;
   import away3d.core.math.*;
   import away3d.core.render.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import away3d.materials.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class AbstractShader extends EventDispatcher implements ILayerMaterial
   {
      
      arcane var directional:DirectionalLight;
      
      arcane var _s:Shape = new Shape();
      
      arcane var _view:View3D;
      
      arcane var _parentFaceMaterialVO:FaceMaterialVO;
      
      arcane var _faceMaterialVO:FaceMaterialVO;
      
      arcane var eTri2x:Number;
      
      arcane var eTri2y:Number;
      
      arcane var _mapping:Matrix = new Matrix();
      
      protected var ini:Init;
      
      public var blendMode:String;
      
      arcane var _dict:Dictionary;
      
      arcane var _normal0:Number3D = new Number3D();
      
      arcane var ambient:AmbientLight;
      
      arcane var _n0:Number3D;
      
      arcane var _n1:Number3D;
      
      arcane var _n2:Number3D;
      
      arcane var _shape:Shape;
      
      public var smooth:Boolean;
      
      arcane var _source:Mesh;
      
      arcane var _lights:ILightConsumer;
      
      arcane var _id:int;
      
      arcane var _face:Face;
      
      arcane var eTri0x:Number;
      
      arcane var eTri0y:Number;
      
      arcane var _bitmapRect:Rectangle;
      
      public var debug:Boolean;
      
      arcane var _session:AbstractRenderSession;
      
      arcane var _sprite:Sprite;
      
      arcane var _materialDirty:Boolean;
      
      arcane var eTri1x:Number;
      
      arcane var eTri1y:Number;
      
      arcane var _graphics:Graphics;
      
      arcane var _faceDictionary:Dictionary = new Dictionary(true);
      
      arcane var _normal2:Number3D = new Number3D();
      
      arcane var _faceVO:FaceVO;
      
      arcane var _normal1:Number3D = new Number3D();
      
      arcane var _materialupdated:MaterialEvent;
      
      public function AbstractShader(param1:Object = null)
      {
         super();
         ini = Init.parse(param1);
         smooth = ini.getBoolean("smooth",false);
         debug = ini.getBoolean("debug",false);
         blendMode = ini.getString("blendMode",BlendMode.NORMAL);
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
      
      public function get visible() : Boolean
      {
         return true;
      }
      
      public function renderBitmapLayer(param1:DrawTriangle, param2:Rectangle, param3:FaceMaterialVO) : FaceMaterialVO
      {
         _source = param1.source as Mesh;
         _session = _source.session;
         _view = param1.view;
         _faceVO = param1.faceVO;
         _face = _faceVO.face;
         _parentFaceMaterialVO = param3;
         _faceMaterialVO = getFaceMaterialVO(_faceVO,_source,_view);
         _faceMaterialVO.invtexturemapping = param3.invtexturemapping;
         if(param3.resized)
         {
            param3.resized = false;
            _faceMaterialVO.resized = true;
         }
         if(param3.updated || _faceMaterialVO.invalidated || _faceMaterialVO.updated)
         {
            param3.updated = false;
            _bitmapRect = _faceVO.bitmapRect;
            if(_faceMaterialVO.invalidated)
            {
               _faceMaterialVO.invalidated = false;
            }
            else
            {
               _faceMaterialVO.updated = true;
            }
            _faceMaterialVO.bitmap = param3.bitmap;
            renderShader(param1);
         }
         return _faceMaterialVO;
      }
      
      public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
         throw new Error("Not implemented");
      }
      
      public function removeOnMaterialUpdate(param1:Function) : void
      {
         removeEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false);
      }
      
      protected function renderShader(param1:DrawTriangle) : void
      {
         throw new Error("Not implemented");
      }
      
      final arcane function contains(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         if(param1 * (param8 - param4) + param3 * (param2 - param8) + param7 * (param4 - param2) < -0.001)
         {
            return false;
         }
         if(param1 * (param6 - param8) + param7 * (param2 - param6) + param5 * (param8 - param2) < -0.001)
         {
            return false;
         }
         if(param7 * (param6 - param4) + param3 * (param8 - param6) + param5 * (param4 - param8) < -0.001)
         {
            return false;
         }
         return true;
      }
      
      public function getFaceMaterialVO(param1:FaceVO, param2:Object3D = null, param3:View3D = null) : FaceMaterialVO
      {
         if(_faceMaterialVO = _faceDictionary[param1])
         {
            return _faceMaterialVO;
         }
         return _faceDictionary[param1] = new FaceMaterialVO();
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function addOnMaterialUpdate(param1:Function) : void
      {
         addEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false,0,true);
      }
      
      public function renderLayer(param1:DrawTriangle, param2:Sprite, param3:int) : int
      {
         _source = param1.source as Mesh;
         _session = _source.session;
         _view = param1.view;
         _faceVO = param1.faceVO;
         _face = _faceVO.face;
         _lights = param1.source.lightarray;
         return param3;
      }
   }
}


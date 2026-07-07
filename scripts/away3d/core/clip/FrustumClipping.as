package away3d.core.clip
{
   import away3d.arcane;
   import away3d.core.base.*;
   import away3d.core.geom.*;
   import away3d.core.render.*;
   import away3d.core.utils.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class FrustumClipping extends Clipping
   {
      
      private var _uv1:UV;
      
      private var _uv20:UV;
      
      private var _v2C:VertexClassification;
      
      private var _v1d:Number;
      
      private var _newFaceVO:FaceVO;
      
      private var _v0:Vertex;
      
      private var _v1:Vertex;
      
      private var _v1w:Number;
      
      private var _faceVOs:Array = new Array();
      
      private var _v2:Vertex;
      
      private var _frustum:Frustum;
      
      private var _v2d:Number;
      
      private var _faces:Array;
      
      private var _v01:Vertex;
      
      private var _v2w:Number;
      
      private var _uv01:UV;
      
      private var _v0C:VertexClassification;
      
      private var _face:Face;
      
      private var _processed:Dictionary;
      
      private var _session:AbstractRenderSession;
      
      private var _v12:Vertex;
      
      private var _uv12:UV;
      
      private var _d:Number;
      
      private var _v1C:VertexClassification;
      
      private var _v0d:Number;
      
      private var _uv2:UV;
      
      private var _faceVO:FaceVO;
      
      private var _uv0:UV;
      
      private var _v20:Vertex;
      
      private var _v0w:Number;
      
      private var _pass:Boolean;
      
      public function FrustumClipping(param1:Object = null)
      {
         super(param1);
         objectCulling = ini.getBoolean("objectCulling",true);
      }
      
      override public function checkElements(param1:Mesh, param2:Array, param3:Array, param4:Array, param5:Array, param6:Array, param7:Array, param8:Array) : void
      {
         var _loc9_:Plane3D = null;
         var _loc10_:Array = null;
         var _loc11_:Boolean = false;
         _session = param1.session;
         _frustum = _cameraVarsStore.frustumDictionary[param1];
         _processed = new Dictionary(true);
         _faces = param1.faces;
         _faceVOs.length = 0;
         for each(_face in _faces)
         {
            if(_face.visible)
            {
               _faceVOs[_faceVOs.length] = _face.faceVO;
            }
         }
         for each(_faceVO in _faceVOs)
         {
            _pass = true;
            _v0C = _cameraVarsStore.createVertexClassification(_faceVO.v0);
            _v1C = _cameraVarsStore.createVertexClassification(_faceVO.v1);
            _v2C = _cameraVarsStore.createVertexClassification(_faceVO.v2);
            if(Boolean(_v0C.plane) || Boolean(_v1C.plane) || Boolean(_v2C.plane))
            {
               _loc9_ = _v0C.plane;
               if(_loc9_)
               {
                  _v0d = _v0C.distance;
                  _v1d = _v1C.getDistance(_loc9_);
                  _v2d = _v2C.getDistance(_loc9_);
               }
               else
               {
                  _loc9_ = _v1C.plane;
                  if(_loc9_)
                  {
                     _v0d = _v0C.getDistance(_loc9_);
                     _v1d = _v1C.distance;
                     _v2d = _v2C.getDistance(_loc9_);
                  }
                  else
                  {
                     _loc9_ = _v2C.plane;
                     if(_loc9_)
                     {
                        _v0d = _v0C.getDistance(_loc9_);
                        _v1d = _v1C.getDistance(_loc9_);
                        _v2d = _v2C.distance;
                     }
                  }
               }
               if(_v0d < 0 && _v1d < 0 && _v2d < 0)
               {
                  continue;
               }
               if(_v0d < 0 || _v1d < 0 || _v2d < 0)
               {
                  _pass = false;
               }
            }
            else
            {
               _loc10_ = _frustum.planes;
               _loc11_ = false;
               for each(_loc9_ in _loc10_)
               {
                  _v0d = _v0C.getDistance(_loc9_);
                  _v1d = _v1C.getDistance(_loc9_);
                  _v2d = _v2C.getDistance(_loc9_);
                  if(_v0d < 0 && _v1d < 0 && _v2d < 0)
                  {
                     _loc11_ = true;
                     break;
                  }
                  if(_v0d < 0 || _v1d < 0 || _v2d < 0)
                  {
                     _pass = false;
                     break;
                  }
               }
               if(_loc11_)
               {
                  continue;
               }
            }
            if(_pass)
            {
               param2[param2.length] = _faceVO;
               param8[param8.length] = param7.length;
               if(!_processed[_faceVO.v0])
               {
                  param5[param5.length] = _faceVO.v0;
                  param7[param7.length] = (_processed[_faceVO.v0] = param5.length) - 1;
               }
               else
               {
                  param7[param7.length] = _processed[_faceVO.v0] - 1;
               }
               if(!_processed[_faceVO.v1])
               {
                  param5[param5.length] = _faceVO.v1;
                  param7[param7.length] = (_processed[_faceVO.v1] = param5.length) - 1;
               }
               else
               {
                  param7[param7.length] = _processed[_faceVO.v1] - 1;
               }
               if(!_processed[_faceVO.v2])
               {
                  param5[param5.length] = _faceVO.v2;
                  param7[param7.length] = (_processed[_faceVO.v2] = param5.length) - 1;
               }
               else
               {
                  param7[param7.length] = _processed[_faceVO.v2] - 1;
               }
            }
            else
            {
               if(_v0d >= 0 && _v1d < 0)
               {
                  _v0w = _v0d;
                  _v1w = _v1d;
                  _v2w = _v2d;
                  _v0 = _faceVO.v0;
                  _v1 = _faceVO.v1;
                  _v2 = _faceVO.v2;
                  _uv0 = _faceVO.uv0;
                  _uv1 = _faceVO.uv1;
                  _uv2 = _faceVO.uv2;
               }
               else if(_v1d >= 0 && _v2d < 0)
               {
                  _v0w = _v1d;
                  _v1w = _v2d;
                  _v2w = _v0d;
                  _v0 = _faceVO.v1;
                  _v1 = _faceVO.v2;
                  _v2 = _faceVO.v0;
                  _uv0 = _faceVO.uv1;
                  _uv1 = _faceVO.uv2;
                  _uv2 = _faceVO.uv0;
               }
               else if(_v2d >= 0 && _v0d < 0)
               {
                  _v0w = _v2d;
                  _v1w = _v0d;
                  _v2w = _v1d;
                  _v0 = _faceVO.v2;
                  _v1 = _faceVO.v0;
                  _v2 = _faceVO.v1;
                  _uv0 = _faceVO.uv2;
                  _uv1 = _faceVO.uv0;
                  _uv2 = _faceVO.uv1;
               }
               _d = _v0w - _v1w;
               _v01 = _cameraVarsStore.createVertex((_v1.x * _v0w - _v0.x * _v1w) / _d,(_v1.y * _v0w - _v0.y * _v1w) / _d,(_v1.z * _v0w - _v0.z * _v1w) / _d);
               _uv01 = _uv0 ? _cameraVarsStore.createUV((_uv1.u * _v0w - _uv0.u * _v1w) / _d,(_uv1.v * _v0w - _uv0.v * _v1w) / _d,_session) : null;
               if(_v2w < 0)
               {
                  _d = _v0w - _v2w;
                  _v20 = _cameraVarsStore.createVertex((_v2.x * _v0w - _v0.x * _v2w) / _d,(_v2.y * _v0w - _v0.y * _v2w) / _d,(_v2.z * _v0w - _v0.z * _v2w) / _d);
                  _uv20 = _uv0 ? _cameraVarsStore.createUV((_uv2.u * _v0w - _uv0.u * _v2w) / _d,(_uv2.v * _v0w - _uv0.v * _v2w) / _d,_session) : null;
                  _newFaceVO = _faceVOs[_faceVOs.length] = _cameraVarsStore.createFaceVO(_faceVO.face,_faceVO.material,_faceVO.back,_uv0,_uv01,_uv20);
                  _newFaceVO.vertices[0] = _newFaceVO.v0 = _v0;
                  _newFaceVO.vertices[1] = _newFaceVO.v1 = _v01;
                  _newFaceVO.vertices[2] = _newFaceVO.v2 = _v20;
               }
               else
               {
                  _d = _v2w - _v1w;
                  _v12 = _cameraVarsStore.createVertex((_v1.x * _v2w - _v2.x * _v1w) / _d,(_v1.y * _v2w - _v2.y * _v1w) / _d,(_v1.z * _v2w - _v2.z * _v1w) / _d);
                  _uv12 = _uv0 ? _cameraVarsStore.createUV((_uv1.u * _v2w - _uv2.u * _v1w) / _d,(_uv1.v * _v2w - _uv2.v * _v1w) / _d,_session) : null;
                  _newFaceVO = _faceVOs[_faceVOs.length] = _cameraVarsStore.createFaceVO(_faceVO.face,_faceVO.material,_faceVO.back,_uv0,_uv01,_uv2);
                  _newFaceVO.vertices[0] = _newFaceVO.v0 = _v0;
                  _newFaceVO.vertices[1] = _newFaceVO.v1 = _v01;
                  _newFaceVO.vertices[2] = _newFaceVO.v2 = _v2;
                  _newFaceVO = _faceVOs[_faceVOs.length] = _cameraVarsStore.createFaceVO(_faceVO.face,_faceVO.material,_faceVO.back,_uv01,_uv12,_uv2);
                  _newFaceVO.vertices[0] = _newFaceVO.v0 = _v01;
                  _newFaceVO.vertices[1] = _newFaceVO.v1 = _v12;
                  _newFaceVO.vertices[2] = _newFaceVO.v2 = _v2;
               }
            }
         }
         param8[param8.length] = param7.length;
      }
      
      override public function clone(param1:Clipping = null) : Clipping
      {
         var _loc2_:FrustumClipping = param1 as FrustumClipping || new FrustumClipping();
         super.clone(_loc2_);
         return _loc2_;
      }
      
      override public function rect(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         if(this.maxX < param1)
         {
            return false;
         }
         if(this.minX > param3)
         {
            return false;
         }
         if(this.maxY < param2)
         {
            return false;
         }
         if(this.minY > param4)
         {
            return false;
         }
         return true;
      }
      
      override public function set objectCulling(param1:Boolean) : void
      {
         if(!param1)
         {
            throw new Error("objectCulling requires setting to true for FrustumClipping");
         }
         _objectCulling = param1;
      }
   }
}


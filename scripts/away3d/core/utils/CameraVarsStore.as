package away3d.core.utils
{
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.geom.*;
   import away3d.core.math.*;
   import away3d.core.render.*;
   import away3d.materials.*;
   import flash.utils.*;
   
   public class CameraVarsStore
   {
      
      private var _uvStore:Array = [];
      
      private var _vtStore:Array = [];
      
      public var frustumDictionary:Dictionary = new Dictionary(true);
      
      private var _sActive:Array = [];
      
      private var _frustum:Frustum;
      
      public var view:View3D;
      
      private var _vStore:Array = [];
      
      private var _segmentVO:SegmentVO;
      
      private var _frStore:Array = [];
      
      public var viewTransformDictionary:Dictionary = new Dictionary(true);
      
      public var nodeClassificationDictionary:Dictionary = new Dictionary(true);
      
      private var _uv:UV;
      
      private var _vertex:Vertex;
      
      private var _fStore:Array = [];
      
      private var _vtActive:Array = [];
      
      private var _vc:VertexClassification;
      
      private var _fActive:Array = [];
      
      private var _frActive:Array = [];
      
      private var _source:Object3D;
      
      private var _session:AbstractRenderSession;
      
      private var _sStore:Array = [];
      
      private var _vt:Matrix3D;
      
      private var _object:Object;
      
      private var _vActive:Array = [];
      
      private var _sourceDictionary:Dictionary = new Dictionary(true);
      
      private var _faceVO:FaceVO;
      
      private var _uvDictionary:Dictionary = new Dictionary(true);
      
      private var _v:Object;
      
      private var _uvArray:Array;
      
      private var _vcStore:Array = [];
      
      private var _vertexClassificationDictionary:Dictionary;
      
      public function CameraVarsStore()
      {
         super();
      }
      
      public function createFaceVO(param1:Face, param2:ITriangleMaterial, param3:ITriangleMaterial, param4:UV, param5:UV, param6:UV) : FaceVO
      {
         if(_fStore.length)
         {
            _fActive.push(_faceVO = _fStore.pop());
         }
         else
         {
            _fActive.push(_faceVO = new FaceVO());
         }
         _faceVO.face = param1;
         _faceVO.uv0 = param4;
         _faceVO.uv1 = param5;
         _faceVO.uv2 = param6;
         _faceVO.material = param2;
         _faceVO.back = param3;
         _faceVO.generated = true;
         return _faceVO;
      }
      
      public function createVertexClassificationDictionary(param1:Object3D) : Dictionary
      {
         if(!(_vertexClassificationDictionary = _sourceDictionary[param1]))
         {
            _vertexClassificationDictionary = _sourceDictionary[param1] = new Dictionary(true);
         }
         return _vertexClassificationDictionary;
      }
      
      public function createSegmentVO(param1:ISegmentMaterial) : SegmentVO
      {
         if(_sStore.length)
         {
            _sActive.push(_segmentVO = _sStore.pop());
         }
         else
         {
            _sActive.push(_segmentVO = new SegmentVO());
         }
         _segmentVO.generated = true;
         return _segmentVO;
      }
      
      public function createUV(param1:Number, param2:Number, param3:AbstractRenderSession) : UV
      {
         if(!(_uvArray = _uvDictionary[param3]))
         {
            _uvArray = _uvDictionary[param3] = [];
         }
         if(_uvStore.length)
         {
            _uvArray.push(_uv = _uvStore.pop());
            _uv.u = param1;
            _uv.v = param2;
         }
         else
         {
            _uvArray.push(_uv = new UV(param1,param2));
         }
         return _uv;
      }
      
      public function createViewTransform(param1:Object3D) : Matrix3D
      {
         if(_vtStore.length)
         {
            _vtActive.push(_vt = viewTransformDictionary[param1] = _vtStore.pop());
         }
         else
         {
            _vtActive.push(_vt = viewTransformDictionary[param1] = new Matrix3D());
         }
         return _vt;
      }
      
      public function createVertex(param1:Number, param2:Number, param3:Number) : Vertex
      {
         if(_vStore.length)
         {
            _vActive.push(_vertex = _vStore.pop());
            _vertex.x = param1;
            _vertex.y = param2;
            _vertex.z = param3;
         }
         else
         {
            _vActive.push(_vertex = new Vertex(param1,param2,param3));
         }
         return _vertex;
      }
      
      public function reset() : void
      {
         for(_object in _sourceDictionary)
         {
            _source = _object as Object3D;
            if(Boolean(_source.session) && _source.session.updated)
            {
               for(_v in _sourceDictionary[_source])
               {
                  _vcStore.push(_sourceDictionary[_source][_v]);
                  delete _sourceDictionary[_source][_v];
               }
            }
         }
         nodeClassificationDictionary = new Dictionary(true);
         _vtStore = _vtStore.concat(_vtActive);
         _vtActive.length = 0;
         _frStore = _frStore.concat(_frActive);
         _frActive.length = 0;
         _vStore = _vStore.concat(_vActive);
         _vActive.length = 0;
         for(_object in _uvDictionary)
         {
            _session = _object as AbstractRenderSession;
            if(_session.updated)
            {
               _uvArray = _uvDictionary[_session] as Array;
               _uvStore = _uvStore.concat();
               _uvArray.length = 0;
            }
         }
         _fStore = _fStore.concat(_fActive);
         _fActive.length = 0;
         _sStore = _sStore.concat(_sActive);
         _sActive.length = 0;
      }
      
      public function createVertexClassification(param1:Vertex) : VertexClassification
      {
         if(_vc = _vertexClassificationDictionary[param1])
         {
            return _vc;
         }
         if(_vcStore.length)
         {
            _vc = _vertexClassificationDictionary[param1] = _vcStore.pop();
         }
         else
         {
            _vc = _vertexClassificationDictionary[param1] = new VertexClassification();
         }
         _vc.vertex = param1;
         _vc.plane = null;
         return _vc;
      }
      
      public function createFrustum(param1:Object3D) : Frustum
      {
         if(_frStore.length)
         {
            _frActive.push(_frustum = frustumDictionary[param1] = _frStore.pop());
         }
         else
         {
            _frActive.push(_frustum = frustumDictionary[param1] = new Frustum());
         }
         return _frustum;
      }
   }
}


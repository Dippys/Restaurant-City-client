package away3d.primitives
{
   import away3d.*;
   import away3d.core.base.*;
   import away3d.materials.*;
   
   use namespace arcane;
   
   public class AbstractPrimitive extends Mesh
   {
      
      arcane var _uvStore:Array = [];
      
      arcane var _faceStore:Array = [];
      
      arcane var _segmentActive:Array = [];
      
      arcane var _vStore:Array = [];
      
      arcane var _face:Face;
      
      arcane var _uv:UV;
      
      arcane var _primitiveDirty:Boolean;
      
      arcane var _segmentStore:Array = [];
      
      private var _index:int;
      
      arcane var _vActive:Array = [];
      
      arcane var _faceActive:Array = [];
      
      arcane var _uvActive:Array = [];
      
      arcane var _v:Vertex;
      
      arcane var _segment:Segment;
      
      public function AbstractPrimitive(param1:Object = null)
      {
         super(param1);
         arcane::_primitiveDirty = true;
      }
      
      arcane function createFace(param1:Vertex, param2:Vertex, param3:Vertex, param4:ITriangleMaterial = null, param5:UV = null, param6:UV = null, param7:UV = null) : Face
      {
         if(_faceStore.length)
         {
            _faceActive.push(_face = _faceStore.pop());
            _face.v0 = param1;
            _face.v1 = param2;
            _face.v2 = param3;
            _face.material = param4;
            _face.uv0 = param5;
            _face.uv1 = param6;
            _face.uv2 = param7;
         }
         else
         {
            _faceActive.push(_face = new Face(param1,param2,param3,param4,param5,param6,param7));
         }
         return _face;
      }
      
      arcane function createSegment(param1:Vertex, param2:Vertex, param3:ISegmentMaterial = null) : Segment
      {
         if(_segmentStore.length)
         {
            _segmentActive.push(_segment = _segmentStore.pop());
            _segment.v0 = param1;
            _segment.v1 = param2;
            _segment.material = param3;
         }
         else
         {
            _segmentActive.push(_segment = new Segment(param1,param2,param3));
         }
         return _segment;
      }
      
      protected function buildPrimitive() : void
      {
         _primitiveDirty = false;
         _objectDirty = true;
         _index = faces.length;
         while(_index--)
         {
            removeFace(faces[_index]);
         }
         _index = segments.length;
         while(_index--)
         {
            removeSegment(segments[_index]);
         }
         _vStore = _vStore.concat(_vActive);
         _vActive = [];
         _uvStore = _uvStore.concat(_uvActive);
         _uvActive = [];
         _faceStore = _faceStore.concat(_faceActive);
         _faceActive = [];
         _segmentStore = _segmentStore.concat(_segmentActive);
         _segmentActive = [];
      }
      
      override public function get billboards() : Array
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return _geometry.billboards;
      }
      
      arcane function createUV(param1:Number = 0, param2:Number = 0) : UV
      {
         if(_uvStore.length)
         {
            _uvActive.push(_uv = _uvStore.pop());
            _uv.u = param1;
            _uv.v = param2;
         }
         else
         {
            _uvActive.push(_uv = new UV(param1,param2));
         }
         return _uv;
      }
      
      protected function updatePrimitive() : void
      {
         buildPrimitive();
         var _loc1_:* = geometry.quarterFacesTotal;
         while(_loc1_--)
         {
            quarterFaces();
         }
      }
      
      override public function get segments() : Array
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return _geometry.segments;
      }
      
      override public function get faces() : Array
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return _geometry.faces;
      }
      
      override public function get minX() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.minX;
      }
      
      override public function get minY() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.minY;
      }
      
      override public function get minZ() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.minZ;
      }
      
      override public function get objectDepth() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.objectDepth;
      }
      
      override public function get objectWidth() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.objectWidth;
      }
      
      arcane function createVertex(param1:Number = 0, param2:Number = 0, param3:Number = 0) : Vertex
      {
         if(_vStore.length)
         {
            _vActive.push(_v = _vStore.pop());
            _v.x = param1;
            _v.y = param2;
            _v.z = param3;
         }
         else
         {
            _vActive.push(_v = new Vertex(param1,param2,param3));
         }
         return _v;
      }
      
      override public function get objectHeight() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.objectHeight;
      }
      
      override public function get boundingRadius() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.boundingRadius;
      }
      
      override public function updateObject() : void
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         super.updateObject();
      }
      
      override public function get geometry() : Geometry
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return _geometry;
      }
      
      override public function get maxX() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.maxX;
      }
      
      override public function get maxY() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.maxY;
      }
      
      override public function get maxZ() : Number
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return super.maxZ;
      }
      
      override public function get vertices() : Array
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return _geometry.vertices;
      }
      
      override public function get elements() : Array
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return _geometry.elements;
      }
   }
}


package away3d.core.project
{
   import away3d.cameras.*;
   import away3d.cameras.lenses.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.clip.*;
   import away3d.core.draw.*;
   import away3d.core.geom.*;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import away3d.materials.*;
   import flash.utils.Dictionary;
   
   public class MeshProjector implements IPrimitiveProvider
   {
      
      private var _defaultClippedSegmentVOs:Array = new Array();
      
      private var _defaultStartIndices:Array = new Array();
      
      private var _sv2y:Number;
      
      private var _bmaterial:IBillboardMaterial;
      
      private var _billboardMaterial:IBillboardMaterial;
      
      private var _sv2x:Number;
      
      private var _billboardVOs:Array;
      
      private var _defaultVertices:Array = new Array();
      
      private var _endIndex:int;
      
      private var _faceVOs:Array;
      
      private var _clipping:Clipping;
      
      private var _smaterial:ISegmentMaterial;
      
      private var _backface:Boolean;
      
      private var _outlineIndices:Dictionary = new Dictionary(true);
      
      private var _startIndex:int;
      
      private var _n01:Face;
      
      private var _cameraVarsStore:CameraVarsStore;
      
      private var _screenCommands:Array;
      
      private var _clipFlag:Boolean;
      
      private var _drawPrimitiveStore:DrawPrimitiveStore;
      
      private var _defaultClippedFaceVOs:Array = new Array();
      
      private var _face:Face;
      
      private var _camera:Camera3D;
      
      private var _segmentMaterial:ISegmentMaterial;
      
      private var _n12:Face;
      
      private var _defaultClippedBillboards:Array = new Array();
      
      private var _vertices:Array;
      
      private var _segmentVOs:Array;
      
      private var _n20:Face;
      
      private var _billboardVO:BillboardVO;
      
      private var _faceMaterial:ITriangleMaterial;
      
      private var _view:View3D;
      
      private var _seg:DrawSegment;
      
      private var _screenIndices:Array;
      
      private var _screenVertices:Array;
      
      private var _segmentVO:SegmentVO;
      
      private var _zoom:Number;
      
      private var _vertex:Vertex;
      
      private var _startIndices:Array;
      
      private var _sv0x:Number;
      
      private var _sv0y:Number;
      
      private var _mesh:Mesh;
      
      private var _focus:Number;
      
      private var _lens:ILens;
      
      private var _backmat:ITriangleMaterial;
      
      private var _index:int;
      
      private var _sv1x:Number;
      
      private var _tri:DrawTriangle;
      
      private var _sv1y:Number;
      
      private var _segment:Segment;
      
      private var _faceVO:FaceVO;
      
      private var _i:int;
      
      public function MeshProjector()
      {
         super();
      }
      
      private function front(param1:int) : Number
      {
         _index = _screenIndices[param1] * 3;
         _sv0x = _screenVertices[_index];
         _sv0y = _screenVertices[_index + 1];
         _index = _screenIndices[param1 + 1] * 3;
         _sv1x = _screenVertices[_index];
         _sv1y = _screenVertices[_index + 1];
         _index = _screenIndices[param1 + 2] * 3;
         _sv2x = _screenVertices[_index];
         _sv2y = _screenVertices[_index + 1];
         return _sv0x * (_sv2y - _sv1y) + _sv1x * (_sv0y - _sv2y) + _sv2x * (_sv1y - _sv0y);
      }
      
      public function set view(param1:View3D) : void
      {
         _view = param1;
         _drawPrimitiveStore = view.drawPrimitiveStore;
         _cameraVarsStore = view.cameraVarsStore;
      }
      
      public function primitives(param1:Object3D, param2:Matrix3D, param3:IPrimitiveConsumer) : void
      {
         _cameraVarsStore.createVertexClassificationDictionary(param1);
         _mesh = param1 as Mesh;
         _camera = _view.camera;
         _clipping = _view.screenClipping;
         _lens = _camera.lens;
         _focus = _camera.focus;
         _zoom = _camera.zoom;
         _faceMaterial = _mesh.faceMaterial;
         _segmentMaterial = _mesh.segmentMaterial;
         _billboardMaterial = _mesh.billboardMaterial;
         _backmat = _mesh.back || _faceMaterial;
         _clipFlag = _cameraVarsStore.nodeClassificationDictionary[param1] == Frustum.INTERSECT && !(_clipping is RectangleClipping);
         if(_clipFlag)
         {
            _vertices = _defaultVertices;
            _vertices.length = 0;
            _screenCommands = _drawPrimitiveStore.getScreenCommands(param1.id);
            _screenCommands.length = 0;
            _screenIndices = _drawPrimitiveStore.getScreenIndices(param1.id);
            _screenIndices.length = 0;
            _startIndices = _defaultStartIndices;
            _startIndices.length = 0;
            _faceVOs = _defaultClippedFaceVOs;
            _faceVOs.length = 0;
            _segmentVOs = _defaultClippedSegmentVOs;
            _segmentVOs.length = 0;
            _billboardVOs = _defaultClippedBillboards;
            _billboardVOs.length = 0;
            _clipping.checkElements(_mesh,_faceVOs,_segmentVOs,_billboardVOs,_vertices,_screenCommands,_screenIndices,_startIndices);
         }
         else
         {
            _vertices = _mesh.vertices;
            _screenCommands = _mesh.commands;
            _screenIndices = _mesh.indices;
            _startIndices = _mesh.startIndices;
            _faceVOs = _mesh.faceVOs;
            _segmentVOs = _mesh.segmentVOs;
            _billboardVOs = _mesh.billboardVOs;
         }
         _screenVertices = _drawPrimitiveStore.getScreenVertices(param1.id);
         _screenVertices.length = 0;
         _lens.project(param2,_vertices,_screenVertices);
         if(_mesh.outline)
         {
            _i = _faceVOs.length;
            while(_i--)
            {
               _outlineIndices[_faceVOs[_i]] = _i;
            }
         }
         _i = 0;
         for each(_faceVO in _faceVOs)
         {
            _startIndex = _startIndices[_i++];
            _endIndex = _startIndices[_i];
            if(!_clipFlag)
            {
               _index = _startIndex;
               while(_screenVertices[_screenIndices[_index] * 3] != null && _index < _endIndex)
               {
                  ++_index;
               }
               if(_index < _endIndex)
               {
                  continue;
               }
            }
            _face = _faceVO.face;
            _tri = _drawPrimitiveStore.createDrawTriangle(param1,_faceVO,null,_screenVertices,_screenIndices,_screenCommands,_startIndex,_endIndex,_faceVO.uv0,_faceVO.uv1,_faceVO.uv2,_faceVO.generated);
            _backface = _tri.backface = _tri.area < 0;
            if(_backface)
            {
               if(!_mesh.bothsides)
               {
                  continue;
               }
               _tri.material = _faceVO.back;
               if(!_tri.material)
               {
                  _tri.material = _faceVO.material;
               }
            }
            else
            {
               _tri.material = _faceVO.material;
            }
            if(!_tri.material)
            {
               if(_backface)
               {
                  _tri.material = _backmat;
               }
               else
               {
                  _tri.material = _faceMaterial;
               }
            }
            if(Boolean(_tri.material) && !_tri.material.visible)
            {
               _tri.material = null;
            }
            if(!(!_mesh.outline && !_tri.material))
            {
               if(param3.primitive(_tri))
               {
                  if(_mesh.pushback)
                  {
                     _tri.screenZ = _tri.maxZ;
                  }
                  if(_mesh.pushfront)
                  {
                     _tri.screenZ = _tri.minZ;
                  }
                  _tri.screenZ += _mesh.screenZOffset;
                  if(Boolean(_mesh.outline) && !_backface)
                  {
                     _n01 = _mesh.geometry.neighbour01(_face);
                     if(_n01 == null || front(_startIndices[_outlineIndices[_n01.faceVO]]) <= 0)
                     {
                        _segmentVO = _cameraVarsStore.createSegmentVO(_mesh.outline);
                        _startIndex = _screenIndices.length;
                        _screenIndices[_screenIndices.length] = _screenIndices[_tri.startIndex];
                        _screenIndices[_screenIndices.length] = _screenIndices[_tri.startIndex + 1];
                        _endIndex = _screenIndices.length;
                        param3.primitive(_drawPrimitiveStore.createDrawSegment(param1,_segmentVO,_mesh.outline,_screenVertices,_screenIndices,_screenCommands,_startIndex,_endIndex));
                     }
                     _n12 = _mesh.geometry.neighbour12(_face);
                     if(_n12 == null || front(_startIndices[_outlineIndices[_n12.faceVO]]) <= 0)
                     {
                        _segmentVO = _cameraVarsStore.createSegmentVO(_mesh.outline);
                        _startIndex = _screenIndices.length;
                        _screenIndices[_screenIndices.length] = _screenIndices[_tri.startIndex + 1];
                        _screenIndices[_screenIndices.length] = _screenIndices[_tri.startIndex + 2];
                        _endIndex = _screenIndices.length;
                        param3.primitive(_drawPrimitiveStore.createDrawSegment(param1,_segmentVO,_mesh.outline,_screenVertices,_screenIndices,_screenCommands,_startIndex,_endIndex));
                     }
                     _n20 = _mesh.geometry.neighbour20(_face);
                     if(_n20 == null || front(_startIndices[_outlineIndices[_n20.faceVO]]) <= 0)
                     {
                        _segmentVO = _cameraVarsStore.createSegmentVO(_mesh.outline);
                        _startIndex = _screenIndices.length;
                        _screenIndices[_screenIndices.length] = _screenIndices[_tri.startIndex + 2];
                        _screenIndices[_screenIndices.length] = _screenIndices[_tri.startIndex];
                        _endIndex = _screenIndices.length;
                        param3.primitive(_drawPrimitiveStore.createDrawSegment(param1,_segmentVO,_mesh.outline,_screenVertices,_screenIndices,_screenCommands,_startIndex,_endIndex));
                     }
                  }
               }
            }
         }
         for each(_segmentVO in _segmentVOs)
         {
            _startIndex = _startIndices[_i++];
            _endIndex = _startIndices[_i];
            if(!_clipFlag)
            {
               _index = _startIndex;
               while(_screenVertices[_screenIndices[_index] * 3] != null && _index < _endIndex)
               {
                  ++_index;
               }
               if(_index < _endIndex)
               {
                  continue;
               }
            }
            _smaterial = _segmentVO.material || _segmentMaterial;
            if(_smaterial.visible)
            {
               _seg = _drawPrimitiveStore.createDrawSegment(param1,_segmentVO,_smaterial,_screenVertices,_screenIndices,_screenCommands,_startIndex,_endIndex,_segmentVO.generated);
               if(param3.primitive(_seg))
               {
                  if(_mesh.pushback)
                  {
                     _seg.screenZ = _seg.maxZ;
                  }
                  if(_mesh.pushfront)
                  {
                     _seg.screenZ = _seg.minZ;
                  }
                  _seg.screenZ += _mesh.screenZOffset;
               }
            }
         }
         for each(_billboardVO in _billboardVOs)
         {
            _index = _startIndices[_i++];
            if(!(!_clipFlag && _screenVertices[_screenIndices[_index] * 3] == null))
            {
               _bmaterial = _billboardVO.material || _billboardMaterial;
               if(_bmaterial.visible)
               {
                  param3.primitive(_drawPrimitiveStore.createDrawBillboard(param1,_billboardVO,_bmaterial,_screenVertices,_screenIndices,_index,_billboardVO.scaling * _zoom / (1 + _screenVertices[_screenIndices[_index] * 3 + 2] / _focus)));
               }
            }
         }
      }
      
      public function get view() : View3D
      {
         return _view;
      }
   }
}


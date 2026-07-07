package away3d.core.base
{
   import away3d.animators.data.*;
   import away3d.animators.skin.*;
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import away3d.loaders.data.MaterialData;
   import away3d.materials.*;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class Geometry extends EventDispatcher
   {
      
      public var framenames:Dictionary;
      
      private var _animation:Animation;
      
      private var _activePrefix:String;
      
      public var materialDictionary:Dictionary = new Dictionary(true);
      
      private var _neighbour01:Dictionary;
      
      private var _fAngle:Number;
      
      private var clonedskincontrollers:Dictionary;
      
      private var _dispatchedDimensionsChange:Boolean;
      
      arcane var billboardVOs:Array = [];
      
      private var _neighboursDirty:Boolean = true;
      
      private var _neighbour12:Dictionary;
      
      private var _element_vertices:Array;
      
      private var _materialData:MaterialData;
      
      private var _vertices:Array = [];
      
      private var _neighbour20:Dictionary;
      
      arcane var faceVOs:Array = [];
      
      private var _verticesDirty:Boolean = true;
      
      private var _vertnormals:Dictionary;
      
      private var _frame:int;
      
      private var _billboardVO:BillboardVO;
      
      private var _quarterFacesTotal:int = 0;
      
      arcane var commands:Array = [];
      
      public var graphics:Graphics3D = new Graphics3D();
      
      public var skinVertices:Array;
      
      private var _animationgroup:AnimationGroup;
      
      private var clonedskinvertices:Dictionary;
      
      private var clonedvertices:Dictionary;
      
      public var skinControllers:Array;
      
      private var _sequencedone:AnimationEvent;
      
      private var _vertfaces:Dictionary;
      
      arcane var indices:Array = [];
      
      private var _fVectors:Array;
      
      private var _segmentVO:SegmentVO;
      
      private var _fNormal:Number3D;
      
      private var _billboards:Array = [];
      
      private var _faces:Array = [];
      
      private var _element:Element;
      
      private var _vertex:Vertex;
      
      public var rootBone:Bone;
      
      arcane var segmentVOs:Array = [];
      
      private var _dimensionschanged:GeometryEvent;
      
      private var _vertfacesDirty:Boolean = true;
      
      private var _processed:Dictionary;
      
      private var _element_commands:Array;
      
      private var _index:int;
      
      public var cloneElementDictionary:Dictionary = new Dictionary();
      
      private var _vertnormalsDirty:Boolean = true;
      
      public var frames:Dictionary;
      
      protected var ini:Init;
      
      arcane var startIndices:Array = [];
      
      private var _cycle:AnimationEvent;
      
      private var cloneduvs:Dictionary;
      
      private var _faceVO:FaceVO;
      
      private var _segments:Array = [];
      
      public function Geometry()
      {
         super();
         graphics.geometry = this;
      }
      
      public function removeFace(param1:Face) : void
      {
         var _loc2_:int = _faces.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         removeElement(param1);
         if(param1.material)
         {
            removeMaterial(param1,param1.material);
         }
         _vertfacesDirty = true;
         param1.v0.geometry = null;
         param1.v1.geometry = null;
         param1.v2.geometry = null;
         _faces.splice(_loc2_,1);
      }
      
      public function removeOnSequenceDone(param1:Function) : void
      {
         removeEventListener(AnimationEvent.SEQUENCE_DONE,param1,false);
      }
      
      public function gotoAndStop(param1:int) : void
      {
         _frame = _animation.frame = param1;
         frames[_frame].adjust(1);
         if(_animation.isRunning)
         {
            _animation.stop();
         }
      }
      
      public function gotoAndPlay(param1:int) : void
      {
         _frame = _animation.frame = param1;
         frames[_frame].adjust(1);
         if(!_animation.isRunning)
         {
            _animation.start();
         }
      }
      
      public function addSegment(param1:Segment) : void
      {
         addElement(param1);
         if(param1.material)
         {
            addMaterial(param1,param1.material);
         }
         param1.v0.geometry = this;
         param1.v1.geometry = this;
         _segments.push(param1);
      }
      
      public function addOnMappingChange(param1:Function) : void
      {
         addEventListener(ElementEvent.MAPPING_CHANGED,param1,false,0,true);
      }
      
      public function playFrames(param1:Array, param2:uint, param3:Boolean = true, param4:Boolean = false) : void
      {
         var _loc5_:String = null;
         if(_animation)
         {
            _animation.sequence = [];
         }
         else
         {
            _animation = new Animation(this);
         }
         _animation.fps = param2;
         _animation.smooth = param3;
         _animation.loop = param4;
         if(param3)
         {
            _animation.createTransition();
         }
         for each(_loc5_ in param1)
         {
            if(framenames[_loc5_] != null)
            {
               _animation.sequence.push(new AnimationFrame(framenames[_loc5_]));
            }
         }
         if(_animation.sequence.length)
         {
            _animation.start();
         }
      }
      
      private function findNeighbours() : void
      {
         var _loc1_:Face = null;
         var _loc2_:Boolean = false;
         var _loc3_:Face = null;
         _neighbour01 = new Dictionary();
         _neighbour12 = new Dictionary();
         _neighbour20 = new Dictionary();
         for each(_loc1_ in _faces)
         {
            _loc2_ = true;
            for each(_loc3_ in _faces)
            {
               if(_loc2_)
               {
                  if(_loc1_ == _loc3_)
                  {
                     _loc2_ = false;
                  }
               }
               else
               {
                  if(_loc1_._v0 == _loc3_._v2 && _loc1_._v1 == _loc3_._v1)
                  {
                     _neighbour01[_loc1_] = _loc3_;
                     _neighbour12[_loc3_] = _loc1_;
                  }
                  if(_loc1_._v0 == _loc3_._v0 && _loc1_._v1 == _loc3_._v2)
                  {
                     _neighbour01[_loc1_] = _loc3_;
                     _neighbour20[_loc3_] = _loc1_;
                  }
                  if(_loc1_._v0 == _loc3_._v1 && _loc1_._v1 == _loc3_._v0)
                  {
                     _neighbour01[_loc1_] = _loc3_;
                     _neighbour01[_loc3_] = _loc1_;
                  }
                  if(_loc1_._v1 == _loc3_._v2 && _loc1_._v2 == _loc3_._v1)
                  {
                     _neighbour12[_loc1_] = _loc3_;
                     _neighbour12[_loc3_] = _loc1_;
                  }
                  if(_loc1_._v1 == _loc3_._v0 && _loc1_._v2 == _loc3_._v2)
                  {
                     _neighbour12[_loc1_] = _loc3_;
                     _neighbour20[_loc3_] = _loc1_;
                  }
                  if(_loc1_._v1 == _loc3_._v1 && _loc1_._v2 == _loc3_._v0)
                  {
                     _neighbour12[_loc1_] = _loc3_;
                     _neighbour01[_loc3_] = _loc1_;
                  }
                  if(_loc1_._v2 == _loc3_._v2 && _loc1_._v0 == _loc3_._v1)
                  {
                     _neighbour20[_loc1_] = _loc3_;
                     _neighbour12[_loc3_] = _loc1_;
                  }
                  if(_loc1_._v2 == _loc3_._v0 && _loc1_._v0 == _loc3_._v2)
                  {
                     _neighbour20[_loc1_] = _loc3_;
                     _neighbour20[_loc3_] = _loc1_;
                  }
                  if(_loc1_._v2 == _loc3_._v1 && _loc1_._v0 == _loc3_._v0)
                  {
                     _neighbour20[_loc1_] = _loc3_;
                     _neighbour01[_loc3_] = _loc1_;
                  }
               }
            }
         }
         _neighboursDirty = false;
      }
      
      public function get billboards() : Array
      {
         return _billboards;
      }
      
      public function neighbour20(param1:Face) : Face
      {
         if(_neighboursDirty)
         {
            findNeighbours();
         }
         return _neighbour20[param1];
      }
      
      public function get transitionValue() : Number
      {
         return _animation.transitionValue;
      }
      
      private function onVertexValueChange(param1:ElementEvent) : void
      {
         if(param1.element is Face)
         {
            (param1.element as Face).normalDirty = true;
         }
         notifyDimensionsChange();
      }
      
      arcane function getVertexNormal(param1:Vertex) : Number3D
      {
         if(_vertfacesDirty)
         {
            findVertFaces();
         }
         if(_vertnormalsDirty)
         {
            findVertNormals();
         }
         return _vertnormals[param1];
      }
      
      private function addElement(param1:Element) : void
      {
         _verticesDirty = true;
         param1.addOnVertexChange(onVertexChange);
         param1.addOnVertexValueChange(onVertexValueChange);
         param1.addOnMappingChange(onMappingChange);
         param1.parent = this;
         notifyDimensionsChange();
      }
      
      public function removeOnCycle(param1:Function) : void
      {
         _animation.cycleEvent = false;
         _animation.removeEventListener(AnimationEvent.CYCLE,param1,false);
      }
      
      public function removeSegment(param1:Segment) : void
      {
         var _loc2_:int = _segments.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         removeElement(param1);
         if(param1.material)
         {
            removeMaterial(param1,param1.material);
         }
         param1.v0.geometry = null;
         param1.v1.geometry = null;
         _segments.splice(_loc2_,1);
      }
      
      private function cloneFrame(param1:Frame) : Frame
      {
         var _loc4_:VertexPosition = null;
         var _loc2_:Frame = new Frame();
         var _loc3_:Array = param1.vertexpositions;
         for each(_loc4_ in _loc3_)
         {
            _loc2_.vertexpositions.push(cloneVertexPosition(_loc4_));
         }
         return _loc2_;
      }
      
      public function quarterFace(param1:Face, param2:Dictionary = null) : void
      {
         if(param2 == null)
         {
            param2 = new Dictionary();
         }
         var _loc3_:Vertex = param1.v0;
         var _loc4_:Vertex = param1.v1;
         var _loc5_:Vertex = param1.v2;
         if(param2[_loc3_] == null)
         {
            param2[_loc3_] = new Dictionary();
         }
         if(param2[_loc4_] == null)
         {
            param2[_loc4_] = new Dictionary();
         }
         if(param2[_loc5_] == null)
         {
            param2[_loc5_] = new Dictionary();
         }
         var _loc6_:Vertex = param2[_loc3_][_loc4_];
         if(_loc6_ == null)
         {
            _loc6_ = Vertex.median(_loc3_,_loc4_);
            param2[_loc3_][_loc4_] = _loc6_;
            param2[_loc4_][_loc3_] = _loc6_;
         }
         var _loc7_:Vertex = param2[_loc4_][_loc5_];
         if(_loc7_ == null)
         {
            _loc7_ = Vertex.median(_loc4_,_loc5_);
            param2[_loc4_][_loc5_] = _loc7_;
            param2[_loc5_][_loc4_] = _loc7_;
         }
         var _loc8_:Vertex = param2[_loc5_][_loc3_];
         if(_loc8_ == null)
         {
            _loc8_ = Vertex.median(_loc5_,_loc3_);
            param2[_loc5_][_loc3_] = _loc8_;
            param2[_loc3_][_loc5_] = _loc8_;
         }
         var _loc9_:UV = param1.uv0;
         var _loc10_:UV = param1.uv1;
         var _loc11_:UV = param1.uv2;
         var _loc12_:UV = UV.median(_loc9_,_loc10_);
         var _loc13_:UV = UV.median(_loc10_,_loc11_);
         var _loc14_:UV = UV.median(_loc11_,_loc9_);
         var _loc15_:ITriangleMaterial = param1.material;
         removeFace(param1);
         addFace(new Face(_loc3_,_loc6_,_loc8_,_loc15_,_loc9_,_loc12_,_loc14_));
         addFace(new Face(_loc6_,_loc4_,_loc7_,_loc15_,_loc12_,_loc10_,_loc13_));
         addFace(new Face(_loc8_,_loc7_,_loc5_,_loc15_,_loc14_,_loc13_,_loc11_));
         addFace(new Face(_loc7_,_loc8_,_loc6_,_loc15_,_loc13_,_loc14_,_loc12_));
      }
      
      public function removeBillboard(param1:Billboard) : void
      {
         var _loc2_:int = _billboards.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         removeElement(param1);
         if(param1.material)
         {
            removeMaterial(param1,param1.material);
         }
         param1.vertex.geometry = null;
         _billboards.splice(_loc2_,1);
      }
      
      public function set transitionValue(param1:Number) : void
      {
         _animation.transitionValue = param1;
      }
      
      public function get isRunning() : Boolean
      {
         return _animation != null ? _animation.isRunning : false;
      }
      
      arcane function notifyDimensionsChange() : void
      {
         if(_dispatchedDimensionsChange || !hasEventListener(GeometryEvent.DIMENSIONS_CHANGED))
         {
            return;
         }
         if(!_dimensionschanged)
         {
            _dimensionschanged = new GeometryEvent(GeometryEvent.DIMENSIONS_CHANGED,this);
         }
         dispatchEvent(_dimensionschanged);
         _dispatchedDimensionsChange = true;
      }
      
      public function get activePrefix() : String
      {
         return _activePrefix;
      }
      
      public function set loop(param1:Boolean) : void
      {
         _animation.loop = param1;
      }
      
      private function findVertFaces() : void
      {
         var _loc1_:Face = null;
         var _loc2_:Vertex = null;
         var _loc3_:Vertex = null;
         var _loc4_:Vertex = null;
         _vertfaces = new Dictionary();
         for each(_loc1_ in faces)
         {
            _loc2_ = _loc1_.v0;
            if(_vertfaces[_loc2_] == null)
            {
               _vertfaces[_loc2_] = [_loc1_];
            }
            else
            {
               _vertfaces[_loc2_].push(_loc1_);
            }
            _loc3_ = _loc1_.v1;
            if(_vertfaces[_loc3_] == null)
            {
               _vertfaces[_loc3_] = [_loc1_];
            }
            else
            {
               _vertfaces[_loc3_].push(_loc1_);
            }
            _loc4_ = _loc1_.v2;
            if(_vertfaces[_loc4_] == null)
            {
               _vertfaces[_loc4_] = [_loc1_];
            }
            else
            {
               _vertfaces[_loc4_].push(_loc1_);
            }
         }
         _vertfacesDirty = false;
         _vertnormalsDirty = true;
      }
      
      public function removeOnMaterialUpdate(param1:Function) : void
      {
         removeEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false);
      }
      
      public function play(param1:AnimationSequence) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         if(!_animation)
         {
            _animation = new Animation(this);
         }
         else
         {
            _animation.sequence = [];
         }
         _animation.fps = param1.fps;
         _animation.smooth = param1.smooth;
         _animation.loop = param1.loop;
         if(param1.prefix != null && param1.prefix != "")
         {
            if(_animation.smooth)
            {
               _animation.interpolate();
            }
            for(_loc3_ in framenames)
            {
               if(_loc3_.indexOf(param1.prefix) == 0)
               {
                  _loc2_ = true;
                  _activePrefix = _activePrefix != param1.prefix ? param1.prefix : _activePrefix;
                  _animation.sequence.push(new AnimationFrame(framenames[_loc3_],"" + parseInt(_loc3_.substring(param1.prefix.length))));
               }
            }
            if(_loc2_)
            {
               _animation.sequence.sortOn("sort",Array.NUMERIC);
               frames[_frame].adjust(1);
               _animation.start();
            }
            else
            {
               trace("--------- \n--> unable to play animation: unvalid prefix [" + param1.prefix + "]\n--------- ");
            }
         }
         else
         {
            trace("--------- \n--> unable to play animation: prefix is null \n--------- ");
         }
      }
      
      public function addOnMaterialUpdate(param1:Function) : void
      {
         addEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false,0,true);
      }
      
      public function removeOnMappingChange(param1:Function) : void
      {
         removeEventListener(ElementEvent.MAPPING_CHANGED,param1,false);
      }
      
      public function clone() : Geometry
      {
         var _loc2_:Face = null;
         var _loc3_:Segment = null;
         var _loc4_:* = 0;
         var _loc5_:Frame = null;
         var _loc6_:String = null;
         var _loc7_:SkinVertex = null;
         var _loc8_:SkinController = null;
         var _loc9_:Face = null;
         var _loc10_:Segment = null;
         var _loc1_:Geometry = new Geometry();
         clonedvertices = new Dictionary();
         cloneduvs = new Dictionary();
         if(skinVertices)
         {
            clonedskinvertices = new Dictionary(true);
            clonedskincontrollers = new Dictionary(true);
            _loc1_.skinVertices = [];
            _loc1_.skinControllers = [];
            for each(_loc7_ in skinVertices)
            {
               _loc1_.skinVertices.push(cloneSkinVertex(_loc7_));
            }
            for each(_loc8_ in clonedskincontrollers)
            {
               _loc1_.skinControllers.push(_loc8_);
            }
         }
         for each(_loc2_ in _faces)
         {
            _loc9_ = new Face(cloneVertex(_loc2_._v0),cloneVertex(_loc2_._v1),cloneVertex(_loc2_._v2),_loc2_.material,cloneUV(_loc2_._uv0),cloneUV(_loc2_._uv1),cloneUV(_loc2_._uv2));
            _loc1_.addFace(_loc9_);
            cloneElementDictionary[_loc2_] = _loc9_;
         }
         for each(_loc3_ in _segments)
         {
            _loc10_ = new Segment(cloneVertex(_loc3_._v0),cloneVertex(_loc3_._v1),_loc3_.material);
            _loc1_.addSegment(_loc10_);
            cloneElementDictionary[_loc3_] = _loc10_;
         }
         _loc1_.frames = new Dictionary(true);
         _loc4_ = 0;
         for each(_loc5_ in frames)
         {
            var _loc13_:Number;
            _loc1_.frames[_loc13_ = _loc4_++] = cloneFrame(_loc5_);
         }
         _loc1_.framenames = new Dictionary(true);
         for(_loc6_ in framenames)
         {
            _loc1_.framenames[_loc6_] = framenames[_loc6_];
         }
         return _loc1_;
      }
      
      private function cloneVertex(param1:Vertex) : Vertex
      {
         var _loc2_:Vertex = clonedvertices[param1];
         if(_loc2_ == null)
         {
            _loc2_ = param1.clone();
            _loc2_.extra = param1.extra is IClonable ? (param1.extra as IClonable).clone() : param1.extra;
            clonedvertices[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function addOnDimensionsChange(param1:Function) : void
      {
         addEventListener(GeometryEvent.DIMENSIONS_CHANGED,param1,false,0,true);
      }
      
      public function quarterFaces() : void
      {
         var _loc2_:Face = null;
         ++_quarterFacesTotal;
         var _loc1_:Dictionary = new Dictionary();
         for each(_loc2_ in _faces.concat([]))
         {
            quarterFace(_loc2_,_loc1_);
         }
      }
      
      public function updateMaterials(param1:Object3D, param2:View3D) : void
      {
         var _loc3_:MaterialData = null;
         for each(_loc3_ in materialDictionary)
         {
            _loc3_.material.updateMaterial(param1,param2);
         }
      }
      
      public function get frame() : int
      {
         return _animation.frame;
      }
      
      private function onMappingChange(param1:ElementEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function invertFaces() : void
      {
         var _loc1_:Face = null;
         for each(_loc1_ in _faces)
         {
            _loc1_.invert();
         }
      }
      
      private function findVertNormals() : void
      {
         var _loc1_:Vertex = null;
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Face = null;
         var _loc7_:Number3D = null;
         var _loc8_:Array = null;
         var _loc9_:Vertex = null;
         _vertnormals = new Dictionary();
         for each(_loc1_ in vertices)
         {
            _loc2_ = _vertfaces[_loc1_];
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            for each(_loc6_ in _loc2_)
            {
               _fNormal = _loc6_.normal;
               _fVectors = [];
               _loc8_ = _loc6_.vertices;
               for each(_loc9_ in _loc8_)
               {
                  if(_loc9_ != _loc1_)
                  {
                     _fVectors.push(new Number3D(_loc9_.x - _loc1_.x,_loc9_.y - _loc1_.y,_loc9_.z - _loc1_.z,true));
                  }
               }
               _fAngle = Math.acos((_fVectors[0] as Number3D).dot(_fVectors[1] as Number3D));
               _loc3_ += _fNormal.x * _fAngle;
               _loc4_ += _fNormal.y * _fAngle;
               _loc5_ += _fNormal.z * _fAngle;
            }
            _loc7_ = new Number3D(_loc3_,_loc4_,_loc5_);
            _loc7_.normalize();
            _vertnormals[_loc1_] = _loc7_;
         }
         _vertnormalsDirty = false;
      }
      
      private function updatePlaySequence(param1:AnimationEvent) : void
      {
         var _loc2_:int = int(_animationgroup.playlist.length);
         if(_loc2_ == 0)
         {
            _animation.removeEventListener(AnimationEvent.SEQUENCE_UPDATE,updatePlaySequence);
            _animation.sequenceEvent = false;
            if(hasSequenceEvent)
            {
               if(_sequencedone == null)
               {
                  _sequencedone = new AnimationEvent(AnimationEvent.SEQUENCE_DONE,null);
               }
               dispatchEvent(_sequencedone);
            }
            if(_animationgroup.loopLast)
            {
               _animation.start();
            }
         }
         else
         {
            if(_loc2_ == 1)
            {
               loop = _animationgroup.loopLast;
               _animationgroup.playlist[0].loop = _animationgroup.loopLast;
            }
            play(_animationgroup.playlist.shift());
         }
      }
      
      public function removeOnDimensionsChange(param1:Function) : void
      {
         removeEventListener(GeometryEvent.DIMENSIONS_CHANGED,param1,false);
      }
      
      public function set smooth(param1:Boolean) : void
      {
         _animation.smooth = param1;
      }
      
      arcane function get vertexDirty() : Boolean
      {
         var _loc2_:Vertex = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in vertices)
         {
            if(_loc2_.getVertexDirty())
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      private function onMaterialUpdate(param1:MaterialEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function addOnCycle(param1:Function) : void
      {
         _animation.cycleEvent = true;
         _cycle = new AnimationEvent(AnimationEvent.CYCLE,_animation);
         _animation.addEventListener(AnimationEvent.CYCLE,param1,false,0,false);
      }
      
      public function splitFace(param1:Face, param2:int = 0) : void
      {
         var _loc9_:Vertex = null;
         var _loc10_:UV = null;
         var _loc3_:Vertex = param1.v0;
         var _loc4_:Vertex = param1.v1;
         var _loc5_:Vertex = param1.v2;
         var _loc6_:UV = param1.uv0;
         var _loc7_:UV = param1.uv1;
         var _loc8_:UV = param1.uv2;
         var _loc11_:ITriangleMaterial = param1.material;
         removeFace(param1);
         switch(param2)
         {
            case 0:
               _loc9_ = new Vertex((param1.v0.x + param1.v1.x) * 0.5,(param1.v0.y + param1.v1.y) * 0.5,(param1.v0.z + param1.v1.z) * 0.5);
               _loc10_ = new UV((_loc6_.u + _loc7_.u) * 0.5,(_loc6_.v + _loc7_.v) * 0.5);
               addFace(new Face(_loc9_,_loc4_,_loc5_,_loc11_,_loc10_,_loc7_,_loc8_));
               addFace(new Face(_loc3_,_loc9_,_loc5_,_loc11_,_loc6_,_loc10_,_loc8_));
               break;
            case 1:
               _loc9_ = new Vertex((param1.v1.x + param1.v2.x) * 0.5,(param1.v1.y + param1.v2.y) * 0.5,(param1.v1.z + param1.v2.z) * 0.5);
               _loc10_ = new UV((_loc7_.u + _loc8_.u) * 0.5,(_loc7_.v + _loc8_.v) * 0.5);
               addFace(new Face(_loc3_,_loc4_,_loc9_,_loc11_,_loc6_,_loc7_,_loc10_));
               addFace(new Face(_loc3_,_loc9_,_loc5_,_loc11_,_loc6_,_loc10_,_loc8_));
               break;
            default:
               _loc9_ = new Vertex((param1.v2.x + param1.v0.x) * 0.5,(param1.v2.y + param1.v0.y) * 0.5,(param1.v2.z + param1.v0.z) * 0.5);
               _loc10_ = new UV((_loc8_.u + _loc6_.u) * 0.5,(_loc8_.v + _loc6_.v) * 0.5);
               addFace(new Face(_loc3_,_loc4_,_loc9_,_loc11_,_loc6_,_loc7_,_loc10_));
               addFace(new Face(_loc9_,_loc4_,_loc5_,_loc11_,_loc10_,_loc7_,_loc8_));
         }
      }
      
      public function addOnSequenceDone(param1:Function) : void
      {
         addEventListener(AnimationEvent.SEQUENCE_DONE,param1,false,0,false);
      }
      
      public function get loop() : Boolean
      {
         return _animation.loop;
      }
      
      public function addFace(param1:Face) : void
      {
         addElement(param1);
         if(param1.material)
         {
            addMaterial(param1,param1.material);
         }
         _vertfacesDirty = true;
         if(param1.v0)
         {
            param1.v0.geometry = this;
         }
         if(param1.v1)
         {
            param1.v1.geometry = this;
         }
         if(param1.v2)
         {
            param1.v2.geometry = this;
         }
         _faces.push(param1);
      }
      
      public function triFace(param1:Face) : void
      {
         var _loc2_:Vertex = param1.v0;
         var _loc3_:Vertex = param1.v1;
         var _loc4_:Vertex = param1.v2;
         var _loc5_:Vertex = new Vertex((param1.v0.x + param1.v1.x + param1.v2.x) / 3,(param1.v0.y + param1.v1.y + param1.v2.y) / 3,(param1.v0.z + param1.v1.z + param1.v2.z) / 3);
         var _loc6_:UV = param1.uv0;
         var _loc7_:UV = param1.uv1;
         var _loc8_:UV = param1.uv2;
         var _loc9_:UV = new UV((_loc6_.u + _loc7_.u + _loc8_.u) / 3,(_loc6_.v + _loc7_.v + _loc8_.v) / 3);
         var _loc10_:ITriangleMaterial = param1.material;
         removeFace(param1);
         addFace(new Face(_loc2_,_loc3_,_loc5_,_loc10_,_loc6_,_loc7_,_loc9_));
         addFace(new Face(_loc5_,_loc3_,_loc4_,_loc10_,_loc9_,_loc7_,_loc8_));
         addFace(new Face(_loc2_,_loc5_,_loc4_,_loc10_,_loc6_,_loc9_,_loc8_));
      }
      
      private function cloneVertexPosition(param1:VertexPosition) : VertexPosition
      {
         var _loc2_:VertexPosition = new VertexPosition(cloneVertex(param1.vertex));
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.z = param1.z;
         return _loc2_;
      }
      
      private function cloneSkinController(param1:SkinController) : SkinController
      {
         var _loc2_:SkinController = clonedskincontrollers[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new SkinController();
            _loc2_.name = param1.name;
            _loc2_.bindMatrix = param1.bindMatrix;
            clonedskincontrollers[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function get hasCycleEvent() : Boolean
      {
         return _animation.hasEventListener(AnimationEvent.CYCLE);
      }
      
      public function splitFaces(param1:int = 0) : void
      {
         var _loc2_:Face = null;
         param1 = param1 < 0 ? 0 : (param1 > 2 ? 2 : param1);
         for each(_loc2_ in _faces.concat([]))
         {
            splitFace(_loc2_,param1);
         }
      }
      
      private function cloneSkinVertex(param1:SkinVertex) : SkinVertex
      {
         var _loc3_:Array = null;
         var _loc4_:SkinController = null;
         var _loc2_:SkinVertex = clonedskinvertices[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new SkinVertex(cloneVertex(param1.skinnedVertex));
            _loc2_.weights = param1.weights.concat();
            _loc3_ = param1.controllers;
            for each(_loc4_ in _loc3_)
            {
               _loc2_.controllers.push(cloneSkinController(_loc4_));
            }
            clonedskinvertices[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function addBillboard(param1:Billboard) : void
      {
         addElement(param1);
         if(param1.material)
         {
            addMaterial(param1,param1.material);
         }
         param1.vertex.geometry = this;
         _billboards.push(param1);
      }
      
      public function get segments() : Array
      {
         return _segments;
      }
      
      private function cloneUV(param1:UV) : UV
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:UV = cloneduvs[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new UV(param1._u,param1._v);
            cloneduvs[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      arcane function removeMaterial(param1:Element, param2:IMaterial) : void
      {
         if(_materialData = materialDictionary[param2])
         {
            if((_index = _materialData.elements.indexOf(param1)) != -1)
            {
               _materialData.elements.splice(_index,1);
            }
            if(!_materialData.elements.length)
            {
               delete materialDictionary[param2];
               param2.removeOnMaterialUpdate(onMaterialUpdate);
            }
         }
      }
      
      public function updateVertex(param1:Vertex, param2:Number, param3:Number, param4:Number, param5:Boolean = false) : void
      {
         param1.setValue(param2,param3,param4);
         if(param5)
         {
            _vertnormalsDirty = true;
         }
      }
      
      public function get smooth() : Boolean
      {
         return _animation.smooth;
      }
      
      public function set fps(param1:int) : void
      {
         _animation.fps = param1 >= 1 ? param1 : 1;
      }
      
      public function setPlaySequences(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:int = int(param1.length);
         if(_loc3_ == 0)
         {
            return;
         }
         if(!_animation)
         {
            _animation = new Animation(this);
         }
         _animationgroup = new AnimationGroup();
         _animationgroup.loopLast = param2;
         _animationgroup.playlist = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _animationgroup.playlist[_loc4_] = new AnimationSequence(param1[_loc4_].prefix,param1[_loc4_].smooth,true,param1[_loc4_].fps);
            _loc4_++;
         }
         if(!_animation.hasEventListener(AnimationEvent.SEQUENCE_UPDATE))
         {
            _animation.addEventListener(AnimationEvent.SEQUENCE_UPDATE,updatePlaySequence);
         }
         _animation.sequenceEvent = true;
         loop = true;
         play(_animationgroup.playlist.shift());
      }
      
      private function removeElement(param1:Element) : void
      {
         _verticesDirty = true;
         param1.removeOnVertexChange(onVertexChange);
         param1.removeOnVertexValueChange(onVertexValueChange);
         param1.notifyMappingChange();
         param1.removeOnMappingChange(onMappingChange);
         notifyDimensionsChange();
      }
      
      public function applyPosition(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Vertex = null;
         for each(_loc7_ in vertices)
         {
            _loc4_ = _loc7_.x;
            _loc5_ = _loc7_.y;
            _loc6_ = _loc7_.z;
            _loc7_.setValue(_loc4_ - param1,_loc5_ - param2,_loc6_ - param3);
         }
      }
      
      public function set frame(param1:int) : void
      {
         if(_animation.frame == param1)
         {
            return;
         }
         _frame = param1;
         _animation.frame = param1;
         frames[param1].adjust(1);
      }
      
      public function neighbour01(param1:Face) : Face
      {
         if(_neighboursDirty)
         {
            findNeighbours();
         }
         return _neighbour01[param1];
      }
      
      public function updateElements() : void
      {
         var _loc1_:SkinController = null;
         var _loc2_:SkinVertex = null;
         _dispatchedDimensionsChange = false;
         for each(_loc1_ in skinControllers)
         {
            _loc1_.update();
         }
         for each(_loc2_ in skinVertices)
         {
            _loc2_.update();
         }
         if(_animation != null && frames != null)
         {
            _animation.update();
         }
         if(vertexDirty)
         {
            notifyDimensionsChange();
         }
      }
      
      public function get faces() : Array
      {
         return _faces;
      }
      
      public function get hasSequenceEvent() : Boolean
      {
         return hasEventListener(AnimationEvent.SEQUENCE_DONE);
      }
      
      arcane function addMaterial(param1:Element, param2:IMaterial) : void
      {
         if(!(_materialData = materialDictionary[param2]))
         {
            _materialData = materialDictionary[param2] = new MaterialData();
            _materialData.material = param2;
            param2.addOnMaterialUpdate(onMaterialUpdate);
         }
         if(_materialData.elements.indexOf(param1) == -1)
         {
            _materialData.elements.push(param1);
         }
      }
      
      public function get fps() : int
      {
         return _animation.fps;
      }
      
      public function triFaces() : void
      {
         var _loc1_:Face = null;
         for each(_loc1_ in _faces.concat([]))
         {
            triFace(_loc1_);
         }
      }
      
      public function applyRotations(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc19_:Vertex = null;
         var _loc9_:Number = Math.PI / 180;
         var _loc10_:Number = param1 * _loc9_;
         var _loc11_:Number = param2 * _loc9_;
         var _loc12_:Number = param3 * _loc9_;
         var _loc13_:Number = Math.sin(_loc10_);
         var _loc14_:Number = Math.cos(_loc10_);
         var _loc15_:Number = Math.sin(_loc11_);
         var _loc16_:Number = Math.cos(_loc11_);
         var _loc17_:Number = Math.sin(_loc12_);
         var _loc18_:Number = Math.cos(_loc12_);
         for each(_loc19_ in vertices)
         {
            _loc4_ = _loc19_.x;
            _loc5_ = _loc19_.y;
            _loc6_ = _loc19_.z;
            _loc8_ = _loc5_;
            _loc5_ = _loc8_ * _loc14_ + _loc6_ * -_loc13_;
            _loc6_ = _loc8_ * _loc13_ + _loc6_ * _loc14_;
            _loc7_ = _loc4_;
            _loc4_ = _loc7_ * _loc16_ + _loc6_ * _loc15_;
            _loc6_ = _loc7_ * -_loc15_ + _loc6_ * _loc16_;
            _loc7_ = _loc4_;
            _loc4_ = _loc7_ * _loc18_ + _loc5_ * -_loc17_;
            _loc5_ = _loc7_ * _loc17_ + _loc5_ * _loc18_;
            updateVertex(_loc19_,_loc4_,_loc5_,_loc6_,false);
         }
      }
      
      private function onVertexChange(param1:ElementEvent) : void
      {
         _verticesDirty = true;
         if(param1.element is Face)
         {
            (param1.element as Face).normalDirty = true;
            _vertfacesDirty = true;
         }
         notifyDimensionsChange();
      }
      
      public function get elements() : Array
      {
         return _faces.concat(_segments,_billboards);
      }
      
      public function get vertices() : Array
      {
         if(_verticesDirty)
         {
            _verticesDirty = false;
            _vertices.length = 0;
            indices.length = 0;
            commands.length = 0;
            startIndices.length = 0;
            faceVOs.length = 0;
            segmentVOs.length = 0;
            billboardVOs.length = 0;
            _processed = new Dictionary(true);
            for each(_element in elements)
            {
               if(_element.visible && _element.vertices.length > 0)
               {
                  _element_vertices = _element.vertices;
                  _element_commands = _element.commands;
                  startIndices[startIndices.length] = indices.length;
                  if(_element is Face)
                  {
                     _faceVO = (_element as Face).faceVO;
                     faceVOs[faceVOs.length] = _faceVO;
                  }
                  else if(_element is Segment)
                  {
                     _segmentVO = (_element as Segment).segmentVO;
                     segmentVOs[segmentVOs.length] = _segmentVO;
                  }
                  else if(_element is Billboard)
                  {
                     _billboardVO = (_element as Billboard).billboardVO;
                     billboardVOs[billboardVOs.length] = _billboardVO;
                  }
                  _index = 0;
                  while(_index < _element_vertices.length)
                  {
                     _vertex = _element_vertices[_index];
                     if(!_processed[_vertex])
                     {
                        _vertices[_vertices.length] = _vertex;
                        indices[indices.length] = (_processed[_vertex] = _vertices.length) - 1;
                     }
                     else
                     {
                        indices[indices.length] = _processed[_vertex] - 1;
                     }
                     commands[commands.length] = _element_commands[_index];
                     ++_index;
                  }
               }
            }
            startIndices[startIndices.length] = indices.length;
         }
         return _vertices;
      }
      
      public function get quarterFacesTotal() : int
      {
         return _quarterFacesTotal;
      }
      
      arcane function getFacesByVertex(param1:Vertex) : Array
      {
         if(_vertfacesDirty)
         {
            findVertFaces();
         }
         return _vertfaces[param1];
      }
      
      public function neighbour12(param1:Face) : Face
      {
         if(_neighboursDirty)
         {
            findNeighbours();
         }
         return _neighbour12[param1];
      }
   }
}


package away3d.core.base
{
   import away3d.animators.data.*;
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.math.*;
   import away3d.core.project.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import away3d.materials.*;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class Mesh extends Object3D
   {
      
      public var indexes:Array;
      
      private var _billboardMaterial:IBillboardMaterial;
      
      public var bothsides:Boolean;
      
      public var type:String = "mesh";
      
      private var _face:Face;
      
      public var outline:ISegmentMaterial;
      
      private var _segmentMaterial:ISegmentMaterial;
      
      public var url:String;
      
      private var _faceMaterial:ITriangleMaterial;
      
      private var _uvMaterial:IUVMaterial;
      
      private var _material:IMaterial;
      
      private var _vertex:Vertex;
      
      private var _back:ITriangleMaterial;
      
      arcane var _geometry:Geometry;
      
      public function Mesh(param1:Object = null)
      {
         super(param1);
         geometry = new Geometry();
         outline = ini.getSegmentMaterial("outline");
         material = ini.getMaterial("material");
         faceMaterial = ini.getMaterial("faceMaterial") as ITriangleMaterial || _faceMaterial;
         segmentMaterial = ini.getMaterial("segmentMaterial") as ISegmentMaterial || _segmentMaterial;
         billboardMaterial = ini.getMaterial("billboardMaterial") as IBillboardMaterial || _billboardMaterial;
         back = ini.getMaterial("back") as ITriangleMaterial;
         bothsides = ini.getBoolean("bothsides",false);
         projectorType = ProjectorType.MESH;
      }
      
      public function removeFace(param1:Face) : void
      {
         _geometry.removeFace(param1);
      }
      
      public function cloneAll(param1:Object3D = null) : Object3D
      {
         var _loc2_:Mesh = param1 as Mesh || new Mesh();
         super.clone(_loc2_);
         _loc2_.type = type;
         _loc2_.material = material;
         _loc2_.outline = outline;
         _loc2_.back = back;
         _loc2_.bothsides = bothsides;
         _loc2_.debugbb = debugbb;
         _loc2_.geometry = geometry.clone();
         return _loc2_;
      }
      
      public function removeOnSequenceDone(param1:Function) : void
      {
         geometry.removeOnSequenceDone(param1);
      }
      
      public function set billboardMaterial(param1:IBillboardMaterial) : void
      {
         if(_billboardMaterial == param1)
         {
            return;
         }
         removeMaterial(_billboardMaterial);
         addMaterial(_billboardMaterial = param1);
      }
      
      public function get billboards() : Array
      {
         return _geometry.billboards;
      }
      
      public function removeSegment(param1:Segment) : void
      {
         _geometry.removeSegment(param1);
      }
      
      public function get transitionValue() : Number
      {
         return geometry.transitionValue;
      }
      
      public function removeBillboard(param1:Billboard) : void
      {
         _geometry.removeBillboard(param1);
      }
      
      public function removeOnCycle(param1:Function) : void
      {
         geometry.removeOnCycle(param1);
      }
      
      public function get material() : IMaterial
      {
         return _material;
      }
      
      public function quarterFace(param1:Face) : void
      {
         _geometry.quarterFace(param1);
      }
      
      public function play(param1:AnimationSequence) : void
      {
         geometry.play(param1);
      }
      
      public function get isRunning() : Boolean
      {
         return geometry.isRunning;
      }
      
      public function set transitionValue(param1:Number) : void
      {
         geometry.transitionValue = param1;
      }
      
      public function get billboardVOs() : Array
      {
         return _geometry.billboardVOs;
      }
      
      public function get activePrefix() : String
      {
         return geometry.activePrefix;
      }
      
      public function set faceMaterial(param1:ITriangleMaterial) : void
      {
         if(_faceMaterial == param1)
         {
            return;
         }
         removeMaterial(_faceMaterial);
         addMaterial(_faceMaterial = param1);
      }
      
      public function set material(param1:IMaterial) : void
      {
         if(_material == param1 && _material != null)
         {
            return;
         }
         removeMaterial(_material);
         addMaterial(_material = param1);
         if(_material is ITriangleMaterial)
         {
            _faceMaterial = _material as ITriangleMaterial;
         }
         else
         {
            faceMaterial = new WireColorMaterial();
         }
         if(_material is ISegmentMaterial)
         {
            _segmentMaterial = _material as ISegmentMaterial;
         }
         else
         {
            segmentMaterial = new WireframeMaterial();
         }
         if(_material is IBillboardMaterial)
         {
            _billboardMaterial = _material as IBillboardMaterial;
         }
         else
         {
            billboardMaterial = new ColorMaterial();
         }
         _sessionDirty = true;
      }
      
      public function set loop(param1:Boolean) : void
      {
         geometry.loop = param1;
      }
      
      public function addSegment(param1:Segment) : void
      {
         _geometry.addSegment(param1);
      }
      
      public function set smooth(param1:Boolean) : void
      {
         geometry.smooth = param1;
      }
      
      public function updateMaterials(param1:Object3D, param2:View3D) : void
      {
         if(_material)
         {
            _material.updateMaterial(param1,param2);
         }
         if(back)
         {
            back.updateMaterial(param1,param2);
         }
         geometry.updateMaterials(param1,param2);
      }
      
      public function get faceVOs() : Array
      {
         return _geometry.faceVOs;
      }
      
      public function addOnCycle(param1:Function) : void
      {
         geometry.addOnCycle(param1);
      }
      
      public function addOnSequenceDone(param1:Function) : void
      {
         geometry.addOnSequenceDone(param1);
      }
      
      override public function clone(param1:Object3D = null) : Object3D
      {
         var _loc2_:Mesh = param1 as Mesh || new Mesh();
         super.clone(_loc2_);
         _loc2_.type = type;
         _loc2_.material = material;
         _loc2_.outline = outline;
         _loc2_.back = back;
         _loc2_.bothsides = bothsides;
         _loc2_.debugbb = debugbb;
         _loc2_.geometry = geometry;
         return _loc2_;
      }
      
      public function get frame() : int
      {
         return geometry.frame;
      }
      
      public function quarterFaces() : void
      {
         _geometry.quarterFaces();
      }
      
      public function get geometry() : Geometry
      {
         return _geometry;
      }
      
      override protected function updateDimensions() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number3D = null;
         var _loc6_:Vertex = null;
         _loc1_ = geometry.vertices.concat();
         _loc2_ = int(_loc1_.length);
         if(_loc2_)
         {
            if(_scaleX < 0)
            {
               _boundingScale = -_scaleX;
            }
            else
            {
               _boundingScale = _scaleX;
            }
            if(_scaleY < 0 && _boundingScale < -_scaleY)
            {
               _boundingScale = -_scaleY;
            }
            else if(_boundingScale < _scaleY)
            {
               _boundingScale = _scaleY;
            }
            if(_scaleZ < 0 && _boundingScale < -_scaleZ)
            {
               _boundingScale = -_scaleZ;
            }
            else if(_boundingScale < _scaleZ)
            {
               _boundingScale = _scaleZ;
            }
            _loc3_ = 0;
            _loc5_ = new Number3D();
            for each(_loc6_ in _loc1_)
            {
               _loc5_.sub(_loc6_.position,_pivotPoint);
               _loc4_ = _loc5_.modulo2;
               if(_loc3_ < _loc4_)
               {
                  _loc3_ = _loc4_;
               }
            }
            if(_loc3_)
            {
               _boundingRadius = Math.sqrt(_loc3_);
            }
            else
            {
               _boundingRadius = 0;
            }
            _loc1_.sortOn("x",Array.DESCENDING | Array.NUMERIC);
            _maxX = _loc1_[0].x;
            _minX = _loc1_[_loc2_ - 1].x;
            _loc1_.sortOn("y",Array.DESCENDING | Array.NUMERIC);
            _maxY = _loc1_[0].y;
            _minY = _loc1_[_loc2_ - 1].y;
            _loc1_.sortOn("z",Array.DESCENDING | Array.NUMERIC);
            _maxZ = _loc1_[0].z;
            _minZ = _loc1_[_loc2_ - 1].z;
         }
         super.updateDimensions();
      }
      
      public function get segmentMaterial() : ISegmentMaterial
      {
         return _segmentMaterial;
      }
      
      private function onMappingChange(param1:ElementEvent) : void
      {
         _sessionDirty = true;
         if(_face = param1.element as Face)
         {
            if(_face.material)
            {
               _uvMaterial = _face.material as IUVMaterial;
            }
            else
            {
               _uvMaterial = _faceMaterial as IUVMaterial;
            }
            if(_uvMaterial)
            {
               _uvMaterial.getFaceMaterialVO(_face.faceVO,this).invalidated = true;
            }
         }
      }
      
      public function invertFaces() : void
      {
         _geometry.invertFaces();
      }
      
      public function asXML() : XML
      {
         var refvertices:Dictionary = null;
         var verticeslist:Array = null;
         var refuvs:Dictionary = null;
         var uvslist:Array = null;
         var face:Face = null;
         var vn:int = 0;
         var v:Vertex = null;
         var uvn:int = 0;
         var uv:UV = null;
         var f:Face = null;
         var result:XML = <mesh></mesh>;
         refvertices = new Dictionary();
         verticeslist = [];
         var remembervertex:Function = function(param1:Vertex):void
         {
            if(refvertices[param1] == null)
            {
               refvertices[param1] = verticeslist.length;
               verticeslist.push(param1);
            }
         };
         refuvs = new Dictionary();
         uvslist = [];
         var rememberuv:Function = function(param1:UV):void
         {
            if(param1 == null)
            {
               return;
            }
            if(refuvs[param1] == null)
            {
               refuvs[param1] = uvslist.length;
               uvslist.push(param1);
            }
         };
         for each(face in _geometry.faces)
         {
            remembervertex(face._v0);
            remembervertex(face._v1);
            remembervertex(face._v2);
            rememberuv(face._uv0);
            rememberuv(face._uv1);
            rememberuv(face._uv2);
         }
         vn = 0;
         for each(v in verticeslist)
         {
            result.appendChild(<vertex id={vn} x={v._x} y={v._y} z={v._z}/>);
            vn++;
         }
         uvn = 0;
         for each(uv in uvslist)
         {
            result.appendChild(<uv id={uvn} u={uv._u} v={uv._v}/>);
            uvn++;
         }
         for each(f in _geometry.faces)
         {
            result.appendChild(<face v0={refvertices[f._v0]} v1={refvertices[f._v1]} v2={refvertices[f._v2]} uv0={refuvs[f._uv0]} uv1={refuvs[f._uv1]} uv2={refuvs[f._uv2]}/>);
         }
         return result;
      }
      
      public function get commands() : Array
      {
         return _geometry.commands;
      }
      
      public function get hasCycleEvent() : Boolean
      {
         return geometry.hasCycleEvent;
      }
      
      private function onMaterialUpdate(param1:MaterialEvent) : void
      {
         _sessionDirty = true;
      }
      
      public function get billboardMaterial() : IBillboardMaterial
      {
         return _billboardMaterial;
      }
      
      public function gotoAndStop(param1:int) : void
      {
         geometry.gotoAndStop(param1);
      }
      
      public function splitFace(param1:Face, param2:int = 0) : void
      {
         _geometry.splitFace(param1,param2);
      }
      
      public function addFace(param1:Face) : void
      {
         _geometry.addFace(param1);
      }
      
      public function get segments() : Array
      {
         return _geometry.segments;
      }
      
      public function get faceMaterial() : ITriangleMaterial
      {
         return _faceMaterial;
      }
      
      public function addBillboard(param1:Billboard) : void
      {
         _geometry.addBillboard(param1);
      }
      
      public function get indices() : Array
      {
         return _geometry.indices;
      }
      
      public function triFace(param1:Face) : void
      {
         _geometry.triFace(param1);
      }
      
      public function get loop() : Boolean
      {
         return geometry.loop;
      }
      
      public function get smooth() : Boolean
      {
         return geometry.smooth;
      }
      
      public function get faces() : Array
      {
         return _geometry.faces;
      }
      
      override public function applyPosition(param1:Number, param2:Number, param3:Number) : void
      {
         _geometry.applyPosition(param1,param2,param3);
         var _loc4_:Number3D = new Number3D(param1,param2,param3);
         _loc4_.rotate(_loc4_,_transform);
         _loc4_.add(_loc4_,position);
         moveTo(_loc4_.x,_loc4_.y,_loc4_.z);
      }
      
      public function setPlaySequences(param1:Array, param2:Boolean = false) : void
      {
         geometry.setPlaySequences(param1,param2);
      }
      
      public function get segmentVOs() : Array
      {
         return _geometry.segmentVOs;
      }
      
      public function gotoAndPlay(param1:int) : void
      {
         geometry.gotoAndPlay(param1);
      }
      
      public function triFaces() : void
      {
         _geometry.triFaces();
      }
      
      public function updateVertex(param1:Vertex, param2:Number, param3:Number, param4:Number, param5:Boolean = false) : void
      {
         _geometry.updateVertex(param1,param2,param3,param4,param5);
      }
      
      public function set back(param1:ITriangleMaterial) : void
      {
         if(_back == param1)
         {
            return;
         }
         removeMaterial(_back);
         addMaterial(_back = param1);
      }
      
      private function removeMaterial(param1:IMaterial) : void
      {
         if(!param1)
         {
            return;
         }
         param1.removeOnMaterialUpdate(onMaterialUpdate);
      }
      
      public function splitFaces(param1:int = 0) : void
      {
         _geometry.splitFaces(param1);
      }
      
      public function set fps(param1:int) : void
      {
         geometry.fps = param1;
      }
      
      public function set frame(param1:int) : void
      {
         geometry.frame = param1;
      }
      
      private function onDimensionsChange(param1:GeometryEvent) : void
      {
         _sessionDirty = true;
         notifyDimensionsChange();
      }
      
      public function get hasSequenceEvent() : Boolean
      {
         return geometry.hasSequenceEvent;
      }
      
      public function set geometry(param1:Geometry) : void
      {
         if(_geometry == param1)
         {
            return;
         }
         if(_geometry != null)
         {
            _geometry.removeOnMaterialUpdate(onMaterialUpdate);
            _geometry.removeOnMappingChange(onMappingChange);
            _geometry.removeOnDimensionsChange(onDimensionsChange);
         }
         _geometry = param1;
         if(_geometry != null)
         {
            _geometry.addOnMaterialUpdate(onMaterialUpdate);
            _geometry.addOnMappingChange(onMappingChange);
            _geometry.addOnDimensionsChange(onDimensionsChange);
         }
      }
      
      public function get startIndices() : Array
      {
         return _geometry.startIndices;
      }
      
      public function get back() : ITriangleMaterial
      {
         return _back;
      }
      
      private function addMaterial(param1:IMaterial) : void
      {
         if(!param1)
         {
            return;
         }
         param1.addOnMaterialUpdate(onMaterialUpdate);
      }
      
      public function get fps() : int
      {
         return geometry.fps;
      }
      
      override public function applyRotations() : void
      {
         _geometry.applyRotations(rotationX,rotationY,rotationZ);
         rotationX = 0;
         rotationY = 0;
         rotationZ = 0;
      }
      
      public function asAS3Class(param1:String = null, param2:String = "", param3:Boolean = false, param4:Boolean = false) : String
      {
         var remembervertex:Function;
         var rememberuv:Function;
         var refvertices:Dictionary = null;
         var verticeslist:Array = null;
         var refuvs:Dictionary = null;
         var uvslist:Array = null;
         var face:Face = null;
         var uv:UV = null;
         var v:Vertex = null;
         var myPattern:RegExp = null;
         var myPattern2:RegExp = null;
         var f:Face = null;
         var tmp:String = null;
         var ind:Array = null;
         var auv:Array = null;
         var i:int = 0;
         var afn:Array = null;
         var avp:Array = null;
         var tmpnames:Array = null;
         var y:int = 0;
         var framename:String = null;
         var fr:Frame = null;
         var classname:String = param1;
         var packagename:String = param2;
         var round:Boolean = param3;
         var animated:Boolean = param4;
         classname = classname || name || "Away3DObject";
         var importextra:String = animated ? "\timport flash.utils.Dictionary;\n" : "";
         var source:String = "package " + packagename + "\n{\n\timport away3d.core.base.*;\n\timport away3d.core.utils.*;\n" + importextra + "\n\tpublic class " + classname + " extends Mesh\n\t{\n";
         source += "\t\tprivate var varr:Array = [];\n\t\tprivate var uvarr:Array = [];\n\t\tprivate var scaling:Number;\n";
         if(animated)
         {
            source += "\t\tprivate var fnarr:Array = [];\n\n";
            source += "\n\t\tprivate function v():void\n\t\t{\n";
            source += "\t\t\tfor(var i:int = 0;i<vcount;++i){\n\t\t\t\tvarr.push(new Vertex(0,0,0));\n\t\t\t}\n\t\t}\n\n";
         }
         else
         {
            source += "\n\t\tprivate function v(x:Number,y:Number,z:Number):void\n\t\t{\n";
            source += "\t\t\tvarr.push(new Vertex(x*scaling, y*scaling, z*scaling));\n\t\t}\n\n";
         }
         source += "\t\tprivate function uv(u:Number,v:Number):void\n\t\t{\n";
         source += "\t\t\tuvarr.push(new UV(u,v));\n\t\t}\n\n";
         source += "\t\tprivate function f(vn0:int, vn1:int, vn2:int, uvn0:int, uvn1:int, uvn2:int):void\n\t\t{\n";
         source += "\t\t\taddFace(new Face(varr[vn0],varr[vn1],varr[vn2], null, uvarr[uvn0],uvarr[uvn1],uvarr[uvn2]));\n\t\t}\n\n";
         source += "\t\tpublic function " + classname + "(init:Object = null)\n\t\t{\n\t\t\tsuper(init);\n\t\t\tinit = Init.parse(init);\n\t\t\tscaling = init.getNumber(\"scaling\", 1);\n\t\t\tbuild();\n\t\t\ttype = \"" + classname + "\";\n\t\t}\n\n";
         source += "\t\tprivate function build():void\n\t\t{\n";
         refvertices = new Dictionary();
         verticeslist = [];
         remembervertex = function(param1:Vertex):void
         {
            if(refvertices[param1] == null)
            {
               refvertices[param1] = verticeslist.length;
               verticeslist.push(param1);
            }
         };
         refuvs = new Dictionary();
         uvslist = [];
         rememberuv = function(param1:UV):void
         {
            if(param1 == null)
            {
               return;
            }
            if(refuvs[param1] == null)
            {
               refuvs[param1] = uvslist.length;
               uvslist.push(param1);
            }
         };
         for each(face in _geometry.faces)
         {
            remembervertex(face._v0);
            remembervertex(face._v1);
            remembervertex(face._v2);
            rememberuv(face._uv0);
            rememberuv(face._uv1);
            rememberuv(face._uv2);
         }
         if(animated)
         {
            myPattern = /vcount/g;
            source = source.replace(myPattern,verticeslist.length);
            source += "\n\t\t\tv();\n\n";
         }
         else
         {
            for each(v in verticeslist)
            {
               source += round ? "\t\t\tv(" + v._x.toFixed(4) + "," + v._y.toFixed(4) + "," + v._z.toFixed(4) + ");\n" : "\t\t\tv(" + v._x + "," + v._y + "," + v._z + ");\n";
            }
         }
         for each(uv in uvslist)
         {
            source += round ? "\t\t\tuv(" + uv._u.toFixed(4) + "," + uv._v.toFixed(4) + ");\n" : "\t\t\tuv(" + uv._u + "," + uv._v + ");\n";
         }
         if(round)
         {
            myPattern2 = /.0000/g;
         }
         if(animated)
         {
            auv = [];
            for each(f in _geometry.faces)
            {
               auv.push(round ? refuvs[f._uv0].toFixed(4) + "," + refuvs[f._uv1].toFixed(4) + "," + refuvs[f._uv2].toFixed(4) : refuvs[f._uv0] + "," + refuvs[f._uv1] + "," + refuvs[f._uv2]);
            }
            i = 0;
            while(i < indexes.length)
            {
               ind = indexes[i];
               source += "\t\t\tf(" + ind[0] + "," + ind[1] + "," + ind[2] + "," + auv[i] + ");\n";
               i++;
            }
         }
         else
         {
            for each(f in _geometry.faces)
            {
               source += "\t\t\tf(" + refvertices[f._v0] + "," + refvertices[f._v1] + "," + refvertices[f._v2] + "," + refuvs[f._uv0] + "," + refuvs[f._uv1] + "," + refuvs[f._uv2] + ");\n";
            }
         }
         if(round)
         {
            source = source.replace(myPattern2,"");
         }
         if(animated)
         {
            afn = [];
            tmpnames = [];
            i = 0;
            y = 0;
            source += "\n\t\t\tgeometry.frames = new Dictionary();\n";
            source += "\t\t\tgeometry.framenames = new Dictionary();\n";
            source += "\t\t\tvar oFrames:Object = {};\n";
            myPattern = / /g;
            for(framename in geometry.framenames)
            {
               tmpnames.push(framename);
            }
            tmpnames.sort();
            i = 0;
            while(i < tmpnames.length)
            {
               avp = [];
               fr = geometry.frames[geometry.framenames[tmpnames[i]]];
               if(tmpnames[i].indexOf(" ") != -1)
               {
                  tmpnames[i] = tmpnames[i].replace(myPattern,"");
               }
               afn.push("\"" + tmpnames[i] + "\"");
               source += "\n\t\t\toFrames." + tmpnames[i] + "=[";
               y = 0;
               while(y < verticeslist.length)
               {
                  if(round)
                  {
                     avp.push(fr.vertexpositions[y].x.toFixed(4));
                     avp.push(fr.vertexpositions[y].y.toFixed(4));
                     avp.push(fr.vertexpositions[y].z.toFixed(4));
                  }
                  else
                  {
                     avp.push(fr.vertexpositions[y].x);
                     avp.push(fr.vertexpositions[y].y);
                     avp.push(fr.vertexpositions[y].z);
                  }
                  y++;
               }
               if(round)
               {
                  tmp = avp.toString();
                  tmp = tmp.replace(myPattern2,"");
                  source += tmp + "];\n";
               }
               else
               {
                  source += avp.toString() + "];\n";
               }
               i++;
            }
            source += "\n\t\t\tfnarr = [" + afn.toString() + "];\n";
            source += "\n\t\t\tvar y:int;\n";
            source += "\t\t\tvar z:int;\n";
            source += "\t\t\tvar frame:Frame;\n";
            source += "\t\t\tfor(var i:int = 0;i<fnarr.length; ++i){\n";
            source += "\t\t\t\ttrace(\"[ \"+fnarr[i]+\" ]\");\n";
            source += "\t\t\t\tframe = new Frame();\n";
            source += "\t\t\t\tgeometry.framenames[fnarr[i]] = i;\n";
            source += "\t\t\t\tgeometry.frames[i] = frame;\n";
            source += "\t\t\t\tz=0;\n";
            source += "\t\t\t\tfor (y = 0; y < oFrames[fnarr[i]].length; y+=3){\n";
            source += "\t\t\t\t\tvar vp:VertexPosition = new VertexPosition(varr[z]);\n";
            source += "\t\t\t\t\tz++;\n";
            source += "\t\t\t\t\tvp.x = oFrames[fnarr[i]][y]*scaling;\n";
            source += "\t\t\t\t\tvp.y = oFrames[fnarr[i]][y+1]*scaling;\n";
            source += "\t\t\t\t\tvp.z = oFrames[fnarr[i]][y+2]*scaling;\n";
            source += "\t\t\t\t\tframe.vertexpositions.push(vp);\n";
            source += "\t\t\t\t}\n";
            source += "\t\t\t\tif (i == 0)\n";
            source += "\t\t\t\t\tframe.adjust();\n";
            source += "\t\t\t}\n";
         }
         source += "\n\t\t}\n\t}\n}";
         return source;
      }
      
      public function set segmentMaterial(param1:ISegmentMaterial) : void
      {
         if(_segmentMaterial == param1)
         {
            return;
         }
         removeMaterial(_segmentMaterial);
         addMaterial(_segmentMaterial = param1);
      }
      
      public function get elements() : Array
      {
         return _geometry.elements;
      }
      
      public function get vertices() : Array
      {
         return _geometry.vertices;
      }
      
      public function playFrames(param1:Array, param2:uint, param3:Boolean = true, param4:Boolean = false) : void
      {
         geometry.playFrames(param1,param2,param3,param4);
      }
   }
}


package away3d.loaders
{
   import away3d.animators.*;
   import away3d.animators.skin.*;
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import away3d.loaders.data.*;
   import away3d.loaders.utils.*;
   import away3d.materials.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class Collada extends AbstractParser
   {
      
      private var symbolLibrary:Dictionary;
      
      public var scaling:Number;
      
      private var _geometryArray:Array;
      
      private var _faceMaterial:ITriangleMaterial;
      
      private var _geometryArrayLength:int;
      
      private var _defaultAnimationClip:AnimationData;
      
      private var _moveVector:Number3D = new Number3D();
      
      private var materialLibrary:MaterialLibrary;
      
      private var animationLibrary:AnimationLibrary;
      
      public var centerMeshes:Boolean;
      
      private var _haveClips:Boolean = false;
      
      public var material:ITriangleMaterial;
      
      private var scalingMatrix:Matrix3D = new Matrix3D();
      
      private var _materials:Object;
      
      private var _containers:Dictionary = new Dictionary(true);
      
      private var _colladaXml:XML;
      
      public var shading:Boolean;
      
      private var _channelArrayLength:int;
      
      private var _face:Face;
      
      private var channelLibrary:ChannelLibrary;
      
      public var containerData:ContainerData;
      
      private var translationMatrix:Matrix3D = new Matrix3D();
      
      private var rotationMatrix:Matrix3D = new Matrix3D();
      
      private var VALUE_U:String = "S";
      
      private var VALUE_V:String = "T";
      
      private var geometryLibrary:GeometryLibrary;
      
      private var VALUE_X:String;
      
      private var VALUE_Y:String;
      
      private var VALUE_Z:String;
      
      private var yUp:Boolean;
      
      private var _channelArray:Array;
      
      private var toRADIANS:Number = 0.017453292519943295;
      
      public function Collada(param1:Object = null)
      {
         super(param1);
         scaling = ini.getNumber("scaling",1);
         shading = ini.getBoolean("shading",false);
         material = ini.getMaterial("material") as ITriangleMaterial;
         centerMeshes = ini.getBoolean("centerMeshes",false);
         container = new ObjectContainer3D(ini);
         container.name = "collada";
         materialLibrary = new MaterialLibrary();
         container.materialLibrary = materialLibrary;
         animationLibrary = new AnimationLibrary();
         container.animationLibrary = animationLibrary;
         geometryLibrary = new GeometryLibrary();
         container.geometryLibrary = geometryLibrary;
         channelLibrary = new ChannelLibrary();
         symbolLibrary = new Dictionary(true);
         try
         {
            applyMaterials(ini.getObject("materials") || {});
         }
         catch(e:Error)
         {
            Debug.warning("Ignoring Collada material overrides: " + e);
         }
         arcane::binary = false;
      }
      
      public static function parse(param1:*, param2:Object = null) : ObjectContainer3D
      {
         return Loader3D.parseGeometry(param1,Collada,param2).handle as ObjectContainer3D;
      }
      
      public static function load(param1:String, param2:Object = null) : Loader3D
      {
         return Loader3D.loadGeometry(param1,Collada,param2);
      }
      
      private function parseMaterial(param1:String, param2:String) : void
      {
         default xml namespace = _colladaXml.namespace();
         var _loc3_:MaterialData = materialLibrary.addMaterial(param2);
         symbolLibrary[param1] = _loc3_;
         if(param1 == "FrontColorNoCulling")
         {
            _loc3_.materialType = MaterialData.SHADING_MATERIAL;
         }
         else
         {
            _loc3_.textureFileName = getTextureFileName(param2);
            if(_loc3_.textureFileName)
            {
               _loc3_.materialType = MaterialData.TEXTURE_MATERIAL;
            }
            else
            {
               if(shading)
               {
                  _loc3_.materialType = MaterialData.SHADING_MATERIAL;
               }
               else
               {
                  _loc3_.materialType = MaterialData.COLOR_MATERIAL;
               }
               parseColorMaterial(param2,_loc3_);
            }
         }
      }
      
      private function getId(param1:String) : String
      {
         return param1.split("#")[1];
      }
      
      private function parseScene() : void
      {
         var scene:XML = null;
         var node:XML = null;
         default xml namespace = _colladaXml.namespace();
         scene = _colladaXml["library_visual_scenes"].visual_scene.(@id == getId(_colladaXml["scene"].instance_visual_scene.@url))[0];
         if(scene == null)
         {
            Debug.trace(" ! ------------- No scene to parse -------------");
            return;
         }
         Debug.trace(" ! ------------- Begin Parse Scene -------------");
         containerData = new ContainerData();
         for each(node in scene["node"])
         {
            parseNode(node,containerData);
         }
         Debug.trace(" ! ------------- End Parse Scene -------------");
         _geometryArray = geometryLibrary.getGeometryArray();
         _geometryArrayLength = _geometryArray.length;
         _totalChunks += _geometryArrayLength;
      }
      
      private function buildContainers(param1:ContainerData, param2:ObjectContainer3D) : void
      {
         var _loc3_:ObjectData = null;
         var _loc4_:Mesh = null;
         var _loc5_:BoneData = null;
         var _loc6_:Bone = null;
         var _loc7_:ContainerData = null;
         var _loc8_:ObjectContainer3D = null;
         for each(_loc3_ in param1.children)
         {
            if(_loc3_ is MeshData)
            {
               _loc4_ = buildMesh(_loc3_ as MeshData,param2);
               _containers[_loc3_.name] = _loc4_;
            }
            else if(_loc3_ is BoneData)
            {
               _loc5_ = _loc3_ as BoneData;
               _loc6_ = new Bone({"name":_loc5_.name});
               _loc5_.container = _loc6_ as ObjectContainer3D;
               _containers[_loc6_.name] = _loc6_;
               _loc6_.boneId = _loc5_.id;
               _loc6_.transform = _loc5_.transform;
               _loc6_.joint.transform = _loc5_.jointTransform;
               buildContainers(_loc5_,_loc6_.joint);
               param2.addChild(_loc6_);
            }
            else if(_loc3_ is ContainerData)
            {
               _loc7_ = _loc3_ as ContainerData;
               _loc8_ = _loc7_.container = new ObjectContainer3D({"name":_loc7_.name});
               _containers[_loc8_.name] = _loc8_;
               _loc8_.transform = _loc3_.transform;
               buildContainers(_loc7_,_loc8_);
               if(centerMeshes && Boolean(_loc8_.children.length))
               {
                  _loc8_.movePivot(_moveVector.x = (_loc8_.maxX + _loc8_.minX) / 2,_moveVector.y = (_loc8_.maxY + _loc8_.minY) / 2,_moveVector.z = (_loc8_.maxZ + _loc8_.minZ) / 2);
                  _moveVector.transform(_moveVector,_loc3_.transform);
                  _loc8_.moveTo(_moveVector.x,_moveVector.y,_moveVector.z);
               }
               param2.addChild(_loc8_);
            }
         }
      }
      
      private function parseAnimationClips() : void
      {
         var _loc3_:XML = null;
         var _loc4_:uint = 0;
         var _loc5_:ChannelData = null;
         var _loc6_:XML = null;
         default xml namespace = _colladaXml.namespace();
         var _loc1_:XML = _colladaXml["library_animations"][0];
         if(!_loc1_)
         {
            Debug.trace(" ! ------------- No animations to parse -------------");
            return;
         }
         var _loc2_:XML = _colladaXml["library_animation_clips"][0];
         Debug.trace(" ! Animation Clips Exist : " + _haveClips);
         Debug.trace(" ! ------------- Begin Parse Animation -------------");
         for each(_loc3_ in _loc1_["animation"])
         {
            if(String(_loc3_.@id).length > 0)
            {
               channelLibrary.addChannel(_loc3_.@id,_loc3_);
            }
         }
         _loc4_ = 0;
         for each(_loc3_ in _loc1_["animation"]["animation"])
         {
            if(String(_loc3_.@id).length > 0)
            {
               channelLibrary.addChannel(_loc3_.@id,_loc3_);
            }
            else
            {
               Debug.trace(" ! C4D id : C4D_" + _loc4_);
               channelLibrary.addChannel("C4D_" + String(_loc4_),_loc3_);
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            for each(_loc6_ in _loc2_["animation_clip"])
            {
               parseAnimationClip(_loc6_);
            }
         }
         _defaultAnimationClip = animationLibrary.addAnimation("default");
         for each(_loc5_ in channelLibrary)
         {
            _defaultAnimationClip.channels[_loc5_.name] = _loc5_;
         }
         Debug.trace(" ! ------------- End Parse Animation -------------");
         _channelArray = channelLibrary.getChannelArray();
         _channelArrayLength = _channelArray.length;
         _totalChunks += _channelArrayLength;
      }
      
      private function getArray(param1:String) : Array
      {
         param1 = param1.split("\r\n").join(" ");
         var _loc2_:Array = param1.split(" ");
         var _loc3_:Array = [];
         var _loc4_:Number = _loc2_.length;
         var _loc5_:Number = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc2_[_loc5_] != "")
            {
               _loc3_.push(Number(_loc2_[_loc5_]));
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function get materials() : Object
      {
         return _materials;
      }
      
      private function translateMatrix(param1:Array) : Matrix3D
      {
         if(yUp)
         {
            translationMatrix.translationMatrix(-param1[0] * scaling,param1[1] * scaling,param1[2] * scaling);
         }
         else
         {
            translationMatrix.translationMatrix(param1[0] * scaling,param1[2] * scaling,param1[1] * scaling);
         }
         return translationMatrix;
      }
      
      private function parseColorMaterial(param1:String, param2:MaterialData) : void
      {
         var material:XML = null;
         var effectId:String = null;
         var effect:XML = null;
         var colorName:String = param1;
         var materialData:MaterialData = param2;
         default xml namespace = _colladaXml.namespace();
         material = _colladaXml["library_materials"].material.(@id == colorName)[0];
         if(material)
         {
            effectId = getId(material["instance_effect"].@url);
            effect = _colladaXml["library_effects"].effect.(@id == effectId)[0];
            materialData.ambientColor = getColorValue(effect..ambient[0]);
            materialData.diffuseColor = getColorValue(effect..diffuse[0]);
            materialData.specularColor = getColorValue(effect..specular[0]);
            materialData.shininess = Number(effect..shininess.float[0]);
         }
      }
      
      private function scaleMatrix(param1:Array) : Matrix3D
      {
         if(yUp)
         {
            scalingMatrix.scaleMatrix(param1[0],param1[1],param1[2]);
         }
         else
         {
            scalingMatrix.scaleMatrix(param1[0],param1[2],param1[1]);
         }
         return scalingMatrix;
      }
      
      private function getTextureFileName(param1:String) : String
      {
         var filename:String = null;
         var material:XML = null;
         var effectId:String = null;
         var effect:XML = null;
         var textureId:String = null;
         var sampler:XML = null;
         var imageId:String = null;
         var image:XML = null;
         var sourceId:String = null;
         var source:XML = null;
         var materialName:String = param1;
         default xml namespace = _colladaXml.namespace();
         filename = null;
         material = _colladaXml["library_materials"].material.(@id == materialName)[0];
         if(material)
         {
            effectId = getId(material["instance_effect"].@url);
            effect = _colladaXml["library_effects"].effect.(@id == effectId)[0];
            if(effect..texture.length() == 0)
            {
               return null;
            }
            textureId = effect..texture[0].@texture;
            sampler = effect..newparam.(@sid == textureId)[0];
            imageId = textureId;
            if(sampler)
            {
               sourceId = sampler..source[0];
               source = effect..newparam.(@sid == sourceId)[0];
               imageId = source..init_from[0];
            }
            image = _colladaXml["library_images"].image.(@id == imageId)[0];
            filename = image["init_from"];
            if(filename.substr(0,2) == "./")
            {
               filename = filename.substr(2);
            }
         }
         return filename;
      }
      
      private function parseGeometry(param1:GeometryData) : void
      {
         var jointId:String;
         var verticesDictionary:Dictionary = null;
         var trianglesXMLList:XMLList = null;
         var isC4D:Boolean = false;
         var triangles:XML = null;
         var skin:XML = null;
         var tmp:String = null;
         var nameArray:Array = null;
         var bind_shape:Matrix3D = null;
         var bindMatrixId:String = null;
         var float_array:Array = null;
         var v:Array = null;
         var matrix:Matrix3D = null;
         var name:String = null;
         var skinController:SkinController = null;
         var i:int = 0;
         var weightsId:String = null;
         var weights:Array = null;
         var vcount:Array = null;
         var skinVertex:SkinVertex = null;
         var c:int = 0;
         var count:int = 0;
         var field:Array = null;
         var input:XML = null;
         var data:Array = null;
         var len:Number = NaN;
         var symbol:String = null;
         var _meshMaterialData:MeshMaterialData = null;
         var j:Number = NaN;
         var semantic:String = null;
         var _faceData:FaceData = null;
         var vn:Number = NaN;
         var fld:String = null;
         var _vertex:Vertex = null;
         var geometryData:GeometryData = param1;
         default xml namespace = _colladaXml.namespace();
         Debug.trace(" + Parse Geometry : " + geometryData.name);
         verticesDictionary = new Dictionary(true);
         trianglesXMLList = geometryData.geoXML["mesh"].triangles;
         isC4D = trianglesXMLList.length() == 0 && geometryData.geoXML["mesh"].polylist.length() > 0;
         if(isC4D)
         {
            trianglesXMLList = geometryData.geoXML["mesh"].polylist;
         }
         for each(triangles in trianglesXMLList)
         {
            field = [];
            for each(input in triangles["input"])
            {
               semantic = input.@semantic;
               switch(semantic)
               {
                  case "VERTEX":
                     deserialize(input,geometryData.geoXML,Vertex,geometryData.vertices);
                     break;
                  case "TEXCOORD":
                     deserialize(input,geometryData.geoXML,UV,geometryData.uvs);
               }
               field.push(input.@semantic);
            }
            data = triangles["p"].split(" ");
            len = Number(triangles.@count);
            symbol = triangles.@material;
            Debug.trace(" + Parse MeshMaterialData");
            _meshMaterialData = new MeshMaterialData();
            _meshMaterialData.symbol = symbol;
            geometryData.materials.push(_meshMaterialData);
            j = 0;
            while(j < len)
            {
               _faceData = new FaceData();
               vn = 0;
               while(vn < 3)
               {
                  for each(fld in field)
                  {
                     switch(fld)
                     {
                        case "VERTEX":
                           _faceData["v" + vn] = data.shift();
                           break;
                        case "TEXCOORD":
                           _faceData["uv" + vn] = data.shift();
                           break;
                        default:
                           data.shift();
                     }
                  }
                  vn++;
               }
               verticesDictionary[_faceData.v0] = geometryData.vertices[_faceData.v0];
               verticesDictionary[_faceData.v1] = geometryData.vertices[_faceData.v1];
               verticesDictionary[_faceData.v2] = geometryData.vertices[_faceData.v2];
               _meshMaterialData.faceList.push(geometryData.faces.length);
               geometryData.faces.push(_faceData);
               j++;
            }
         }
         if(centerMeshes)
         {
            geometryData.maxX = -Infinity;
            geometryData.minX = Infinity;
            geometryData.maxY = -Infinity;
            geometryData.minY = Infinity;
            geometryData.maxZ = -Infinity;
            geometryData.minZ = Infinity;
            for each(_vertex in verticesDictionary)
            {
               if(geometryData.maxX < _vertex._x)
               {
                  geometryData.maxX = _vertex._x;
               }
               if(geometryData.minX > _vertex._x)
               {
                  geometryData.minX = _vertex._x;
               }
               if(geometryData.maxY < _vertex._y)
               {
                  geometryData.maxY = _vertex._y;
               }
               if(geometryData.minY > _vertex._y)
               {
                  geometryData.minY = _vertex._y;
               }
               if(geometryData.maxZ < _vertex._z)
               {
                  geometryData.maxZ = _vertex._z;
               }
               if(geometryData.minZ > _vertex._z)
               {
                  geometryData.minZ = _vertex._z;
               }
            }
         }
         if(String(geometryData.geoXML["extra"].technique.double_sided) != "")
         {
            geometryData.bothsides = geometryData.geoXML["extra"].technique.double_sided[0].toString() == "1";
         }
         else
         {
            geometryData.bothsides = false;
         }
         if(!geometryData.ctrlXML)
         {
            return;
         }
         skin = geometryData.ctrlXML["skin"][0];
         jointId = getId(skin["joints"].input.(@semantic == "JOINT")[0].@source);
         tmp = skin["source"].(@id == jointId)["Name_array"].toString();
         if(!tmp)
         {
            tmp = skin["source"].(@id == jointId)["IDREF_array"].toString();
         }
         tmp = tmp.replace(/\n/g," ");
         nameArray = tmp.split(" ");
         bind_shape = new Matrix3D();
         bind_shape.array2matrix(getArray(skin["bind_shape_matrix"][0].toString()),yUp,scaling);
         bindMatrixId = getId(skin["joints"].input.(@semantic == "INV_BIND_MATRIX").@source);
         float_array = getArray(skin["source"].(@id == bindMatrixId)[0].float_array.toString());
         i = 0;
         while(i < float_array.length)
         {
            name = nameArray[i / 16];
            matrix = new Matrix3D();
            matrix.array2matrix(float_array.slice(i,i + 16),yUp,scaling);
            matrix.multiply(matrix,bind_shape);
            geometryData.skinControllers.push(skinController = new SkinController());
            skinController.name = name;
            skinController.bindMatrix = matrix;
            i += 16;
         }
         Debug.trace(" + SkinWeight");
         tmp = skin["vertex_weights"][0].@count;
         weightsId = getId(skin["vertex_weights"].input.(@semantic == "WEIGHT")[0].@source);
         tmp = skin["source"].(@id == weightsId)["float_array"].toString();
         weights = tmp.split(" ");
         tmp = skin["vertex_weights"].vcount.toString();
         vcount = tmp.split(" ");
         tmp = skin["vertex_weights"].v.toString();
         v = tmp.split(" ");
         count = 0;
         i = 0;
         while(i < geometryData.vertices.length)
         {
            c = int(vcount[i]);
            skinVertex = new SkinVertex(geometryData.vertices[i]);
            geometryData.skinVertices.push(skinVertex);
            j = 0;
            while(j < c)
            {
               skinVertex.controllers.push(geometryData.skinControllers[int(v[count])]);
               count++;
               skinVertex.weights.push(Number(weights[int(v[count])]));
               count++;
               j++;
            }
            i++;
         }
      }
      
      override arcane function parseNext() : void
      {
         default xml namespace = _colladaXml.namespace();
         if(_parsedChunks < _geometryArrayLength)
         {
            parseGeometry(_geometryArray[_parsedChunks]);
         }
         else
         {
            parseChannel(_channelArray[-_geometryArrayLength + _parsedChunks]);
         }
         ++_parsedChunks;
         if(_parsedChunks == _totalChunks)
         {
            buildMaterials();
            buildContainers(containerData,container as ObjectContainer3D);
            buildAnimations();
            notifySuccess();
         }
         else
         {
            notifyProgress();
         }
      }
      
      private function parseAnimationClip(param1:XML) : void
      {
         var _loc3_:XML = null;
         default xml namespace = _colladaXml.namespace();
         var _loc2_:AnimationData = animationLibrary.addAnimation(param1.@id);
         for each(_loc3_ in param1["instance_animation"])
         {
            _loc2_.channels[getId(_loc3_.@url)] = channelLibrary[getId(_loc3_.@url)];
         }
      }
      
      override arcane function prepareData(param1:*) : void
      {
         _colladaXml = Cast.xml(param1);
         default xml namespace = _colladaXml.namespace();
         Debug.trace(" ! ------------- Begin Parse Collada -------------");
         yUp = _colladaXml["asset"].up_axis == "Y_UP" || String(_colladaXml["asset"].up_axis) == "";
         if(yUp)
         {
            VALUE_X = "X";
            VALUE_Y = "Y";
            VALUE_Z = "Z";
         }
         else
         {
            VALUE_X = "X";
            VALUE_Y = "Z";
            VALUE_Z = "Y";
         }
         parseScene();
         parseAnimationClips();
      }
      
      private function getColorValue(param1:XML) : uint
      {
         default xml namespace = _colladaXml.namespace();
         if(!param1 || param1.length() == 0)
         {
            return 16777215;
         }
         if(!param1["color"] || param1["color"].length() == 0)
         {
            return 16777215;
         }
         var _loc2_:Array = param1["color"].split(" ");
         if(_loc2_.length <= 0)
         {
            return 16777215;
         }
         return int(_loc2_[0] * 255 << 16) | int(_loc2_[1] * 255 << 8) | int(_loc2_[2] * 255);
      }
      
      private function parseNode(param1:XML, param2:ContainerData) : void
      {
         var boneData:BoneData;
         var _transform:Matrix3D = null;
         var _objectData:ObjectData = null;
         var nodeName:String = null;
         var geo:XML = null;
         var ctrlr:XML = null;
         var sid:String = null;
         var instance_material:XML = null;
         var arrayChild:Array = null;
         var childNode:XML = null;
         var m:Matrix3D = null;
         var node:XML = param1;
         var parent:ContainerData = param2;
         default xml namespace = _colladaXml.namespace();
         if(String(node["instance_light"].@url) != "" || String(node["instance_camera"].@url) != "")
         {
            return;
         }
         if(String(node["instance_controller"]) == "" && String(node["instance_geometry"]) == "")
         {
            if(String(node.@type) == "JOINT")
            {
               _objectData = new BoneData();
            }
            else
            {
               if(String(node["instance_node"].@url) == "" && (String(node["node"]) == "" || parent is BoneData))
               {
                  return;
               }
               _objectData = new ContainerData();
            }
         }
         else
         {
            _objectData = new MeshData();
         }
         parent.children.push(_objectData);
         if(String(node.@type) == "JOINT")
         {
            _objectData.id = node.@sid;
         }
         else
         {
            _objectData.id = node.@id;
         }
         _objectData.name = node.@id;
         _transform = _objectData.transform;
         Debug.trace(" + Parse Node : " + _objectData.id + " : " + _objectData.name);
         boneData = _objectData as BoneData;
         for each(childNode in node.children())
         {
            arrayChild = getArray(childNode);
            nodeName = String(childNode.name()["localName"]);
            switch(nodeName)
            {
               case "translate":
                  _transform.multiply(_transform,translateMatrix(arrayChild));
                  break;
               case "rotate":
                  sid = childNode.@sid;
                  if(_objectData is BoneData && (sid == "rotateX" || sid == "rotateY" || sid == "rotateZ" || sid == "rotX" || sid == "rotY" || sid == "rotZ"))
                  {
                     boneData.jointTransform.multiply(boneData.jointTransform,rotateMatrix(arrayChild));
                  }
                  else
                  {
                     _transform.multiply(_transform,rotateMatrix(arrayChild));
                  }
                  break;
               case "scale":
                  if(_objectData is BoneData)
                  {
                     boneData.jointTransform.multiply(boneData.jointTransform,scaleMatrix(arrayChild));
                  }
                  else
                  {
                     _transform.multiply(_transform,scaleMatrix(arrayChild));
                  }
                  break;
               case "matrix":
                  m = new Matrix3D();
                  m.array2matrix(arrayChild,yUp,scaling);
                  _transform.multiply(_transform,m);
                  break;
               case "node":
                  if(_objectData is MeshData)
                  {
                     parseNode(childNode,parent as ContainerData);
                  }
                  else
                  {
                     parseNode(childNode,_objectData as ContainerData);
                  }
                  break;
               case "instance_node":
                  parseNode(_colladaXml["library_nodes"].node.(@id == getId(childNode.@url))[0],_objectData as ContainerData);
                  break;
               case "instance_geometry":
                  if(String(childNode).indexOf("lines") == -1)
                  {
                     for each(instance_material in childNode..instance_material)
                     {
                        parseMaterial(instance_material.@symbol,getId(instance_material.@target));
                     }
                     geo = _colladaXml["library_geometries"].geometry.(@id == getId(childNode.@url))[0];
                     (_objectData as MeshData).geometry = geometryLibrary.addGeometry(geo.@id,geo);
                  }
                  break;
               case "instance_controller":
                  for each(instance_material in childNode..instance_material)
                  {
                     parseMaterial(instance_material.@symbol,getId(instance_material.@target));
                  }
                  ctrlr = _colladaXml["library_controllers"].controller.(@id == getId(childNode.@url))[0];
                  geo = _colladaXml["library_geometries"].geometry.(@id == getId(ctrlr["skin"][0].@source))[0];
                  (_objectData as MeshData).geometry = geometryLibrary.addGeometry(geo.@id,geo,ctrlr);
                  (_objectData as MeshData).skeleton = getId(childNode["skeleton"]);
            }
         }
      }
      
      private function buildMaterials() : void
      {
         var _loc1_:MaterialData = null;
         for each(_loc1_ in materialLibrary)
         {
            Debug.trace(" + Build Material : " + _loc1_.name);
            if(material)
            {
               _loc1_.material = material;
            }
            if(_loc1_.material)
            {
               continue;
            }
            Debug.trace(" + Material Type : " + _loc1_.materialType);
            switch(_loc1_.materialType)
            {
               case MaterialData.TEXTURE_MATERIAL:
                  materialLibrary.loadRequired = true;
                  break;
               case MaterialData.SHADING_MATERIAL:
                  _loc1_.material = new ShadingColorMaterial(null,{
                     "ambient":_loc1_.ambientColor,
                     "diffuse":_loc1_.diffuseColor,
                     "specular":_loc1_.specularColor,
                     "shininess":_loc1_.shininess
                  });
                  break;
               case MaterialData.COLOR_MATERIAL:
                  _loc1_.material = new ColorMaterial(_loc1_.diffuseColor);
                  break;
               case MaterialData.WIREFRAME_MATERIAL:
                  _loc1_.material = new WireColorMaterial();
            }
         }
      }
      
      private function parseChannel(param1:ChannelData) : void
      {
         var node:XML;
         var isC4DType:String;
         var sampler:XML;
         var channel:Channel;
         var name:String;
         var id:String;
         var isC4D:Boolean;
         var type:String;
         var i:int = 0;
         var j:int = 0;
         var input:XML = null;
         var src:XML = null;
         var list:Array = null;
         var len:int = 0;
         var stride:int = 0;
         var semantic:String = null;
         var p:String = null;
         var m:Matrix3D = null;
         var channelData:ChannelData = param1;
         default xml namespace = _colladaXml.namespace();
         node = channelData.xml;
         id = node["channel"].@target;
         name = id.split("/")[0];
         type = id.split("/")[1];
         sampler = node["sampler"][0];
         if(!type)
         {
            Debug.trace(" ! No animation type detected");
            return;
         }
         isC4D = String(node.@id).length <= 0;
         isC4DType = type.split(".").join("");
         type = type.split(".")[0];
         if(!isC4D && (type == "image" || node.@id.split(".")[1] == "frameExtension"))
         {
            Debug.trace(" ! Material animation not yet implemented");
            return;
         }
         channel = channelData.channel = new Channel(name);
         _defaultAnimationClip.channels[channelData.name] = channelData;
         Debug.trace(" ! channelType : " + type);
         for each(input in sampler["input"])
         {
            src = node["source"].(@id == getId(input.@source))[0];
            list = String(src["float_array"]).split(" ");
            len = int(src["technique_common"].accessor.@count);
            stride = int(src["technique_common"].accessor.@stride);
            semantic = input.@semantic;
            if(stride == 0)
            {
               stride = 1;
            }
            switch(semantic)
            {
               case "INPUT":
                  for each(p in list)
                  {
                     channel.times.push(Number(p));
                  }
                  if(_defaultAnimationClip.start > channel.times[0])
                  {
                     _defaultAnimationClip.start = channel.times[0];
                  }
                  if(_defaultAnimationClip.end < channel.times[channel.times.length - 1])
                  {
                     _defaultAnimationClip.end = channel.times[channel.times.length - 1];
                  }
                  break;
               case "OUTPUT":
                  i = 0;
                  while(i < len)
                  {
                     channel.param[i] = [];
                     if(stride == 16)
                     {
                        m = new Matrix3D();
                        m.array2matrix(list.slice(i * stride,i * stride + 16),yUp,scaling);
                        channel.param[i].push(m);
                     }
                     else
                     {
                        j = 0;
                        while(j < stride)
                        {
                           channel.param[i].push(Number(list[i * stride + j]));
                           j++;
                        }
                     }
                     i++;
                  }
                  Debug.trace("OUTPUT:" + len);
                  break;
               case "INTERPOLATION":
                  for each(p in list)
                  {
                     channel.interpolations.push(p);
                  }
                  break;
               case "IN_TANGENT":
                  i = 0;
                  while(i < len)
                  {
                     channel.inTangent[i] = [];
                     j = 0;
                     while(j < stride)
                     {
                        channel.inTangent[i].push(new Number2D(Number(list[stride * i + j]),Number(list[stride * i + j + 1])));
                        j++;
                     }
                     i++;
                  }
                  break;
               case "OUT_TANGENT":
                  i = 0;
                  while(i < len)
                  {
                     channel.outTangent[i] = [];
                     j = 0;
                     while(j < stride)
                     {
                        channel.outTangent[i].push(new Number2D(Number(list[stride * i + j]),Number(list[stride * i + j + 1])));
                        j++;
                     }
                     i++;
                  }
            }
         }
         channelData.type = isC4D ? isC4DType : type;
         Debug.trace("channelData.type:" + channelData.type);
      }
      
      public function set materials(param1:Object) : void
      {
         applyMaterials(param1);
      }
      
      private function applyMaterials(param1:Object) : void
      {
         var _loc2_:MaterialData = null;
         var _loc3_:String = null;
         var _loc4_:IMaterial = null;
         if(materialLibrary == null)
         {
            materialLibrary = new MaterialLibrary();
            if(container != null)
            {
               container.materialLibrary = materialLibrary;
            }
         }
         _materials = param1 || {};
         for(_loc3_ in _materials)
         {
            _loc2_ = materialLibrary.addMaterial(_loc3_);
            if(_loc2_ == null)
            {
               continue;
            }
            try
            {
               _loc4_ = Cast.material(_materials[_loc3_]);
            }
            catch(e:Error)
            {
               Debug.warning("Ignoring Collada material override " + _loc3_ + ": " + e);
               _loc4_ = null;
            }
            _loc2_.material = _loc4_;
            if(_loc4_ is BitmapMaterial)
            {
               _loc2_.materialType = MaterialData.TEXTURE_MATERIAL;
            }
            else if(_loc4_ is ShadingColorMaterial)
            {
               _loc2_.materialType = MaterialData.SHADING_MATERIAL;
            }
            else if(_loc4_ is WireframeMaterial)
            {
               _loc2_.materialType = MaterialData.WIREFRAME_MATERIAL;
            }
         }
      }
      
      private function buildMesh(param1:MeshData, param2:ObjectContainer3D) : Mesh
      {
         var _loc3_:Mesh = null;
         var _loc4_:GeometryData = null;
         var _loc6_:FaceData = null;
         var _loc7_:MeshMaterialData = null;
         var _loc8_:int = 0;
         var _loc9_:Bone = null;
         var _loc10_:SkinController = null;
         Debug.trace(" + Build Mesh : " + param1.name);
         _loc3_ = new Mesh({"name":param1.name});
         _loc3_.transform = param1.transform;
         _loc3_.bothsides = param1.geometry.bothsides;
         _loc4_ = param1.geometry;
         var _loc5_:Geometry = _loc4_.geometry;
         if(!_loc5_)
         {
            _loc5_ = _loc4_.geometry = new Geometry();
            _loc3_.geometry = _loc5_;
            for each(_loc7_ in _loc4_.materials)
            {
               for each(_loc8_ in _loc7_.faceList)
               {
                  _loc6_ = _loc4_.faces[_loc8_] as FaceData;
                  _loc6_.materialData = symbolLibrary[_loc7_.symbol];
               }
            }
            if(_loc4_.skinVertices.length)
            {
               _loc9_ = (container as ObjectContainer3D).getBoneByName(param1.skeleton);
               _loc5_.skinVertices = _loc4_.skinVertices;
               _loc5_.skinControllers = _loc4_.skinControllers;
               _loc5_.rootBone = _loc9_;
               for each(_loc10_ in _loc5_.skinControllers)
               {
                  _loc10_.inverseTransform = param2.inverseSceneTransform;
               }
            }
            for each(_loc6_ in _loc4_.faces)
            {
               if(_loc6_.materialData)
               {
                  _faceMaterial = _loc6_.materialData.material as ITriangleMaterial;
               }
               else
               {
                  _faceMaterial = null;
               }
               _face = new Face(_loc4_.vertices[_loc6_.v0],_loc4_.vertices[_loc6_.v1],_loc4_.vertices[_loc6_.v2],_faceMaterial,_loc4_.uvs[_loc6_.uv0],_loc4_.uvs[_loc6_.uv1],_loc4_.uvs[_loc6_.uv2]);
               _loc5_.addFace(_face);
               if(_loc6_.materialData)
               {
                  _loc6_.materialData.elements.push(_face);
               }
            }
         }
         else
         {
            _loc3_.geometry = _loc5_;
         }
         if(centerMeshes)
         {
            _loc3_.movePivot(_moveVector.x = (_loc4_.maxX + _loc4_.minX) / 2,_moveVector.y = (_loc4_.maxY + _loc4_.minY) / 2,_moveVector.z = (_loc4_.maxZ + _loc4_.minZ) / 2);
            _moveVector.transform(_moveVector,param1.transform);
            _loc3_.moveTo(_moveVector.x,_moveVector.y,_moveVector.z);
         }
         _loc3_.type = ".Collada";
         param2.addChild(_loc3_);
         return _loc3_;
      }
      
      private function rotateMatrix(param1:Array) : Matrix3D
      {
         if(yUp)
         {
            rotationMatrix.rotationMatrix(param1[0],-param1[1],-param1[2],param1[3] * toRADIANS);
         }
         else
         {
            rotationMatrix.rotationMatrix(param1[0],param1[2],param1[1],-param1[3] * toRADIANS);
         }
         return rotationMatrix;
      }
      
      private function buildAnimations() : void
      {
         var _loc1_:Bone = null;
         var _loc2_:GeometryData = null;
         var _loc3_:AnimationData = null;
         var _loc4_:SkinController = null;
         var _loc5_:SkinAnimation = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:ChannelData = null;
         var _loc14_:Channel = null;
         var _loc15_:Array = null;
         for each(_loc2_ in geometryLibrary)
         {
            for each(_loc4_ in _loc2_.geometry.skinControllers)
            {
               _loc1_ = (container as ObjectContainer3D).getBoneByName(_loc4_.name);
               if(_loc1_)
               {
                  _loc4_.joint = _loc1_.joint;
               }
               else
               {
                  Debug.warning("no joint found for " + _loc4_.name);
               }
            }
         }
         for each(_loc3_ in animationLibrary)
         {
            switch(_loc3_.animationType)
            {
               case AnimationData.SKIN_ANIMATION:
                  _loc5_ = new SkinAnimation();
                  for each(_loc13_ in _loc3_.channels)
                  {
                     _loc14_ = _loc13_.channel;
                     _loc14_.target = _containers[_loc14_.name];
                     _loc5_.appendChannel(_loc14_);
                     _loc15_ = _loc14_.times;
                     if(_loc3_.start > _loc15_[0])
                     {
                        _loc3_.start = _loc15_[0];
                     }
                     if(_loc3_.end < _loc15_[_loc15_.length - 1])
                     {
                        _loc3_.end = _loc15_[_loc15_.length - 1];
                     }
                     if(_loc14_.target is Bone)
                     {
                        _loc7_ = "jointRotationX";
                        _loc8_ = "jointRotationY";
                        _loc9_ = "jointRotationZ";
                        _loc10_ = "jointScaleX";
                        _loc11_ = "jointScaleY";
                        _loc12_ = "jointScaleZ";
                     }
                     else
                     {
                        _loc7_ = "rotationX";
                        _loc8_ = "rotationY";
                        _loc9_ = "rotationZ";
                        _loc10_ = "scaleX";
                        _loc11_ = "scaleY";
                        _loc12_ = "scaleZ";
                     }
                     switch(_loc13_.type)
                     {
                        case "translateX":
                        case "transform(3)(0)":
                           _loc14_.type = ["x"];
                           if(yUp)
                           {
                              for each(_loc6_ in _loc14_.param)
                              {
                                 _loc6_[0] *= -1 * scaling;
                              }
                           }
                           break;
                        case "translateY":
                        case "transform(3)(1)":
                           if(yUp)
                           {
                              _loc14_.type = ["y"];
                           }
                           else
                           {
                              _loc14_.type = ["z"];
                           }
                           for each(_loc6_ in _loc14_.param)
                           {
                              _loc6_[0] *= scaling;
                           }
                           break;
                        case "translateZ":
                        case "transform(3)(2)":
                           if(yUp)
                           {
                              _loc14_.type = ["z"];
                           }
                           else
                           {
                              _loc14_.type = ["y"];
                           }
                           for each(_loc6_ in _loc14_.param)
                           {
                              _loc6_[0] *= scaling;
                           }
                           break;
                        case "jointOrientX":
                           _loc14_.type = ["rotationX"];
                           if(yUp)
                           {
                              for each(_loc6_ in _loc14_.param)
                              {
                                 _loc6_[0] *= -1;
                              }
                           }
                           break;
                        case "rotateXANGLE":
                        case "rotateX":
                        case "RotX":
                           _loc14_.type = [_loc7_];
                           if(yUp)
                           {
                              for each(_loc6_ in _loc14_.param)
                              {
                                 _loc6_[0] *= -1;
                              }
                           }
                           break;
                        case "jointOrientY":
                           _loc14_.type = ["rotationY"];
                           for each(_loc6_ in _loc14_.param)
                           {
                              _loc6_[0] *= -1;
                           }
                           break;
                        case "rotateYANGLE":
                        case "rotateY":
                        case "RotY":
                           if(yUp)
                           {
                              _loc14_.type = [_loc8_];
                           }
                           else
                           {
                              _loc14_.type = [_loc9_];
                           }
                           for each(_loc6_ in _loc14_.param)
                           {
                              _loc6_[0] *= -1;
                           }
                           break;
                        case "jointOrientZ":
                           _loc14_.type = ["rotationZ"];
                           for each(_loc6_ in _loc14_.param)
                           {
                              _loc6_[0] *= -1;
                           }
                           break;
                        case "rotateZANGLE":
                        case "rotateZ":
                        case "RotZ":
                           if(yUp)
                           {
                              _loc14_.type = [_loc9_];
                           }
                           else
                           {
                              _loc14_.type = [_loc8_];
                           }
                           for each(_loc6_ in _loc14_.param)
                           {
                              _loc6_[0] *= -1;
                           }
                           break;
                        case "scaleX":
                        case "transform(0)(0)":
                           _loc14_.type = [_loc10_];
                           break;
                        case "scaleY":
                        case "transform(1)(1)":
                           if(yUp)
                           {
                              _loc14_.type = [_loc11_];
                           }
                           else
                           {
                              _loc14_.type = [_loc12_];
                           }
                           break;
                        case "scaleZ":
                        case "transform(2)(2)":
                           if(yUp)
                           {
                              _loc14_.type = [_loc12_];
                           }
                           else
                           {
                              _loc14_.type = [_loc11_];
                           }
                           break;
                        case "translate":
                        case "translation":
                           if(yUp)
                           {
                              _loc14_.type = ["x","y","z"];
                              for each(_loc6_ in _loc14_.param)
                              {
                                 _loc6_[0] *= -1;
                              }
                           }
                           else
                           {
                              _loc14_.type = ["x","z","y"];
                           }
                           for each(_loc6_ in _loc14_.param)
                           {
                              _loc6_[0] *= scaling;
                              _loc6_[1] *= scaling;
                              _loc6_[2] *= scaling;
                           }
                           break;
                        case "scale":
                           if(yUp)
                           {
                              _loc14_.type = [_loc10_,_loc11_,_loc12_];
                           }
                           else
                           {
                              _loc14_.type = [_loc10_,_loc12_,_loc11_];
                           }
                           break;
                        case "rotate":
                           if(yUp)
                           {
                              _loc14_.type = [_loc7_,_loc8_,_loc9_];
                              for each(_loc6_ in _loc14_.param)
                              {
                                 _loc6_[0] *= -1;
                                 _loc6_[1] *= -1;
                                 _loc6_[2] *= -1;
                              }
                           }
                           else
                           {
                              _loc14_.type = [_loc7_,_loc9_,_loc8_];
                              for each(_loc6_ in _loc14_.param)
                              {
                                 _loc6_[1] *= -1;
                                 _loc6_[2] *= -1;
                              }
                           }
                           break;
                        case "transform":
                           _loc14_.type = ["transform"];
                           break;
                        case "visibility":
                           _loc14_.type = ["visibility"];
                     }
                  }
                  _loc5_.start = _loc3_.start;
                  _loc5_.length = _loc3_.end - _loc3_.start;
                  _loc3_.animation = _loc5_;
                  break;
               case AnimationData.VERTEX_ANIMATION:
            }
         }
      }
      
      private function deserialize(param1:XML, param2:XML, param3:Class, param4:Array) : Array
      {
         var id:String = null;
         var acc:XMLList = null;
         var floId:String = null;
         var floXML:XMLList = null;
         var floStr:String = null;
         var floats:Array = null;
         var float:Number = NaN;
         var params:Array = null;
         var param:String = null;
         var par:XML = null;
         var len:int = 0;
         var i:int = 0;
         var element:ValueObject = null;
         var vertex:Vertex = null;
         var uv:UV = null;
         var recursive:XMLList = null;
         var input:XML = param1;
         var geo:XML = param2;
         var VObject:Class = param3;
         var output:Array = param4;
         default xml namespace = _colladaXml.namespace();
         id = input.@source.split("#")[1];
         acc = geo..source.(@id == id)["technique_common"].accessor;
         if(acc != new XMLList())
         {
            floId = acc.@source.split("#")[1];
            floXML = _colladaXml..float_array.(@id == floId);
            floStr = floXML.toString();
            floats = getArray(floStr);
            params = [];
            for each(par in acc["param"])
            {
               params.push(par.@name);
            }
            len = int(floats.length);
            i = 0;
            while(i < len)
            {
               element = new VObject();
               if(element is Vertex)
               {
                  vertex = element as Vertex;
                  for each(param in params)
                  {
                     float = Number(floats[i]);
                     switch(param)
                     {
                        case VALUE_X:
                           if(yUp)
                           {
                              vertex._x = -float * scaling;
                           }
                           else
                           {
                              vertex._x = float * scaling;
                           }
                           break;
                        case VALUE_Y:
                           vertex._y = float * scaling;
                           break;
                        case VALUE_Z:
                           vertex._z = float * scaling;
                     }
                     i++;
                  }
               }
               else if(element is UV)
               {
                  uv = element as UV;
                  for each(param in params)
                  {
                     float = Number(floats[i]);
                     switch(param)
                     {
                        case VALUE_U:
                           uv._u = float;
                           break;
                        case VALUE_V:
                           uv._v = float;
                     }
                     i++;
                  }
               }
               output.push(element);
            }
         }
         else
         {
            recursive = geo..vertices.(@id == id)["input"];
            output = deserialize(recursive[0],geo,VObject,output);
         }
         return output;
      }
   }
}


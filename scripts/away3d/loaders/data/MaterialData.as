package away3d.loaders.data
{
   import away3d.core.base.*;
   import away3d.materials.*;
   import flash.display.BitmapData;
   
   public class MaterialData
   {
      
      public static const TEXTURE_MATERIAL:String = "textureMaterial";
      
      public static const SHADING_MATERIAL:String = "shadingMaterial";
      
      public static const COLOR_MATERIAL:String = "colorMaterial";
      
      public static const WIREFRAME_MATERIAL:String = "wireframeMaterial";
      
      public var specularColor:uint;
      
      public var diffuseColor:uint;
      
      private var _material:IMaterial;
      
      public var materialType:String = "wireframeMaterial";
      
      public var textureFileName:String;
      
      public var textureBitmap:BitmapData;
      
      public var name:String;
      
      public var shininess:Number;
      
      public var ambientColor:uint;
      
      public var elements:Array = [];
      
      public function MaterialData()
      {
         super();
      }
      
      public function get material() : IMaterial
      {
         return _material;
      }
      
      public function set material(param1:IMaterial) : void
      {
         var _loc2_:Element = null;
         if(_material == param1)
         {
            return;
         }
         _material = param1;
         if(_material is IUVMaterial)
         {
            textureBitmap = (_material as IUVMaterial).bitmap;
         }
         if(_material is ITriangleMaterial)
         {
            for each(_loc2_ in elements)
            {
               (_loc2_ as Face).material = _material as ITriangleMaterial;
            }
         }
         else if(_material is ISegmentMaterial)
         {
            for each(_loc2_ in elements)
            {
               (_loc2_ as Segment).material = _material as ISegmentMaterial;
            }
         }
      }
      
      public function clone(param1:Object3D) : MaterialData
      {
         var _loc3_:Element = null;
         var _loc4_:Geometry = null;
         var _loc5_:Element = null;
         var _loc2_:MaterialData = param1.materialLibrary.addMaterial(name);
         _loc2_.materialType = materialType;
         _loc2_.ambientColor = ambientColor;
         _loc2_.diffuseColor = diffuseColor;
         _loc2_.shininess = shininess;
         _loc2_.specularColor = specularColor;
         _loc2_.textureBitmap = textureBitmap;
         _loc2_.textureFileName = textureFileName;
         _loc2_.material = material;
         for each(_loc3_ in elements)
         {
            _loc4_ = _loc3_.parent;
            _loc5_ = _loc4_.cloneElementDictionary[_loc3_];
            _loc2_.elements.push(_loc5_);
         }
         return _loc2_;
      }
   }
}


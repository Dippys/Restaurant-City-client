package away3d.materials
{
   import away3d.core.utils.*;
   import away3d.materials.shaders.*;
   import flash.display.*;
   
   public class PhongBitmapMaterial extends CompositeMaterial
   {
      
      private var _specular:Number;
      
      private var _shininess:Number;
      
      private var _diffusePhongShader:DiffusePhongShader;
      
      private var _specularPhongShader:SpecularPhongShader;
      
      private var _bitmapMaterial:TransformBitmapMaterial;
      
      private var _phongShader:CompositeMaterial;
      
      private var _ambientShader:AmbientShader;
      
      public function PhongBitmapMaterial(param1:BitmapData, param2:Object = null)
      {
         if(Boolean(param2) && Boolean(param2["materials"]))
         {
            delete param2["materials"];
         }
         super(param2);
         _shininess = ini.getNumber("shininess",20);
         _specular = ini.getNumber("specular",0.7,{
            "min":0,
            "max":1
         });
         _bitmapMaterial = new TransformBitmapMaterial(param1,ini);
         _phongShader = new CompositeMaterial({"blendMode":BlendMode.MULTIPLY});
         _phongShader.addMaterial(_ambientShader = new AmbientShader({"blendMode":BlendMode.ADD}));
         _phongShader.addMaterial(_diffusePhongShader = new DiffusePhongShader({"blendMode":BlendMode.ADD}));
         _specularPhongShader = new SpecularPhongShader({
            "shininess":_shininess,
            "specular":_specular,
            "blendMode":BlendMode.ADD
         });
         addMaterial(_bitmapMaterial);
         addMaterial(_phongShader);
         if(_specular)
         {
            addMaterial(_specularPhongShader);
         }
      }
      
      public function get specular() : Number
      {
         return _specular;
      }
      
      public function set specular(param1:Number) : void
      {
         if(_specular == param1)
         {
            return;
         }
         _specular = param1;
         _specularPhongShader.specular = param1;
         if(Boolean(_specular) && materials.length < 3)
         {
            addMaterial(_specularPhongShader);
         }
         else if(!_specular && materials.length > 2)
         {
            removeMaterial(_specularPhongShader);
         }
      }
      
      public function get shininess() : Number
      {
         return _shininess;
      }
      
      public function set shininess(param1:Number) : void
      {
         _shininess = param1;
         _specularPhongShader.shininess = param1;
      }
   }
}


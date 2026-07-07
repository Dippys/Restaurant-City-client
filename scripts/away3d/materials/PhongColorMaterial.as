package away3d.materials
{
   import away3d.arcane;
   import away3d.core.utils.*;
   import away3d.materials.shaders.*;
   import flash.display.*;
   
   use namespace arcane;
   
   public class PhongColorMaterial extends CompositeMaterial
   {
      
      private var _specular:Number;
      
      private var _shininess:Number;
      
      private var _diffusePhongShader:DiffusePhongShader;
      
      private var _specularPhongShader:SpecularPhongShader;
      
      private var _phongShader:CompositeMaterial;
      
      private var _ambientShader:AmbientShader;
      
      public function PhongColorMaterial(param1:*, param2:Object = null)
      {
         if(Boolean(param2) && Boolean(param2["materials"]))
         {
            delete param2["materials"];
         }
         super(param2);
         this.color = Cast.trycolor(param1);
         _shininess = ini.getNumber("shininess",20);
         _specular = ini.getNumber("specular",0.7,{
            "min":0,
            "max":1
         });
         _phongShader = new CompositeMaterial();
         _phongShader.addMaterial(_ambientShader = new AmbientShader({"blendMode":BlendMode.ADD}));
         _phongShader.addMaterial(_diffusePhongShader = new DiffusePhongShader({"blendMode":BlendMode.ADD}));
         _specularPhongShader = new SpecularPhongShader({
            "shininess":_shininess,
            "specular":_specular,
            "blendMode":BlendMode.ADD
         });
         if(_specular)
         {
            addMaterial(_phongShader);
            addMaterial(_specularPhongShader);
         }
         else
         {
            addMaterial(_ambientShader);
            addMaterial(_diffusePhongShader);
         }
      }
      
      public function get specular() : Number
      {
         return _specular;
      }
      
      public function get shininess() : Number
      {
         return _shininess;
      }
      
      public function set specular(param1:Number) : void
      {
         if(_specular == param1)
         {
            return;
         }
         _specular = param1;
         if(_specular)
         {
            _specularPhongShader.shininess = _shininess;
            _specularPhongShader.specular = _specular;
            removeMaterial(_ambientShader);
            removeMaterial(_diffusePhongShader);
            addMaterial(_phongShader);
            addMaterial(_specularPhongShader);
         }
         else
         {
            removeMaterial(_phongShader);
            removeMaterial(_specularPhongShader);
            addMaterial(_ambientShader);
            addMaterial(_diffusePhongShader);
         }
         _colorTransformDirty = true;
      }
      
      override protected function setColorTransform() : void
      {
         _colorTransformDirty = false;
         if(_specular)
         {
            _colorTransform = null;
            _phongShader.color = _color;
            _phongShader.alpha = _alpha;
         }
         else
         {
            _phongShader.color = 16777215;
            _phongShader.alpha = 1;
            super.setColorTransform();
         }
      }
      
      public function set shininess(param1:Number) : void
      {
         _shininess = param1;
         if(_specularPhongShader)
         {
            _specularPhongShader.shininess = param1;
         }
      }
   }
}


package away3d.lights
{
   import away3d.arcane;
   import away3d.core.base.Object3D;
   import away3d.core.light.DirectionalLight;
   import away3d.core.light.ILightConsumer;
   import away3d.core.light.ILightProvider;
   import away3d.core.utils.IClonable;
   import away3d.materials.ColorMaterial;
   import away3d.primitives.Sphere;
   
   use namespace arcane;
   
   public class DirectionalLight3D extends Object3D implements ILightProvider, IClonable
   {
      
      private var _green:Number;
      
      private var _debugMaterial:ColorMaterial;
      
      private var _specular:Number;
      
      private var _diffuse:Number;
      
      private var _ls:DirectionalLight = new DirectionalLight();
      
      private var _blue:Number;
      
      private var _colorDirty:Boolean;
      
      private var _specularDirty:Boolean;
      
      private var _red:Number;
      
      private var _ambient:Number;
      
      private var _debug:Boolean;
      
      private var _color:int;
      
      private var _diffuseDirty:Boolean;
      
      private var _brightness:Number;
      
      private var _debugPrimitive:Sphere;
      
      private var _ambientDirty:Boolean;
      
      public function DirectionalLight3D(param1:Object = null)
      {
         super(param1);
         color = ini.getColor("color",16777215);
         ambient = ini.getNumber("ambient",0.5,{
            "min":0,
            "max":1
         });
         diffuse = ini.getNumber("diffuse",0.5,{
            "min":0,
            "max":10
         });
         specular = ini.getNumber("specular",1,{
            "min":0,
            "max":1
         });
         brightness = ini.getNumber("brightness",1);
         debug = ini.getBoolean("debug",false);
         _ls.light = this;
      }
      
      public function set specular(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         _specular = param1;
         _specularDirty = true;
      }
      
      public function light(param1:ILightConsumer) : void
      {
         if(_colorDirty)
         {
            _ls.red = _red;
            _ls.green = _green;
            _ls.blue = _blue;
         }
         _ls.ambient = _ambient * _brightness;
         _ls.diffuse = _diffuse * _brightness;
         _ls.specular = _specular * _brightness;
         if(_ambientDirty || _diffuseDirty)
         {
            _ls.updateAmbientDiffuseBitmap();
         }
         if(_ambientDirty)
         {
            _ambientDirty = false;
            _ls.updateAmbientBitmap();
         }
         if(_diffuseDirty)
         {
            _diffuseDirty = false;
            _ls.updateDiffuseBitmap();
         }
         if(_specularDirty)
         {
            _specularDirty = false;
            _ls.updateSpecularBitmap();
         }
         param1.directionalLight(_ls);
         _colorDirty = false;
      }
      
      public function get ambient() : Number
      {
         return _ambient;
      }
      
      public function set brightness(param1:Number) : void
      {
         _brightness = param1;
         _ambientDirty = true;
         _diffuseDirty = true;
         _specularDirty = true;
      }
      
      public function set debug(param1:Boolean) : void
      {
         _debug = param1;
      }
      
      public function set ambient(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         _ambient = param1;
         _ambientDirty = true;
      }
      
      public function get specular() : Number
      {
         return _specular;
      }
      
      public function set diffuse(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         _diffuse = param1;
         _diffuseDirty = true;
      }
      
      public function set color(param1:int) : void
      {
         _color = param1;
         _red = ((color & 0xFF0000) >> 16) / 255;
         _green = ((color & 0xFF00) >> 8) / 255;
         _blue = (color & 0xFF) / 255;
         _colorDirty = true;
         _ambientDirty = true;
         _diffuseDirty = true;
         _specularDirty = true;
      }
      
      public function get brightness() : Number
      {
         return _brightness;
      }
      
      public function get debug() : Boolean
      {
         return _debug;
      }
      
      override public function clone(param1:Object3D = null) : Object3D
      {
         var _loc2_:DirectionalLight3D = param1 as DirectionalLight3D || new DirectionalLight3D();
         super.clone(_loc2_);
         _loc2_.color = color;
         _loc2_.brightness = brightness;
         _loc2_.ambient = ambient;
         _loc2_.diffuse = diffuse;
         _loc2_.specular = specular;
         _loc2_.debug = debug;
         return _loc2_;
      }
      
      public function get diffuse() : Number
      {
         return _diffuse;
      }
      
      public function get color() : int
      {
         return _color;
      }
      
      public function get debugPrimitive() : Object3D
      {
         if(!_debugPrimitive)
         {
            _debugPrimitive = new Sphere({"radius":10});
            _scene.clearId(_id);
         }
         if(!_debugMaterial)
         {
            _debugMaterial = new ColorMaterial();
            _debugPrimitive.material = _debugMaterial;
         }
         _debugMaterial.color = color;
         return _debugPrimitive;
      }
   }
}


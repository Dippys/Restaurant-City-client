package away3d.lights
{
   import away3d.arcane;
   import away3d.core.base.Object3D;
   import away3d.core.light.ILightConsumer;
   import away3d.core.light.ILightProvider;
   import away3d.core.light.PointLight;
   import away3d.core.utils.IClonable;
   import away3d.geom.Merge;
   import away3d.materials.ColorMaterial;
   import away3d.primitives.Sphere;
   
   use namespace arcane;
   
   public class PointLight3D extends Object3D implements ILightProvider, IClonable
   {
      
      public var specular:Number;
      
      public var brightness:Number;
      
      private var _debug:Boolean;
      
      private var _falloff:Number = 1000;
      
      public var ambient:Number;
      
      private var _debugMaterial:ColorMaterial;
      
      public var diffuse:Number;
      
      private var _ls:PointLight = new PointLight();
      
      private var _color:uint;
      
      private var _radius:Number = 200;
      
      private var _debugPrimitive:Sphere;
      
      public function PointLight3D(param1:Object = null)
      {
         super(param1);
         _color = ini.getColor("color",16777215);
         ambient = ini.getNumber("ambient",1);
         diffuse = ini.getNumber("diffuse",1);
         specular = ini.getNumber("specular",1);
         brightness = ini.getNumber("brightness",1000) * 255;
         debug = ini.getBoolean("debug",false);
         _radius = ini.getNumber("radius",50);
         _falloff = ini.getNumber("fallOff",1000);
         _ls.light = this;
      }
      
      public function set color(param1:uint) : void
      {
         _color = param1;
         _ls.red = ((_color & 0xFF0000) >> 16) / 255;
         _ls.green = ((_color & 0xFF00) >> 8) / 255;
         _ls.blue = (_color & 0xFF) / 255;
         _debugPrimitive = null;
      }
      
      public function get radius() : Number
      {
         return _radius;
      }
      
      public function get debug() : Boolean
      {
         return _debug;
      }
      
      public function light(param1:ILightConsumer) : void
      {
         _ls.red = ((_color & 0xFF0000) >> 16) / 255;
         _ls.green = ((_color & 0xFF00) >> 8) / 255;
         _ls.blue = (_color & 0xFF) / 255;
         _ls.ambient = ambient * brightness;
         _ls.diffuse = diffuse * brightness;
         _ls.specular = specular * brightness;
         _ls.radius = _radius;
         _ls.fallOff = _falloff;
         param1.pointLight(_ls);
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function set radius(param1:Number) : void
      {
         _radius = param1;
         _falloff = radius > _falloff ? radius + 1 : _falloff;
         _debugPrimitive = null;
      }
      
      public function get debugPrimitive() : Object3D
      {
         var _loc1_:Merge = null;
         var _loc2_:Sphere = null;
         if(!_debugPrimitive)
         {
            _debugPrimitive = new Sphere({"radius":radius});
            _scene.setId(_debugPrimitive);
            _debugMaterial = new ColorMaterial();
            _debugPrimitive.material = _debugMaterial;
            _debugMaterial.color = color;
            _debugMaterial.alpha = 0.15;
            _loc1_ = new Merge(false,true,false);
            _loc2_ = new Sphere({
               "segmentsW":10,
               "segmentsH":8,
               "material":_debugMaterial,
               "radius":_falloff
            });
            _loc1_.apply(_debugPrimitive,_loc2_);
         }
         return _debugPrimitive;
      }
      
      public function set fallOff(param1:Number) : void
      {
         _falloff = radius > _falloff ? radius + 1 : param1;
         _debugPrimitive = null;
         _scene.clearId(_id);
      }
      
      public function get fallOff() : Number
      {
         return _falloff;
      }
      
      public function set debug(param1:Boolean) : void
      {
         _debug = param1;
      }
      
      override public function clone(param1:Object3D = null) : Object3D
      {
         var _loc2_:PointLight3D = param1 as PointLight3D || new PointLight3D();
         super.clone(_loc2_);
         _loc2_.color = _color;
         _loc2_.ambient = ambient;
         _loc2_.diffuse = diffuse;
         _loc2_.specular = specular;
         _loc2_.debug = debug;
         _loc2_.radius = _radius;
         _loc2_.fallOff = _falloff;
         return _loc2_;
      }
   }
}


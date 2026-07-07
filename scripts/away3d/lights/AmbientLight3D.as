package away3d.lights
{
   import away3d.arcane;
   import away3d.core.base.Object3D;
   import away3d.core.light.AmbientLight;
   import away3d.core.light.ILightConsumer;
   import away3d.core.light.ILightProvider;
   import away3d.core.utils.IClonable;
   import away3d.materials.ColorMaterial;
   import away3d.primitives.Sphere;
   
   use namespace arcane;
   
   public class AmbientLight3D extends Object3D implements ILightProvider, IClonable
   {
      
      private var _ambientDirty:Boolean;
      
      private var _green:int;
      
      private var _colorDirty:Boolean;
      
      private var _red:int;
      
      private var _debug:Boolean;
      
      private var _ambient:Number;
      
      private var _debugMaterial:ColorMaterial;
      
      private var _ls:AmbientLight = new AmbientLight();
      
      private var _color:int;
      
      private var _debugPrimitive:Sphere;
      
      private var _blue:int;
      
      public function AmbientLight3D(param1:Object = null)
      {
         super(param1);
         color = ini.getColor("color",16777215);
         ambient = ini.getNumber("ambient",0.5,{
            "min":0,
            "max":1
         });
         debug = ini.getBoolean("debug",false);
      }
      
      public function set color(param1:int) : void
      {
         _color = param1;
         _red = (_color & 0xFF0000) >> 16;
         _green = (_color & 0xFF00) >> 8;
         _blue = _color & 0xFF;
         _colorDirty = true;
      }
      
      public function get debug() : Boolean
      {
         return _debug;
      }
      
      public function light(param1:ILightConsumer) : void
      {
         if(_colorDirty)
         {
            _ls.red = _red;
            _ls.green = _green;
            _ls.blue = _blue;
            _colorDirty = false;
         }
         if(_ambientDirty)
         {
            _ambientDirty = false;
            _ls.updateAmbientBitmap(_ambient);
         }
         param1.ambientLight(_ls);
      }
      
      public function get ambient() : Number
      {
         return _ambient;
      }
      
      public function get color() : int
      {
         return _color;
      }
      
      public function get debugPrimitive() : Object3D
      {
         if(!_debugPrimitive)
         {
            _debugPrimitive = new Sphere();
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
      
      public function set ambient(param1:Number) : void
      {
         _ambient = param1;
         _ambientDirty = true;
      }
      
      public function set debug(param1:Boolean) : void
      {
         _debug = param1;
      }
      
      override public function clone(param1:Object3D = null) : Object3D
      {
         var _loc2_:AmbientLight3D = param1 as AmbientLight3D || new AmbientLight3D();
         super.clone(_loc2_);
         _loc2_.color = color;
         _loc2_.ambient = ambient;
         _loc2_.debug = debug;
         return _loc2_;
      }
   }
}


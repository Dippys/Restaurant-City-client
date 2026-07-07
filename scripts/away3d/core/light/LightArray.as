package away3d.core.light
{
   public class LightArray implements ILightConsumer
   {
      
      private var _points:Array;
      
      private var _numLights:int;
      
      private var _directionals:Array;
      
      private var _ambients:Array;
      
      public function LightArray()
      {
         super();
      }
      
      public function get numLights() : int
      {
         return _numLights;
      }
      
      public function directionalLight(param1:DirectionalLight) : void
      {
         _directionals.push(param1);
         ++_numLights;
      }
      
      public function clear() : void
      {
         _ambients = [];
         _directionals = [];
         _points = [];
         _numLights = 0;
      }
      
      public function get directionals() : Array
      {
         return _directionals;
      }
      
      public function get ambients() : Array
      {
         return _ambients;
      }
      
      public function get points() : Array
      {
         return _points;
      }
      
      public function ambientLight(param1:AmbientLight) : void
      {
         _ambients.push(param1);
         ++_numLights;
      }
      
      public function pointLight(param1:PointLight) : void
      {
         _points.push(param1);
         ++_numLights;
      }
   }
}


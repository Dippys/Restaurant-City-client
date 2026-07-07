package away3d.core.light
{
   public interface ILightConsumer
   {
      
      function get points() : Array;
      
      function pointLight(param1:PointLight) : void;
      
      function get directionals() : Array;
      
      function get numLights() : int;
      
      function get ambients() : Array;
      
      function directionalLight(param1:DirectionalLight) : void;
      
      function clear() : void;
      
      function ambientLight(param1:AmbientLight) : void;
   }
}


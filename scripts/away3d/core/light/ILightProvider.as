package away3d.core.light
{
   import away3d.core.base.Object3D;
   
   public interface ILightProvider
   {
      
      function get debug() : Boolean;
      
      function get debugPrimitive() : Object3D;
      
      function light(param1:ILightConsumer) : void;
   }
}


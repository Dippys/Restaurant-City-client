package away3d.core.light
{
   import away3d.containers.*;
   import away3d.core.math.*;
   import away3d.events.*;
   import away3d.lights.*;
   import flash.utils.*;
   
   public class PointLight extends LightPrimitive
   {
      
      public var viewPositions:Dictionary;
      
      private var _light:PointLight3D;
      
      public function PointLight()
      {
         super();
      }
      
      public function setViewPosition(param1:View3D) : void
      {
         if(!viewPositions[param1])
         {
            viewPositions[param1] = new Number3D();
         }
         viewPositions[param1].clone(param1.cameraVarsStore.viewTransformDictionary[_light].position);
      }
      
      public function updatePosition(param1:Object3DEvent) : void
      {
         clearViewPositions();
      }
      
      public function get light() : PointLight3D
      {
         return _light;
      }
      
      public function clearViewPositions() : void
      {
         viewPositions = new Dictionary(true);
      }
      
      public function set light(param1:PointLight3D) : void
      {
         _light = param1;
         param1.addOnSceneTransformChange(updatePosition);
      }
   }
}


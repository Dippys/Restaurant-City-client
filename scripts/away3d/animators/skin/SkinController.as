package away3d.animators.skin
{
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.math.*;
   
   public class SkinController
   {
      
      public var sceneTransform:Matrix3D = new Matrix3D();
      
      public var joint:ObjectContainer3D;
      
      public var name:String;
      
      public var updated:Boolean;
      
      public var inverseTransform:Matrix3D;
      
      public var bindMatrix:Matrix3D;
      
      public function SkinController()
      {
         super();
      }
      
      public function update() : void
      {
         if(!joint)
         {
            return;
         }
         if(!joint.scene.updatedObjects[joint])
         {
            updated = false;
            return;
         }
         updated = true;
         sceneTransform.multiply(joint.sceneTransform,bindMatrix);
         sceneTransform.multiply(inverseTransform,sceneTransform);
      }
   }
}


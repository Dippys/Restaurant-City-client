package away3d.core.traverse
{
   import away3d.core.base.Object3D;
   import away3d.core.light.ILightProvider;
   
   public class LightTraverser extends Traverser
   {
      
      public function LightTraverser()
      {
         super();
      }
      
      override public function match(param1:Object3D) : Boolean
      {
         return param1.visible;
      }
      
      override public function apply(param1:Object3D) : void
      {
         if(param1.ownLights)
         {
            param1.lightarray.clear();
         }
         if(param1 is ILightProvider)
         {
            (param1 as ILightProvider).light(param1.parent.lightarray);
         }
      }
   }
}


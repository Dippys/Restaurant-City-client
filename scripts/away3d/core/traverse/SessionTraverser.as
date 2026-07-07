package away3d.core.traverse
{
   import away3d.core.base.Object3D;
   
   public class SessionTraverser extends Traverser
   {
      
      public function SessionTraverser()
      {
         super();
      }
      
      override public function match(param1:Object3D) : Boolean
      {
         return param1.visible;
      }
      
      override public function apply(param1:Object3D) : void
      {
         param1.updateSession();
      }
   }
}


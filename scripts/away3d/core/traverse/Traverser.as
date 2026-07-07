package away3d.core.traverse
{
   import away3d.core.base.Object3D;
   
   public class Traverser
   {
      
      public function Traverser()
      {
         super();
      }
      
      public function enter(param1:Object3D) : void
      {
      }
      
      public function match(param1:Object3D) : Boolean
      {
         return true;
      }
      
      public function apply(param1:Object3D) : void
      {
      }
      
      public function leave(param1:Object3D) : void
      {
      }
   }
}


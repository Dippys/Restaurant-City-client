package away3d.core.traverse
{
   import away3d.core.base.Object3D;
   
   public class TickTraverser extends Traverser
   {
      
      public var now:int;
      
      public function TickTraverser()
      {
         super();
      }
      
      override public function enter(param1:Object3D) : void
      {
         param1.tick(now);
      }
   }
}


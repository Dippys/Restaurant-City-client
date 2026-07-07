package away3d.blockers
{
   import away3d.core.base.Object3D;
   import away3d.core.project.ProjectorType;
   
   public class ConvexBlock extends Object3D
   {
      
      public var vertices:Array = [];
      
      public var debug:Boolean;
      
      public function ConvexBlock(param1:Array, param2:Object = null)
      {
         super(param2);
         this.vertices = param1;
         debug = ini.getBoolean("debug",false);
         projectorType = ProjectorType.CONVEX_BLOCK;
      }
   }
}


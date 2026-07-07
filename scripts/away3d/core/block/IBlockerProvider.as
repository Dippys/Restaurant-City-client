package away3d.core.block
{
   import away3d.core.base.Object3D;
   import away3d.core.math.Matrix3D;
   
   public interface IBlockerProvider
   {
      
      function blockers(param1:Object3D, param2:Matrix3D, param3:IBlockerConsumer) : void;
   }
}


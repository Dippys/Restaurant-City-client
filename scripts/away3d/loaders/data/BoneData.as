package away3d.loaders.data
{
   import away3d.core.math.Matrix3D;
   
   public class BoneData extends ContainerData
   {
      
      public var jointTransform:Matrix3D = new Matrix3D();
      
      public function BoneData()
      {
         super();
      }
   }
}


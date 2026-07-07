package away3d.loaders.data
{
   import away3d.core.math.Matrix3D;
   
   public class ObjectData
   {
      
      public var name:String;
      
      public var scale:Number;
      
      public var id:String;
      
      public var transform:Matrix3D = new Matrix3D();
      
      public function ObjectData()
      {
         super();
      }
   }
}


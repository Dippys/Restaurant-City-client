package away3d.loaders.data
{
   import away3d.containers.ObjectContainer3D;
   
   public class ContainerData extends ObjectData
   {
      
      public var container:ObjectContainer3D;
      
      public var children:Array = [];
      
      public function ContainerData()
      {
         super();
      }
   }
}


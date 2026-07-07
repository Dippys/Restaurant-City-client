package away3d.core.utils
{
   import away3d.core.base.Billboard;
   import away3d.core.base.Vertex;
   import away3d.materials.IBillboardMaterial;
   
   public class BillboardVO
   {
      
      public var vertex:Vertex;
      
      public var width:Number;
      
      public var material:IBillboardMaterial;
      
      public var scaling:Number;
      
      public var command:String;
      
      public var billboard:Billboard;
      
      public var rotation:Number;
      
      public var height:Number;
      
      public function BillboardVO()
      {
         super();
      }
   }
}


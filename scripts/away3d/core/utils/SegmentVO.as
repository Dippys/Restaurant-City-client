package away3d.core.utils
{
   import away3d.core.base.Vertex;
   import away3d.materials.ISegmentMaterial;
   
   public class SegmentVO
   {
      
      public var material:ISegmentMaterial;
      
      public var commands:Array = new Array();
      
      public var generated:Boolean;
      
      public var vertices:Array = new Array();
      
      public var v0:Vertex;
      
      public var v1:Vertex;
      
      public function SegmentVO()
      {
         super();
      }
   }
}


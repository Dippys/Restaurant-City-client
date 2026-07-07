package away3d.loaders.data
{
   import away3d.core.base.Geometry;
   
   public class GeometryData
   {
      
      public var uvs:Array = [];
      
      public var maxZ:Number;
      
      public var geoXML:XML;
      
      public var minY:Number;
      
      public var minZ:Number;
      
      public var name:String;
      
      public var minX:Number;
      
      public var skinVertices:Array = [];
      
      public var skinControllers:Array = [];
      
      public var bothsides:Boolean;
      
      public var materials:Array = [];
      
      public var geometry:Geometry;
      
      public var maxX:Number;
      
      public var maxY:Number;
      
      public var faces:Array = [];
      
      public var vertices:Array = [];
      
      public var ctrlXML:XML;
      
      public function GeometryData()
      {
         super();
      }
   }
}


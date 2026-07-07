package away3d.core.base
{
   import away3d.core.geom.Plane3D;
   
   public class VertexClassification
   {
      
      public var vertex:Vertex;
      
      public var distance:Number;
      
      public var plane:Plane3D;
      
      public function VertexClassification()
      {
         super();
      }
      
      public function getDistance(param1:Plane3D) : Number
      {
         var _loc2_:Number = param1.distance(vertex.position);
         if(_loc2_ < 0 && !isNaN(_loc2_))
         {
            plane = param1;
            distance = _loc2_;
         }
         return _loc2_;
      }
   }
}


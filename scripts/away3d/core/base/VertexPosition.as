package away3d.core.base
{
   import away3d.core.math.*;
   
   public class VertexPosition
   {
      
      public var vertex:Vertex;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function VertexPosition(param1:Vertex)
      {
         super();
         this.vertex = param1;
         this.x = 0;
         this.y = 0;
         this.z = 0;
      }
      
      public function add(param1:Number3D) : void
      {
         vertex.add(param1);
      }
      
      public function transform(param1:Matrix3D) : void
      {
         vertex.transform(param1);
      }
      
      public function adjust(param1:Number = 1) : void
      {
         vertex.adjust(x,y,z,param1);
      }
      
      public function reset() : void
      {
         vertex.reset();
      }
      
      public function getIndex(param1:Array) : int
      {
         var _loc2_:Number = vertex.x;
         var _loc3_:Number = vertex.y;
         var _loc4_:Number = vertex.z;
         vertex.x = NaN;
         vertex.y = NaN;
         vertex.z = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            if(isNaN(param1[_loc6_].x) && isNaN(param1[_loc6_].y) && isNaN(param1[_loc6_].z))
            {
               _loc5_ = _loc6_;
               break;
            }
            _loc6_++;
         }
         vertex.x = _loc2_;
         vertex.y = _loc3_;
         vertex.z = _loc4_;
         return _loc5_;
      }
   }
}


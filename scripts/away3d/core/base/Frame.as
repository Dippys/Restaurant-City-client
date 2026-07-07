package away3d.core.base
{
   public class Frame implements IFrame
   {
      
      public var vertexpositions:Array = [];
      
      public function Frame()
      {
         super();
      }
      
      public function getIndexes(param1:Array) : Array
      {
         var _loc3_:VertexPosition = null;
         var _loc2_:Array = [];
         for each(_loc3_ in vertexpositions)
         {
            _loc2_.push(_loc3_.getIndex(param1));
         }
         return _loc2_;
      }
      
      public function adjust(param1:Number = 1) : void
      {
         var _loc2_:VertexPosition = null;
         for each(_loc2_ in vertexpositions)
         {
            _loc2_.adjust(param1);
         }
      }
   }
}


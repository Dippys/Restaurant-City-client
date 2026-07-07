package away3d.core.base
{
   public class DrawingCommand
   {
      
      public static const MOVE:String = "M";
      
      public static const LINE:String = "L";
      
      public static const CURVE:String = "C";
      
      public var type:String;
      
      public var pStart:Vertex;
      
      public var pEnd:Vertex;
      
      public var pControl:Vertex;
      
      public function DrawingCommand(param1:String, param2:Vertex, param3:Vertex, param4:Vertex)
      {
         super();
         this.type = param1;
         this.pStart = param2;
         this.pControl = param3;
         this.pEnd = param4;
      }
      
      public function toString() : String
      {
         return "DrawingCommand: " + type + ", " + pStart + ", " + pControl + ", " + pEnd;
      }
   }
}


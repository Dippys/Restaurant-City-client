package away3d.core.geom
{
   import away3d.core.draw.ScreenVertex;
   
   public class Line2D
   {
      
      public var a:Number;
      
      public var c:Number;
      
      public var b:Number;
      
      public function Line2D(param1:Number, param2:Number, param3:Number)
      {
         super();
         this.a = param1;
         this.b = param2;
         this.c = param3;
      }
      
      public static function cross(param1:Line2D, param2:Line2D) : ScreenVertex
      {
         var _loc3_:Number = param1.a * param2.b - param1.b * param2.a;
         var _loc4_:Number = param1.b * param2.c - param1.c * param2.b;
         var _loc5_:Number = param2.a * param1.c - param1.a * param2.c;
         return new ScreenVertex(_loc4_ / _loc3_,_loc5_ / _loc3_,0);
      }
      
      public static function from2points(param1:Number, param2:Number, param3:Number, param4:Number) : Line2D
      {
         var _loc5_:Number = param4 - param2;
         var _loc6_:Number = param1 - param3;
         var _loc7_:Number = -(_loc6_ * param2 + _loc5_ * param1);
         return new Line2D(_loc5_,_loc6_,_loc7_);
      }
      
      public function distance(param1:ScreenVertex) : Number
      {
         return sideV(param1) / Math.sqrt(a * a + b * b);
      }
      
      public function side(param1:Number, param2:Number) : Number
      {
         return a * param1 + b * param2 + c;
      }
      
      public function toString() : String
      {
         return "line{ a: " + a + " b: " + b + " c:" + c + " }";
      }
      
      public function sideV(param1:ScreenVertex) : Number
      {
         return a * param1.x + b * param1.y + c;
      }
   }
}


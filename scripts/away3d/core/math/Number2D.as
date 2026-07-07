package away3d.core.math
{
   public final class Number2D
   {
      
      public static var LEFT:Number2D = new Number2D(-1,0);
      
      public static var RIGHT:Number2D = new Number2D(1,0);
      
      public static var UP:Number2D = new Number2D(0,1);
      
      public static var DOWN:Number2D = new Number2D(0,-1);
      
      public var x:Number;
      
      public var y:Number;
      
      public function Number2D(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
      
      public static function sub(param1:Number2D, param2:Number2D) : Number2D
      {
         return new Number2D(param1.x - param2.x,param1.y - param2.y);
      }
      
      public static function add(param1:Number3D, param2:Number3D) : Number2D
      {
         return new Number2D(param1.x + param2.x,param1.y + param2.y);
      }
      
      public static function scale(param1:Number2D, param2:Number) : Number2D
      {
         return new Number2D(param1.x * param2,param1.y * param2);
      }
      
      public static function dot(param1:Number2D, param2:Number2D) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public function normalize() : void
      {
         var _loc1_:Number = modulo;
         if(_loc1_ != 0 && _loc1_ != 1)
         {
            this.x /= _loc1_;
            this.y /= _loc1_;
         }
      }
      
      public function get modulo() : Number
      {
         return Math.sqrt(x * x + y * y);
      }
      
      public function toString() : String
      {
         return "x:" + x + " y:" + y;
      }
      
      public function clone() : Number2D
      {
         return new Number2D(x,y);
      }
   }
}


package away3d.core.utils
{
   public class Color
   {
      
      public static const white:int = 16777215;
      
      public static const black:int = 0;
      
      public static const red:int = 16711680;
      
      public static const green:int = 65280;
      
      public static const blue:int = 255;
      
      public static const yellow:int = 16776960;
      
      public static const cyan:int = 65535;
      
      public static const purple:int = 16711935;
      
      public function Color()
      {
         super();
      }
      
      public static function inverseAdd(param1:int, param2:int) : int
      {
         var _loc3_:int = 255 - param1 & 16711680 >> 16;
         var _loc4_:int = 255 - param1 & 65280 >> 8;
         var _loc5_:int = 255 - param1 & 0xFF;
         var _loc6_:int = 255 - param2 & 16711680 >> 16;
         var _loc7_:int = 255 - param2 & 65280 >> 8;
         var _loc8_:int = 255 - param2 & 0xFF;
         return fromIntsCheck(255 - (_loc3_ + _loc6_),255 - (_loc4_ + _loc7_),255 - (_loc5_ + _loc8_));
      }
      
      public static function add(param1:int, param2:int) : int
      {
         var _loc3_:int = param1 & 16711680 >> 16;
         var _loc4_:int = param1 & 65280 >> 8;
         var _loc5_:int = param1 & 0xFF;
         var _loc6_:int = param2 & 16711680 >> 16;
         var _loc7_:int = param2 & 65280 >> 8;
         var _loc8_:int = param2 & 0xFF;
         return fromIntsCheck(_loc3_ + _loc6_,_loc4_ + _loc7_,_loc5_ + _loc8_);
      }
      
      public static function multiply(param1:int, param2:Number) : int
      {
         var _loc3_:int = param1 & 16711680 >> 16;
         var _loc4_:int = param1 & 65280 >> 8;
         var _loc5_:int = param1 & 0xFF;
         return fromIntsCheck(int(_loc3_ * param2),int(_loc4_ * param2),int(_loc5_ * param2));
      }
      
      public static function fromIntsCheck(param1:int, param2:int, param3:int) : int
      {
         param1 = Math.max(0,Math.min(255,param1));
         param2 = Math.max(0,Math.min(255,param2));
         param3 = Math.max(0,Math.min(255,param3));
         return 65536 * param1 + 256 * param2 + param3;
      }
      
      public static function fromFloats(param1:Number, param2:Number, param3:Number) : int
      {
         return 65536 * int(param1 * 255) + 256 * int(param2 * 255) + int(param3 * 255);
      }
      
      public static function fromInts(param1:int, param2:int, param3:int) : int
      {
         return 65536 * param1 + 256 * param2 + param3;
      }
      
      public static function fromHSV(param1:Number, param2:Number, param3:Number) : int
      {
         var _loc4_:Number = (param1 % 360 + 360) % 360;
         var _loc5_:Number = param2;
         var _loc6_:Number = param3;
         var _loc7_:int = int(_loc4_ / 60) % 6;
         var _loc8_:Number = _loc4_ / 60 - _loc7_;
         var _loc9_:Number = _loc6_ * (1 - _loc5_);
         var _loc10_:Number = _loc6_ * (1 - _loc8_ * _loc5_);
         var _loc11_:Number = _loc6_ * (1 - (1 - _loc8_) * _loc5_);
         switch(_loc7_)
         {
            case 0:
               return fromFloats(_loc6_,_loc11_,_loc9_);
            case 1:
               return fromFloats(_loc10_,_loc6_,_loc9_);
            case 2:
               return fromFloats(_loc9_,_loc6_,_loc11_);
            case 3:
               return fromFloats(_loc9_,_loc10_,_loc6_);
            case 4:
               return fromFloats(_loc11_,_loc9_,_loc6_);
            case 5:
               return fromFloats(_loc6_,_loc9_,_loc10_);
            default:
               return 0;
         }
      }
   }
}


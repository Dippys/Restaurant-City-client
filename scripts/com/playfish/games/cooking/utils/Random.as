package com.playfish.games.cooking.utils
{
   import flash.utils.ByteArray;
   
   public class Random
   {
      
      private static const MULTIPLIER_HIGH:uint = 5;
      
      private static const MULTIPLIER_MID:uint = 57068;
      
      private static const MULTIPLIER_LOW:uint = 58989;
      
      private static const ADDEND:uint = 11;
      
      private static var seedExtra:uint = 2353648897;
      
      private var seedLow:uint;
      
      private var seedMid:uint;
      
      private var seedHigh:uint;
      
      public function Random(param1:uint = 2147483648, param2:uint = 0)
      {
         var _loc3_:ByteArray = null;
         super();
         if(param1 == 2147483648 && param2 == 0)
         {
            _loc3_ = new ByteArray();
            _loc3_.writeDouble(new Date().time);
            _loc3_.position = 0;
            param1 = _loc3_.readUnsignedInt() + seedExtra;
            param2 = _loc3_.readUnsignedInt() + (param1 >>> 16);
            ++seedExtra;
         }
         setSeed(param1,param2);
      }
      
      private function next(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = seedLow * MULTIPLIER_LOW;
         _loc2_ = seedLow * MULTIPLIER_HIGH + seedMid * MULTIPLIER_MID + seedHigh * MULTIPLIER_LOW;
         _loc3_ = seedLow * MULTIPLIER_MID;
         _loc2_ += _loc3_ >>> 16;
         _loc3_ &= 65535;
         _loc3_ += seedMid * MULTIPLIER_LOW;
         _loc2_ += _loc3_ >>> 16;
         _loc3_ &= 65535;
         _loc3_ += _loc4_ >>> 16;
         _loc2_ += _loc3_ >>> 16;
         _loc4_ &= 65535;
         _loc3_ &= 65535;
         _loc2_ &= 65535;
         _loc4_ += ADDEND;
         _loc3_ += _loc4_ >>> 16;
         _loc2_ += _loc3_ >>> 16;
         _loc4_ &= 65535;
         _loc3_ &= 65535;
         _loc2_ &= 65535;
         seedLow = _loc4_;
         seedMid = _loc3_;
         seedHigh = _loc2_;
         if(param1 == 0)
         {
            return 0;
         }
         return (_loc2_ << 16 | _loc3_) >>> 32 - param1;
      }
      
      public function setSeed(param1:uint, param2:uint) : void
      {
         this.seedHigh = param1 & 0xFFFF ^ MULTIPLIER_HIGH;
         this.seedMid = param2 >> 16 & 0xFFFF ^ MULTIPLIER_MID;
         this.seedLow = param2 & 0xFFFF ^ MULTIPLIER_LOW;
      }
      
      public function nextInt(param1:int) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 == 0 || (param1 & 0x80000000) != 0)
         {
            throw new Error();
         }
         if((param1 & -param1) == param1)
         {
            _loc2_ = 0;
            if((param1 & 0xFFFF0000) != 0)
            {
               _loc2_ += 16;
            }
            if((param1 & 0xFF00FF00) != 0)
            {
               _loc2_ += 8;
            }
            if((param1 & 0xF0F0F0F0) != 0)
            {
               _loc2_ += 4;
            }
            if((param1 & 0xCCCCCCCC) != 0)
            {
               _loc2_ += 2;
            }
            if((param1 & 0xAAAAAAAA) != 0)
            {
               _loc2_ += 1;
            }
            return next(_loc2_);
         }
         do
         {
            _loc2_ = next(31);
            _loc3_ = _loc2_ % param1;
         }
         while(_loc2_ - _loc3_ + param1 - 1 < 0);
         return _loc3_;
      }
   }
}


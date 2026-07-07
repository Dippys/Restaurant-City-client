package com.playfish.stream.hurlant.crypto
{
   import flash.utils.ByteArray;
   
   public class ARC4
   {
      
      private var i:int = 0;
      
      private var j:int = 0;
      
      private const psize:uint = 256;
      
      private var S:ByteArray;
      
      public function ARC4(param1:ByteArray = null)
      {
         super();
         S = new ByteArray();
         if(param1)
         {
            init(param1);
         }
      }
      
      public function encrypt(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            var _temp_2:* = param1;
            var _loc3_:uint = _loc2_++;
            _temp_2[_loc3_] ^= next();
         }
      }
      
      public function next() : uint
      {
         var _loc1_:int = 0;
         i = i + 1 & 0xFF;
         j = j + S[i] & 0xFF;
         _loc1_ = int(S[i]);
         S[i] = S[j];
         S[j] = _loc1_;
         return S[_loc1_ + S[i] & 0xFF];
      }
      
      public function toString() : String
      {
         return "rc4";
      }
      
      public function decrypt(param1:ByteArray) : void
      {
         encrypt(param1);
      }
      
      public function init(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 256)
         {
            S[_loc2_] = _loc2_;
            _loc2_++;
         }
         _loc3_ = 0;
         _loc2_ = 0;
         while(_loc2_ < 256)
         {
            _loc3_ = _loc3_ + S[_loc2_] + param1[_loc2_ % param1.length] & 0xFF;
            _loc4_ = int(S[_loc2_]);
            S[_loc2_] = S[_loc3_];
            S[_loc3_] = _loc4_;
            _loc2_++;
         }
         this.i = 0;
         this.j = 0;
      }
      
      public function getBlockSize() : uint
      {
         return 1;
      }
      
      public function getPoolSize() : uint
      {
         return psize;
      }
      
      public function dispose() : void
      {
         var _loc1_:uint = 0;
         if(S != null)
         {
            _loc1_ = 0;
            while(_loc1_ < S.length)
            {
               S[_loc1_] = Math.random() * 256;
               _loc1_++;
            }
            S.length = 0;
            S = null;
         }
         this.i = 0;
         this.j = 0;
         Memory.gc();
      }
   }
}


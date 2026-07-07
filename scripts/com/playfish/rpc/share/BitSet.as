package com.playfish.rpc.share
{
   import flash.utils.ByteArray;
   
   public class BitSet
   {
      
      internal var bits:ByteArray;
      
      public function BitSet()
      {
         super();
         bits = new ByteArray();
      }
      
      public function set(param1:uint, param2:uint = 0, param3:Boolean = true) : void
      {
         if(param2 == 0)
         {
            _set(param1,param3);
            return;
         }
         var _loc4_:uint = param1;
         while(_loc4_ < param2)
         {
            _set(_loc4_,param3);
            _loc4_++;
         }
      }
      
      private function _set(param1:uint, param2:Boolean) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc3_:uint = param1 / 8;
         var _loc4_:uint = 7 - param1 % 8;
         var _loc5_:ByteArray = new ByteArray();
         if(bits.length <= _loc3_)
         {
            if(!param2)
            {
               return;
            }
            _loc6_ = _loc3_ - bits.length;
            _loc5_.writeBytes(bits);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc5_.writeByte(0);
               _loc7_++;
            }
            _loc5_.writeByte(1 << _loc4_);
         }
         else
         {
            if(_loc3_ != 0)
            {
               _loc5_.writeBytes(bits,0,_loc3_);
            }
            if(param2)
            {
               _loc5_.writeByte(bits[_loc3_] | 1 << _loc4_);
            }
            else
            {
               _loc5_.writeByte(~(~bits[_loc3_] | 1 << _loc4_));
            }
            if(_loc3_ < bits.length - 1)
            {
               _loc5_.writeBytes(bits,_loc3_ + 1,bits.length - _loc3_ - 1);
            }
         }
         setArray(_loc5_);
      }
      
      public function length() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < bits.length * 8)
         {
            if(get(_loc2_))
            {
               _loc1_ = _loc2_;
            }
            _loc2_++;
         }
         return _loc1_ + 1;
      }
      
      private function getBitString(param1:ByteArray) : String
      {
         var _loc4_:uint = 0;
         var _loc2_:String = "";
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = uint(param1[_loc3_]);
            _loc2_ += _loc4_ >> 7 & 1;
            _loc2_ += _loc4_ >> 6 & 1;
            _loc2_ += _loc4_ >> 5 & 1;
            _loc2_ += _loc4_ >> 4 & 1;
            _loc2_ += _loc4_ >> 3 & 1;
            _loc2_ += _loc4_ >> 2 & 1;
            _loc2_ += _loc4_ >> 1 & 1;
            _loc2_ += _loc4_ & 1;
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function isEmpty() : Boolean
      {
         return bits.length == 0;
      }
      
      public function cardinality() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < bits.length * 8)
         {
            if(get(_loc2_))
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function clear(param1:uint = 0, param2:uint = 0) : void
      {
         if(param1 == 0 && param2 == 0)
         {
            bits = new ByteArray();
            return;
         }
         if(param2 == 0)
         {
            _set(param1,false);
            return;
         }
         var _loc3_:uint = param1;
         while(_loc3_ < param2)
         {
            _set(_loc3_,false);
            _loc3_++;
         }
      }
      
      public function get(param1:uint) : Boolean
      {
         var _loc2_:int = param1 / 8;
         var _loc3_:int = 7 - param1 % 8;
         if(bits.length < _loc2_)
         {
            return false;
         }
         return Boolean(bits[_loc2_] >> _loc3_ & 1);
      }
      
      internal function setArray(param1:ByteArray) : void
      {
         this.bits = param1;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[bits=";
         _loc1_ += getBitString(bits);
         return _loc1_ + "]";
      }
      
      public function clone() : BitSet
      {
         var _loc1_:BitSet = new BitSet();
         _loc1_.bits.writeBytes(bits);
         return _loc1_;
      }
   }
}


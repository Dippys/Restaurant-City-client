package com.playfish.games.cooking.utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ProtectedInt
   {
      
      private static var rnd:Random = new Random();
      
      public static const EVENT_CHECKSUM_MISMATCH:String = "checksum_mismatch";
      
      private static var eventDispatcher:EventDispatcher = new EventDispatcher();
      
      private static const ENCRYPT_CONST:int = 286331153;
      
      private static const CONSTANT:int = int(new Date().time);
      
      private static const POLY:uint = 3172090281;
      
      private static const RPOLY:int = (POLY << 1) + 1;
      
      private static const ROUNDS:int = 10;
      
      private var checksum:int;
      
      private var _value:int;
      
      public function ProtectedInt(param1:int = 0)
      {
         super();
         _value = encode(param1);
         checksum = getChecksum(_value);
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         eventDispatcher.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         eventDispatcher.removeEventListener(param1,param2);
      }
      
      private function getChecksum(param1:int) : int
      {
         param1 += ENCRYPT_CONST;
         var _loc2_:Number = 0;
         while(_loc2_ < 10)
         {
            param1 = param1 >> 1 ^ (param1 & 1) * 2567483615;
            _loc2_++;
         }
         return param1;
      }
      
      public function get value() : int
      {
         return decode(_value);
      }
      
      public function set value(param1:int) : void
      {
         if(isValid())
         {
            _value = encode(param1);
            checksum = getChecksum(_value);
         }
         else
         {
            checksum += rnd.nextInt(1000000) + 1000000;
            if(eventDispatcher.hasEventListener("checksum_mismatch"))
            {
               eventDispatcher.dispatchEvent(new Event("checksum_mismatch"));
            }
         }
      }
      
      private function encode(param1:int) : int
      {
         param1 += CONSTANT;
         var _loc2_:int = 0;
         while(_loc2_ < ROUNDS)
         {
            if((param1 & 1) != 0)
            {
               param1 = param1 >>> 1 ^ POLY;
            }
            else
            {
               param1 >>>= 1;
            }
            _loc2_++;
         }
         return param1;
      }
      
      private function decode(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < ROUNDS)
         {
            if((param1 & 0x80000000) != 0)
            {
               param1 = param1 << 1 ^ RPOLY;
            }
            else
            {
               param1 <<= 1;
            }
            _loc2_++;
         }
         return param1 - CONSTANT;
      }
      
      public function isValid() : Boolean
      {
         return getChecksum(_value) == checksum;
      }
   }
}


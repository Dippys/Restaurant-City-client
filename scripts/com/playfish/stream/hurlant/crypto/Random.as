package com.playfish.stream.hurlant.crypto
{
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.text.Font;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class Random
   {
      
      private var ready:Boolean = false;
      
      private var pool:ByteArray;
      
      private var seeded:Boolean = false;
      
      private var psize:int;
      
      private var state:IPRNG;
      
      private var pptr:int;
      
      public function Random(param1:Class = null)
      {
         var _loc2_:uint = 0;
         super();
         if(param1 == null)
         {
            param1 = ARC4;
         }
         state = new param1() as IPRNG;
         psize = state.getPoolSize();
         pool = new ByteArray();
         pptr = 0;
         while(pptr < psize)
         {
            _loc2_ = 65536 * Math.random();
            pool[pptr++] = _loc2_ >>> 8;
            var _loc4_:Number;
            pool[_loc4_ = pptr++] = _loc2_ & 0xFF;
         }
         pptr = 0;
         seed();
      }
      
      public function autoSeed() : void
      {
         var _loc3_:Font = null;
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUnsignedInt(System.totalMemory);
         _loc1_.writeUTF(Capabilities.serverString);
         _loc1_.writeUnsignedInt(getTimer());
         _loc1_.writeUnsignedInt(new Date().getTime());
         var _loc2_:Array = Font.enumerateFonts(true);
         for each(_loc3_ in _loc2_)
         {
            _loc1_.writeUTF(_loc3_.fontName);
            _loc1_.writeUTF(_loc3_.fontStyle);
            _loc1_.writeUTF(_loc3_.fontType);
         }
         _loc1_.position = 0;
         while(_loc1_.bytesAvailable >= 4)
         {
            seed(_loc1_.readUnsignedInt());
         }
      }
      
      public function seed(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            param1 = new Date().getTime();
         }
         var _temp_3:* = pool;
         var _loc2_:Number = pptr++;
         _temp_3[_loc2_] ^= param1 & 0xFF;
         var _temp_6:* = pool;
         var _loc3_:Number = pptr++;
         _temp_6[_loc3_] ^= param1 >> 8 & 0xFF;
         var _loc4_:Number;
         pool[_loc4_ = pptr++] = pool[_loc4_] ^ param1 >> 16 & 0xFF;
         var _loc5_:Number;
         pool[_loc5_ = pptr++] = pool[_loc5_] ^ param1 >> 24 & 0xFF;
         pptr %= psize;
         seeded = true;
      }
      
      public function toString() : String
      {
         return "random-" + state.toString();
      }
      
      public function dispose() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < pool.length)
         {
            pool[_loc1_] = Math.random() * 256;
            _loc1_++;
         }
         pool.length = 0;
         pool = null;
         state.dispose();
         state = null;
         psize = 0;
         pptr = 0;
         Memory.gc();
      }
      
      public function nextBytes(param1:ByteArray, param2:int) : void
      {
         while(param2--)
         {
            param1.writeByte(nextByte());
         }
      }
      
      public function nextByte() : int
      {
         if(!ready)
         {
            if(!seeded)
            {
               autoSeed();
            }
            state.init(pool);
            pool.length = 0;
            pptr = 0;
            ready = true;
         }
         return state.next();
      }
   }
}


package com.playfish.rpc.share
{
   import flash.utils.ByteArray;
   
   internal class TimingData
   {
      
      internal var token:ByteArray;
      
      internal var rtt:uint;
      
      public function TimingData(param1:ByteArray, param2:uint)
      {
         super();
         this.token = param1;
         this.rtt = param2;
      }
   }
}


package com.playfish.rpc.share
{
   public class NetworkUid
   {
      
      public static const FACEBOOK:uint = 2;
      
      public static const MYSPACE:uint = 3;
      
      public static const BEBO:uint = 4;
      
      public static const YAHOO:uint = 5;
      
      public static const NETLOG:uint = 6;
      
      public static const IGOOGLE:uint = 7;
      
      public static const INTERNAL_USER:uint = 4294967295;
      
      internal var _networkUid:String;
      
      internal var _playfishUid:uint;
      
      internal var _network:uint;
      
      public function NetworkUid(param1:uint, param2:String, param3:uint)
      {
         super();
         this._network = param1;
         this._networkUid = param2;
         this._playfishUid = param3;
      }
      
      public static function areEqual(param1:NetworkUid, param2:NetworkUid) : Boolean
      {
         return param1._network == param2._network && param1._networkUid == param2._networkUid;
      }
      
      public static function create(param1:uint, param2:String) : NetworkUid
      {
         return new NetworkUid(param1,param2,0);
      }
      
      public function get playfishUid() : uint
      {
         return _playfishUid;
      }
      
      public function get networkUid() : String
      {
         return _networkUid;
      }
      
      public function toString() : String
      {
         return _network + ":" + _networkUid;
      }
      
      public function get network() : uint
      {
         return _network;
      }
      
      public function get seed() : uint
      {
         var _loc1_:uint = 1480002569 + _network * 3571;
         var _loc2_:uint = 0;
         while(_loc2_ < _networkUid.length)
         {
            _loc1_ = _loc1_ * 23 + _networkUid.charCodeAt(_loc2_);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}


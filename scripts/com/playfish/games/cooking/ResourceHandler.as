package com.playfish.games.cooking
{
   import flash.events.*;
   import flash.net.*;
   
   public class ResourceHandler extends URLLoader
   {
      
      private var resPath:Object;
      
      private var networkResPath:Object;
      
      public var network:String;
      
      public function ResourceHandler(param1:String, param2:String)
      {
         super(new URLRequest(param1));
         this.addEventListener(Event.COMPLETE,onComplete);
         this.network = param2;
      }
      
      public function getResUrl(param1:String) : String
      {
         var _loc6_:Object = null;
         var _loc2_:String = networkResPath[network].src;
         var _loc3_:String = networkResPath[network].name;
         var _loc4_:Array = resPath[_loc3_];
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc6_.name == param1 && _loc6_.network == network)
            {
               return _loc2_ + _loc6_.src;
            }
            _loc5_++;
         }
         return null;
      }
      
      private function onComplete(param1:Event) : void
      {
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:XML = null;
         var _loc12_:Object = null;
         var _loc2_:XML = new XML(param1.currentTarget.data);
         var _loc3_:XMLList = _loc2_.paths;
         var _loc4_:XMLList = _loc2_.resources;
         networkResPath = new Object();
         for each(_loc5_ in _loc3_.path)
         {
            _loc7_ = new Object();
            _loc7_["name"] = _loc5_.attribute("name").toString();
            _loc7_["src"] = _loc5_.attribute("src").toString();
            _loc8_ = _loc5_.attribute("network").toString();
            networkResPath[_loc8_] = _loc7_;
         }
         resPath = new Object();
         for each(_loc6_ in _loc4_)
         {
            _loc9_ = new Array();
            _loc10_ = _loc6_.attribute("path").toString();
            resPath[_loc10_] = _loc9_;
            for each(_loc11_ in _loc6_.resource)
            {
               _loc12_ = new Object();
               _loc12_["name"] = _loc11_.attribute("name").toString();
               _loc12_["network"] = _loc11_.attribute("network").toString();
               _loc12_["src"] = _loc11_.attribute("src").toString();
               _loc9_.push(_loc12_);
            }
         }
      }
   }
}


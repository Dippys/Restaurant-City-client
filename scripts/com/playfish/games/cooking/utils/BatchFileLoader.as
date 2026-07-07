package com.playfish.games.cooking.utils
{
   import com.playfish.games.cooking.Debug;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   
   public class BatchFileLoader extends EventDispatcher
   {
      
      private var urls:Array = new Array();
      
      private var loaded:Array;
      
      private var loaders:Array = new Array();
      
      private var names:Array = new Array();
      
      public var completed:Boolean = false;
      
      public function BatchFileLoader()
      {
         super();
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         Debug.out("asset " + names[loaders.indexOf(param1.currentTarget)] + " load error");
         dispatchEvent(param1);
      }
      
      public function load() : void
      {
         var _loc2_:FileLoader = null;
         var _loc1_:int = 0;
         while(_loc1_ < names.length)
         {
            _loc2_ = new FileLoader(urls[_loc1_],3);
            _loc2_.addEventListener(Event.COMPLETE,onComplete,false,0,true);
            _loc2_.addEventListener(IOErrorEvent.IO_ERROR,onIOError,false,0,true);
            loaders[_loc1_] = _loc2_;
            _loc1_++;
         }
         loaded = new Array(names.length);
      }
      
      public function getTotalBytes() : int
      {
         var _loc3_:FileLoader = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < loaders.length)
         {
            _loc3_ = loaders[_loc2_];
            _loc1_ += _loc3_.bytesTotal;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function isTotalBytesReady() : Boolean
      {
         var _loc2_:FileLoader = null;
         var _loc1_:int = 0;
         while(_loc1_ < loaders.length)
         {
            _loc2_ = loaders[_loc1_];
            if(_loc2_.bytesTotal <= 0)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function getBytes(param1:String) : ByteArray
      {
         var _loc3_:FileLoader = null;
         var _loc2_:int = names.indexOf(param1);
         if(_loc2_ != -1)
         {
            _loc3_ = loaders[_loc2_];
            return _loc3_.data;
         }
         return null;
      }
      
      public function getLoadedBytes() : int
      {
         var _loc3_:FileLoader = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < loaders.length)
         {
            _loc3_ = loaders[_loc2_];
            _loc1_ += _loc3_.bytesLoaded;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function close() : void
      {
         var _loc2_:FileLoader = null;
         var _loc1_:int = 0;
         while(_loc1_ < loaders.length)
         {
            _loc2_ = loaders[_loc1_];
            _loc2_.close();
            _loc1_++;
         }
         names.splice(0,names.length);
         urls.splice(0,urls.length);
         loaders.splice(0,loaders.length);
         loaded = null;
         completed = false;
      }
      
      public function addFile(param1:String, param2:String) : void
      {
         names.push(param1);
         urls.push(param2);
      }
      
      private function onComplete(param1:Event) : void
      {
         var _loc2_:int = loaders.indexOf(param1.currentTarget);
         Debug.out("asset " + names[_loc2_] + " loaded");
         loaded[_loc2_] = true;
         var _loc3_:int = 0;
         while(_loc3_ < loaded.length)
         {
            if(!loaded[_loc3_])
            {
               return;
            }
            _loc3_++;
         }
         completed = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}


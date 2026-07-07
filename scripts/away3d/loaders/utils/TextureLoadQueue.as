package away3d.loaders.utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   
   public class TextureLoadQueue extends EventDispatcher
   {
      
      private var _currentItemIndex:int;
      
      private var _queue:Array;
      
      public function TextureLoadQueue()
      {
         super();
         _queue = [];
      }
      
      public function get currentURLRequest() : URLRequest
      {
         return (_queue[currentItemIndex] as LoaderAndRequest).request;
      }
      
      private function calcProgress() : Number
      {
         var _loc1_:Number = currentItemIndex / numItems;
         var _loc2_:Number = calcCurrentLoaderAmountLoaded() / numItems;
         return _loc2_;
      }
      
      public function get currentItemIndex() : int
      {
         return _currentItemIndex;
      }
      
      public function start() : void
      {
         _currentItemIndex = 0;
         loadNext();
      }
      
      private function onItemComplete(param1:Event) : void
      {
         cleanUpOldItem(currentLoader);
         ++_currentItemIndex;
         loadNext();
      }
      
      public function get currentLoader() : TextureLoader
      {
         return (_queue[currentItemIndex] as LoaderAndRequest).loader;
      }
      
      private function redispatchEvent(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      public function get percentLoaded() : Number
      {
         return progress * 100;
      }
      
      private function calcCurrentLoaderAmountLoaded() : Number
      {
         if(currentLoader.contentLoaderInfo.bytesLoaded > 0)
         {
            return currentLoader.contentLoaderInfo.bytesLoaded / currentLoader.contentLoaderInfo.bytesTotal;
         }
         return 0;
      }
      
      private function cleanUpOldItem(param1:TextureLoader) : void
      {
         currentLoader.removeEventListener(Event.COMPLETE,onItemComplete,false);
         currentLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,redispatchEvent,false);
         currentLoader.removeEventListener(IOErrorEvent.IO_ERROR,redispatchEvent,false);
         currentLoader.removeEventListener(ProgressEvent.PROGRESS,redispatchEvent,false);
         currentLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,redispatchEvent,false);
      }
      
      public function get images() : Array
      {
         var _loc2_:LoaderAndRequest = null;
         var _loc1_:Array = [];
         for each(_loc2_ in _queue)
         {
            _loc1_.push(_loc2_.loader);
         }
         return _loc1_;
      }
      
      private function loadNext() : void
      {
         var _loc1_:ProgressEvent = null;
         if(_currentItemIndex >= numItems)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            _loc1_ = new ProgressEvent(ProgressEvent.PROGRESS);
            _loc1_.bytesTotal = 100;
            _loc1_.bytesLoaded = percentLoaded;
            dispatchEvent(_loc1_);
            if(!(currentLoader.contentLoaderInfo.bytesLoaded > 0 && currentLoader.contentLoaderInfo.bytesLoaded == currentLoader.contentLoaderInfo.bytesTotal))
            {
               currentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onItemComplete,false,int.MIN_VALUE,true);
               currentLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,redispatchEvent,false,0,true);
               currentLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,redispatchEvent,false,0,true);
               currentLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,redispatchEvent,false,0,true);
               currentLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,redispatchEvent,false,0,true);
               currentLoader.load(currentURLRequest);
            }
         }
      }
      
      public function get numItems() : int
      {
         return _queue.length;
      }
      
      public function addItem(param1:TextureLoader, param2:URLRequest) : void
      {
         var _loc3_:LoaderAndRequest = null;
         for each(_loc3_ in _queue)
         {
            if(_loc3_.request.url == param2.url)
            {
               return;
            }
         }
         _queue.push(new LoaderAndRequest(param1,param2));
      }
      
      public function get progress() : Number
      {
         return calcProgress();
      }
   }
}

import flash.net.URLRequest;
import away3d.loaders.utils.TextureLoader;

class LoaderAndRequest
{
   
   public var loader:TextureLoader;
   
   public var request:URLRequest;
   
   public function LoaderAndRequest(param1:TextureLoader, param2:URLRequest)
   {
      super();
      this.loader = param1;
      this.request = param2;
   }
}

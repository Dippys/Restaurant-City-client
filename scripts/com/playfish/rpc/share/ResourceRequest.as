package com.playfish.rpc.share
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   internal class ResourceRequest
   {
      
      private var loader:Loader;
      
      private var doneCallback:Function;
      
      private var url:String;
      
      private var resultArray:Array;
      
      public function ResourceRequest(param1:String, param2:Array)
      {
         super();
         this.url = param1;
         this.resultArray = param2;
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
      }
      
      private function done() : void
      {
         if(loader != null)
         {
            loader = null;
            doneCallback();
         }
      }
      
      private function errorHandler(param1:Event) : void
      {
         RpcClientBase.debug("ERROR: image load failed with event: " + param1);
         done();
      }
      
      public function toString() : String
      {
         return "[ResourceRequest: " + url + "]";
      }
      
      internal function load(param1:Function) : void
      {
         var doneCallback:Function = param1;
         this.doneCallback = doneCallback;
         try
         {
            loader.load(new URLRequest(url));
         }
         catch(e:Error)
         {
            RpcClientBase.debug("ERROR: image loading threw error: " + e);
            done();
         }
      }
      
      private function completeHandler(param1:Event) : void
      {
         RpcClientBase.debug("loadImages: complete: url=" + url);
         if(loader != null)
         {
            resultArray.push(loader);
            done();
         }
      }
      
      internal function cancel() : void
      {
         if(loader != null)
         {
            loader.close();
            loader = null;
         }
      }
   }
}


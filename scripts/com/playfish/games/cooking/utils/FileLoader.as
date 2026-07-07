package com.playfish.games.cooking.utils
{
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class FileLoader extends URLLoader
   {
      
      private var numRetries:int;
      
      public var request:URLRequest;
      
      public function FileLoader(param1:String, param2:int = 0, param3:String = "binary")
      {
         this.numRetries = param2;
         this.request = new URLRequest(param1);
         addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         super(request);
         this.dataFormat = param3;
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         if(numRetries > 0)
         {
            param1.stopImmediatePropagation();
            super.load(request);
            --numRetries;
         }
      }
   }
}


package com.playfish.coretech.engine.filesystem
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   
   public class PFReadXML extends URLLoader
   {
      
      public var xml:XML;
      
      protected var request:URLRequest;
      
      public function PFReadXML(param1:String)
      {
         super();
         xml = null;
         request = new URLRequest(param1);
         addEventListener(Event.COMPLETE,onFeedXMLLoaderComplete);
         super.load(request);
      }
      
      private function onFeedXMLLoaderComplete(param1:Event) : void
      {
         xml = new XML(param1.currentTarget.data);
         initialiseFromXML(xml);
      }
      
      public function initialiseFromXML(param1:XML) : void
      {
      }
   }
}


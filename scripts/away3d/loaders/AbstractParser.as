package away3d.loaders
{
   import away3d.arcane;
   import away3d.core.base.Object3D;
   import away3d.core.utils.Init;
   import away3d.events.ParserEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   use namespace arcane;
   
   public class AbstractParser extends EventDispatcher
   {
      
      arcane var binary:Boolean;
      
      arcane var _totalChunks:int = 0;
      
      private var _parseStart:int;
      
      arcane var _parsesuccess:ParserEvent;
      
      arcane var _parseerror:ParserEvent;
      
      public var container:Object3D;
      
      arcane var _parseprogress:ParserEvent;
      
      protected var ini:Init;
      
      public var parseTimeout:int;
      
      private var _broadcaster:Sprite = new Sprite();
      
      private var _parseTime:int;
      
      arcane var _parsedChunks:int = 0;
      
      public function AbstractParser(param1:Object = null)
      {
         super();
         ini = Init.parse(param1);
         parseTimeout = ini.getNumber("parseTimeout",40000);
      }
      
      public function removeOnSuccess(param1:Function) : void
      {
         removeEventListener(ParserEvent.PARSE_SUCCESS,param1,false);
      }
      
      public function addOnSuccess(param1:Function) : void
      {
         addEventListener(ParserEvent.PARSE_SUCCESS,param1,false,0,true);
      }
      
      public function removeOnError(param1:Function) : void
      {
         removeEventListener(ParserEvent.PARSE_ERROR,param1,false);
      }
      
      arcane function parseNext() : void
      {
         notifySuccess();
      }
      
      public function get totalChunks() : int
      {
         return _totalChunks;
      }
      
      private function update(param1:Event) : void
      {
         parseNext();
      }
      
      public function parse(param1:*) : Object3D
      {
         _broadcaster.addEventListener(Event.ENTER_FRAME,update);
         prepareData(param1);
         _parseStart = getTimer();
         parseNext();
         return container;
      }
      
      arcane function notifyProgress() : void
      {
         _parseTime = getTimer() - _parseStart;
         if(_parseTime < parseTimeout)
         {
            parseNext();
         }
         else
         {
            _parseStart = getTimer();
            if(!_parseprogress)
            {
               _parseprogress = new ParserEvent(ParserEvent.PARSE_PROGRESS,this,container);
            }
            dispatchEvent(_parseprogress);
         }
      }
      
      public function get parsedChunks() : int
      {
         return _parsedChunks;
      }
      
      arcane function prepareData(param1:*) : void
      {
      }
      
      public function removeOnProgress(param1:Function) : void
      {
         removeEventListener(ParserEvent.PARSE_PROGRESS,param1,false);
      }
      
      public function addOnError(param1:Function) : void
      {
         addEventListener(ParserEvent.PARSE_ERROR,param1,false,0,true);
      }
      
      public function addOnProgress(param1:Function) : void
      {
         addEventListener(ParserEvent.PARSE_PROGRESS,param1,false,0,true);
      }
      
      arcane function notifySuccess() : void
      {
         _broadcaster.removeEventListener(Event.ENTER_FRAME,update);
         if(!_parsesuccess)
         {
            _parsesuccess = new ParserEvent(ParserEvent.PARSE_SUCCESS,this,container);
         }
         dispatchEvent(_parsesuccess);
      }
      
      arcane function notifyError() : void
      {
         _broadcaster.removeEventListener(Event.ENTER_FRAME,update);
         if(!_parseerror)
         {
            _parseerror = new ParserEvent(ParserEvent.PARSE_ERROR,this,container);
         }
         dispatchEvent(_parseerror);
      }
   }
}


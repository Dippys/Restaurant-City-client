package com.facebook.delegates
{
   import com.facebook.data.FacebookData;
   import com.facebook.data.FacebookErrorCodes;
   import com.facebook.data.FacebookErrorReason;
   import com.facebook.data.XMLDataParser;
   import com.facebook.errors.FacebookError;
   import com.facebook.events.FacebookEvent;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.session.IFacebookSession;
   import com.facebook.session.WebSession;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.FileReference;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.utils.Timer;
   
   use namespace facebook_internal;
   
   public class WebDelegate extends EventDispatcher implements IFacebookCallDelegate
   {
      
      protected var connectTimer:Timer;
      
      protected var loader:URLLoader;
      
      protected var _session:WebSession;
      
      protected var parser:XMLDataParser;
      
      protected var fileRef:FileReference;
      
      protected var _call:FacebookCall;
      
      protected var loadTimer:Timer;
      
      public function WebDelegate(param1:FacebookCall, param2:WebSession)
      {
         super();
         this.call = param1;
         this.session = param2;
         this.parser = new XMLDataParser();
         this.connectTimer = new Timer(param1.connectTimeout,1);
         this.connectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onConnectTimeout,false,0,true);
         this.loadTimer = new Timer(param1.loadTimeout,1);
         this.loadTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onLoadTimeOut,false,0,true);
         this.execute();
      }
      
      public function set call(param1:FacebookCall) : void
      {
         this._call = param1;
      }
      
      protected function execute() : void
      {
         if(this.call == null)
         {
            throw new Error("No call defined.");
         }
         this.post();
      }
      
      protected function createURLLoader() : void
      {
         this.loader = new URLLoader();
         this.loader.addEventListener(Event.COMPLETE,this.onDataComplete);
         this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHTTPStatus);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         this.loader.addEventListener(Event.OPEN,this.onOpen);
      }
      
      protected function onOpen(param1:Event) : void
      {
         this.connectTimer.stop();
         this.loadTimer.start();
      }
      
      protected function addOptionalArguments() : void
      {
         this.call.setRequestArgument("ss",true);
      }
      
      protected function onConnectTimeout(param1:TimerEvent) : void
      {
         var _loc2_:FacebookError = new FacebookError();
         _loc2_.errorCode = FacebookErrorCodes.SERVER_ERROR;
         _loc2_.reason = FacebookErrorReason.CONNECT_TIMEOUT;
         this._call.handleError(_loc2_);
         dispatchEvent(new FacebookEvent(FacebookEvent.COMPLETE,false,false,false,null,_loc2_));
         this.loadTimer.stop();
         this.close();
      }
      
      protected function clean() : void
      {
         this.connectTimer.stop();
         this.loadTimer.stop();
         if(this.loader == null)
         {
            return;
         }
         this.loader.removeEventListener(Event.COMPLETE,this.onDataComplete);
         this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         this.loader.removeEventListener(Event.OPEN,this.onOpen);
      }
      
      protected function onDataComplete(param1:Event) : void
      {
         this.handleResult(param1.target.data as String);
      }
      
      protected function onLoadTimeOut(param1:TimerEvent) : void
      {
         this.connectTimer.stop();
         this.close();
         var _loc2_:FacebookError = new FacebookError();
         _loc2_.errorCode = FacebookErrorCodes.SERVER_ERROR;
         _loc2_.reason = FacebookErrorReason.LOAD_TIMEOUT;
         this._call.handleError(_loc2_);
         dispatchEvent(new FacebookEvent(FacebookEvent.COMPLETE,false,false,false,null,_loc2_));
      }
      
      public function get session() : IFacebookSession
      {
         return this._session;
      }
      
      protected function post() : void
      {
         this.addOptionalArguments();
         RequestHelper.formatRequest(this.call);
         this.sendRequest();
         this.connectTimer.start();
      }
      
      public function get call() : FacebookCall
      {
         return this._call;
      }
      
      protected function sendRequest() : void
      {
         this.createURLLoader();
         var _loc1_:URLRequest = new URLRequest(this._session.rest_url);
         _loc1_.contentType = "application/x-www-form-urlencoded";
         _loc1_.method = URLRequestMethod.POST;
         _loc1_.data = this.call.args;
         trace(_loc1_.url + "?" + unescape(this.call.args.toString()));
         this.loader.dataFormat = URLLoaderDataFormat.TEXT;
         this.loader.load(_loc1_);
      }
      
      protected function onError(param1:ErrorEvent) : void
      {
         this.clean();
         var _loc2_:FacebookError = this.parser.createFacebookError(param1,this.loader.data);
         this.call.handleError(_loc2_);
         dispatchEvent(new FacebookEvent(FacebookEvent.COMPLETE,false,false,false,null,_loc2_));
      }
      
      protected function handleResult(param1:String) : void
      {
         var _loc3_:FacebookData = null;
         this.clean();
         var _loc2_:FacebookError = this.parser.validateFacebookResponce(param1);
         if(_loc2_ == null)
         {
            _loc3_ = this.parser.parse(param1,this.call.method);
            this.call.handleResult(_loc3_);
         }
         else
         {
            this.call.handleError(_loc2_);
         }
      }
      
      public function close() : void
      {
         try
         {
            this.loader.close();
         }
         catch(e:*)
         {
         }
         this.connectTimer.stop();
         this.loadTimer.stop();
      }
      
      protected function onHTTPStatus(param1:HTTPStatusEvent) : void
      {
      }
      
      public function set session(param1:IFacebookSession) : void
      {
         this._session = param1 as WebSession;
      }
   }
}


package com.facebook.session
{
   import com.facebook.delegates.IFacebookCallDelegate;
   import com.facebook.delegates.VideoUploadDelegate;
   import com.facebook.delegates.WebDelegate;
   import com.facebook.delegates.WebImageUploadDelegate;
   import com.facebook.events.FacebookEvent;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.net.IUploadPhoto;
   import com.facebook.net.IUploadVideo;
   import flash.events.EventDispatcher;
   
   use namespace facebook_internal;
   
   public class WebSession extends EventDispatcher implements IFacebookSession
   {
      
      public static const REST_URL:String = "http://api.facebook.com/restserver.php";
      
      public static const VIDEO_URL:String = "http://api-video.facebook.com/restserver.php";
      
      facebook_internal var _uid:String;
      
      protected var _is_connected:Boolean = false;
      
      public var login_url:String = "http://www.facebook.com/login.php";
      
      protected var _secret:String;
      
      protected var _rest_url:String = "http://api.facebook.com/restserver.php";
      
      protected var _api_version:String = "1.0";
      
      protected var _expires:Date;
      
      protected var _session_key:String;
      
      protected var _api_key:String;
      
      public function WebSession(param1:String, param2:String, param3:String = null)
      {
         super();
         this._api_key = param1;
         this._session_key = param3;
         this.secret = param2;
      }
      
      public function get waiting_for_login() : Boolean
      {
         return false;
      }
      
      public function get rest_url() : String
      {
         return this._rest_url;
      }
      
      public function set rest_url(param1:String) : void
      {
         this._rest_url = param1;
      }
      
      public function post(param1:FacebookCall) : IFacebookCallDelegate
      {
         this.rest_url = REST_URL;
         if(param1 is IUploadPhoto)
         {
            return new WebImageUploadDelegate(param1,this);
         }
         if(param1 is IUploadVideo)
         {
            this.rest_url = VIDEO_URL;
            return new VideoUploadDelegate(param1,this);
         }
         return new WebDelegate(param1,this);
      }
      
      public function get secret() : String
      {
         return this._secret;
      }
      
      public function get expires() : Date
      {
         return this._expires;
      }
      
      public function get api_key() : String
      {
         return this._api_key;
      }
      
      public function refreshSession() : void
      {
      }
      
      public function get session_key() : String
      {
         return this._session_key;
      }
      
      public function get uid() : String
      {
         return facebook_internal::_uid;
      }
      
      public function get api_version() : String
      {
         return this._api_version;
      }
      
      public function get is_connected() : Boolean
      {
         return this._is_connected;
      }
      
      public function set secret(param1:String) : void
      {
         this._secret = param1;
      }
      
      public function verifySession() : void
      {
         if(this._session_key)
         {
            this._is_connected = true;
            dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT,false,false,true));
         }
         else
         {
            this._is_connected = false;
            dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT,false,false,false));
         }
      }
      
      public function set api_version(param1:String) : void
      {
         this._api_version = param1;
      }
      
      public function login(param1:Boolean) : void
      {
      }
      
      public function set session_key(param1:String) : void
      {
         this._session_key = param1;
      }
   }
}


package com.facebook.session
{
   import com.facebook.commands.auth.CreateToken;
   import com.facebook.commands.auth.GetSession;
   import com.facebook.commands.users.GetLoggedInUser;
   import com.facebook.data.StringResultData;
   import com.facebook.data.auth.GetSessionData;
   import com.facebook.delegates.DesktopDelegate;
   import com.facebook.delegates.IFacebookCallDelegate;
   import com.facebook.delegates.VideoUploadDelegate;
   import com.facebook.delegates.WebImageUploadDelegate;
   import com.facebook.errors.FacebookError;
   import com.facebook.events.FacebookEvent;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.net.IUploadPhoto;
   import com.facebook.net.IUploadVideo;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class DesktopSession extends WebSession implements IFacebookSession
   {
      
      protected var _auth_token:String;
      
      protected var loginRequest:IFacebookCallDelegate;
      
      protected var _waiting_for_login:Boolean = false;
      
      protected var _offline_access:Boolean = false;
      
      public function DesktopSession(param1:String, param2:String = null, param3:String = null)
      {
         super(param1,null);
         this._is_connected = false;
         this._secret = param2;
         if(param3)
         {
            this._session_key = param3;
         }
      }
      
      override public function post(param1:FacebookCall) : IFacebookCallDelegate
      {
         rest_url = REST_URL;
         if(param1 is IUploadPhoto)
         {
            return new WebImageUploadDelegate(param1,this);
         }
         if(param1 is IUploadVideo)
         {
            rest_url = VIDEO_URL;
            return new VideoUploadDelegate(param1,this);
         }
         return new DesktopDelegate(param1,this);
      }
      
      override public function get waiting_for_login() : Boolean
      {
         return this._waiting_for_login;
      }
      
      protected function onLogin(param1:FacebookEvent) : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:String = null;
         param1.target.removeEventListener(FacebookEvent.COMPLETE,this.onLogin);
         if(param1.success)
         {
            this._auth_token = (param1.data as StringResultData).value;
            _loc2_ = new URLRequest();
            _loc3_ = "?";
            if(this._offline_access)
            {
               _loc3_ += "ext_perm=offline_access&";
            }
            _loc2_.url = login_url + _loc3_ + "api_key=" + api_key + "&v=" + api_version + "&auth_token=" + this._auth_token;
            navigateToURL(_loc2_,"_blank");
            this._waiting_for_login = true;
            dispatchEvent(new FacebookEvent(FacebookEvent.WAITING_FOR_LOGIN));
         }
         else
         {
            this.onConnectionError(param1.error);
         }
      }
      
      protected function onConnectionError(param1:FacebookError) : void
      {
         _is_connected = false;
         dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT,false,false,false,null,param1));
      }
      
      protected function tokenCreated() : void
      {
         navigateToURL(new URLRequest(login_url));
      }
      
      override public function login(param1:Boolean) : void
      {
         this._offline_access = param1;
         _session_key = null;
         var _loc2_:FacebookCall = new CreateToken();
         _loc2_.session = this;
         _loc2_.facebook_internal::initialize();
         _loc2_.addEventListener(FacebookEvent.COMPLETE,this.onLogin);
         this.post(_loc2_);
      }
      
      protected function onVerifyLogin(param1:FacebookEvent) : void
      {
         var _loc2_:FacebookEvent = new FacebookEvent(FacebookEvent.CONNECT);
         _loc2_.success = param1.success;
         if(param1.success)
         {
            facebook_internal::_uid = (param1.data as StringResultData).value;
            _loc2_.data = param1.data;
            _is_connected = true;
         }
         else
         {
            _loc2_.error = param1.error;
            _is_connected = false;
         }
         dispatchEvent(_loc2_);
      }
      
      override public function verifySession() : void
      {
         var _loc1_:FacebookCall = null;
         if(_session_key)
         {
            _loc1_ = new GetLoggedInUser();
            _loc1_.session = this;
            _loc1_.facebook_internal::initialize();
            _loc1_.addEventListener(FacebookEvent.COMPLETE,this.onVerifyLogin,false,0,true);
            this.post(_loc1_);
            dispatchEvent(new FacebookEvent(FacebookEvent.VERIFYING_SESSION));
         }
         else
         {
            _is_connected = false;
            dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT));
         }
      }
      
      protected function validateSessionReply(param1:FacebookEvent) : void
      {
         var _loc2_:GetSessionData = null;
         if(param1.success)
         {
            _loc2_ = param1.data as GetSessionData;
            facebook_internal::_uid = _loc2_.uid;
            this._session_key = _loc2_.session_key;
            this._expires = _loc2_.expires;
            this._secret = _loc2_.secret == null || _loc2_.secret == "" ? this._secret : _loc2_.secret;
            _is_connected = true;
            dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT,false,false,true,_loc2_));
         }
         else
         {
            this.onConnectionError(param1.error);
         }
      }
      
      override public function refreshSession() : void
      {
         this._waiting_for_login = false;
         var _loc1_:GetSession = new GetSession(this._auth_token);
         _loc1_.session = this;
         _loc1_.facebook_internal::initialize();
         _loc1_.addEventListener(FacebookEvent.COMPLETE,this.validateSessionReply);
         this.post(_loc1_);
      }
   }
}


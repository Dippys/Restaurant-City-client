package com.facebook
{
   import com.facebook.commands.auth.ExpireSession;
   import com.facebook.delegates.IFacebookCallDelegate;
   import com.facebook.events.FacebookEvent;
   import com.facebook.net.FacebookCall;
   import com.facebook.session.IFacebookSession;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   use namespace facebook_internal;
   
   public class Facebook extends EventDispatcher
   {
      
      public var waiting_for_login:Boolean;
      
      protected var _currentSession:IFacebookSession;
      
      public var connectionErrorMessage:String;
      
      public function Facebook()
      {
         super();
      }
      
      public function post(param1:FacebookCall) : FacebookCall
      {
         var _loc2_:IFacebookCallDelegate = null;
         if(this._currentSession)
         {
            param1.session = this._currentSession;
            param1.initialize();
            _loc2_ = this._currentSession.post(param1);
            param1.delegate = _loc2_;
            return param1;
         }
         throw new Error("Cannot post a call; no session has been set.");
      }
      
      public function startSession(param1:IFacebookSession) : void
      {
         this._currentSession = param1;
         if(this._currentSession.is_connected)
         {
            dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT,false,false,true));
         }
         else
         {
            this._currentSession.addEventListener(FacebookEvent.CONNECT,this.onSessionConnected);
            this._currentSession.addEventListener(FacebookEvent.WAITING_FOR_LOGIN,this.onWaitingForLogin);
         }
      }
      
      public function grantExtendedPermission(param1:String) : void
      {
         navigateToURL(new URLRequest("http://www.facebook.com/authorize.php?api_key=" + this.api_key + "&v=" + this.api_version + "&ext_perm=" + param1),"_blank");
      }
      
      public function refreshSession() : void
      {
         this._currentSession.refreshSession();
      }
      
      public function logout() : void
      {
         var _loc1_:ExpireSession = new ExpireSession();
         _loc1_.addEventListener(FacebookEvent.COMPLETE,this.onLoggedOut,false,0,true);
         this.post(_loc1_);
      }
      
      public function get api_version() : String
      {
         return this._currentSession ? this._currentSession.api_version : null;
      }
      
      protected function onLoggedOut(param1:FacebookEvent) : void
      {
         if(param1.success == true)
         {
            this._currentSession.session_key = null;
         }
         dispatchEvent(new FacebookEvent(FacebookEvent.LOGOUT,false,false,param1.success,param1.data,param1.error));
      }
      
      protected function onWaitingForLogin(param1:FacebookEvent) : void
      {
         this.waiting_for_login = true;
         dispatchEvent(new FacebookEvent(FacebookEvent.WAITING_FOR_LOGIN));
      }
      
      public function login(param1:Boolean) : void
      {
         this._currentSession.login(param1);
      }
      
      public function get secret() : String
      {
         return this._currentSession ? this._currentSession.secret : null;
      }
      
      public function grantPermission(param1:Boolean) : void
      {
         var _loc2_:String = "http://www.facebook.com/login.php?return_session=" + (param1 ? 1 : 0) + "&api_key=" + this.api_key;
         navigateToURL(new URLRequest(_loc2_),"_blank");
      }
      
      public function get is_connected() : Boolean
      {
         return this._currentSession ? this._currentSession.is_connected : false;
      }
      
      public function get session_key() : String
      {
         return this._currentSession ? this._currentSession.session_key : null;
      }
      
      public function get uid() : String
      {
         return this._currentSession ? this._currentSession.uid : null;
      }
      
      protected function onSessionConnected(param1:FacebookEvent) : void
      {
         var _loc2_:IFacebookSession = param1.target as IFacebookSession;
         dispatchEvent(param1);
      }
      
      public function get api_key() : String
      {
         return this._currentSession ? this._currentSession.api_key : null;
      }
      
      public function get expires() : Date
      {
         return this._currentSession ? this._currentSession.expires : new Date();
      }
   }
}


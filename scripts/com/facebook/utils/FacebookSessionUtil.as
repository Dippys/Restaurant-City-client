package com.facebook.utils
{
   import com.facebook.Facebook;
   import com.facebook.events.FacebookEvent;
   import com.facebook.facebook_internal;
   import com.facebook.session.DesktopSession;
   import com.facebook.session.IFacebookSession;
   import com.facebook.session.JSSession;
   import com.facebook.session.WebSession;
   import flash.display.LoaderInfo;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import flash.system.Capabilities;
   
   public class FacebookSessionUtil extends EventDispatcher
   {
      
      protected var loaderInfo:LoaderInfo;
      
      public var facebook:Facebook;
      
      protected var secret:String;
      
      protected var _activeSession:IFacebookSession;
      
      protected var session_key:String;
      
      protected var api_key:String;
      
      public function FacebookSessionUtil(param1:String, param2:String, param3:LoaderInfo)
      {
         super();
         this.secret = param2 == null ? param3.parameters.fb_sig_ss : param2;
         this.api_key = param1;
         this.loaderInfo = param3;
         var _loc4_:SharedObject = this.getStoredSession();
         if(_loc4_.data.session_key)
         {
            this.session_key = _loc4_.data.session_key;
         }
         var _loc5_:Object = param3 != null ? param3.parameters : {};
         if(_loc5_.fb_sig_session_key != null)
         {
            this.session_key = _loc5_.fb_sig_session_key;
         }
         if(param3.url.slice(0,5) == "file:" || Capabilities.playerType == "Desktop")
         {
            this._activeSession = new DesktopSession(param1,this.secret);
         }
         else if(Boolean(_loc5_.fb_sig_ss) && Boolean(_loc5_.fb_sig_api_key) && Boolean(_loc5_.fb_sig_session_key))
         {
            this._activeSession = new WebSession(_loc5_.fb_sig_api_key,_loc5_.fb_sig_ss,_loc5_.fb_sig_session_key);
            (this._activeSession as WebSession).facebook_internal::_uid = _loc5_.fb_sig_user;
         }
         else if(_loc5_.as_app_name)
         {
            this._activeSession = new JSSession(param1,_loc5_.as_app_name);
         }
         else
         {
            this._activeSession = new DesktopSession(param1,param2);
         }
         this._activeSession.session_key = this.session_key;
         this._activeSession.addEventListener(FacebookEvent.VERIFYING_SESSION,this.onVerifyingSession);
         this.facebook = new Facebook();
         this.facebook.addEventListener(FacebookEvent.WAITING_FOR_LOGIN,this.handleWaitingForLogin);
         this.facebook.addEventListener(FacebookEvent.CONNECT,this.onFacebookReady);
         this.facebook.startSession(this._activeSession);
      }
      
      protected function getStoredSession() : SharedObject
      {
         return SharedObject.getLocal(this.api_key + "_stored_session");
      }
      
      protected function handleWaitingForLogin(param1:FacebookEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function logout() : void
      {
         this.getStoredSession().clear();
         this.getStoredSession().flush();
         this.facebook.logout();
      }
      
      protected function onFacebookReady(param1:FacebookEvent) : void
      {
         var _loc2_:SharedObject = null;
         if(this.facebook.session_key)
         {
            _loc2_ = this.getStoredSession();
            _loc2_.data.session_key = this.facebook.session_key;
            _loc2_.data.stored_secret = this.facebook.secret;
            _loc2_.flush(3000);
         }
         if(param1)
         {
            dispatchEvent(param1);
         }
      }
      
      protected function onWaitingForLogin(param1:FacebookEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function validateLogin() : void
      {
         this.facebook.refreshSession();
      }
      
      public function get activeSession() : IFacebookSession
      {
         return this._activeSession;
      }
      
      public function login(param1:Boolean = true) : void
      {
         this.facebook.login(param1);
      }
      
      public function onVerifyingSession(param1:FacebookEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function verifySession() : void
      {
         this._activeSession.verifySession();
      }
      
      protected function onVerifyLogin(param1:FacebookEvent) : void
      {
         this._activeSession.removeEventListener(FacebookEvent.CONNECT,this.onVerifyLogin);
         if(param1.success)
         {
            this.onFacebookReady(null);
            dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT,false,false,true));
         }
         else
         {
            dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT,false,false,false));
         }
      }
   }
}


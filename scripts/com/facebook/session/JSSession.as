package com.facebook.session
{
   import com.facebook.commands.users.GetLoggedInUser;
   import com.facebook.delegates.IFacebookCallDelegate;
   import com.facebook.delegates.JSDelegate;
   import com.facebook.events.FacebookEvent;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import flash.events.EventDispatcher;
   
   public class JSSession extends EventDispatcher implements IFacebookSession
   {
      
      public var _api_key:String;
      
      public var as_swf_name:String;
      
      protected var _session_key:String;
      
      public function JSSession(param1:String, param2:String)
      {
         super();
         this._api_key = param1;
         this.as_swf_name = param2;
      }
      
      public function get waiting_for_login() : Boolean
      {
         return true;
      }
      
      public function get expires() : Date
      {
         return null;
      }
      
      public function get rest_url() : String
      {
         return null;
      }
      
      public function get session_key() : String
      {
         return this._session_key;
      }
      
      public function set rest_url(param1:String) : void
      {
      }
      
      public function refreshSession() : void
      {
      }
      
      protected function onVerifyLogin(param1:FacebookEvent) : void
      {
         if(param1.success)
         {
            dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT,false,false,true));
         }
         else
         {
            dispatchEvent(new FacebookEvent(FacebookEvent.CONNECT,false,false,false));
         }
      }
      
      public function get uid() : String
      {
         return null;
      }
      
      public function get is_sessionless() : Boolean
      {
         return true;
      }
      
      public function verifySession() : void
      {
         var _loc1_:FacebookCall = new GetLoggedInUser();
         _loc1_.addEventListener(FacebookEvent.COMPLETE,this.onVerifyLogin);
         _loc1_.session = this;
         _loc1_.facebook_internal::initialize();
         this.post(_loc1_);
      }
      
      public function set secret(param1:String) : void
      {
      }
      
      public function login(param1:Boolean) : void
      {
      }
      
      public function set session_key(param1:String) : void
      {
         this._session_key = param1;
      }
      
      public function post(param1:FacebookCall) : IFacebookCallDelegate
      {
         return new JSDelegate(param1,this);
      }
      
      public function get secret() : String
      {
         return null;
      }
      
      public function get api_version() : String
      {
         return "1.0";
      }
      
      public function get api_key() : String
      {
         return this._api_key;
      }
      
      public function get is_connected() : Boolean
      {
         return true;
      }
   }
}


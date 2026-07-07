package com.facebook.session
{
   import com.facebook.delegates.IFacebookCallDelegate;
   import com.facebook.net.FacebookCall;
   import flash.events.IEventDispatcher;
   
   public interface IFacebookSession extends IEventDispatcher
   {
      
      function set secret(param1:String) : void;
      
      function get waiting_for_login() : Boolean;
      
      function refreshSession() : void;
      
      function get rest_url() : String;
      
      function post(param1:FacebookCall) : IFacebookCallDelegate;
      
      function set rest_url(param1:String) : void;
      
      function login(param1:Boolean) : void;
      
      function set session_key(param1:String) : void;
      
      function get secret() : String;
      
      function get api_version() : String;
      
      function get expires() : Date;
      
      function get session_key() : String;
      
      function get uid() : String;
      
      function get api_key() : String;
      
      function get is_connected() : Boolean;
      
      function verifySession() : void;
   }
}


package com.facebook.delegates
{
   import com.facebook.net.FacebookCall;
   import com.facebook.session.IFacebookSession;
   import flash.events.IEventDispatcher;
   
   public interface IFacebookCallDelegate extends IEventDispatcher
   {
      
      function get session() : IFacebookSession;
      
      function close() : void;
      
      function set call(param1:FacebookCall) : void;
      
      function set session(param1:IFacebookSession) : void;
      
      function get call() : FacebookCall;
   }
}


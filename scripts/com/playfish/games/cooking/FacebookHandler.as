package com.playfish.games.cooking
{
   import com.facebook.events.FacebookEvent;
   import com.facebook.utils.FacebookSessionUtil;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class FacebookHandler extends EventDispatcher
   {
      
      public static const EVENT_ERROR:String = "error";
      
      private var fbApiKey:String;
      
      public var session:FacebookSessionUtil;
      
      private var stage:Stage;
      
      public function FacebookHandler(param1:String, param2:Stage)
      {
         super();
         this.fbApiKey = param1;
         this.stage = param2;
      }
      
      public function init() : void
      {
         try
         {
            session = new FacebookSessionUtil(fbApiKey,null,stage.loaderInfo);
            session.addEventListener(FacebookEvent.CONNECT,onFacebookSessionConnect);
            session.verifySession();
         }
         catch(error:Error)
         {
            Debug.warning("facebook verify session error " + error);
            throw error;
         }
      }
      
      public function onFacebookSessionConnect(param1:FacebookEvent) : void
      {
         Debug.out("onFacebookSessionConnect success=" + param1.success + " " + param1.error);
         if(param1.success)
         {
            if(hasEventListener(Event.COMPLETE))
            {
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
         else if(hasEventListener(EVENT_ERROR))
         {
            dispatchEvent(new Event(EVENT_ERROR));
         }
      }
   }
}


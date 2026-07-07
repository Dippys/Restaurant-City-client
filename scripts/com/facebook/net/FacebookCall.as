package com.facebook.net
{
   import com.facebook.data.FacebookData;
   import com.facebook.delegates.IFacebookCallDelegate;
   import com.facebook.errors.FacebookError;
   import com.facebook.events.FacebookEvent;
   import com.facebook.facebook_internal;
   import com.facebook.session.IFacebookSession;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   
   use namespace facebook_internal;
   
   public class FacebookCall extends EventDispatcher
   {
      
      public var success:Boolean = false;
      
      public var delegate:IFacebookCallDelegate;
      
      public var error:FacebookError;
      
      public var useSession:Boolean = true;
      
      public var session:IFacebookSession;
      
      public var connectTimeout:uint = 8000;
      
      public var loadTimeout:uint = 30000;
      
      public var args:URLVariables;
      
      public var method:String;
      
      public var result:FacebookData;
      
      public function FacebookCall(param1:String = "no_method_required", param2:URLVariables = null)
      {
         super();
         this.method = param1;
         this.args = param2 != null ? param2 : new URLVariables();
      }
      
      facebook_internal function handleError(param1:FacebookError) : void
      {
         this.error = param1;
         this.success = false;
         dispatchEvent(new FacebookEvent(FacebookEvent.COMPLETE,false,false,false,null,param1));
      }
      
      facebook_internal function initialize() : void
      {
      }
      
      facebook_internal function handleResult(param1:FacebookData) : void
      {
         this.result = param1;
         this.success = true;
         dispatchEvent(new FacebookEvent(FacebookEvent.COMPLETE,false,false,true,param1));
      }
      
      facebook_internal function setRequestArgument(param1:String, param2:Object) : void
      {
         if(param2 is Number && isNaN(param2 as Number))
         {
            return;
         }
         if(Boolean(param1) && Boolean(param2 != null) && String(param2).length > 0)
         {
            this.args[param1] = param2;
         }
      }
      
      protected function applySchema(param1:Array, ... rest) : void
      {
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            this.setRequestArgument(param1[_loc4_],rest[_loc4_]);
            _loc4_++;
         }
      }
      
      facebook_internal function clearRequestArguments() : void
      {
         this.args = new URLVariables();
      }
   }
}


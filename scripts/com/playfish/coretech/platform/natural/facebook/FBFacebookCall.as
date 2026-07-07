package com.playfish.coretech.platform.natural.facebook
{
   import com.facebook.data.FacebookData;
   import com.facebook.errors.FacebookError;
   import com.facebook.events.FacebookEvent;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.playfish.coretech.engine.core.JSONEncoder;
   import com.playfish.coretech.engine.core.PFDebug;
   import flash.net.URLVariables;
   
   use namespace facebook_internal;
   
   public class FBFacebookCall extends FacebookCall
   {
      
      public function FBFacebookCall(param1:String, param2:URLVariables = null)
      {
         super(param1,param2);
      }
      
      override facebook_internal function handleError(param1:FacebookError) : void
      {
         if(param1 != null && param1.error != null)
         {
            PFDebug.trace(null,"error:" + param1.error.toString());
         }
         dispatchEvent(new FacebookEvent(FacebookEvent.COMPLETE,false,false,false,null,param1));
      }
      
      public function setArg(param1:String, param2:Object) : void
      {
         var _loc3_:JSONEncoder = new JSONEncoder(param2);
         var _loc4_:String = _loc3_.getString();
         super.facebook_internal::setRequestArgument(param1,_loc4_);
      }
      
      override facebook_internal function handleResult(param1:FacebookData) : void
      {
         PFDebug.trace(null,"handleResult:" + param1.toString());
         PFDebug.trace(null,"handleResult.raw:" + param1.rawResult.toString());
         dispatchEvent(new FacebookEvent(FacebookEvent.COMPLETE,false,false,true,param1));
      }
   }
}


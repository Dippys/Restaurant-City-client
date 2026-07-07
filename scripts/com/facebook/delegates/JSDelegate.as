package com.facebook.delegates
{
   import com.adobe.serialization.json.JSON;
   import com.facebook.data.JSONResultData;
   import com.facebook.errors.FacebookError;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.session.IFacebookSession;
   import com.facebook.session.JSSession;
   import com.facebook.utils.JavascriptRequestHelper;
   import flash.events.ErrorEvent;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExternalInterface;
   
   public class JSDelegate extends EventDispatcher implements IFacebookCallDelegate
   {
      
      protected static var externalInterfaceCallId:Number = 0;
      
      protected static var externalInterfaceCalls:Object = {};
      
      protected var _call:FacebookCall;
      
      protected var _session:JSSession;
      
      public function JSDelegate(param1:FacebookCall, param2:JSSession)
      {
         super();
         this.call = param1;
         this.session = param2;
         this.execute();
      }
      
      public function set call(param1:FacebookCall) : void
      {
         this._call = param1;
      }
      
      protected function onReceiveError(param1:ErrorEvent) : void
      {
         var _loc2_:FacebookError = new FacebookError();
         _loc2_.errorEvent = param1;
         this.call.facebook_internal::handleError(_loc2_);
      }
      
      public function get call() : FacebookCall
      {
         return this._call;
      }
      
      protected function postBridgeAsyncReply(param1:Object, param2:Object, param3:uint) : void
      {
         var _loc5_:JSONResultData = null;
         var _loc6_:FacebookError = null;
         var _loc4_:FacebookCall = externalInterfaceCalls[param3];
         if(param1)
         {
            _loc5_ = new JSONResultData();
            _loc5_.result = param1;
            _loc4_.facebook_internal::handleResult(_loc5_);
         }
         else
         {
            _loc6_ = new FacebookError();
            _loc6_.rawResult = com.adobe.serialization.json.JSON.encode(param2);
            _loc4_.facebook_internal::handleError(_loc6_);
         }
         delete externalInterfaceCalls[param3];
      }
      
      protected function buildCall() : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:String = "bridgeFacebookCall_" + externalInterfaceCallId;
         RequestHelper.formatRequest(this.call);
         var _loc2_:Object = {};
         for(_loc3_ in this.call.args)
         {
            _loc2_[_loc3_] = this.call.args[_loc3_];
         }
         return "function " + _loc1_ + "() { " + "FB.Facebook.apiClient.callMethod(\"" + this.call.method + "\", " + JavascriptRequestHelper.formatURLVariables(this.call.args) + ", " + "function(result, exception) {" + "document." + (this._session as JSSession).as_swf_name + ".bridgeFacebookReply(result, exception, " + externalInterfaceCallId + ")" + "}" + ");" + "}";
      }
      
      protected function execute() : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.call.args)
         {
            _loc1_.push(_loc2_);
         }
         var _loc4_:Number;
         externalInterfaceCalls[_loc4_ = ++externalInterfaceCallId] = this.call;
         _loc3_ = this.buildCall();
         ExternalInterface.addCallback("bridgeFacebookReply",this.postBridgeAsyncReply);
         ExternalInterface.call(_loc3_);
      }
      
      protected function onReceiveStatus(param1:StatusEvent) : void
      {
         var _loc2_:FacebookError = null;
         switch(param1.level == "error")
         {
            case "error":
               _loc2_ = new FacebookError();
               _loc2_.rawResult = param1.level;
               this.call.facebook_internal::handleError(_loc2_);
               break;
            case "warning":
            case "status":
         }
      }
      
      public function set session(param1:IFacebookSession) : void
      {
         this._session = param1 as JSSession;
      }
      
      public function get session() : IFacebookSession
      {
         return this._session;
      }
      
      public function close() : void
      {
      }
   }
}


package com.playfish.external
{
   import com.playfish.coretech.engine.PFEngine;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.net.*;
   import flash.system.Security;
   
   public class ExternalPage extends EventDispatcher
   {
      
      internal static const POPUP:String = "popup:";
      
      internal static const HTTP:String = "http://";
      
      internal static const PF:String = "pf_";
      
      internal static const URL:String = "_url";
      
      internal static const HOSTNAME_PARAMETER:String = "pf_url";
      
      private var psEventType:String;
      
      public var POSITION:String = "_top";
      
      private var psNavigateTo:String;
      
      public function ExternalPage(param1:String)
      {
         super();
         psNavigateTo = PFEngine.instance.getParameterString(PF + param1 + URL);
         psEventType = param1;
         if(param1.indexOf(POPUP) != -1)
         {
            psNavigateTo = param1;
            psEventType = psNavigateTo.substr(psNavigateTo.length + 1);
         }
         addSecurityDomain();
         ExternalInterface.addCallback("sendToActionScript",JSCallBack);
      }
      
      public static function addSecurityDomain() : void
      {
         var _loc1_:String = PFEngine.instance.getParameterString(HOSTNAME_PARAMETER);
         var _loc2_:int = _loc1_.indexOf(":",HTTP.length + 1) - HTTP.length;
         var _loc3_:int = _loc1_.indexOf("/",HTTP.length + 1) - HTTP.length;
         if(_loc2_ < 0 && _loc3_ < 0)
         {
            _loc3_ = _loc1_.length - HTTP.length;
         }
         var _loc4_:String = _loc1_.substr(HTTP.length,_loc2_ > -1 && _loc2_ < _loc3_ ? _loc2_ : _loc3_);
         Security.allowDomain(_loc4_);
      }
      
      public function hide() : void
      {
         ExternalInterface.call("hide" + psEventType + "IFrame");
      }
      
      public function JSCallBack(param1:Array) : void
      {
         var _loc2_:ExternalPageEvent = null;
         if(psEventType != null)
         {
            _loc2_ = new ExternalPageEvent(ExternalPageEvent.COMPLETE,param1,psEventType);
            this.dispatchEvent(_loc2_);
         }
      }
      
      public function show(... rest) : void
      {
         var _loc2_:URLRequest = null;
         if(rest.length == 0)
         {
            rest[0] = false;
         }
         if(psNavigateTo.substr(0,POPUP.length) == POPUP)
         {
            if(rest.length > 1)
            {
               ExternalInterface.call.apply(ExternalInterface.call,[psNavigateTo.substring(POPUP.length)].concat(rest));
            }
            else
            {
               ExternalInterface.call(psNavigateTo.substring(POPUP.length),rest);
            }
         }
         else
         {
            _loc2_ = new URLRequest(psNavigateTo);
            navigateToURL(_loc2_,POSITION);
         }
      }
   }
}


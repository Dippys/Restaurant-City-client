package com.facebook.delegates
{
   import com.adobe.crypto.MD5;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.session.IFacebookSession;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   
   use namespace facebook_internal;
   
   public class RequestHelper
   {
      
      protected static var callID:int = 0;
      
      public function RequestHelper()
      {
         super();
      }
      
      public static function formatRequest(param1:FacebookCall) : void
      {
         var _loc2_:IFacebookSession = param1.session;
         param1.setRequestArgument("v",_loc2_.api_version);
         if(_loc2_.api_key != null)
         {
            param1.setRequestArgument("api_key",_loc2_.api_key);
         }
         if(_loc2_.session_key != null && param1.useSession)
         {
            param1.setRequestArgument("session_key",_loc2_.session_key);
         }
         var _loc3_:String = new Date().time.toString() + (callID++).toString();
         param1.setRequestArgument("call_id",_loc3_);
         param1.setRequestArgument("method",param1.method);
         param1.setRequestArgument("sig",formatSig(param1));
      }
      
      public static function formatSig(param1:FacebookCall) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc2_:IFacebookSession = param1.session;
         var _loc3_:Array = [];
         for(_loc4_ in param1.args)
         {
            _loc6_ = param1.args[_loc4_];
            if(_loc4_ !== "sig" && !(_loc6_ is ByteArray) && !(_loc6_ is FileReference) && !(_loc6_ is BitmapData) && !(_loc6_ is Bitmap))
            {
               _loc3_.push(_loc4_ + "=" + _loc6_.toString());
            }
         }
         _loc3_.sort();
         _loc5_ = _loc3_.join("");
         if(_loc2_.secret != null)
         {
            _loc5_ += _loc2_.secret;
         }
         return MD5.hash(_loc5_);
      }
   }
}


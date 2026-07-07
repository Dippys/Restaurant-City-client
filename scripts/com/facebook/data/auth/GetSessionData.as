package com.facebook.data.auth
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetSessionData extends FacebookData
   {
      
      private var _1309235404expires:Date;
      
      private var _22145738session_key:String;
      
      private var _906277200secret:String;
      
      private var _115792uid:String;
      
      public function GetSessionData()
      {
         super();
      }
      
      public function set uid(param1:String) : void
      {
         var _loc2_:Object = this._115792uid;
         if(_loc2_ !== param1)
         {
            this._115792uid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"uid",_loc2_,param1));
         }
      }
      
      public function set expires(param1:Date) : void
      {
         var _loc2_:Object = this._1309235404expires;
         if(_loc2_ !== param1)
         {
            this._1309235404expires = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"expires",_loc2_,param1));
         }
      }
      
      public function set secret(param1:String) : void
      {
         var _loc2_:Object = this._906277200secret;
         if(_loc2_ !== param1)
         {
            this._906277200secret = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secret",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get expires() : Date
      {
         return this._1309235404expires;
      }
      
      [Bindable(event="propertyChange")]
      public function get uid() : String
      {
         return this._115792uid;
      }
      
      public function set session_key(param1:String) : void
      {
         var _loc2_:Object = this._22145738session_key;
         if(_loc2_ !== param1)
         {
            this._22145738session_key = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"session_key",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get session_key() : String
      {
         return this._22145738session_key;
      }
      
      [Bindable(event="propertyChange")]
      public function get secret() : String
      {
         return this._906277200secret;
      }
   }
}


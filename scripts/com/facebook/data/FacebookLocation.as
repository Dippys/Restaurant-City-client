package com.facebook.data
{
   import mx.events.PropertyChangeEvent;
   
   public class FacebookLocation extends FacebookData
   {
      
      private var _957831062country:String;
      
      private var _3053931city:String;
      
      private var _120609zip:String;
      
      private var _891990013street:String;
      
      private var _109757585state:String;
      
      public function FacebookLocation()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get zip() : String
      {
         return this._120609zip;
      }
      
      public function set state(param1:String) : void
      {
         var _loc2_:Object = this._109757585state;
         if(_loc2_ !== param1)
         {
            this._109757585state = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"state",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get street() : String
      {
         return this._891990013street;
      }
      
      public function set city(param1:String) : void
      {
         var _loc2_:Object = this._3053931city;
         if(_loc2_ !== param1)
         {
            this._3053931city = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"city",_loc2_,param1));
         }
      }
      
      public function set street(param1:String) : void
      {
         var _loc2_:Object = this._891990013street;
         if(_loc2_ !== param1)
         {
            this._891990013street = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"street",_loc2_,param1));
         }
      }
      
      public function set zip(param1:String) : void
      {
         var _loc2_:Object = this._120609zip;
         if(_loc2_ !== param1)
         {
            this._120609zip = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"zip",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get city() : String
      {
         return this._3053931city;
      }
      
      [Bindable(event="propertyChange")]
      public function get country() : String
      {
         return this._957831062country;
      }
      
      [Bindable(event="propertyChange")]
      public function get state() : String
      {
         return this._109757585state;
      }
      
      public function set country(param1:String) : void
      {
         var _loc2_:Object = this._957831062country;
         if(_loc2_ !== param1)
         {
            this._957831062country = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"country",_loc2_,param1));
         }
      }
   }
}


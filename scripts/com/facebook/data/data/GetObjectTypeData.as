package com.facebook.data.data
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetObjectTypeData extends FacebookData
   {
      
      private var _747164295index_type:Number;
      
      private var _3373707name:String;
      
      private var _363359569data_type:Number;
      
      public function GetObjectTypeData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get index_type() : Number
      {
         return this._747164295index_type;
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      [Bindable(event="propertyChange")]
      public function get data_type() : Number
      {
         return this._363359569data_type;
      }
      
      public function set index_type(param1:Number) : void
      {
         var _loc2_:Object = this._747164295index_type;
         if(_loc2_ !== param1)
         {
            this._747164295index_type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"index_type",_loc2_,param1));
         }
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      public function set data_type(param1:Number) : void
      {
         var _loc2_:Object = this._363359569data_type;
         if(_loc2_ !== param1)
         {
            this._363359569data_type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"data_type",_loc2_,param1));
         }
      }
   }
}


package com.facebook.data
{
   import mx.events.PropertyChangeEvent;
   
   public class NumberResultData extends FacebookData
   {
      
      private var _111972721value:Number;
      
      public function NumberResultData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : Number
      {
         return this._111972721value;
      }
      
      public function set value(param1:Number) : void
      {
         var _loc2_:Object = this._111972721value;
         if(_loc2_ !== param1)
         {
            this._111972721value = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"value",_loc2_,param1));
         }
      }
   }
}


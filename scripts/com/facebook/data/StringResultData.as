package com.facebook.data
{
   import mx.events.PropertyChangeEvent;
   
   public class StringResultData extends FacebookData
   {
      
      private var _111972721value:String;
      
      public function StringResultData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : String
      {
         return this._111972721value;
      }
      
      public function set value(param1:String) : void
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


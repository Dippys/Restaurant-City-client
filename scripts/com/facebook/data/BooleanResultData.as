package com.facebook.data
{
   import mx.events.PropertyChangeEvent;
   
   public class BooleanResultData extends FacebookData
   {
      
      private var _111972721value:Boolean;
      
      public function BooleanResultData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : Boolean
      {
         return this._111972721value;
      }
      
      public function set value(param1:Boolean) : void
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


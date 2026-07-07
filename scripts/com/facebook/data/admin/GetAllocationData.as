package com.facebook.data.admin
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetAllocationData extends FacebookData
   {
      
      private var _376596805allocationLimit:Number;
      
      public function GetAllocationData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get allocationLimit() : Number
      {
         return this._376596805allocationLimit;
      }
      
      public function set allocationLimit(param1:Number) : void
      {
         var _loc2_:Object = this._376596805allocationLimit;
         if(_loc2_ !== param1)
         {
            this._376596805allocationLimit = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allocationLimit",_loc2_,param1));
         }
      }
   }
}


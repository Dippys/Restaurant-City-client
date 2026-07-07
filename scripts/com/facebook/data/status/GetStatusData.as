package com.facebook.data.status
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetStatusData extends FacebookData
   {
      
      private var _892481550status:Array;
      
      public function GetStatusData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get status() : Array
      {
         return this._892481550status;
      }
      
      public function set status(param1:Array) : void
      {
         var _loc2_:Object = this._892481550status;
         if(_loc2_ !== param1)
         {
            this._892481550status = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,param1));
         }
      }
   }
}


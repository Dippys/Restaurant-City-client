package com.facebook.data.batch
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class BatchResult extends FacebookData
   {
      
      private var _1097546742results:Array;
      
      public function BatchResult()
      {
         super();
      }
      
      public function set results(param1:Array) : void
      {
         var _loc2_:Object = this._1097546742results;
         if(_loc2_ !== param1)
         {
            this._1097546742results = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"results",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get results() : Array
      {
         return this._1097546742results;
      }
   }
}


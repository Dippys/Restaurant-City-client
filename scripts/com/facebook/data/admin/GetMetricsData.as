package com.facebook.data.admin
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetMetricsData extends FacebookData
   {
      
      private var _1648653249metricsCollection:MetricsDataCollection;
      
      public function GetMetricsData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get metricsCollection() : MetricsDataCollection
      {
         return this._1648653249metricsCollection;
      }
      
      public function set metricsCollection(param1:MetricsDataCollection) : void
      {
         var _loc2_:Object = this._1648653249metricsCollection;
         if(_loc2_ !== param1)
         {
            this._1648653249metricsCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"metricsCollection",_loc2_,param1));
         }
      }
   }
}


package com.facebook.data.events
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetEventsData extends FacebookData
   {
      
      private var _2121991384eventCollection:EventCollection;
      
      public function GetEventsData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get eventCollection() : EventCollection
      {
         return this._2121991384eventCollection;
      }
      
      public function set eventCollection(param1:EventCollection) : void
      {
         var _loc2_:Object = this._2121991384eventCollection;
         if(_loc2_ !== param1)
         {
            this._2121991384eventCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eventCollection",_loc2_,param1));
         }
      }
   }
}


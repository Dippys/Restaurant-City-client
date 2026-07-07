package com.facebook.data.stream
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetFiltersData extends FacebookData
   {
      
      private var _854547461filters:StreamFilterCollection;
      
      public function GetFiltersData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get filters() : StreamFilterCollection
      {
         return this._854547461filters;
      }
      
      public function set filters(param1:StreamFilterCollection) : void
      {
         var _loc2_:Object = this._854547461filters;
         if(_loc2_ !== param1)
         {
            this._854547461filters = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filters",_loc2_,param1));
         }
      }
   }
}


package com.facebook.data.data
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetUserPreferencesData extends FacebookData
   {
      
      private var _1984973153perferenceCollection:PreferenceCollection;
      
      public function GetUserPreferencesData()
      {
         super();
      }
      
      public function set perferenceCollection(param1:PreferenceCollection) : void
      {
         var _loc2_:Object = this._1984973153perferenceCollection;
         if(_loc2_ !== param1)
         {
            this._1984973153perferenceCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"perferenceCollection",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get perferenceCollection() : PreferenceCollection
      {
         return this._1984973153perferenceCollection;
      }
   }
}


package com.facebook.data.data
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetObjectTypesData extends FacebookData
   {
      
      private var _1481977495objectTypeCollection:ObjectTypesCollection;
      
      public function GetObjectTypesData()
      {
         super();
      }
      
      public function set objectTypeCollection(param1:ObjectTypesCollection) : void
      {
         var _loc2_:Object = this._1481977495objectTypeCollection;
         if(_loc2_ !== param1)
         {
            this._1481977495objectTypeCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"objectTypeCollection",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get objectTypeCollection() : ObjectTypesCollection
      {
         return this._1481977495objectTypeCollection;
      }
   }
}


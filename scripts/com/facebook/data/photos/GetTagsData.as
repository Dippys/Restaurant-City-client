package com.facebook.data.photos
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetTagsData extends FacebookData
   {
      
      private var _2107998615photoTagsCollection:PhotoTagCollection;
      
      public function GetTagsData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get photoTagsCollection() : PhotoTagCollection
      {
         return this._2107998615photoTagsCollection;
      }
      
      public function set photoTagsCollection(param1:PhotoTagCollection) : void
      {
         var _loc2_:Object = this._2107998615photoTagsCollection;
         if(_loc2_ !== param1)
         {
            this._2107998615photoTagsCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"photoTagsCollection",_loc2_,param1));
         }
      }
   }
}


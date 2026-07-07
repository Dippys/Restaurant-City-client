package com.facebook.data.photos
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetAlbumsData extends FacebookData
   {
      
      private var _1670051219albumCollection:AlbumCollection;
      
      public function GetAlbumsData()
      {
         super();
      }
      
      public function set albumCollection(param1:AlbumCollection) : void
      {
         var _loc2_:Object = this._1670051219albumCollection;
         if(_loc2_ !== param1)
         {
            this._1670051219albumCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"albumCollection",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get albumCollection() : AlbumCollection
      {
         return this._1670051219albumCollection;
      }
   }
}


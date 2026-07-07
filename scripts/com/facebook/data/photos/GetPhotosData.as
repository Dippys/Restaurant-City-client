package com.facebook.data.photos
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetPhotosData extends FacebookData
   {
      
      private var _1751633296photoCollection:PhotoCollection;
      
      public function GetPhotosData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get photoCollection() : PhotoCollection
      {
         return this._1751633296photoCollection;
      }
      
      public function set photoCollection(param1:PhotoCollection) : void
      {
         var _loc2_:Object = this._1751633296photoCollection;
         if(_loc2_ !== param1)
         {
            this._1751633296photoCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"photoCollection",_loc2_,param1));
         }
      }
   }
}


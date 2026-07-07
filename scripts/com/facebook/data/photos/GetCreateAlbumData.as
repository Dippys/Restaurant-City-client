package com.facebook.data.photos
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetCreateAlbumData extends FacebookData
   {
      
      private var _248976057albumData:AlbumData;
      
      public function GetCreateAlbumData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get albumData() : AlbumData
      {
         return this._248976057albumData;
      }
      
      public function set albumData(param1:AlbumData) : void
      {
         var _loc2_:Object = this._248976057albumData;
         if(_loc2_ !== param1)
         {
            this._248976057albumData = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"albumData",_loc2_,param1));
         }
      }
   }
}


package com.facebook.data.stream
{
   import com.facebook.data.FacebookData;
   import com.facebook.data.photos.AlbumCollection;
   import mx.events.PropertyChangeEvent;
   
   public class GetStreamData extends FacebookData
   {
      
      private var _1884266413stories:StreamStoryCollection;
      
      private var _1415163932albums:AlbumCollection;
      
      private var _1002263574profiles:ProfileCollection;
      
      public function GetStreamData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get albums() : AlbumCollection
      {
         return this._1415163932albums;
      }
      
      public function set stories(param1:StreamStoryCollection) : void
      {
         var _loc2_:Object = this._1884266413stories;
         if(_loc2_ !== param1)
         {
            this._1884266413stories = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stories",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profiles() : ProfileCollection
      {
         return this._1002263574profiles;
      }
      
      public function set albums(param1:AlbumCollection) : void
      {
         var _loc2_:Object = this._1415163932albums;
         if(_loc2_ !== param1)
         {
            this._1415163932albums = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"albums",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stories() : StreamStoryCollection
      {
         return this._1884266413stories;
      }
      
      public function set profiles(param1:ProfileCollection) : void
      {
         var _loc2_:Object = this._1002263574profiles;
         if(_loc2_ !== param1)
         {
            this._1002263574profiles = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profiles",_loc2_,param1));
         }
      }
   }
}


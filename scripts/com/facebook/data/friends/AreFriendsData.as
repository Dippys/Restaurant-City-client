package com.facebook.data.friends
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class AreFriendsData extends FacebookData
   {
      
      private var _40395245friendsCollection:FriendsCollection;
      
      public function AreFriendsData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get friendsCollection() : FriendsCollection
      {
         return this._40395245friendsCollection;
      }
      
      public function set friendsCollection(param1:FriendsCollection) : void
      {
         var _loc2_:Object = this._40395245friendsCollection;
         if(_loc2_ !== param1)
         {
            this._40395245friendsCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friendsCollection",_loc2_,param1));
         }
      }
   }
}


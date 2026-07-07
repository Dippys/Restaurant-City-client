package com.facebook.data.friends
{
   import com.facebook.data.FacebookData;
   import com.facebook.data.users.FacebookUserCollection;
   import mx.events.PropertyChangeEvent;
   
   public class GetFriendsData extends FacebookData
   {
      
      private var _600094315friends:FacebookUserCollection;
      
      public function GetFriendsData()
      {
         super();
      }
      
      public function set friends(param1:FacebookUserCollection) : void
      {
         var _loc2_:Object = this._600094315friends;
         if(_loc2_ !== param1)
         {
            this._600094315friends = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friends",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get friends() : FacebookUserCollection
      {
         return this._600094315friends;
      }
   }
}


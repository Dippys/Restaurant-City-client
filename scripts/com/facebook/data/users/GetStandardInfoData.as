package com.facebook.data.users
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetStandardInfoData extends FacebookData
   {
      
      private var _986811191userCollection:UserCollection;
      
      public function GetStandardInfoData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get userCollection() : UserCollection
      {
         return this._986811191userCollection;
      }
      
      public function set userCollection(param1:UserCollection) : void
      {
         var _loc2_:Object = this._986811191userCollection;
         if(_loc2_ !== param1)
         {
            this._986811191userCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userCollection",_loc2_,param1));
         }
      }
   }
}


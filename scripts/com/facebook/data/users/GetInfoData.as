package com.facebook.data.users
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetInfoData extends FacebookData
   {
      
      private var _986811191userCollection:FacebookUserCollection;
      
      public function GetInfoData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get userCollection() : FacebookUserCollection
      {
         return this._986811191userCollection;
      }
      
      public function set userCollection(param1:FacebookUserCollection) : void
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


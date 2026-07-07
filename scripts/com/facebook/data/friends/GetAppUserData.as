package com.facebook.data.friends
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetAppUserData extends FacebookData
   {
      
      private var _3589667uids:Array;
      
      public function GetAppUserData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get uids() : Array
      {
         return this._3589667uids;
      }
      
      public function set uids(param1:Array) : void
      {
         var _loc2_:Object = this._3589667uids;
         if(_loc2_ !== param1)
         {
            this._3589667uids = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"uids",_loc2_,param1));
         }
      }
   }
}


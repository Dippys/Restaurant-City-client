package com.facebook.data.groups
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetGroupData extends FacebookData
   {
      
      private var _1237460524groups:GroupCollection;
      
      public function GetGroupData()
      {
         super();
      }
      
      public function set groups(param1:GroupCollection) : void
      {
         var _loc2_:Object = this._1237460524groups;
         if(_loc2_ !== param1)
         {
            this._1237460524groups = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groups",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groups() : GroupCollection
      {
         return this._1237460524groups;
      }
   }
}


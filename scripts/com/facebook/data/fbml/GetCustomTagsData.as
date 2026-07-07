package com.facebook.data.fbml
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetCustomTagsData extends FacebookData
   {
      
      private var _189132328tagCollection:TagCollection;
      
      public function GetCustomTagsData()
      {
         super();
      }
      
      public function set tagCollection(param1:TagCollection) : void
      {
         var _loc2_:Object = this._189132328tagCollection;
         if(_loc2_ !== param1)
         {
            this._189132328tagCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tagCollection",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tagCollection() : TagCollection
      {
         return this._189132328tagCollection;
      }
   }
}


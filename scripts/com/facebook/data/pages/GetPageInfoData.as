package com.facebook.data.pages
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetPageInfoData extends FacebookData
   {
      
      private var _1492481627pageInfoCollection:PageInfoCollection;
      
      public function GetPageInfoData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get pageInfoCollection() : PageInfoCollection
      {
         return this._1492481627pageInfoCollection;
      }
      
      public function set pageInfoCollection(param1:PageInfoCollection) : void
      {
         var _loc2_:Object = this._1492481627pageInfoCollection;
         if(_loc2_ !== param1)
         {
            this._1492481627pageInfoCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pageInfoCollection",_loc2_,param1));
         }
      }
   }
}


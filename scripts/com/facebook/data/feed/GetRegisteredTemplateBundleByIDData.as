package com.facebook.data.feed
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetRegisteredTemplateBundleByIDData extends FacebookData
   {
      
      private var _858818232templateCollection:TemplateCollection;
      
      public function GetRegisteredTemplateBundleByIDData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get templateCollection() : TemplateCollection
      {
         return this._858818232templateCollection;
      }
      
      public function set templateCollection(param1:TemplateCollection) : void
      {
         var _loc2_:Object = this._858818232templateCollection;
         if(_loc2_ !== param1)
         {
            this._858818232templateCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"templateCollection",_loc2_,param1));
         }
      }
   }
}


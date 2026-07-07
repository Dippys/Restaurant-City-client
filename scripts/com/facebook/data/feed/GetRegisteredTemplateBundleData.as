package com.facebook.data.feed
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetRegisteredTemplateBundleData extends FacebookData
   {
      
      private var _1345486656bundleCollection:TemplateCollection;
      
      public function GetRegisteredTemplateBundleData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get bundleCollection() : TemplateCollection
      {
         return this._1345486656bundleCollection;
      }
      
      public function set bundleCollection(param1:TemplateCollection) : void
      {
         var _loc2_:Object = this._1345486656bundleCollection;
         if(_loc2_ !== param1)
         {
            this._1345486656bundleCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bundleCollection",_loc2_,param1));
         }
      }
   }
}


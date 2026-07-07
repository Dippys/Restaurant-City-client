package com.facebook.data.feed
{
   import com.facebook.utils.FacebookArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class TemplateCollection extends FacebookArrayCollection
   {
      
      private var _630236298time_created:Date;
      
      private var _1933135987template_bundle_id:Number;
      
      public function TemplateCollection()
      {
         super(null,TemplateData);
      }
      
      public function addTemplateData(param1:TemplateData) : void
      {
         this.addItem(param1);
      }
      
      public function set template_bundle_id(param1:Number) : void
      {
         var _loc2_:Object = this._1933135987template_bundle_id;
         if(_loc2_ !== param1)
         {
            this._1933135987template_bundle_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"template_bundle_id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get template_bundle_id() : Number
      {
         return this._1933135987template_bundle_id;
      }
      
      public function set time_created(param1:Date) : void
      {
         var _loc2_:Object = this._630236298time_created;
         if(_loc2_ !== param1)
         {
            this._630236298time_created = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"time_created",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get time_created() : Date
      {
         return this._630236298time_created;
      }
   }
}


package com.facebook.data.admin
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetAppPropertiesData extends FacebookData
   {
      
      private var _554397236appProperties:Array;
      
      public function GetAppPropertiesData()
      {
         super();
      }
      
      public function set appProperties(param1:Array) : void
      {
         var _loc2_:Object = this._554397236appProperties;
         if(_loc2_ !== param1)
         {
            this._554397236appProperties = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"appProperties",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get appProperties() : Array
      {
         return this._554397236appProperties;
      }
   }
}


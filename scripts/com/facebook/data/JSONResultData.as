package com.facebook.data
{
   import mx.events.PropertyChangeEvent;
   
   public class JSONResultData extends FacebookData
   {
      
      private var _934426595result:Object;
      
      public function JSONResultData()
      {
         super();
      }
      
      public function set result(param1:Object) : void
      {
         var _loc2_:Object = this._934426595result;
         if(_loc2_ !== param1)
         {
            this._934426595result = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"result",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get result() : Object
      {
         return this._934426595result;
      }
   }
}


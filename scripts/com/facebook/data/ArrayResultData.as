package com.facebook.data
{
   import mx.events.PropertyChangeEvent;
   
   public class ArrayResultData extends FacebookData
   {
      
      private var _682377174arrayResult:Array;
      
      public function ArrayResultData()
      {
         super();
      }
      
      public function set arrayResult(param1:Array) : void
      {
         var _loc2_:Object = this._682377174arrayResult;
         if(_loc2_ !== param1)
         {
            this._682377174arrayResult = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrayResult",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get arrayResult() : Array
      {
         return this._682377174arrayResult;
      }
   }
}


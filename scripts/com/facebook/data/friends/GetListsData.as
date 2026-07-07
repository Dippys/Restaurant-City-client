package com.facebook.data.friends
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetListsData extends FacebookData
   {
      
      private var _102982549lists:Array;
      
      public function GetListsData()
      {
         super();
      }
      
      public function set lists(param1:Array) : void
      {
         var _loc2_:Object = this._102982549lists;
         if(_loc2_ !== param1)
         {
            this._102982549lists = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lists",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lists() : Array
      {
         return this._102982549lists;
      }
   }
}


package com.facebook.data.stream
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetCommentsData extends FacebookData
   {
      
      private var _602415628comments:Array;
      
      public function GetCommentsData()
      {
         super();
      }
      
      public function set comments(param1:Array) : void
      {
         var _loc2_:Object = this._602415628comments;
         if(_loc2_ !== param1)
         {
            this._602415628comments = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"comments",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get comments() : Array
      {
         return this._602415628comments;
      }
   }
}


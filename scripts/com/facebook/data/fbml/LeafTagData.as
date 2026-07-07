package com.facebook.data.fbml
{
   import mx.events.PropertyChangeEvent;
   
   public class LeafTagData extends AbstractTagData
   {
      
      private var _3136347fbml:String;
      
      public function LeafTagData(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String = "", param7:String = "", param8:AttributeCollection = null)
      {
         this.fbml = param2;
         super(param1,param3,param4,param5,param6,param7,param8);
      }
      
      [Bindable(event="propertyChange")]
      public function get fbml() : String
      {
         return this._3136347fbml;
      }
      
      public function set fbml(param1:String) : void
      {
         var _loc2_:Object = this._3136347fbml;
         if(_loc2_ !== param1)
         {
            this._3136347fbml = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fbml",_loc2_,param1));
         }
      }
   }
}


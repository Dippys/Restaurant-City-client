package com.facebook.data.events
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetMembersData extends FacebookData
   {
      
      private var _354428152attending:Array;
      
      private var _568196142declined:Array;
      
      private var _840227282unsure:Array;
      
      private var _487874675not_replied:Array;
      
      public function GetMembersData()
      {
         super();
      }
      
      public function set declined(param1:Array) : void
      {
         var _loc2_:Object = this._568196142declined;
         if(_loc2_ !== param1)
         {
            this._568196142declined = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"declined",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get attending() : Array
      {
         return this._354428152attending;
      }
      
      public function set not_replied(param1:Array) : void
      {
         var _loc2_:Object = this._487874675not_replied;
         if(_loc2_ !== param1)
         {
            this._487874675not_replied = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"not_replied",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get not_replied() : Array
      {
         return this._487874675not_replied;
      }
      
      [Bindable(event="propertyChange")]
      public function get unsure() : Array
      {
         return this._840227282unsure;
      }
      
      public function set attending(param1:Array) : void
      {
         var _loc2_:Object = this._354428152attending;
         if(_loc2_ !== param1)
         {
            this._354428152attending = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attending",_loc2_,param1));
         }
      }
      
      public function set unsure(param1:Array) : void
      {
         var _loc2_:Object = this._840227282unsure;
         if(_loc2_ !== param1)
         {
            this._840227282unsure = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unsure",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get declined() : Array
      {
         return this._568196142declined;
      }
   }
}


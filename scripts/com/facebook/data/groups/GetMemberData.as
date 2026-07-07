package com.facebook.data.groups
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetMemberData extends FacebookData
   {
      
      private var _138904922notReplied:Array;
      
      private var _1422235900admins:Array;
      
      private var _948881689members:Array;
      
      private var _765293059officers:Array;
      
      public function GetMemberData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get admins() : Array
      {
         return this._1422235900admins;
      }
      
      [Bindable(event="propertyChange")]
      public function get notReplied() : Array
      {
         return this._138904922notReplied;
      }
      
      public function set admins(param1:Array) : void
      {
         var _loc2_:Object = this._1422235900admins;
         if(_loc2_ !== param1)
         {
            this._1422235900admins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"admins",_loc2_,param1));
         }
      }
      
      public function set notReplied(param1:Array) : void
      {
         var _loc2_:Object = this._138904922notReplied;
         if(_loc2_ !== param1)
         {
            this._138904922notReplied = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"notReplied",_loc2_,param1));
         }
      }
      
      public function set members(param1:Array) : void
      {
         var _loc2_:Object = this._948881689members;
         if(_loc2_ !== param1)
         {
            this._948881689members = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"members",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get members() : Array
      {
         return this._948881689members;
      }
      
      public function set officers(param1:Array) : void
      {
         var _loc2_:Object = this._765293059officers;
         if(_loc2_ !== param1)
         {
            this._765293059officers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"officers",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get officers() : Array
      {
         return this._765293059officers;
      }
   }
}


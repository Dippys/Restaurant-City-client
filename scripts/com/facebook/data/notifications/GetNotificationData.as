package com.facebook.data.notifications
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetNotificationData extends FacebookData
   {
      
      private var _2011259082group_invites:Array;
      
      private var _757115001friendsRequests:Array;
      
      private var _823645719notificationCollection:NotificationCollection;
      
      private var _1950182939event_invites:Array;
      
      public function GetNotificationData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get event_invites() : Array
      {
         return this._1950182939event_invites;
      }
      
      [Bindable(event="propertyChange")]
      public function get notificationCollection() : NotificationCollection
      {
         return this._823645719notificationCollection;
      }
      
      [Bindable(event="propertyChange")]
      public function get group_invites() : Array
      {
         return this._2011259082group_invites;
      }
      
      public function set event_invites(param1:Array) : void
      {
         var _loc2_:Object = this._1950182939event_invites;
         if(_loc2_ !== param1)
         {
            this._1950182939event_invites = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"event_invites",_loc2_,param1));
         }
      }
      
      public function set friendsRequests(param1:Array) : void
      {
         var _loc2_:Object = this._757115001friendsRequests;
         if(_loc2_ !== param1)
         {
            this._757115001friendsRequests = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"friendsRequests",_loc2_,param1));
         }
      }
      
      public function set group_invites(param1:Array) : void
      {
         var _loc2_:Object = this._2011259082group_invites;
         if(_loc2_ !== param1)
         {
            this._2011259082group_invites = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"group_invites",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get friendsRequests() : Array
      {
         return this._757115001friendsRequests;
      }
      
      public function set notificationCollection(param1:NotificationCollection) : void
      {
         var _loc2_:Object = this._823645719notificationCollection;
         if(_loc2_ !== param1)
         {
            this._823645719notificationCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"notificationCollection",_loc2_,param1));
         }
      }
   }
}


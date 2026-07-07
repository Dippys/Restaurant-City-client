package com.facebook.data.application
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetPublicInfoData extends FacebookData
   {
      
      private var _737588055icon_url:String;
      
      private var _1793855977developers:String;
      
      private var _1615086568display_name:String;
      
      private var _1872800494canvas_name:String;
      
      private var _1724546052description:String;
      
      private var _2027875547logo_url:String;
      
      private var _171158145monthly_active_users:Number;
      
      private var _1429880077company_name:String;
      
      private var _650176883weekly_active_users:Number;
      
      private var _800085318api_key:String;
      
      private var _1411074055app_id:String;
      
      private var _1957597173daily_active_users:Number;
      
      public function GetPublicInfoData()
      {
         super();
      }
      
      public function set app_id(param1:String) : void
      {
         var _loc2_:Object = this._1411074055app_id;
         if(_loc2_ !== param1)
         {
            this._1411074055app_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"app_id",_loc2_,param1));
         }
      }
      
      public function set monthly_active_users(param1:Number) : void
      {
         var _loc2_:Object = this._171158145monthly_active_users;
         if(_loc2_ !== param1)
         {
            this._171158145monthly_active_users = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"monthly_active_users",_loc2_,param1));
         }
      }
      
      public function set api_key(param1:String) : void
      {
         var _loc2_:Object = this._800085318api_key;
         if(_loc2_ !== param1)
         {
            this._800085318api_key = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"api_key",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get monthly_active_users() : Number
      {
         return this._171158145monthly_active_users;
      }
      
      [Bindable(event="propertyChange")]
      public function get developers() : String
      {
         return this._1793855977developers;
      }
      
      public function set display_name(param1:String) : void
      {
         var _loc2_:Object = this._1615086568display_name;
         if(_loc2_ !== param1)
         {
            this._1615086568display_name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"display_name",_loc2_,param1));
         }
      }
      
      public function set company_name(param1:String) : void
      {
         var _loc2_:Object = this._1429880077company_name;
         if(_loc2_ !== param1)
         {
            this._1429880077company_name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"company_name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get company_name() : String
      {
         return this._1429880077company_name;
      }
      
      public function set developers(param1:String) : void
      {
         var _loc2_:Object = this._1793855977developers;
         if(_loc2_ !== param1)
         {
            this._1793855977developers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"developers",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get logo_url() : String
      {
         return this._2027875547logo_url;
      }
      
      [Bindable(event="propertyChange")]
      public function get weekly_active_users() : Number
      {
         return this._650176883weekly_active_users;
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
      
      public function set weekly_active_users(param1:Number) : void
      {
         var _loc2_:Object = this._650176883weekly_active_users;
         if(_loc2_ !== param1)
         {
            this._650176883weekly_active_users = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"weekly_active_users",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get canvas_name() : String
      {
         return this._1872800494canvas_name;
      }
      
      public function set canvas_name(param1:String) : void
      {
         var _loc2_:Object = this._1872800494canvas_name;
         if(_loc2_ !== param1)
         {
            this._1872800494canvas_name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"canvas_name",_loc2_,param1));
         }
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon_url() : String
      {
         return this._737588055icon_url;
      }
      
      public function set icon_url(param1:String) : void
      {
         var _loc2_:Object = this._737588055icon_url;
         if(_loc2_ !== param1)
         {
            this._737588055icon_url = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon_url",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get display_name() : String
      {
         return this._1615086568display_name;
      }
      
      public function set daily_active_users(param1:Number) : void
      {
         var _loc2_:Object = this._1957597173daily_active_users;
         if(_loc2_ !== param1)
         {
            this._1957597173daily_active_users = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"daily_active_users",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get daily_active_users() : Number
      {
         return this._1957597173daily_active_users;
      }
      
      [Bindable(event="propertyChange")]
      public function get app_id() : String
      {
         return this._1411074055app_id;
      }
      
      [Bindable(event="propertyChange")]
      public function get api_key() : String
      {
         return this._800085318api_key;
      }
      
      public function set logo_url(param1:String) : void
      {
         var _loc2_:Object = this._2027875547logo_url;
         if(_loc2_ !== param1)
         {
            this._2027875547logo_url = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logo_url",_loc2_,param1));
         }
      }
   }
}


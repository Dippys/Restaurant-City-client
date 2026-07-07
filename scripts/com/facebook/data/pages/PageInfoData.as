package com.facebook.data.pages
{
   import com.facebook.data.FacebookLocation;
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class PageInfoData extends EventDispatcher
   {
      
      private var _485238799hometown:String;
      
      private var _3575610type:String;
      
      private var _1405038154awards:String;
      
      private var _99469071hours:String;
      
      private var _1635870290directed_by:String;
      
      private var _1224335515website:String;
      
      private var _1768882106pic_large:String;
      
      private var _2002886397has_added_app:Boolean;
      
      private var _578385717pic_big:String;
      
      private var _1817326876plot_outline:String;
      
      private var _1214494066pic_square:String;
      
      private var _697920873schedule:String;
      
      private var _1965855514release_date:String;
      
      private var _97544bio:String;
      
      private var _1774829598influences:String;
      
      private var _2116416122record_label:String;
      
      private var _1843485230network:String;
      
      private var _3373707name:String;
      
      private var _1762076142pic_small:String;
      
      private var _68251919band_members:String;
      
      private var _1316747138starring:String;
      
      private var _1901043637location:FacebookLocation;
      
      private var _906335517season:String;
      
      private var _674640991founded:String;
      
      private var _803548981page_id:Number;
      
      private var _915840763company_overview:String;
      
      private var _98240899genre:String;
      
      private var _891901482studio:String;
      
      private var _1505017102produced_by:String;
      
      private var _1003761308products:String;
      
      private var _1069449612mission:String;
      
      private var _201317249written_by:String;
      
      public function PageInfoData()
      {
         super();
      }
      
      public function set starring(param1:String) : void
      {
         var _loc2_:Object = this._1316747138starring;
         if(_loc2_ !== param1)
         {
            this._1316747138starring = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"starring",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get season() : String
      {
         return this._906335517season;
      }
      
      [Bindable(event="propertyChange")]
      public function get bio() : String
      {
         return this._97544bio;
      }
      
      public function set record_label(param1:String) : void
      {
         var _loc2_:Object = this._2116416122record_label;
         if(_loc2_ !== param1)
         {
            this._2116416122record_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"record_label",_loc2_,param1));
         }
      }
      
      public function set genre(param1:String) : void
      {
         var _loc2_:Object = this._98240899genre;
         if(_loc2_ !== param1)
         {
            this._98240899genre = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"genre",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hours() : String
      {
         return this._99469071hours;
      }
      
      [Bindable(event="propertyChange")]
      public function get pic_small() : String
      {
         return this._1762076142pic_small;
      }
      
      public function set bio(param1:String) : void
      {
         var _loc2_:Object = this._97544bio;
         if(_loc2_ !== param1)
         {
            this._97544bio = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bio",_loc2_,param1));
         }
      }
      
      public function set hours(param1:String) : void
      {
         var _loc2_:Object = this._99469071hours;
         if(_loc2_ !== param1)
         {
            this._99469071hours = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hours",_loc2_,param1));
         }
      }
      
      public function set mission(param1:String) : void
      {
         var _loc2_:Object = this._1069449612mission;
         if(_loc2_ !== param1)
         {
            this._1069449612mission = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mission",_loc2_,param1));
         }
      }
      
      public function set pic_small(param1:String) : void
      {
         var _loc2_:Object = this._1762076142pic_small;
         if(_loc2_ !== param1)
         {
            this._1762076142pic_small = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pic_small",_loc2_,param1));
         }
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get band_members() : String
      {
         return this._68251919band_members;
      }
      
      public function set band_members(param1:String) : void
      {
         var _loc2_:Object = this._68251919band_members;
         if(_loc2_ !== param1)
         {
            this._68251919band_members = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"band_members",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get network() : String
      {
         return this._1843485230network;
      }
      
      public function set website(param1:String) : void
      {
         var _loc2_:Object = this._1224335515website;
         if(_loc2_ !== param1)
         {
            this._1224335515website = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"website",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function set influences(param1:String) : void
      {
         var _loc2_:Object = this._1774829598influences;
         if(_loc2_ !== param1)
         {
            this._1774829598influences = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"influences",_loc2_,param1));
         }
      }
      
      public function set schedule(param1:String) : void
      {
         var _loc2_:Object = this._697920873schedule;
         if(_loc2_ !== param1)
         {
            this._697920873schedule = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"schedule",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get influences() : String
      {
         return this._1774829598influences;
      }
      
      public function set founded(param1:String) : void
      {
         var _loc2_:Object = this._674640991founded;
         if(_loc2_ !== param1)
         {
            this._674640991founded = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"founded",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pic_large() : String
      {
         return this._1768882106pic_large;
      }
      
      public function set directed_by(param1:String) : void
      {
         var _loc2_:Object = this._1635870290directed_by;
         if(_loc2_ !== param1)
         {
            this._1635870290directed_by = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"directed_by",_loc2_,param1));
         }
      }
      
      public function set network(param1:String) : void
      {
         var _loc2_:Object = this._1843485230network;
         if(_loc2_ !== param1)
         {
            this._1843485230network = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"network",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get products() : String
      {
         return this._1003761308products;
      }
      
      public function set location(param1:FacebookLocation) : void
      {
         var _loc2_:Object = this._1901043637location;
         if(_loc2_ !== param1)
         {
            this._1901043637location = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"location",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pic_square() : String
      {
         return this._1214494066pic_square;
      }
      
      public function set awards(param1:String) : void
      {
         var _loc2_:Object = this._1405038154awards;
         if(_loc2_ !== param1)
         {
            this._1405038154awards = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"awards",_loc2_,param1));
         }
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get written_by() : String
      {
         return this._201317249written_by;
      }
      
      [Bindable(event="propertyChange")]
      public function get starring() : String
      {
         return this._1316747138starring;
      }
      
      [Bindable(event="propertyChange")]
      public function get genre() : String
      {
         return this._98240899genre;
      }
      
      public function set pic_large(param1:String) : void
      {
         var _loc2_:Object = this._1768882106pic_large;
         if(_loc2_ !== param1)
         {
            this._1768882106pic_large = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pic_large",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mission() : String
      {
         return this._1069449612mission;
      }
      
      public function set page_id(param1:Number) : void
      {
         var _loc2_:Object = this._803548981page_id;
         if(_loc2_ !== param1)
         {
            this._803548981page_id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"page_id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get schedule() : String
      {
         return this._697920873schedule;
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      [Bindable(event="propertyChange")]
      public function get website() : String
      {
         return this._1224335515website;
      }
      
      public function set pic_big(param1:String) : void
      {
         var _loc2_:Object = this._578385717pic_big;
         if(_loc2_ !== param1)
         {
            this._578385717pic_big = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pic_big",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get record_label() : String
      {
         return this._2116416122record_label;
      }
      
      [Bindable(event="propertyChange")]
      public function get founded() : String
      {
         return this._674640991founded;
      }
      
      [Bindable(event="propertyChange")]
      public function get directed_by() : String
      {
         return this._1635870290directed_by;
      }
      
      [Bindable(event="propertyChange")]
      public function get location() : FacebookLocation
      {
         return this._1901043637location;
      }
      
      public function set studio(param1:String) : void
      {
         var _loc2_:Object = this._891901482studio;
         if(_loc2_ !== param1)
         {
            this._891901482studio = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"studio",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get awards() : String
      {
         return this._1405038154awards;
      }
      
      public function set season(param1:String) : void
      {
         var _loc2_:Object = this._906335517season;
         if(_loc2_ !== param1)
         {
            this._906335517season = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"season",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get page_id() : Number
      {
         return this._803548981page_id;
      }
      
      public function set release_date(param1:String) : void
      {
         var _loc2_:Object = this._1965855514release_date;
         if(_loc2_ !== param1)
         {
            this._1965855514release_date = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"release_date",_loc2_,param1));
         }
      }
      
      public function set products(param1:String) : void
      {
         var _loc2_:Object = this._1003761308products;
         if(_loc2_ !== param1)
         {
            this._1003761308products = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"products",_loc2_,param1));
         }
      }
      
      public function set plot_outline(param1:String) : void
      {
         var _loc2_:Object = this._1817326876plot_outline;
         if(_loc2_ !== param1)
         {
            this._1817326876plot_outline = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"plot_outline",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get studio() : String
      {
         return this._891901482studio;
      }
      
      [Bindable(event="propertyChange")]
      public function get pic_big() : String
      {
         return this._578385717pic_big;
      }
      
      public function set pic_square(param1:String) : void
      {
         var _loc2_:Object = this._1214494066pic_square;
         if(_loc2_ !== param1)
         {
            this._1214494066pic_square = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pic_square",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get release_date() : String
      {
         return this._1965855514release_date;
      }
      
      public function set hometown(param1:String) : void
      {
         var _loc2_:Object = this._485238799hometown;
         if(_loc2_ !== param1)
         {
            this._485238799hometown = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hometown",_loc2_,param1));
         }
      }
      
      public function set produced_by(param1:String) : void
      {
         var _loc2_:Object = this._1505017102produced_by;
         if(_loc2_ !== param1)
         {
            this._1505017102produced_by = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"produced_by",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hometown() : String
      {
         return this._485238799hometown;
      }
      
      [Bindable(event="propertyChange")]
      public function get produced_by() : String
      {
         return this._1505017102produced_by;
      }
      
      [Bindable(event="propertyChange")]
      public function get plot_outline() : String
      {
         return this._1817326876plot_outline;
      }
      
      public function set company_overview(param1:String) : void
      {
         var _loc2_:Object = this._915840763company_overview;
         if(_loc2_ !== param1)
         {
            this._915840763company_overview = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"company_overview",_loc2_,param1));
         }
      }
      
      public function set has_added_app(param1:Boolean) : void
      {
         var _loc2_:Object = this._2002886397has_added_app;
         if(_loc2_ !== param1)
         {
            this._2002886397has_added_app = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"has_added_app",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get company_overview() : String
      {
         return this._915840763company_overview;
      }
      
      [Bindable(event="propertyChange")]
      public function get has_added_app() : Boolean
      {
         return this._2002886397has_added_app;
      }
      
      public function set written_by(param1:String) : void
      {
         var _loc2_:Object = this._201317249written_by;
         if(_loc2_ !== param1)
         {
            this._201317249written_by = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"written_by",_loc2_,param1));
         }
      }
   }
}


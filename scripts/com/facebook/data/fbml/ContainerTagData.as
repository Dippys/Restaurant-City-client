package com.facebook.data.fbml
{
   import mx.events.PropertyChangeEvent;
   
   public class ContainerTagData extends AbstractTagData
   {
      
      private var _1772097351close_tag_fbml:String;
      
      private var _1445528373open_tag_fbml:String;
      
      public function ContainerTagData(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String = "", param8:String = "", param9:AttributeCollection = null)
      {
         this.open_tag_fbml = param5;
         this.close_tag_fbml = param6;
         super(param1,param2,param3,param4,param7,param8,param9);
      }
      
      [Bindable(event="propertyChange")]
      public function get open_tag_fbml() : String
      {
         return this._1445528373open_tag_fbml;
      }
      
      [Bindable(event="propertyChange")]
      public function get close_tag_fbml() : String
      {
         return this._1772097351close_tag_fbml;
      }
      
      public function set open_tag_fbml(param1:String) : void
      {
         var _loc2_:Object = this._1445528373open_tag_fbml;
         if(_loc2_ !== param1)
         {
            this._1445528373open_tag_fbml = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"open_tag_fbml",_loc2_,param1));
         }
      }
      
      public function set close_tag_fbml(param1:String) : void
      {
         var _loc2_:Object = this._1772097351close_tag_fbml;
         if(_loc2_ !== param1)
         {
            this._1772097351close_tag_fbml = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"close_tag_fbml",_loc2_,param1));
         }
      }
   }
}


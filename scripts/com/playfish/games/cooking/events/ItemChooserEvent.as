package com.playfish.games.cooking.events
{
   import flash.events.Event;
   
   public class ItemChooserEvent extends Event
   {
      
      public static const EVENT_ITEM_MOUSE_DOWN:String = "item_mousedown";
      
      public static const EVENT_ITEM_CLICK:String = "item_click";
      
      public static const EVENT_SELL:String = "item_sell";
      
      public static const EVENT_GIFT:String = "item_gift";
      
      public var itemConfig:Object;
      
      public function ItemChooserEvent(param1:String)
      {
         super(param1);
      }
   }
}


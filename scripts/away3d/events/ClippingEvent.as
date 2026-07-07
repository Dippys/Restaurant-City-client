package away3d.events
{
   import away3d.core.clip.Clipping;
   import flash.events.Event;
   
   public class ClippingEvent extends Event
   {
      
      public static const CLIPPING_UPDATED:String = "clippingUpdated";
      
      public static const SCREEN_UPDATED:String = "screenUpdated";
      
      public var clipping:Clipping;
      
      public function ClippingEvent(param1:String, param2:Clipping)
      {
         super(param1);
         this.clipping = param2;
      }
      
      override public function clone() : Event
      {
         return new ClippingEvent(type,clipping);
      }
   }
}


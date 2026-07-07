package away3d.events
{
   import away3d.core.base.Geometry;
   import flash.events.Event;
   
   public class GeometryEvent extends Event
   {
      
      public static const DIMENSIONS_CHANGED:String = "dimensionsChanged";
      
      public var geometry:Geometry;
      
      public function GeometryEvent(param1:String, param2:Geometry)
      {
         super(param1);
         this.geometry = param2;
      }
      
      override public function clone() : Event
      {
         return new GeometryEvent(type,geometry);
      }
   }
}


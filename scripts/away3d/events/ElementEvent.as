package away3d.events
{
   import away3d.core.base.Element;
   import flash.events.Event;
   
   public class ElementEvent extends Event
   {
      
      public static const MAPPING_CHANGED:String = "mappingChanged";
      
      public static const VERTEX_CHANGED:String = "vertexChanged";
      
      public static const VERTEXVALUE_CHANGED:String = "vertexvalueChanged";
      
      public static const VISIBLE_CHANGED:String = "visibleChanged";
      
      public var element:Element;
      
      public function ElementEvent(param1:String, param2:Element)
      {
         super(param1);
         this.element = param2;
      }
      
      override public function clone() : Event
      {
         return new ElementEvent(type,element);
      }
   }
}


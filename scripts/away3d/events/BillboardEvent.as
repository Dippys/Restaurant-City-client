package away3d.events
{
   import away3d.core.base.Billboard;
   import flash.events.Event;
   
   public class BillboardEvent extends Event
   {
      
      public static const MATERIAL_CHANGED:String = "materialChanged";
      
      public var billboard:Billboard;
      
      public function BillboardEvent(param1:String, param2:Billboard)
      {
         super(param1);
         this.billboard = param2;
      }
      
      override public function clone() : Event
      {
         return new BillboardEvent(type,billboard);
      }
   }
}


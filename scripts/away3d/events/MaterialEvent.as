package away3d.events
{
   import away3d.materials.IMaterial;
   import flash.events.Event;
   
   public class MaterialEvent extends Event
   {
      
      public static const LOAD_ERROR:String = "loadError";
      
      public static const LOAD_PROGRESS:String = "loadProgress";
      
      public static const LOAD_SUCCESS:String = "loadSuccess";
      
      public static const MATERIAL_UPDATED:String = "materialUpdated";
      
      public static const MATERIAL_CHANGED:String = "materialChanged";
      
      public var extra:Object;
      
      public var material:IMaterial;
      
      public function MaterialEvent(param1:String, param2:IMaterial)
      {
         super(param1);
         this.material = param2;
      }
      
      override public function clone() : Event
      {
         return new MaterialEvent(type,material);
      }
   }
}


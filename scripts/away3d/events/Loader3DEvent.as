package away3d.events
{
   import away3d.loaders.Loader3D;
   import flash.events.Event;
   
   public class Loader3DEvent extends Event
   {
      
      public static const LOAD_SUCCESS:String = "loadSuccess";
      
      public static const LOAD_PROGRESS:String = "loadProgress";
      
      public static const LOAD_ERROR:String = "loadError";
      
      public var loader:Loader3D;
      
      public function Loader3DEvent(param1:String, param2:Loader3D)
      {
         super(param1);
         this.loader = param2;
      }
      
      override public function clone() : Event
      {
         return new Loader3DEvent(type,loader);
      }
   }
}


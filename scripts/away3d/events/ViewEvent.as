package away3d.events
{
   import away3d.containers.View3D;
   import flash.events.Event;
   
   public class ViewEvent extends Event
   {
      
      public static const UPDATE_SCENE:String = "updateScene";
      
      public static const RENDER_COMPLETE:String = "renderComplete";
      
      public var view:View3D;
      
      public function ViewEvent(param1:String, param2:View3D)
      {
         super(param1);
         this.view = param2;
      }
      
      override public function clone() : Event
      {
         return new ViewEvent(type,view);
      }
   }
}


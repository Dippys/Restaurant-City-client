package away3d.events
{
   import away3d.cameras.Camera3D;
   import flash.events.Event;
   
   public class CameraEvent extends Event
   {
      
      public static const CAMERA_UPDATED:String = "cameraUpdated";
      
      public var camera:Camera3D;
      
      public function CameraEvent(param1:String, param2:Camera3D)
      {
         super(param1);
         this.camera = param2;
      }
      
      override public function clone() : Event
      {
         return new CameraEvent(type,camera);
      }
   }
}


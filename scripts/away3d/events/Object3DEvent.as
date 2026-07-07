package away3d.events
{
   import away3d.core.base.Object3D;
   import flash.events.Event;
   
   public class Object3DEvent extends Event
   {
      
      public static const PARENT_UPDATED:String = "parentUpdated";
      
      public static const TRANSFORM_CHANGED:String = "transformChanged";
      
      public static const SCENETRANSFORM_CHANGED:String = "scenetransformChanged";
      
      public static const SCENE_CHANGED:String = "sceneChanged";
      
      public static const SESSION_CHANGED:String = "sessionChanged";
      
      public static const SESSION_UPDATED:String = "sessionUpdated";
      
      public static const DIMENSIONS_CHANGED:String = "dimensionsChanged";
      
      public var object:Object3D;
      
      public function Object3DEvent(param1:String, param2:Object3D)
      {
         super(param1);
         this.object = param2;
      }
      
      override public function clone() : Event
      {
         return new Object3DEvent(type,object);
      }
   }
}


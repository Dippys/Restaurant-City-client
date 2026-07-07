package away3d.events
{
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.base.UV;
   import away3d.core.draw.DrawPrimitive;
   import away3d.materials.IUVMaterial;
   import flash.events.Event;
   
   public class MouseEvent3D extends Event
   {
      
      public static const MOUSE_OVER:String = "mouseOver3d";
      
      public static const MOUSE_OUT:String = "mouseOut3d";
      
      public static const MOUSE_UP:String = "mouseUp3d";
      
      public static const MOUSE_DOWN:String = "mouseDown3d";
      
      public static const MOUSE_MOVE:String = "mouseMove3d";
      
      public static const ROLL_OVER:String = "rollOver3d";
      
      public static const ROLL_OUT:String = "rollOut3d";
      
      public var sceneX:Number;
      
      public var sceneY:Number;
      
      public var sceneZ:Number;
      
      public var uv:UV;
      
      public var drawpri:DrawPrimitive;
      
      public var view:View3D;
      
      public var material:IUVMaterial;
      
      public var screenX:Number;
      
      public var screenY:Number;
      
      public var screenZ:Number;
      
      public var ctrlKey:Boolean;
      
      public var element:Object;
      
      public var shiftKey:Boolean;
      
      public var object:Object3D;
      
      public function MouseEvent3D(param1:String)
      {
         super(param1,false,true);
      }
      
      override public function clone() : Event
      {
         var _loc1_:MouseEvent3D = new MouseEvent3D(type);
         if(isDefaultPrevented())
         {
            _loc1_.preventDefault();
         }
         _loc1_.screenX = screenX;
         _loc1_.screenY = screenY;
         _loc1_.screenZ = screenZ;
         _loc1_.sceneX = sceneX;
         _loc1_.sceneY = sceneY;
         _loc1_.sceneZ = sceneZ;
         _loc1_.view = view;
         _loc1_.object = object;
         _loc1_.element = element;
         _loc1_.drawpri = drawpri;
         _loc1_.material = material;
         _loc1_.uv = uv;
         _loc1_.ctrlKey = ctrlKey;
         _loc1_.shiftKey = shiftKey;
         return _loc1_;
      }
   }
}


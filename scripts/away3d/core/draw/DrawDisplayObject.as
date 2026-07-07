package away3d.core.draw
{
   import away3d.core.render.AbstractRenderSession;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class DrawDisplayObject extends DrawPrimitive
   {
      
      public var displayobject:DisplayObject;
      
      public var vx:Number;
      
      public var vy:Number;
      
      public var vz:Number;
      
      private var displayRect:Rectangle;
      
      public var session:AbstractRenderSession;
      
      public function DrawDisplayObject()
      {
         super();
      }
      
      override public function clear() : void
      {
         displayobject = null;
      }
      
      override public function calc() : void
      {
         displayRect = displayobject.getBounds(displayobject);
         screenZ = vz;
         minZ = screenZ;
         maxZ = screenZ;
         minX = vx + displayRect.left;
         minY = vy + displayRect.top;
         maxX = vx + displayRect.right;
         maxY = vy + displayRect.bottom;
      }
      
      override public function render() : void
      {
         displayobject.x = vx;
         displayobject.y = vy;
         session.addDisplayObject(displayobject);
      }
      
      override public function contains(param1:Number, param2:Number) : Boolean
      {
         return true;
      }
   }
}


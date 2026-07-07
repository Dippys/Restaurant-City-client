package away3d.core.draw
{
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   
   public class DrawPrimitive
   {
      
      public var create:Function;
      
      public var minX:Number;
      
      public var minY:Number;
      
      public var minZ:Number;
      
      public var generated:Boolean;
      
      public var source:Object3D;
      
      public var view:View3D;
      
      public var screenZ:Number;
      
      public var maxX:Number;
      
      public var maxY:Number;
      
      public var quadrant:PrimitiveQuadrantTreeNode;
      
      public var maxZ:Number;
      
      public function DrawPrimitive()
      {
         super();
      }
      
      public function getZ(param1:Number, param2:Number) : Number
      {
         return screenZ;
      }
      
      public function clear() : void
      {
         throw new Error("Not implemented");
      }
      
      public function calc() : void
      {
         throw new Error("Not implemented");
      }
      
      public function render() : void
      {
         throw new Error("Not implemented");
      }
      
      public function contains(param1:Number, param2:Number) : Boolean
      {
         throw new Error("Not implemented");
      }
      
      public function quarter(param1:Number) : Array
      {
         return [this];
      }
      
      public function toString() : String
      {
         return "P{ screenZ = " + screenZ + ", minZ = " + minZ + ", maxZ = " + maxZ + " }";
      }
   }
}


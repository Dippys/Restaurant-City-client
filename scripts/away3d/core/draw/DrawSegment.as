package away3d.core.draw
{
   import away3d.arcane;
   import away3d.core.utils.*;
   import away3d.materials.*;
   
   use namespace arcane;
   
   public class DrawSegment extends DrawPrimitive
   {
      
      public var screenVertices:Array;
      
      private var bzf:Number;
      
      private var axf:Number;
      
      public var startIndex:int;
      
      private var det:Number;
      
      private var dx:Number;
      
      private var dy:Number;
      
      public var screenIndices:Array;
      
      private var faz:Number;
      
      public var screenCommands:Array;
      
      public var material:ISegmentMaterial;
      
      public var segmentVO:SegmentVO;
      
      private var ayf:Number;
      
      private var ax:Number;
      
      private var ay:Number;
      
      private var az:Number;
      
      private var fbz:Number;
      
      public var v0y:Number;
      
      public var v0x:Number;
      
      public var endIndex:int;
      
      public var v0z:Number;
      
      private var azf:Number;
      
      private var bxf:Number;
      
      private var _index:int;
      
      private var bx:Number;
      
      private var by:Number;
      
      private var bz:Number;
      
      public var v1x:Number;
      
      private var focus:Number;
      
      private var xfocus:Number;
      
      public var v1y:Number;
      
      public var v1z:Number;
      
      public var length:Number;
      
      private var byf:Number;
      
      private var da:Number;
      
      private var db:Number;
      
      private var yfocus:Number;
      
      public function DrawSegment()
      {
         super();
      }
      
      override public function render() : void
      {
         material.renderSegment(this);
      }
      
      arcane function onepointcut(param1:Number, param2:Number, param3:Number) : Array
      {
         var _loc4_:int = int(screenIndices.length);
         screenIndices[screenIndices.length] = startIndex;
         screenIndices[screenIndices.length] = screenVertices.length;
         var _loc5_:int = int(screenIndices.length);
         screenIndices[screenIndices.length] = screenVertices.length;
         screenIndices[screenIndices.length] = startIndex + 1;
         var _loc6_:int = int(screenIndices.length);
         screenVertices[screenVertices.length] = param1;
         screenVertices[screenVertices.length] = param2;
         screenVertices[screenVertices.length] = param3;
         return [create(source,segmentVO,material,screenVertices,screenIndices,screenCommands,_loc4_,_loc5_,true),create(source,segmentVO,material,screenVertices,screenIndices,screenCommands,_loc5_,_loc6_,true)];
      }
      
      override public function quarter(param1:Number) : Array
      {
         if(length < 5)
         {
            return null;
         }
         var _loc2_:int = int(screenIndices.length);
         screenIndices[screenIndices.length] = startIndex;
         screenIndices[screenIndices.length] = screenVertices.length;
         var _loc3_:int = int(screenIndices.length);
         screenIndices[screenIndices.length] = screenVertices.length;
         screenIndices[screenIndices.length] = startIndex + 1;
         var _loc4_:int = int(screenIndices.length);
         ScreenVertex.median(startIndex,startIndex + 1,screenVertices,screenIndices,param1);
         return [create(source,segmentVO,material,screenVertices,screenIndices,screenCommands,_loc2_,_loc3_,true),create(source,segmentVO,material,screenVertices,screenIndices,screenCommands,_loc3_,_loc4_,true)];
      }
      
      override public function contains(param1:Number, param2:Number) : Boolean
      {
         if(Math.abs(v0x * (param2 - v1y) + v1x * (v0y - param2) + param1 * (v1y - v0y)) > 0.001 * 1000 * 1000)
         {
            return false;
         }
         if(distanceToCenter(param1,param2) * 2 > length)
         {
            return false;
         }
         return true;
      }
      
      override public function getZ(param1:Number, param2:Number) : Number
      {
         focus = view.camera.focus;
         ax = v0x;
         ay = v0y;
         az = v0z;
         bx = v1x;
         by = v1y;
         bz = v1z;
         if(ax == param1 && ay == param2)
         {
            return az;
         }
         if(bx == param1 && by == param2)
         {
            return bz;
         }
         dx = bx - ax;
         dy = by - ay;
         azf = az / focus;
         bzf = bz / focus;
         faz = 1 + azf;
         fbz = 1 + bzf;
         xfocus = param1;
         yfocus = param2;
         axf = ax * faz - param1 * azf;
         bxf = bx * fbz - param1 * bzf;
         ayf = ay * faz - param2 * azf;
         byf = by * fbz - param2 * bzf;
         det = dx * (axf - bxf) + dy * (ayf - byf);
         db = dx * (axf - param1) + dy * (ayf - param2);
         da = dx * (param1 - bxf) + dy * (param2 - byf);
         return (da * az + db * bz) / det;
      }
      
      private function distanceToCenter(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (v0x + v1x) / 2;
         var _loc4_:Number = (v0y + v1y) / 2;
         return Math.sqrt((_loc3_ - param1) * (_loc3_ - param1) + (_loc4_ - param2) * (_loc4_ - param2));
      }
      
      override public function clear() : void
      {
      }
      
      override public function calc() : void
      {
         _index = screenIndices[startIndex] * 3;
         v0x = screenVertices[_index];
         v0y = screenVertices[_index + 1];
         v0z = screenVertices[_index + 2];
         _index = screenIndices[startIndex + 1] * 3;
         v1x = screenVertices[_index];
         v1y = screenVertices[_index + 1];
         v1z = screenVertices[_index + 2];
         if(v0z < v1z)
         {
            minZ = v0z;
            maxZ = v1z + 1;
         }
         else
         {
            minZ = v1z;
            maxZ = v0z + 1;
         }
         screenZ = (v0z + v1z) / 2;
         if(v0x < v1x)
         {
            minX = v0x;
            maxX = v1x + 1;
         }
         else
         {
            minX = v1x;
            maxX = v0x + 1;
         }
         if(v0y < v1y)
         {
            minY = v0y;
            maxY = v1y + 1;
         }
         else
         {
            minY = v1y;
            maxY = v0y + 1;
         }
         length = Math.sqrt((maxX - minX) * (maxX - minX) + (maxY - minY) * (maxY - minY));
      }
      
      override public function toString() : String
      {
         return "S{ screenZ = " + screenZ + ", minZ = " + minZ + ", maxZ = " + maxZ + " }";
      }
   }
}


package away3d.core.clip
{
   import away3d.core.draw.DrawPrimitive;
   
   public class RectangleClipping extends Clipping
   {
      
      public function RectangleClipping(param1:Object = null)
      {
         super(param1);
         objectCulling = ini.getBoolean("objectCulling",false);
      }
      
      override public function clone(param1:Clipping = null) : Clipping
      {
         var _loc2_:RectangleClipping = param1 as RectangleClipping || new RectangleClipping();
         super.clone(_loc2_);
         return _loc2_;
      }
      
      override public function checkPrimitive(param1:DrawPrimitive) : Boolean
      {
         if(param1.maxX < minX)
         {
            return false;
         }
         if(param1.minX > maxX)
         {
            return false;
         }
         if(param1.maxY < minY)
         {
            return false;
         }
         if(param1.minY > maxY)
         {
            return false;
         }
         return true;
      }
   }
}


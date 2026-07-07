package away3d.core.block
{
   import away3d.core.draw.DrawPrimitive;
   
   public class Blocker extends DrawPrimitive
   {
      
      public function Blocker()
      {
         super();
      }
      
      public function block(param1:DrawPrimitive) : Boolean
      {
         return false;
      }
   }
}


package away3d.core.filter
{
   import away3d.cameras.Camera3D;
   import away3d.containers.Scene3D;
   import away3d.core.clip.Clipping;
   
   public class ZSortFilter implements IPrimitiveFilter
   {
      
      public function ZSortFilter()
      {
         super();
      }
      
      public function filter(param1:Array, param2:Scene3D, param3:Camera3D, param4:Clipping) : Array
      {
         param1.sortOn("screenZ",Array.DESCENDING | Array.NUMERIC);
         return param1;
      }
      
      public function toString() : String
      {
         return "ZSort";
      }
   }
}


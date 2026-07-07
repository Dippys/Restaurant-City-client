package away3d.core.block
{
   import away3d.core.clip.Clipping;
   
   public class BlockerArray implements IBlockerConsumer
   {
      
      private var _blockers:Array = [];
      
      private var _clip:Clipping;
      
      public function BlockerArray()
      {
         super();
      }
      
      public function set clip(param1:Clipping) : void
      {
         _clip = param1;
         _blockers = [];
      }
      
      public function list() : Array
      {
         _blockers.sortOn("screenZ",Array.NUMERIC);
         return _blockers;
      }
      
      public function get clip() : Clipping
      {
         return _clip;
      }
      
      public function blocker(param1:Blocker) : void
      {
         if(_clip.checkPrimitive(param1))
         {
            _blockers.push(param1);
         }
      }
   }
}


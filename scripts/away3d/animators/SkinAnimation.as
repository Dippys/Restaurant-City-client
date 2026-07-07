package away3d.animators
{
   import away3d.animators.skin.Channel;
   import away3d.containers.ObjectContainer3D;
   import away3d.core.utils.Debug;
   
   public class SkinAnimation implements IMeshAnimation
   {
      
      public var start:Number;
      
      public var loop:Boolean;
      
      public var length:Number;
      
      private var _channels:Array;
      
      public function SkinAnimation()
      {
         super();
         Debug.trace(" + SkinAnimation");
         _channels = [];
         loop = true;
         length = 0;
      }
      
      public function update(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:Channel = null;
         if(param1 > start + length)
         {
            if(loop)
            {
               param1 = start + (param1 - start) % length;
            }
            else
            {
               param1 = start + length;
            }
         }
         else if(param1 < start)
         {
            if(loop)
            {
               param1 = start + (param1 - start) % length + length;
            }
            else
            {
               param1 = start;
            }
         }
         for each(_loc3_ in _channels)
         {
            _loc3_.update(param1,param2);
         }
      }
      
      public function appendChannel(param1:Channel) : void
      {
         _channels.push(param1);
      }
      
      public function clone(param1:ObjectContainer3D) : IMeshAnimation
      {
         var _loc3_:Channel = null;
         var _loc2_:SkinAnimation = new SkinAnimation();
         _loc2_.loop = loop;
         _loc2_.length = length;
         _loc2_.start = start;
         for each(_loc3_ in _channels)
         {
            _loc2_.appendChannel(_loc3_.clone(param1));
         }
         return _loc2_;
      }
   }
}


package away3d.loaders.utils
{
   import away3d.core.utils.Debug;
   import away3d.loaders.data.*;
   import flash.utils.Dictionary;
   
   public dynamic class ChannelLibrary extends Dictionary
   {
      
      private var _channelArray:Array;
      
      private var _channelArrayDirty:Boolean;
      
      public function ChannelLibrary()
      {
         super();
      }
      
      public function addChannel(param1:String, param2:XML) : ChannelData
      {
         if(this[param1])
         {
            return this[param1];
         }
         _channelArrayDirty = true;
         var _loc3_:ChannelData = new ChannelData();
         _loc3_.xml = param2;
         var _loc4_:String;
         this[_loc4_ = _loc3_.name = param1] = _loc3_;
         return _loc3_;
      }
      
      public function getChannel(param1:String) : ChannelData
      {
         if(this[param1])
         {
            return this[param1];
         }
         Debug.warning("Channel \'" + param1 + "\' does not exist");
         return null;
      }
      
      public function getChannelArray() : Array
      {
         if(_channelArrayDirty)
         {
            updateChannelArray();
         }
         return _channelArray;
      }
      
      private function updateChannelArray() : void
      {
         var _loc1_:ChannelData = null;
         _channelArray = [];
         for each(_loc1_ in this)
         {
            _channelArray.push(_loc1_);
         }
      }
   }
}


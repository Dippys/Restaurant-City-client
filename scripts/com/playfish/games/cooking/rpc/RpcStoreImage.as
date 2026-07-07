package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class RpcStoreImage extends RpcBase
   {
      
      public function RpcStoreImage()
      {
         super();
      }
      
      public function onStoreImageSuccess(param1:Number) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("onStoreImageSuccess success=" + param1);
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc2_);
         }
      }
      
      public function onStoreImageFail() : void
      {
         Debug.out("onStoreImageFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         var _loc1_:BitmapData = null;
         if(GameWorld.gameUser.avatarFrame != null)
         {
            _loc1_ = GameWorld.gameUser.avatarFrame.bitmapData;
            GameWorld.rpcClient.storeImage(RpcClient.AVATAR_TYPE_PROFILE_NARROW,_loc1_.getPixels(new Rectangle(0,0,_loc1_.width,_loc1_.height)),_loc1_.width,_loc1_.height,onStoreImageSuccess,onStoreImageFail);
            return true;
         }
         return false;
      }
   }
}


package com.playfish.games.cooking
{
   import flash.display.*;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.*;
   import flash.system.LoaderContext;
   
   public class BitmapBatch
   {
      
      public var bitmaps:Array = new Array();
      
      public function BitmapBatch()
      {
         super();
      }
      
      public function releaseAll() : void
      {
         var _loc2_:Bitmap = null;
         var _loc1_:int = 0;
         while(_loc1_ < bitmaps.length)
         {
            _loc2_ = bitmaps[_loc1_];
            _loc2_.bitmapData.dispose();
            _loc1_++;
         }
      }
      
      public function getBitmap(param1:String) : Loader
      {
         var _loc2_:Loader = null;
         var _loc3_:URLRequest = null;
         var _loc4_:LoaderContext = null;
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = new Loader();
            _loc3_ = new URLRequest(param1);
            _loc4_ = new LoaderContext(true);
            _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,onFaceImageComplete);
            _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onFaceImageError);
            _loc2_.load(_loc3_,_loc4_);
            return _loc2_;
         }
         return null;
      }
      
      private function onFaceImageComplete(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget.content);
         param1.currentTarget.removeEventListener(Event.COMPLETE,onFaceImageComplete);
         param1.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,onFaceImageError);
         _loc2_.x = -_loc2_.width / 2;
         _loc2_.y = -_loc2_.height / 2;
         bitmaps.push(_loc2_);
      }
      
      private function onFaceImageError(param1:IOErrorEvent) : void
      {
         Debug.out("BitmapBatch image load failed: " + param1.text);
         param1.currentTarget.removeEventListener(Event.COMPLETE,onFaceImageComplete);
         param1.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,onFaceImageError);
      }
   }
}


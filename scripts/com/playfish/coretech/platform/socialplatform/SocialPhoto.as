package com.playfish.coretech.platform.socialplatform
{
   import flash.display.BitmapData;
   
   public class SocialPhoto
   {
      
      protected var caption:String;
      
      protected var backRefObject:Object;
      
      protected var imageSource:BitmapData;
      
      protected var taglist:Array;
      
      public function SocialPhoto(param1:Object = null)
      {
         super();
         taglist = new Array();
         backRefObject = param1;
      }
      
      public function upload(param1:Function = null) : Boolean
      {
         return SocialPlatform.instance.photos.uploadPhoto(this,param1);
      }
      
      public function setImageData(param1:BitmapData) : Boolean
      {
         imageSource = param1;
         return true;
      }
      
      public function setCaption(param1:String) : Boolean
      {
         caption = param1;
         return true;
      }
      
      public function build() : Object
      {
         return null;
      }
      
      private function _getWidth() : uint
      {
         return 0;
      }
      
      public function getTagCount() : uint
      {
         return taglist.length;
      }
      
      public function getReferenceObject() : Object
      {
         return backRefObject;
      }
      
      public function addTag(param1:SocialPhotoTag) : Boolean
      {
         taglist.push(param1);
         return true;
      }
      
      public function getTag(param1:uint) : SocialPhotoTag
      {
         if(param1 < taglist.length)
         {
            return taglist[param1];
         }
         return null;
      }
      
      private function _getHeight() : uint
      {
         return 0;
      }
   }
}


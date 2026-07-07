package com.facebook.data.photos
{
   import com.facebook.utils.FacebookArrayCollection;
   
   public class PhotoTagCollection extends FacebookArrayCollection
   {
      
      public function PhotoTagCollection(param1:Array = null)
      {
         super(null,TagData);
      }
      
      public function addPhotoTag(param1:TagData) : void
      {
         this.addItem(param1);
      }
   }
}


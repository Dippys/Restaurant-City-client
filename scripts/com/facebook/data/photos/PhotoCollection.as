package com.facebook.data.photos
{
   import com.facebook.utils.FacebookArrayCollection;
   
   public class PhotoCollection extends FacebookArrayCollection
   {
      
      public function PhotoCollection()
      {
         super(null,PhotoData);
      }
      
      public function addPhoto(param1:PhotoData) : void
      {
         this.addItem(param1);
      }
   }
}


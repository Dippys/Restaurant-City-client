package com.facebook.data.photos
{
   import com.facebook.utils.FacebookArrayCollection;
   
   public class AlbumCollection extends FacebookArrayCollection
   {
      
      public function AlbumCollection()
      {
         super(null,AlbumData);
      }
      
      public function addAlbum(param1:AlbumData) : void
      {
         this.addItem(param1);
      }
   }
}


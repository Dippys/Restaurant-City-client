package com.facebook.data.pages
{
   import com.facebook.utils.FacebookArrayCollection;
   
   public class PageInfoCollection extends FacebookArrayCollection
   {
      
      public function PageInfoCollection()
      {
         super(null,PageInfoData);
      }
      
      public function addPageInfo(param1:PageInfoData) : void
      {
         this.addItem(param1);
      }
   }
}


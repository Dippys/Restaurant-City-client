package com.facebook.data.users
{
   import com.facebook.utils.FacebookArrayCollection;
   
   public class AffiliationCollection extends FacebookArrayCollection
   {
      
      public function AffiliationCollection()
      {
         super(null,AffiliationData);
      }
      
      public function addAffiliation(param1:AffiliationData) : void
      {
         this.addItem(param1);
      }
   }
}


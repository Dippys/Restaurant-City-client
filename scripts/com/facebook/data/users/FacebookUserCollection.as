package com.facebook.data.users
{
   import com.facebook.utils.FacebookArrayCollection;
   
   public class FacebookUserCollection extends FacebookArrayCollection
   {
      
      public function FacebookUserCollection()
      {
         super(null,FacebookUser);
      }
      
      public function getUserById(param1:int) : FacebookUser
      {
         return findItemByProperty("uid",param1) as FacebookUser;
      }
      
      public function addUser(param1:FacebookUser) : void
      {
         addItem(param1);
      }
   }
}


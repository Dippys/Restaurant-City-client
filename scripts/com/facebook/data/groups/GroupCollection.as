package com.facebook.data.groups
{
   import com.facebook.utils.FacebookArrayCollection;
   
   public class GroupCollection extends FacebookArrayCollection
   {
      
      public function GroupCollection()
      {
         super(null,GroupData);
      }
      
      public function addGroup(param1:GroupData) : void
      {
         this.addItem(param1);
      }
   }
}


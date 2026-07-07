package com.facebook.data.batch
{
   import com.facebook.net.FacebookCall;
   import com.facebook.utils.FacebookArrayCollection;
   
   public class BatchCollection extends FacebookArrayCollection
   {
      
      public function BatchCollection()
      {
         super(null,FacebookCall);
      }
   }
}


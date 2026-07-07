package com.playfish.coretech.platform.natural.facebook
{
   import com.facebook.commands.batch.BatchRun;
   import com.facebook.data.batch.BatchCollection;
   
   public class FBCallBatchRun extends BatchRun
   {
      
      public var param2:Object;
      
      public var param:Object;
      
      public function FBCallBatchRun(param1:BatchCollection, param2:Boolean = false)
      {
         super(param1,param2);
      }
   }
}


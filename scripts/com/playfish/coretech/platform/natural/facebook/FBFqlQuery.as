package com.playfish.coretech.platform.natural.facebook
{
   import com.facebook.commands.fql.FqlQuery;
   
   public class FBFqlQuery extends FqlQuery
   {
      
      public var queuedObjectRef:Object;
      
      public function FBFqlQuery(param1:String, param2:Object)
      {
         super(param1);
         queuedObjectRef = param2;
      }
   }
}


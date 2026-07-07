package com.playfish.coretech.platform.socialstats
{
   public class RequestProcessor
   {
      
      protected var total:uint;
      
      protected var callbackHandler:Function;
      
      protected var completed:uint;
      
      protected var requestList:Array;
      
      public function RequestProcessor(param1:Function)
      {
         super();
         callbackHandler = param1;
         requestList = new Array();
      }
      
      public static function begin(param1:Function) : RequestProcessor
      {
         return new RequestProcessor(param1);
      }
      
      public function addRequest(param1:FriendshipEvaluator, param2:Object, param3:Object, param4:uint) : void
      {
         var _loc5_:Object = new Object();
         _loc5_["eval"] = param1;
         _loc5_["weight"] = param4;
         _loc5_["query"] = param1.generateQuery(param2,param3);
         if(_loc5_["query"] != null)
         {
            requestList.push(_loc5_);
         }
      }
      
      public function process() : void
      {
         var _loc1_:Object = null;
         end();
         for each(_loc1_ in requestList)
         {
            _loc1_["eval"].processQuery(this,_loc1_);
         }
      }
      
      public function onComplete() : Boolean
      {
         if(++completed == total)
         {
            if(callbackHandler != null)
            {
               callbackHandler();
            }
            return true;
         }
         return false;
      }
      
      public function end() : void
      {
         completed = 0;
         total = requestList.length;
      }
   }
}


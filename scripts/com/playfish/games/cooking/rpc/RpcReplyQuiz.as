package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.RpcClient;
   
   public class RpcReplyQuiz extends RpcBase
   {
      
      public var coinReward:int;
      
      private var ingredientItemConfig:Object;
      
      private var quizMailId:int;
      
      private var correct:Boolean;
      
      public function RpcReplyQuiz(param1:int, param2:Object, param3:Boolean)
      {
         super();
         this.quizMailId = param1;
         this.ingredientItemConfig = param2;
         this.correct = param3;
      }
      
      private function onReplyQuizFail() : void
      {
         Debug.out("onReplyQuizFail");
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         var _loc1_:String = null;
         if(ingredientItemConfig != null)
         {
            _loc1_ = ingredientItemConfig.hash;
         }
         else
         {
            _loc1_ = "";
         }
         GameWorld.rpcClient.replyQuizz(quizMailId,_loc1_,correct,onReplyQuizOK,onReplyQuizFail);
         return true;
      }
      
      private function onReplyQuizOK(param1:int) : void
      {
         var _loc2_:RpcEvent = null;
         Debug.out("onReplyQuizOK credit=" + param1);
         coinReward = 0;
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc2_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc2_.successCode = param1 == 0 ? 1 : int(RpcClient.STATUS_OK);
            dispatchEvent(_loc2_);
         }
      }
   }
}


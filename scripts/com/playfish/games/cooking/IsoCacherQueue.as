package com.playfish.games.cooking
{
   import flash.events.EventDispatcher;
   
   public class IsoCacherQueue extends EventDispatcher
   {
      
      private static var activeQueueItem:IsoCacherQueue;
      
      private static var queue:Array = new Array();
      
      protected var gameUser:GameUser;
      
      public function IsoCacherQueue(param1:GameUser)
      {
         super();
         this.gameUser = param1;
      }
      
      public static function removeQueueItemsForUser(param1:GameUser) : void
      {
         var _loc2_:* = int(queue.length - 1);
         while(_loc2_ >= 0)
         {
            if(queue[_loc2_].gameUser == param1)
            {
               queue[_loc2_].destroy();
            }
            _loc2_--;
         }
         if(Boolean(activeQueueItem) && activeQueueItem.gameUser == param1)
         {
            activeQueueItem.destroy();
         }
      }
      
      public static function clearQueue() : void
      {
         if(activeQueueItem)
         {
            activeQueueItem.destroy();
         }
         var _loc1_:* = int(queue.length - 1);
         while(_loc1_ >= 0)
         {
            queue[_loc1_].destroy();
            _loc1_--;
         }
         queue.splice(0,queue.length);
      }
      
      protected function destroy() : void
      {
         if(activeQueueItem == this)
         {
            activeQueueItem = null;
         }
         var _loc1_:int = queue.indexOf(this);
         if(_loc1_ >= 0)
         {
            queue.splice(_loc1_,1);
         }
      }
      
      protected function start() : void
      {
         if(activeQueueItem)
         {
            activeQueueItem.destroy();
         }
         activeQueueItem = this;
         queue.splice(queue.indexOf(this),1);
      }
      
      public function addToQueue(param1:Boolean) : void
      {
         if(param1)
         {
            queue.splice(0,0,this);
         }
         else
         {
            queue.push(this);
         }
         if(!activeQueueItem && queue.length >= 1)
         {
            startNextInQueue();
         }
      }
      
      public function startNextInQueue() : void
      {
         if(queue.length >= 1)
         {
            queue[0].start();
         }
      }
   }
}


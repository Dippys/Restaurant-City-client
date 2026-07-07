package com.playfish.games.cooking.usertask
{
   public class UserTaskQueue
   {
      
      public var tasks:Array = new Array();
      
      public function UserTaskQueue()
      {
         super();
      }
      
      public function addTask(param1:UserTask) : void
      {
         param1.queue = this;
         tasks.push(param1);
         if(tasks.length == 1)
         {
            tasks[0].start();
         }
      }
      
      public function removeTask(param1:UserTask) : void
      {
         var _loc2_:int = tasks.indexOf(param1);
         if(_loc2_ != -1)
         {
            tasks.splice(_loc2_,1);
         }
      }
      
      public function tick(param1:uint) : void
      {
         if(tasks.length > 0)
         {
            tasks[0].tick(param1);
            if(tasks[0].isCompleted())
            {
               tasks.splice(0,1);
               if(tasks.length > 0)
               {
                  tasks[0].start();
               }
            }
         }
      }
   }
}


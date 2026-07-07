package com.playfish.games.cooking
{
   public class PathFinderNode
   {
      
      public var g:int;
      
      public var parent:PathFinderNode;
      
      public var fScore:int;
      
      public var state:int;
      
      public var x:int;
      
      public var y:int;
      
      public function PathFinderNode(param1:int, param2:int, param3:PathFinderNode, param4:int, param5:int)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.parent = param3;
         this.g = param4;
         this.fScore = param5;
      }
   }
}


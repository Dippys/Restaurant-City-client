package com.playfish.rpc.cooking
{
   import com.playfish.rpc.share.NetworkUid;
   
   public class Employee
   {
      
      public var task:Number;
      
      public var happiness:Number;
      
      public var clothes:Array;
      
      public var notify:Boolean = false;
      
      public var id:NetworkUid;
      
      public function Employee()
      {
         super();
      }
      
      public function toString() : String
      {
         return "id " + id + " happiness=" + happiness;
      }
   }
}


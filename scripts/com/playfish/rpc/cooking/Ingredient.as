package com.playfish.rpc.cooking
{
   public class Ingredient
   {
      
      public var globalItemId:Number;
      
      public var isLocked:Boolean;
      
      public var number:Number;
      
      public function Ingredient()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[Ingredient id=" + globalItemId + " number=" + number + " isSelected=" + isLocked + "]";
      }
   }
}


package com.playfish.games.cooking
{
   import com.playfish.rpc.cooking.*;
   import flash.text.TextField;
   
   public class PerkItem extends UserItem
   {
      
      public static const TARGET_EMPLOYEE:int = 0;
      
      public static const TARGET_RESTAURANT:int = 1;
      
      private static const PERK_EFFECTS:Array = ["exp","productivity","happiness","clean","demand","gourmet","workTime"];
      
      public var durationTextField:TextField;
      
      public var happiness:Number = 0;
      
      public var clean:Number = 0;
      
      public var demand:Number = 0;
      
      public var target:int;
      
      public var productivity:Number = 0;
      
      public var duration:Number = 0;
      
      public var gourmet:Number = 0;
      
      public var exp:Number = 0;
      
      public var workTime:int = 0;
      
      public function PerkItem(param1:Object)
      {
         super(param1,null);
         if(param1.group.name == "Restaurant")
         {
            target = TARGET_RESTAURANT;
         }
         else
         {
            target = TARGET_EMPLOYEE;
         }
         var _loc2_:int = 0;
         while(_loc2_ < PERK_EFFECTS.length)
         {
            if(param1[PERK_EFFECTS[_loc2_]])
            {
               this[PERK_EFFECTS[_loc2_]] = param1[PERK_EFFECTS[_loc2_]];
            }
            _loc2_++;
         }
         duration = param1.duration;
      }
   }
}


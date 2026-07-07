package com.playfish.games.cooking.challenge
{
   import flash.display.MovieClip;
   
   public class ChallengeItem
   {
      
      public static const STATE_LOCKED:int = 0;
      
      public static const STATE_UNLOCKED:int = 1;
      
      public static const STATE_COMPLETED:int = 2;
      
      public var durationHours:int;
      
      public var iconName:String;
      
      public var name:String;
      
      public var rewardRecipe:Object;
      
      public var text:String;
      
      public var tasks:Array;
      
      public var state:int = -1;
      
      public var rewardIngredients:Array;
      
      public var mc:MovieClip;
      
      public var id:int;
      
      public function ChallengeItem()
      {
         super();
      }
   }
}


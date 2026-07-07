package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.Avatar3D;
   import com.playfish.games.cooking.GameUserEmployee;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   
   public class IdleEmployee extends EmployeeActor
   {
      
      private static const ANIMATION_USED:Array = [Avatar3D.ANIMATION_IDLE];
      
      public function IdleEmployee(param1:int, param2:int, param3:GameUserEmployee, param4:WorldRestaurantPlay)
      {
         super(param1,param2,param3,param4,ANIMATION_USED);
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
      }
   }
}


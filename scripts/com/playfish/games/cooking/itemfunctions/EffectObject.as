package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.utils.*;
   import flash.utils.*;
   
   public class EffectObject extends BaseObject
   {
      
      public var removed:Boolean;
      
      private var speedX:Number;
      
      private var speedY:Number;
      
      public var timeToLive:int;
      
      public function EffectObject(param1:String, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:int = 0)
      {
         super(param1);
         this.x = param2;
         this.y = param3;
         this.speedX = param4;
         this.speedY = param5;
         this.timeToLive = param6;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function remove() : void
      {
         BaseObject(parent).removeObject(this);
         removed = true;
      }
      
      override public function tick(param1:uint) : void
      {
         y += speedY;
         x += speedX;
         if(timeToLive > 0)
         {
            timeToLive -= param1;
            if(timeToLive <= 1000)
            {
               if(timeToLive <= 0)
               {
                  remove();
               }
               else
               {
                  alpha = timeToLive / 1000;
               }
            }
         }
      }
   }
}


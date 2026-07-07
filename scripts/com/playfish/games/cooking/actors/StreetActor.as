package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class StreetActor extends BaseObject
   {
      
      private static const ANIMATION_USED:Array = [Avatar3D.ANIMATION_STREET_IDLE,Avatar3D.ANIMATION_STREET_WALK];
      
      private static const MIN_MOVE_SPEED_X:Number = 0.02;
      
      private static const MAX_MOVE_SPEED_X:Number = 0.04;
      
      private static const STATE_WALKING:int = 0;
      
      private static const STATE_IDLING:int = 1;
      
      public var street:WorldStreet;
      
      private var timer:int = 0;
      
      private var user:GameUser;
      
      private var state:int = 0;
      
      protected var speedY:Number = 0;
      
      protected var destY:Number = 0;
      
      protected var speedX:Number = 0;
      
      protected var destX:Number = 0;
      
      public var avatarSprite:CachedAvatar3D;
      
      public function StreetActor(param1:GameUser)
      {
         super();
         this.user = param1;
         avatarSprite = new CachedAvatar3D(param1,ANIMATION_USED);
         addChild(avatarSprite);
         reset();
      }
      
      override public function destroy() : void
      {
         avatarSprite = null;
         user.clearAnimationFrames();
      }
      
      public function moveLeft() : void
      {
         speedX = -(Math.random() * (MAX_MOVE_SPEED_X - MIN_MOVE_SPEED_X) + MIN_MOVE_SPEED_X);
         avatarSprite.setDirection(6);
         avatarSprite.setAnimation(Avatar3D.ANIMATION_STREET_WALK);
         timer = 4000 + Engine.rnd(-4000,4000);
         state = STATE_WALKING;
      }
      
      public function reset() : void
      {
         avatarSprite.reset();
         timer = 0;
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:Array = null;
         timer -= param1;
         if(state == STATE_WALKING)
         {
            x += speedX * param1;
            y += speedY * param1;
            if(x < -parent.x - 2 * GameWorld.CANVAS_WIDTH || x >= -parent.x + 2 * GameWorld.CANVAS_WIDTH)
            {
               street.removeStreetActor(this);
               return;
            }
            if(timer <= 0)
            {
               state = STATE_IDLING;
               _loc2_ = [0,4];
               avatarSprite.setDirection(_loc2_[Engine.rnd(0,_loc2_.length)]);
               avatarSprite.setAnimation(Avatar3D.ANIMATION_STREET_IDLE);
               timer = 8000 + Engine.rnd(-6000,6000);
            }
         }
         else if(state == STATE_IDLING)
         {
            if(timer <= 0)
            {
               state = STATE_WALKING;
               if(speedX > 0)
               {
                  avatarSprite.setDirection(2);
               }
               else
               {
                  avatarSprite.setDirection(6);
               }
               avatarSprite.setAnimation(Avatar3D.ANIMATION_STREET_WALK);
               timer = 8000 + Engine.rnd(-6000,6000);
            }
         }
         avatarSprite.tick(param1);
      }
      
      public function moveRight() : void
      {
         speedX = Math.random() * (MAX_MOVE_SPEED_X - MIN_MOVE_SPEED_X) + MIN_MOVE_SPEED_X;
         avatarSprite.setDirection(2);
         avatarSprite.setAnimation(Avatar3D.ANIMATION_STREET_WALK);
         timer = 4000 + Engine.rnd(-4000,4000);
         state = STATE_WALKING;
      }
      
      private function hasReached(param1:Number, param2:Number, param3:Number) : Boolean
      {
         if(param3 > 0)
         {
            if(param1 >= param2)
            {
               return true;
            }
         }
         else if(param3 < 0)
         {
            if(param1 <= param2)
            {
               return true;
            }
         }
         else if(param1 == param2)
         {
            return true;
         }
         return false;
      }
   }
}


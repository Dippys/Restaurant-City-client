package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.AnimatedObject;
   import com.playfish.games.cooking.Avatar3D;
   import com.playfish.games.cooking.BaseObject;
   import com.playfish.games.cooking.CachedAvatar3D;
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.GameUser;
   import com.playfish.games.cooking.PathFinder;
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurant;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   
   public class AvatarActor extends RestaurantActor
   {
      
      protected static const DEFAULT_MOVE_SPEED_X:Number = 0.06;
      
      protected static const DEFAULT_MOVE_SPEED_Y:Number = 0.03;
      
      private var userSelection:BaseObject;
      
      public var user:GameUser;
      
      public var restaurantPlay:WorldRestaurantPlay;
      
      private var badgeOutTimer:int = 0;
      
      private var shadow:BaseObject;
      
      protected var badge:AnimatedObject;
      
      private var status:MovieClip;
      
      public var avatarSprite:CachedAvatar3D;
      
      public function AvatarActor(param1:int, param2:int, param3:GameUser, param4:WorldRestaurantPlay, param5:Array, param6:Boolean = false)
      {
         var _loc7_:Shape = null;
         super(null,param4);
         this.restaurantPlay = param4;
         this.user = param3;
         shadow = new BaseObject("AvatarShadow");
         shadow.drawPriority = WorldRestaurant.SHADOW_DRAW_PRIORITY;
         avatarSprite = new CachedAvatar3D(param3,param5);
         addChild(avatarSprite);
         if(Debug.DEBUG)
         {
            if(Debug.SHOW_AVATAR_BASE)
            {
               _loc7_ = new Shape();
               _loc7_.graphics.beginFill(16711680);
               _loc7_.graphics.lineTo(-WorldRestaurant.tileWidthHalf,WorldRestaurant.tileHeightHalf);
               _loc7_.graphics.lineTo(0,WorldRestaurant.tileHeight);
               _loc7_.graphics.lineTo(WorldRestaurant.tileWidthHalf,WorldRestaurant.tileHeightHalf);
               _loc7_.graphics.endFill();
               addChildAt(_loc7_,0);
            }
         }
         setPosition(param1,param2);
         mouseEnabled = false;
      }
      
      public function setDirection(param1:int) : void
      {
         avatarSprite.setDirection(param1);
      }
      
      override public function hide() : void
      {
         super.hide();
         if(shadow != null)
         {
            restaurant.room.removeObject(shadow);
         }
         if(userSelection != null)
         {
            restaurant.room.removeObject(userSelection);
         }
      }
      
      override public function destroy() : void
      {
         user.clearAnimationFrames();
         restaurant.room.removeObject(shadow);
         if(userSelection)
         {
            restaurant.room.removeObject(userSelection);
         }
      }
      
      public function addMouseOverBadge(param1:AnimatedObject) : void
      {
         avatarSprite.buttonMode = true;
         avatarSprite.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
         avatarSprite.addEventListener(MouseEvent.ROLL_OUT,onRollOut,false,0,true);
         this.badge = param1;
         param1.numLoops = 1;
         param1.y = -20;
         param1.drawPriority = 100;
         param1.mouseEnabled = false;
         param1.mouseChildren = false;
         addObject(param1);
      }
      
      public function updateStatus() : void
      {
         if(!user.userInfo)
         {
         }
      }
      
      public function addSelectionEffect(param1:String) : void
      {
         userSelection = new BaseObject(param1);
         userSelection.drawPriority = WorldRestaurant.SHADOW_DRAW_PRIORITY;
         userSelection.x = x;
         userSelection.y = y + WorldRestaurant.tileHeightHalf;
      }
      
      public function face(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = param1 - x;
         var _loc4_:Number = param2 - y;
         var _loc5_:Number = Engine.getAngle(0,0,_loc3_,_loc4_) + PI_DIV_2;
         if(_loc5_ < 0)
         {
            _loc5_ += PI_TIMES_2;
         }
         else if(_loc5_ > Math.PI * 2)
         {
            _loc5_ -= PI_TIMES_2;
         }
         avatarSprite.setDirection(Math.round(_loc5_ / PI_DIV_4));
      }
      
      public function moveToRoomItem(param1:RoomItem, param2:Boolean) : Boolean
      {
         return moveToTile(param1.tileX,param1.tileY,param2);
      }
      
      public function showMouseOverBadge() : void
      {
         if(badge.getCurrentSequence() != "in")
         {
            badge.numLoops = 1;
            badge.setSequence("in");
         }
         badgeOutTimer = 0;
      }
      
      override public function setPosition(param1:Number, param2:Number) : void
      {
         x = param1;
         y = param2;
         tileX = WorldRestaurant.getTileIndexX(x,y + WorldRestaurant.tileHeightHalf);
         tileY = WorldRestaurant.getTileIndexY(x,y + WorldRestaurant.tileHeightHalf);
         drawPriority = WorldRestaurant.getTileDrawPriority(tileX,tileY) + y % WorldRestaurant.tileHeight;
         shadow.x = x;
         shadow.y = y + WorldRestaurant.tileHeightHalf;
         if(userSelection != null)
         {
            userSelection.x = x;
            userSelection.y = y + WorldRestaurant.tileHeightHalf;
         }
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
         if(avatarSprite.animationType == Avatar3D.ANIMATION_WALK)
         {
            if(speedX == 0 && speedY == 0)
            {
               avatarSprite.setAnimation(Avatar3D.ANIMATION_IDLE);
            }
         }
         avatarSprite.tick(param1);
         if(badgeOutTimer > 0)
         {
            badgeOutTimer -= param1;
            if(badgeOutTimer <= 0)
            {
               badgeOutTimer = 0;
               badge.numLoops = 1;
               badge.setSequence("out");
            }
         }
      }
      
      public function removeMouseOverBadge() : void
      {
         if(badge != null)
         {
            avatarSprite.buttonMode = false;
            avatarSprite.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
            avatarSprite.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
            removeObject(badge);
            badge = null;
         }
      }
      
      public function setAnimation(param1:int) : void
      {
         avatarSprite.setAnimation(param1);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         showMouseOverBadge();
      }
      
      public function getPathTo(param1:int, param2:int, param3:Boolean = false) : Array
      {
         var _loc4_:PathFinder = null;
         if(tileX > 0 && tileY > 0 && param1 > 0 && param2 > 0)
         {
            _loc4_ = new PathFinder(tileX,tileY,param1,param2,restaurant,param3);
            if(_loc4_.processOpenList(-1) == PathFinder.PROCESS_STATE_FOUND)
            {
               return _loc4_.getFinalPath();
            }
         }
         return null;
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         badgeOutTimer = 1000;
      }
      
      public function moveToTile(param1:int, param2:int, param3:Boolean) : Boolean
      {
         var _loc5_:Array = null;
         var _loc4_:PathFinder = new PathFinder(tileX,tileY,param1,param2,restaurant,param3);
         if(_loc4_.processOpenList(-1) == PathFinder.PROCESS_STATE_FOUND)
         {
            _loc5_ = _loc4_.getFinalPath();
            if(param3)
            {
               _loc5_.pop();
            }
            setMovePath(_loc5_);
            return true;
         }
         return false;
      }
      
      override public function moveTo(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         super.moveTo(param1,param2);
         if(speedX != 0 || speedY != 0)
         {
            _loc3_ = getSign(speedX);
            _loc4_ = getSign(speedY);
            _loc5_ = Engine.getAngle(0,0,_loc3_,_loc4_) + PI_DIV_2;
            if(_loc5_ < 0)
            {
               _loc5_ += PI_TIMES_2;
            }
            else if(_loc5_ >= PI_TIMES_2)
            {
               _loc5_ -= PI_TIMES_2;
            }
            avatarSprite.setDirection(Math.round(_loc5_ / PI_DIV_4));
         }
      }
      
      override public function show() : void
      {
         super.show();
         if(shadow != null)
         {
            restaurant.room.addObject(shadow);
         }
         if(userSelection != null)
         {
            restaurant.room.addObject(userSelection);
         }
      }
   }
}


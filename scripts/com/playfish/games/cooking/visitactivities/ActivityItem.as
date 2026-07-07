package com.playfish.games.cooking.visitactivities
{
   import com.playfish.games.cooking.BaseObject;
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameObject;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurant;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import com.playfish.games.cooking.actors.MovingVisitActor;
   import com.playfish.games.cooking.usertask.VisitActivityTask;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   
   public class ActivityItem extends EventDispatcher
   {
      
      public static const BLOCKING:int = 0;
      
      public static const NON_BLOCKING:int = 1;
      
      public static const ACTOR:int = 2;
      
      public static const EVENT_ITEM_CLICKED:String = "Event: Item Clicked";
      
      private var rotateCount:int = 0;
      
      private var itemString:String;
      
      private var roomItem:RoomItem;
      
      public var parent:CompositeActivityItem;
      
      private var bigItem:Boolean;
      
      private var type:int;
      
      private var activityTask:VisitActivityTask;
      
      private var restaurant:WorldRestaurantPlay;
      
      public var containsSubObjects:Boolean = false;
      
      private var lastClickedObject:Sprite;
      
      public var roomActor:MovingVisitActor;
      
      public var tileX:int;
      
      public var tileY:int;
      
      private var baseObject:BaseObject;
      
      private var tightBounds:Boolean = false;
      
      private var bigItemTileX:int = 0;
      
      private var bigItemTileY:int = 0;
      
      public var visitActivity:VisitActivity;
      
      public function ActivityItem(param1:VisitActivity, param2:String = null, param3:int = 0, param4:Boolean = false)
      {
         super();
         this.restaurant = param1.restaurant;
         this.visitActivity = param1;
         this.bigItem = param4;
         if(param2 != null)
         {
            this.itemString = param2;
            this.type = param3;
            createItem(param2,param3);
         }
      }
      
      public function remove() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:GameObject = null;
         var _loc4_:GameObject = null;
         var _loc5_:GameObject = null;
         if(containsSubObjects)
         {
            _loc1_ = baseObject.getContentMC().mc_content_1;
            _loc2_ = 1;
            while(_loc1_ != null)
            {
               _loc3_ = new GameObject("Clean");
               _loc3_.removeWhenComplete = true;
               _loc3_.numLoops = 1;
               _loc3_.x = baseObject.x + _loc1_.x;
               _loc3_.y = baseObject.y + _loc1_.y;
               Debug.out("eachEffect.x=" + _loc3_.x + " eachEffect.y" + _loc3_.y);
               _loc3_.drawPriority = baseObject.drawPriority;
               restaurant.room.addObject(_loc3_);
               _loc2_++;
               _loc1_ = baseObject.getContentMC()["mc_content_" + _loc2_] as MovieClip;
            }
         }
         else
         {
            _loc4_ = new GameObject("Clean");
            _loc4_.removeWhenComplete = true;
            _loc4_.numLoops = 1;
            _loc4_.drawPriority = getDrawPriority();
            _loc4_.x = getX();
            _loc4_.y = getY();
            restaurant.room.addObject(_loc4_);
         }
         if(lastClickedObject)
         {
            _loc5_ = new GameObject("MoneyVisits");
            _loc5_.getChildMovieClipInstance("mc_money").tf_money.text = "$" + GameWorld.getVisitRewardAmount();
            _loc5_.x = lastClickedObject.x;
            _loc5_.y = lastClickedObject.y;
            if(containsSubObjects)
            {
               _loc5_.x += baseObject.x;
               _loc5_.y += baseObject.y;
            }
            _loc5_.drawPriority = getDrawPriority();
            _loc5_.numLoops = 1;
            _loc5_.removeWhenComplete = true;
            restaurant.room.addObject(_loc5_);
         }
         if(baseObject)
         {
            restaurant.room.removeObject(baseObject);
         }
         else if(roomItem)
         {
            restaurant.removeRoomItem(roomItem);
         }
         else if(roomActor)
         {
            restaurant.room.removeObject(roomActor);
         }
      }
      
      private function onUserTaskItemRollOut(param1:MouseEvent) : void
      {
         param1.currentTarget.filters = null;
         param1.stopImmediatePropagation();
      }
      
      protected function removeGlowListenersFromItem() : void
      {
         if(containsSubObjects || Boolean(baseObject))
         {
            return;
         }
         var _loc1_:Sprite = getRawItem();
         _loc1_.removeEventListener(MouseEvent.ROLL_OVER,onUserTaskItemRollOver);
         _loc1_.removeEventListener(MouseEvent.ROLL_OUT,onUserTaskItemRollOut);
         _loc1_.buttonMode = false;
         _loc1_.filters = null;
      }
      
      public function setBigItemTilesDelta(param1:int, param2:int) : void
      {
         if(bigItem)
         {
            bigItemTileX = tileX + param1;
            bigItemTileY = tileY + param2;
         }
      }
      
      public function removeAllEventListeners() : void
      {
         if(baseObject)
         {
            baseObject.removeEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown);
            disableListenersForSubObjects();
            baseObject.buttonMode = false;
         }
         else if(roomItem)
         {
            roomItem.removeEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown);
            roomItem.buttonMode = false;
         }
         else if(roomActor)
         {
            roomActor.removeEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown);
            roomActor.buttonMode = false;
         }
         removeGlowListenersFromItem();
      }
      
      private function getRawItem() : Sprite
      {
         if(baseObject)
         {
            return baseObject;
         }
         if(roomItem)
         {
            return roomItem;
         }
         return roomActor;
      }
      
      protected function addGlowListenersToItem() : void
      {
         if(containsSubObjects || Boolean(baseObject))
         {
            return;
         }
         var _loc1_:Sprite = getRawItem();
         _loc1_.addEventListener(MouseEvent.ROLL_OVER,onUserTaskItemRollOver,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OUT,onUserTaskItemRollOut,false,0,true);
         _loc1_.buttonMode = true;
      }
      
      public function getBounds(param1:DisplayObject) : Rectangle
      {
         if(containsSubObjects)
         {
            return lastClickedObject.getBounds(param1);
         }
         if(tightBounds)
         {
            return new Rectangle(getRawItem().x - getRawItem().width / 2,getRawItem().y,getRawItem().width,getRawItem().height);
         }
         return getRawItem().getBounds(param1);
      }
      
      private function disableListenersForSubObjects() : void
      {
         var _loc1_:MovieClip = baseObject.getContentMC().mc_content_1;
         var _loc2_:int = 1;
         while(_loc1_ != null)
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown);
            _loc1_.buttonMode = false;
            _loc1_.removeEventListener(MouseEvent.ROLL_OVER,onUserTaskItemRollOver);
            _loc1_.removeEventListener(MouseEvent.ROLL_OUT,onUserTaskItemRollOut);
            _loc1_.filters = null;
            _loc2_++;
            _loc1_ = baseObject.getContentMC()["mc_content_" + _loc2_] as MovieClip;
         }
      }
      
      public function createItem(param1:String, param2:int) : void
      {
         switch(param2)
         {
            case ActivityItem.BLOCKING:
               roomItem = RoomItem.createRoomItems(WorldRestaurant.getItemConfig(param1),null);
               break;
            case ActivityItem.NON_BLOCKING:
               baseObject = new BaseObject(param1);
               checkForSubObjects();
               break;
            case ActivityItem.ACTOR:
               roomActor = new MovingVisitActor(param1,restaurant);
         }
      }
      
      public function setTightBounds(param1:Boolean) : void
      {
         tightBounds = param1;
      }
      
      public function checkForSubObjects() : void
      {
         if(baseObject.getContentMC().mc_content_1 != null)
         {
            containsSubObjects = true;
         }
         enableListenersForSubObjects();
      }
      
      public function setScreenPosition(param1:Boolean = true, param2:int = 0, param3:int = 0) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1)
         {
            _loc4_ = WorldRestaurant.getScreenX(tileX,tileY);
            _loc5_ = WorldRestaurant.getScreenY(tileX,tileY);
         }
         else
         {
            _loc4_ = param2;
            _loc5_ = param3;
         }
         getRawItem().x = _loc4_;
         getRawItem().y = _loc5_;
      }
      
      private function enableListenersForSubObjects() : void
      {
         var _loc1_:MovieClip = baseObject.getContentMC().mc_content_1;
         var _loc2_:int = 1;
         while(_loc1_ != null)
         {
            _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown,false,0,true);
            _loc1_.addEventListener(MouseEvent.ROLL_OVER,onUserTaskItemRollOver,false,0,true);
            _loc1_.addEventListener(MouseEvent.ROLL_OUT,onUserTaskItemRollOut,false,0,true);
            _loc1_.buttonMode = true;
            _loc2_++;
            _loc1_ = baseObject.getContentMC()["mc_content_" + _loc2_] as MovieClip;
         }
      }
      
      public function getY() : Number
      {
         if(bigItem)
         {
            return WorldRestaurant.getScreenY(bigItemTileX,bigItemTileY);
         }
         return getRawItem().y;
      }
      
      public function getX() : Number
      {
         if(bigItem)
         {
            return WorldRestaurant.getScreenX(bigItemTileX,bigItemTileY);
         }
         return getRawItem().x;
      }
      
      private function onUserTaskItemRollOver(param1:MouseEvent) : void
      {
         param1.currentTarget.filters = [new GlowFilter(16777215,1,6,6,20)];
      }
      
      public function addToRestaurant() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(baseObject)
         {
            restaurant.room.addObject(baseObject);
            baseObject.drawPriority = WorldRestaurant.getTileDrawPriority(tileX,tileY);
         }
         else if(roomItem)
         {
            _loc1_ = WorldRestaurant.getTileIndex(tileX,tileX);
            roomItem.addEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown,false,0,true);
            roomItem.drawPriority = WorldRestaurant.getTileDrawPriority(tileX,tileY);
            roomItem.buttonMode = true;
            restaurant.placeRoomItem(roomItem,tileX,tileY);
            _loc2_ = 0;
            while(_loc2_ < rotateCount)
            {
               roomItem.rotate();
               _loc2_++;
            }
         }
         else
         {
            if(!roomActor)
            {
               Debug.out("Error ActivityItem.addToRestaurant()");
               return false;
            }
            roomActor.show();
            roomActor.buttonMode = true;
            roomActor.addEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown,false,0,true);
            roomActor.setInitialTilePosition(tileX,tileY);
            restaurant.room.addObject(roomActor);
         }
         addGlowListenersToItem();
         return true;
      }
      
      public function rotate() : void
      {
         var _loc1_:int = 0;
         if(roomItem)
         {
            ++rotateCount;
            if(bigItem)
            {
               _loc1_ = bigItemTileX;
               bigItemTileX = bigItemTileY;
               bigItemTileY = _loc1_;
            }
         }
      }
      
      public function onItemMouseDown(param1:MouseEvent) : void
      {
         lastClickedObject = param1.currentTarget as Sprite;
         if(parent)
         {
            parent.removeAllEventListeners();
         }
         else
         {
            removeAllEventListeners();
         }
         activityTask = new VisitActivityTask(this);
         activityTask.onActivityItemClick();
         param1.stopImmediatePropagation();
      }
      
      public function getDrawPriority() : Number
      {
         if(roomActor)
         {
            return roomActor.drawPriority;
         }
         return WorldRestaurant.getTileDrawPriority(tileX,tileY);
      }
   }
}


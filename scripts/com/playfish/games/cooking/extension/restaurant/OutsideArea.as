package com.playfish.games.cooking.extension.restaurant
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.GameEvent;
   import com.playfish.games.cooking.events.RestaurantEvent;
   import com.playfish.games.cooking.ui.BuyOutsideAreaExpansionPopUp;
   import com.playfish.games.cooking.ui.ToolTip;
   import com.playfish.rpc.share.NetworkUid;
   import flash.display.Shape;
   import flash.events.*;
   
   public class OutsideArea extends RestaurantExtensionBase
   {
      
      private var saleSign:BaseObject;
      
      private var expansionArea:Shape;
      
      private var nextOutsideAreaSizeItem:OutsideAreaSizeItem;
      
      private var restaurant:WorldRestaurant;
      
      private var glowEffect:GlowEffect;
      
      private var saleSignToolTip:ToolTip;
      
      public function OutsideArea(param1:WorldRestaurant)
      {
         super();
         this.restaurant = param1;
      }
      
      private function onLevelUp(param1:GameEvent) : void
      {
         onOutsideAreaSizeChange(null);
      }
      
      override public function destroy() : void
      {
         GameWorld.gameEventDispatcher.removeEventListener(GameEvent.LEVEL_UP,onLevelUp);
      }
      
      private function onOutsideAreaSizeChange(param1:RestaurantEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Array = GameWorld.interiorItemDatabase.getItems("OutsideAreaSize");
         _loc2_.sortOn(["unlockLevel","sizeX","sizeY"],[Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
         nextOutsideAreaSizeItem = null;
         if(restaurant.gameUser.outsideAreaSizeItems.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length - 1)
            {
               if(_loc2_[_loc3_].id == restaurant.gameUser.outsideAreaSizeItems[0].itemConfig.id)
               {
                  nextOutsideAreaSizeItem = new OutsideAreaSizeItem(_loc2_[_loc3_ + 1]);
                  break;
               }
               _loc3_++;
            }
         }
         else
         {
            nextOutsideAreaSizeItem = new OutsideAreaSizeItem(_loc2_[0]);
         }
         if(saleSign)
         {
            saleSign.removeEventListener(MouseEvent.ROLL_OVER,onSaleSignRollOver);
            saleSign.removeEventListener(MouseEvent.ROLL_OUT,onSaleSignRollOut);
            saleSign.removeEventListener(MouseEvent.CLICK,onSaleSignClick);
            restaurant.room.removeObject(saleSign);
            saleSign = null;
            if(saleSignToolTip)
            {
               saleSignToolTip.destroy();
               saleSignToolTip = null;
            }
         }
         if(nextOutsideAreaSizeItem)
         {
            saleSign = new BaseObject("OutsideAreaSign");
            if(restaurant.numOutsideTilesX == 0)
            {
               _loc4_ = nextOutsideAreaSizeItem.sizeX / 2 + 1;
               _loc5_ = restaurant.numTilesY + nextOutsideAreaSizeItem.sizeY / 2;
            }
            else
            {
               _loc4_ = restaurant.numOutsideTilesX + 1;
               _loc5_ = restaurant.numTilesY + nextOutsideAreaSizeItem.sizeY / 2;
            }
            saleSign.x = WorldRestaurant.getScreenX(_loc4_,_loc5_);
            saleSign.y = WorldRestaurant.getScreenY(_loc4_,_loc5_);
            saleSign.drawPriority = WorldRestaurant.getTileDrawPriority(_loc4_,_loc5_);
            restaurant.room.addObject(saleSign);
            saleSign.buttonMode = true;
            saleSign.addEventListener(MouseEvent.ROLL_OVER,onSaleSignRollOver,false,0,true);
            saleSign.addEventListener(MouseEvent.ROLL_OUT,onSaleSignRollOut,false,0,true);
            if(!GameWorld.isItemLevelReached(nextOutsideAreaSizeItem.itemConfig))
            {
               GameWorld.textHandler.setReplaceString("level",nextOutsideAreaSizeItem.unlockLevel.toString());
               saleSignToolTip = new ToolTip(saleSign,GameWorld.textHandler.getTextFromId("UnlocksAtLevel"));
            }
            else
            {
               saleSign.addEventListener(MouseEvent.CLICK,onSaleSignClick,false,0,true);
               saleSignToolTip = new ToolTip(saleSign,GameWorld.textHandler.getTextFromId("ClickToBuyOutsideRestaurantExpansion"));
            }
         }
      }
      
      private function onSaleSignRollOut(param1:MouseEvent) : void
      {
         if(expansionArea)
         {
            restaurant.room.removeChild(expansionArea);
            glowEffect.remove();
            expansionArea = null;
            glowEffect = null;
         }
      }
      
      override public function init() : void
      {
         if(NetworkUid.areEqual(restaurant.gameUser.userInfo.id,GameWorld.gameUser.userInfo.id))
         {
            onOutsideAreaSizeChange(null);
            restaurant.addEventListener(RestaurantEvent.EVENT_OUTSIDE_AREA_SIZE_CHANGE,onOutsideAreaSizeChange,false,0,true);
            GameWorld.gameEventDispatcher.addEventListener(GameEvent.LEVEL_UP,onLevelUp,false,0,true);
         }
      }
      
      private function onSaleSignClick(param1:MouseEvent) : void
      {
         var _loc2_:BuyOutsideAreaExpansionPopUp = new BuyOutsideAreaExpansionPopUp(nextOutsideAreaSizeItem,restaurant);
         _loc2_.show();
      }
      
      private function onSaleSignRollOver(param1:MouseEvent) : void
      {
         if(!expansionArea)
         {
            expansionArea = new Shape();
            restaurant.fillBaseArea(expansionArea.graphics,10668375,1,restaurant.numTilesY,nextOutsideAreaSizeItem.sizeX,restaurant.numTilesY + nextOutsideAreaSizeItem.sizeY);
            restaurant.room.addChildAt(expansionArea,0);
            glowEffect = new GlowEffect(expansionArea);
         }
      }
   }
}


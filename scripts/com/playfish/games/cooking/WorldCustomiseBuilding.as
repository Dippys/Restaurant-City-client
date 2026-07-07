package com.playfish.games.cooking
{
   import com.playfish.games.cooking.events.*;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.games.cooking.ui.mail.WorldWriteMessage;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class WorldCustomiseBuilding extends BaseWorld
   {
      
      public static const DEFAULT_BUILDING_ITEMS:Array = [{
         "name":"Starter Building Base",
         "id":2060000,
         "x":0,
         "y":0
      },{
         "name":"Red Tile Roof",
         "id":2020001,
         "x":0,
         "y":0
      },{
         "name":"Basic Door",
         "id":2010012,
         "x":0,
         "y":0
      },{
         "name":"Wooden Banner",
         "id":2070000,
         "x":0,
         "y":-100
      },{
         "name":"Basic Window",
         "id":2000014,
         "x":60,
         "y":-23
      },{
         "name":"Basic Window",
         "id":2000014,
         "x":-60,
         "y":-23
      },{
         "name":"Dark Grey Bricks",
         "id":2050008,
         "x":0,
         "y":0
      },{
         "name":"Flower bed",
         "id":2040002,
         "x":70,
         "y":0
      },{
         "name":"Flower bed",
         "id":2040002,
         "x":-70,
         "y":0
      },{
         "name":"Wooden Menu Board",
         "id":2040017,
         "x":30,
         "y":0
      },{
         "name":"Trashcan",
         "id":2040011,
         "x":120,
         "y":0
      }];
      
      public static const ZOOM_SCALE:Number = 1.2;
      
      private var bgRoad:Shape;
      
      public var scene:MovieClip;
      
      private var prevBannerText:String;
      
      private var bgSky:MovieClip;
      
      public var itemChooser:ItemChooser;
      
      private var shopTransactionHandler:ShopTransactionHandler;
      
      public var itemDatabase:ItemDatabase;
      
      private var cashItemToPurchase:BuildingItem;
      
      public var building:StreetBuilding;
      
      private var parallaxBg:BackgroundLayer;
      
      private var dragOffsetX:Number = 0;
      
      private var dragOffsetY:Number = 0;
      
      private var gameUser:GameUser;
      
      private var bgMusic:GameSound;
      
      private var dragItem:BuildingItem;
      
      private var placeItemSound:GameSound;
      
      private var flipButton:MovieClip;
      
      public function WorldCustomiseBuilding(param1:ItemDatabase, param2:StreetBuilding, param3:BaseObject, param4:BackgroundLayer)
      {
         var _loc7_:BuildingItem = null;
         shopTransactionHandler = new ShopTransactionHandler();
         placeItemSound = new GameSound("SfxPlaceItem",GameSound.TYPE_SOUND);
         super();
         this.itemDatabase = param1;
         this.gameUser = GameWorld.gameUser;
         this.prevBannerText = GameWorld.gameUser.bannerText;
         this.parallaxBg = param4;
         this.building = param2;
         bgRoad = new Shape();
         bgSky = Engine.getMovieClip("StreetSky");
         refreshBgRoad();
         refreshBgSky();
         addChild(bgRoad);
         addChild(bgSky);
         param4.x = -Engine.getStageWidth() / 2;
         if(param3 != null)
         {
            addObject(param3);
         }
         var _loc5_:int = 0;
         while(_loc5_ < building.items.length)
         {
            _loc7_ = building.items[_loc5_];
            if(_loc7_.draggable && !_loc7_.wallTile)
            {
               _loc7_.buttonMode = true;
               _loc7_.addEventListener(MouseEvent.MOUSE_DOWN,itemClicked,false,0,true);
               if(_loc7_.isFlippable())
               {
                  _loc7_.addEventListener(MouseEvent.ROLL_OVER,onItemRollOver,false,0,true);
               }
            }
            _loc5_++;
         }
         building.x = Engine.STAGE_WIDTH / 2;
         building.y = param3.y;
         building.scaleX = ZOOM_SCALE;
         building.scaleY = ZOOM_SCALE;
         building.stopItemFunctions();
         addObject(building);
         building.setBannerTextEditable(true);
         var _loc6_:BaseObject = new BaseObject();
         addObject(_loc6_);
         scene = Engine.getMovieClip("CustomiseBuildingScene");
         _loc6_.addChild(scene);
         itemChooser = new ItemChooser(param1,GameWorld.gameUser,Engine.getMovieClip("BuildingItemChooserScene2"));
         itemChooser.y = Engine.getStageBottom() + itemChooser.height;
         itemChooser.drawPriority = 100;
         itemChooser.addEventListener(ItemChooserEvent.EVENT_ITEM_MOUSE_DOWN,onNewItem);
         itemChooser.addEventListener(MouseEvent.MOUSE_UP,onItemChooserMouseUp);
         itemChooser.sellButton.addEventListener(MouseEvent.MOUSE_UP,onSellButtonMouseUp,false,0,true);
         itemChooser.giftButton.addEventListener(MouseEvent.MOUSE_UP,onGiftItem,false,0,true);
         addObject(itemChooser);
         itemChooser.setGroup(param1.getGroup("Body"));
         this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
         setButtonMode(scene.okButton,true);
         scene.okButton.addEventListener(MouseEvent.CLICK,okClicked);
         bgMusic = new GameSound("MusicEditor",GameSound.TYPE_MUSIC);
         GameWorld.stopGlobalRpcs();
      }
      
      public static function getDefaultBuildingItems() : Array
      {
         var _loc3_:Object = null;
         var _loc4_:UserItem = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < DEFAULT_BUILDING_ITEMS.length)
         {
            _loc3_ = DEFAULT_BUILDING_ITEMS[_loc2_];
            _loc4_ = new UserItem(GameWorld.buildingItemDatabase.getItem(_loc3_.name));
            _loc4_.x = _loc3_.x;
            _loc4_.y = _loc3_.y;
            _loc1_.push(_loc4_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function refreshBgSky() : void
      {
         bgSky.y = Engine.getStageY();
         bgSky.x = Engine.getStageX();
         bgSky.width = Engine.getStageWidth();
         bgSky.height = Engine.getStageHeight();
      }
      
      public function onGiftCancel(param1:BuildingItem) : void
      {
         putItemInInventory(param1);
      }
      
      private function setItemInventoryPosition() : void
      {
         var _loc1_:Rectangle = dragItem.getBounds(null);
         dragItem.x = mouseX - _loc1_.left * dragItem.scaleX - dragItem.width / 2;
         dragItem.y = mouseY - _loc1_.top * dragItem.scaleY - dragItem.height / 2;
      }
      
      private function itemClicked(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(dragItem == null)
         {
            if(flipButton != null)
            {
               removeChild(flipButton);
               flipButton = null;
            }
            dragItem = BuildingItem(param1.currentTarget);
            removeItem(dragItem);
            gameUser.removeUsedBuildingItem(dragItem.serverUid);
            _loc2_ = globalToLocal(building.localToGlobal(new Point(dragItem.x,dragItem.y)));
            dragOffsetX = _loc2_.x - mouseX;
            dragOffsetY = _loc2_.y - mouseY;
            dragItem.drawPriority = 150;
            dragItem.scaleX = building.scaleX;
            dragItem.scaleY = building.scaleY;
            if(dragItem.flipped)
            {
               dragItem.scaleX = -dragItem.scaleX;
            }
            dragItem.x = mouseX + dragOffsetX;
            dragItem.y = mouseY + dragOffsetY;
            dragItem.owned = true;
            dragItem.fromInventory = false;
            addObject(dragItem);
            Debug.out("itemPos.x=" + _loc2_.x + " itemPos.y=" + _loc2_.y + " mouseX=" + mouseX + " mouseY=" + mouseY + " dragItem.x=" + dragItem.x + " dragItem.y=" + dragItem.y + " dragItem.flipped=" + dragItem.flipped);
            param1.stopImmediatePropagation();
         }
      }
      
      public function putItemInInventory(param1:BuildingItem) : void
      {
         var _loc2_:InventoryUserItem = null;
         var _loc3_:GameObject = null;
         if(Boolean(param1) && param1.owned)
         {
            _loc2_ = new InventoryUserItem(param1.itemConfig);
            _loc2_.serverUid = param1.serverUid;
            gameUser.addInventoryItem(_loc2_);
            itemChooser.refresh();
            shopTransactionHandler.addChangedItem(_loc2_,param1.fromInventory);
            _loc3_ = new GameObject("InventoryCrateAnim");
            _loc3_.x = param1.x;
            _loc3_.y = param1.y;
            _loc3_.drawPriority = param1.drawPriority;
            _loc3_.numLoops = 1;
            _loc3_.removeWhenComplete = true;
            addObject(_loc3_);
         }
      }
      
      private function onItemChooserMouseUp(param1:MouseEvent) : void
      {
         if(dragItem)
         {
            if(dragItem.owned)
            {
               putItemInInventory(dragItem);
            }
            removeObject(dragItem);
            dragItem = null;
         }
         param1.stopImmediatePropagation();
      }
      
      private function onStageFullScreen(param1:Event) : void
      {
         itemChooser.y = Engine.getStageBottom();
         parallaxBg.x = -Engine.getStageWidth() / 2;
         refreshBgRoad();
         refreshBgSky();
      }
      
      private function onPurchaseCashItemSuccess(param1:int) : void
      {
         Debug.out("onPurchaseCashItemSuccess code=" + param1);
         var _loc2_:BuildingItem = cashItemToPurchase;
         cashItemToPurchase = null;
         GameWorld.cashPanel.showPlayfishCashPopUp(-int(_loc2_.itemConfig.cash));
         itemChooser.refresh();
         GameWorld.addAwardValue(GameAwards.AWARD_BUY_OUTDOOR_ITEM,1);
         GameWorld.addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(_loc2_.itemConfig));
      }
      
      private function onPurchaseCashItemCancel(param1:int) : void
      {
         removeItem(cashItemToPurchase);
         gameUser.removeUsedBuildingItem(cashItemToPurchase.serverUid);
         cashItemToPurchase = null;
         if(param1 == RpcClient.STATUS_NOT_ENOUGH_CASH)
         {
            itemChooser.refresh();
         }
      }
      
      override public function keyDown(param1:int, param2:int) : void
      {
      }
      
      private function onItemRollOver(param1:MouseEvent) : void
      {
         var _loc2_:BuildingItem = null;
         var _loc3_:Rectangle = null;
         Debug.out("onItemRollOver");
         if(dragItem == null)
         {
            if(flipButton != null)
            {
               removeChild(flipButton);
               flipButton.item.glow(false);
               flipButton = null;
            }
            _loc2_ = BuildingItem(param1.currentTarget);
            _loc2_.fromInventory = false;
            _loc2_.glow(true);
            _loc3_ = _loc2_.getBounds(this);
            flipButton = Engine.getMovieClip("ButtonFlip");
            flipButton.item = _loc2_;
            flipButton.x = (_loc3_.left + _loc3_.right) / 2;
            flipButton.y = _loc3_.bottom + flipButton.height / 2;
            setButtonMode(flipButton,true);
            flipButton.addEventListener(MouseEvent.MOUSE_DOWN,onFlipButtonClick,false,0,true);
            addChild(flipButton);
         }
      }
      
      override public function showNotify() : void
      {
         addObject(GameWorld.cashPanel);
         bgMusic.play(-1);
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onStageFullScreen,false,0,true);
      }
      
      private function scaleItemToButton(param1:BuildingItem) : void
      {
         if(param1.width > param1.height)
         {
            param1.width = 80;
            param1.scaleY = param1.scaleX;
         }
         else
         {
            param1.height = 80;
            param1.scaleX = param1.scaleY;
         }
      }
      
      override public function hideNotify() : void
      {
         removeObject(GameWorld.cashPanel);
         bgMusic.stop();
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onStageFullScreen);
      }
      
      override public function tick(param1:uint) : void
      {
         if(itemChooser.y > Engine.getStageBottom())
         {
            itemChooser.y -= (itemChooser.y - Engine.getStageBottom()) / 4;
            if(Math.round(itemChooser.y) == Engine.getStageBottom())
            {
               itemChooser.y = Engine.getStageBottom();
            }
         }
         if(flipButton != null)
         {
            if(!(flipButton.hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY) || flipButton.item.hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY)))
            {
               removeChild(flipButton);
               flipButton.item.glow(false);
               flipButton = null;
            }
         }
      }
      
      private function onCommitSuccess(param1:RpcEvent) : void
      {
         removeObject(itemChooser);
         building.setBannerTextEditable(false);
         GameWorld.startGlobalRpcs();
         Engine.setActiveWorld(new WorldStreet(GameWorld.gameUser,false,true));
      }
      
      private function okClicked(param1:MouseEvent) : void
      {
         building.save();
         shopTransactionHandler.addEventListener(RpcEvent.SUCCESS,onCommitSuccess,false,0,true);
         shopTransactionHandler.addEventListener(RpcEvent.FAIL,onCommitFail,false,0,true);
         if(shopTransactionHandler.hasChanges())
         {
            shopTransactionHandler.commit();
         }
         else
         {
            onCommitSuccess(null);
         }
         if(param1)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      public function removeItem(param1:BuildingItem) : void
      {
         building.removeItem(param1);
         if(param1.draggable && !param1.wallTile)
         {
            param1.buttonMode = false;
            param1.mouseEnabled = false;
            param1.mouseChildren = false;
            param1.removeEventListener(MouseEvent.MOUSE_DOWN,itemClicked);
         }
      }
      
      private function onCommitFail(param1:RpcEvent) : void
      {
      }
      
      private function onSellButtonMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:InventoryUserItem = null;
         var _loc3_:WorldPopUp = null;
         if(dragItem)
         {
            if(dragItem.owned)
            {
               putItemInInventory(dragItem);
               _loc2_ = gameUser.getInventoryItem(dragItem.itemConfig);
               _loc3_ = new WorldSellItemPopUp(_loc2_,onItemSellOK);
               _loc3_.show();
               removeObject(dragItem);
               dragItem = null;
            }
            else
            {
               removeObject(dragItem);
               dragItem = null;
            }
            param1.stopImmediatePropagation();
         }
      }
      
      private function showMoneyDeductAnimation(param1:BuildingItem) : void
      {
         var _loc3_:Point = null;
         var _loc2_:GameObject = new GameObject("MoneyLostAnim");
         _loc2_.getChildMovieClipInstance("mc_content").tf_money.text = -param1.itemConfig.cost;
         _loc3_ = globalToLocal(building.localToGlobal(new Point(param1.x,param1.y)));
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         _loc2_.drawPriority = 1000;
         _loc2_.numLoops = 1;
         _loc2_.removeWhenComplete = true;
         addObject(_loc2_);
      }
      
      private function onCashGiftBuySuccess(param1:int) : void
      {
         GameWorld.cashPanel.showPlayfishCashPopUp(-dragItem.itemConfig.cash);
         GameWorld.addAwardValue(GameAwards.AWARD_BUY_OUTDOOR_ITEM,1);
         GameWorld.addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(dragItem.itemConfig));
         var _loc2_:InventoryUserItem = new InventoryUserItem(dragItem.itemConfig);
         _loc2_.serverUid = dragItem.serverUid;
         shopTransactionHandler.addChangedItem(_loc2_,dragItem.fromInventory);
         itemChooser.refresh();
         dragItem.fromInventory = true;
         dragItem.owned = true;
         var _loc3_:WorldWriteMessage = new WorldWriteMessage(dragItem,null,null,onGiftCancel,onGiftSent);
         _loc3_.show();
         dragItem = null;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:UserItem = null;
         var _loc4_:PurchaseCashItemConfirmPopUp = null;
         Debug.out("onMouseUp");
         if(dragItem)
         {
            if(dragItem.owned || GameWorld.isItemAffordable(dragItem.itemConfig) && GameWorld.isItemLevelReached(dragItem.itemConfig))
            {
               _loc2_ = building.globalToLocal(localToGlobal(new Point(dragItem.x,dragItem.y)));
               dragItem.x = _loc2_.x;
               dragItem.y = _loc2_.y;
               dragItem.scaleX = 1;
               dragItem.scaleY = 1;
               dragItem.drawPriority = dragItem.itemConfig.group.drawPriority;
               removeObject(dragItem);
               addItem(dragItem);
               placeItemSound.play(1);
               _loc3_ = dragItem.getUserItem();
               Debug.out("dragItem.x=" + dragItem.x + " dragItem.y=" + dragItem.y);
               if(!dragItem.owned)
               {
                  dragItem.owned = true;
                  if(dragItem.itemConfig.cash > 0)
                  {
                     _loc4_ = new PurchaseCashItemConfirmPopUp(dragItem.getUserItem(),onPurchaseCashItemSuccess,onPurchaseCashItemCancel);
                     _loc4_.show();
                     cashItemToPurchase = dragItem;
                  }
                  else
                  {
                     GameWorld.cashPanel.addCoins(-int(dragItem.itemConfig.cost));
                     itemChooser.refresh();
                     showMoneyDeductAnimation(dragItem);
                     GameWorld.addAwardValue(GameAwards.AWARD_SPEND_COIN,dragItem.itemConfig.cost);
                     GameWorld.addAwardValue(GameAwards.AWARD_BUY_OUTDOOR_ITEM,1);
                     GameWorld.addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(dragItem.itemConfig));
                     shopTransactionHandler.addBoughtItem(_loc3_);
                  }
               }
               else
               {
                  shopTransactionHandler.addChangedItem(_loc3_,dragItem.fromInventory);
               }
               gameUser.addUsedBuildingItem(_loc3_);
            }
            else
            {
               if(GameWorld.isItemLevelReached(dragItem.itemConfig) && !GameWorld.isItemAffordable(dragItem.itemConfig))
               {
                  if(Boolean(dragItem.itemConfig.cash) && dragItem.itemConfig.cash > 0)
                  {
                     GameWorld.cashPanel.showPlayfishCashToolTip();
                  }
                  else
                  {
                     GameWorld.cashPanel.showCoinsToolTip();
                  }
               }
               putItemInInventory(dragItem);
               removeObject(dragItem);
            }
            dragItem = null;
         }
      }
      
      private function onCashGiftBuyCancel(param1:int) : void
      {
         dragItem = null;
      }
      
      private function refreshBgRoad() : void
      {
         bgRoad.graphics.clear();
         var _loc1_:Number = Engine.getStageBottom() - Engine.STAGE_HEIGHT;
         if(_loc1_ > 0)
         {
            bgRoad.graphics.beginFill(WorldStreet.STREET_ROAD_COLOUR[WorldStreet.STREET_TYPE_FRIENDS]);
            bgRoad.graphics.drawRect(Engine.getStageX(),Engine.STAGE_HEIGHT,Engine.getStageWidth(),_loc1_);
            bgRoad.graphics.endFill();
         }
      }
      
      public function onGiftBuyCancelTickClick(param1:MouseEvent) : void
      {
         dragItem = null;
      }
      
      public function addItem(param1:BuildingItem) : void
      {
         if(param1.roof)
         {
            if(building.roof != null)
            {
               building.roof.fromInventory = false;
               putItemInInventory(building.roof);
               building.removeItem(building.roof);
            }
         }
         else if(param1.body)
         {
            if(building.body != null)
            {
               building.body.fromInventory = false;
               putItemInInventory(building.body);
               removeItem(building.body);
            }
         }
         else if(param1.wallTile)
         {
            if(building.tile != null)
            {
               building.tile.fromInventory = false;
               putItemInInventory(building.tile);
               removeItem(building.tile);
            }
         }
         else if(param1.banner)
         {
            if(building.banner != null)
            {
               building.banner.fromInventory = false;
               putItemInInventory(building.banner);
               removeItem(building.banner);
            }
         }
         building.addItem(param1);
         if(param1.draggable && !param1.wallTile)
         {
            param1.buttonMode = true;
            dragItem.mouseEnabled = true;
            dragItem.mouseChildren = true;
            param1.addEventListener(MouseEvent.MOUSE_DOWN,itemClicked,false,0,true);
            if(param1.isFlippable())
            {
               param1.addEventListener(MouseEvent.ROLL_OVER,onItemRollOver,false,0,true);
            }
         }
      }
      
      public function onGiftBuyTickClick(param1:MouseEvent) : void
      {
         GameWorld.cashPanel.addCoins(-dragItem.itemConfig.cost);
         itemChooser.refresh();
         GameWorld.addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(dragItem.itemConfig));
         GameWorld.addAwardValue(GameAwards.AWARD_SPEND_COIN,dragItem.itemConfig.cost);
         GameWorld.addAwardValue(GameAwards.AWARD_BUY_OUTDOOR_ITEM,1);
         var _loc2_:InventoryUserItem = new InventoryUserItem(dragItem.itemConfig);
         shopTransactionHandler.addBoughtItem(_loc2_);
         dragItem.fromInventory = true;
         dragItem.owned = true;
         var _loc3_:WorldWriteMessage = new WorldWriteMessage(dragItem,null,null,onGiftCancel,onGiftSent);
         _loc3_.show();
         dragItem = null;
      }
      
      public function adjustBuildingItemPosition(param1:BuildingItem) : void
      {
         var _loc2_:Rectangle = null;
         if(param1.onFloor)
         {
            param1.y = building.y;
            _loc2_ = param1.getBounds(param1.parent);
            if(_loc2_.left < 0)
            {
               param1.x -= _loc2_.left;
            }
            else if(_loc2_.right > Engine.STAGE_WIDTH)
            {
               param1.x -= _loc2_.right - Engine.STAGE_WIDTH;
            }
         }
         if(param1.banner || param1.wallAttach)
         {
            _loc2_ = param1.getBounds(param1.parent);
            if(_loc2_.left < 0)
            {
               param1.x -= _loc2_.left;
            }
            else if(_loc2_.right > Engine.STAGE_WIDTH)
            {
               param1.x -= _loc2_.right - Engine.STAGE_WIDTH;
            }
            if(_loc2_.top < 0)
            {
               param1.y -= _loc2_.top;
            }
            else if(_loc2_.bottom > building.y)
            {
               param1.y -= _loc2_.bottom - building.y;
            }
         }
         if(dragItem.roof)
         {
            param1.x = building.x + building.body.x;
            param1.y = building.y + building.body.y - building.body.height * building.scaleY;
         }
         else if(dragItem.body)
         {
            param1.x = building.x;
            param1.y = building.y;
         }
      }
      
      private function onGiftItem(param1:MouseEvent) : void
      {
         var _loc2_:WorldWriteMessage = null;
         var _loc3_:PurchaseCashItemConfirmPopUp = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:WorldPopUp = null;
         if(dragItem != null && !dragItem.notGiftable)
         {
            removeObject(dragItem);
            if(dragItem.owned)
            {
               _loc2_ = new WorldWriteMessage(dragItem,null,null,onGiftCancel,onGiftSent);
               _loc2_.show();
               dragItem = null;
            }
            else if(GameWorld.isItemAffordable(dragItem.itemConfig))
            {
               if(dragItem.itemConfig.cash > 0)
               {
                  _loc3_ = new PurchaseCashItemConfirmPopUp(dragItem.getUserItem(),onCashGiftBuySuccess,onCashGiftBuyCancel);
                  _loc3_.show();
               }
               else
               {
                  _loc4_ = Engine.getMovieClip("SellPopUpAnim");
                  _loc5_ = _loc4_.mc_content;
                  ItemChooser.setItemOnIconButton(dragItem.itemConfig,_loc5_.mc_item);
                  _loc5_.mc_addCoins.stop();
                  _loc5_.mc_addCoins.visible = false;
                  setButtonMode(_loc5_.mc_tick,true);
                  setButtonMode(_loc5_.mc_cancel,true);
                  _loc5_.mc_tick.addEventListener(MouseEvent.CLICK,onGiftBuyTickClick,false,0,true);
                  _loc5_.mc_cancel.addEventListener(MouseEvent.CLICK,onGiftBuyCancelTickClick,false,0,true);
                  _loc5_.mc_count.visible = false;
                  GameWorld.textHandler.setReplaceString("ItemName",dragItem.itemConfig.name);
                  GameWorld.textHandler.setReplaceString("ItemSellPrice",dragItem.itemConfig.cost);
                  GameWorld.textHandler.setTextFieldWithId(_loc5_.tf_text,"BuyGiftItemWithCoins",true);
                  _loc6_ = new WorldPopUp(_loc4_,_loc5_.mc_tick,_loc5_.mc_cancel);
                  _loc6_.show();
               }
            }
            else
            {
               if(dragItem.itemConfig.cash > 0)
               {
                  GameWorld.cashPanel.showPlayfishCashToolTip();
               }
               else
               {
                  GameWorld.cashPanel.showCoinsToolTip();
               }
               dragItem = null;
            }
            param1.stopImmediatePropagation();
         }
      }
      
      public function onGiftSent(param1:BuildingItem) : void
      {
      }
      
      private function onItemSellOK(param1:UserItem, param2:int) : void
      {
         GameWorld.cashPanel.addCoins(GameWorld.getItemSellPrice(param1.itemConfig) * param2);
         GameWorld.addGourmetPoints(GameWorld.GOURMET_POINTS_SELL_ITEM * param2);
         shopTransactionHandler.addSoldItem(param1,param2,true);
         gameUser.removeInventoryItemWithId(param1.itemConfig.id,param2);
         itemChooser.refresh();
      }
      
      private function onFlipButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:BuildingItem = param1.currentTarget.item;
         _loc2_.flip();
         var _loc3_:UserItem = _loc2_.getUserItem();
         gameUser.removeUsedBuildingItem(_loc3_.serverUid);
         gameUser.addUsedBuildingItem(_loc3_);
         shopTransactionHandler.addChangedItem(_loc3_,_loc2_.fromInventory);
      }
      
      private function onNewItem(param1:ItemChooserEvent) : void
      {
         if(dragItem != null)
         {
            removeObject(dragItem);
         }
         var _loc2_:InventoryUserItem = gameUser.getInventoryItem(param1.itemConfig);
         if(_loc2_)
         {
            dragItem = new BuildingItem(_loc2_);
            gameUser.removeInventoryItem(_loc2_);
            dragItem.fromInventory = true;
            dragItem.owned = true;
            itemChooser.refresh();
         }
         else
         {
            dragItem = new BuildingItem(new UserItem(param1.itemConfig));
         }
         dragItem.drawPriority = 150;
         var _loc3_:Rectangle = dragItem.getBounds(null);
         dragOffsetX = -(_loc3_.right + _loc3_.left) / 2;
         dragOffsetY = -(_loc3_.top + _loc3_.bottom) / 2;
         scaleItemToButton(dragItem);
         setItemInventoryPosition();
         dragItem.mouseEnabled = false;
         dragItem.mouseChildren = false;
         addObject(dragItem);
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         if(dragItem != null)
         {
            if(!itemChooser.hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY,true))
            {
               if(dragItem.roof)
               {
                  building.positionRoof(dragItem);
                  dragItem.width *= building.scaleX;
                  dragItem.height *= building.scaleX;
                  dragItem.x = dragItem.x * building.scaleX + building.x;
                  dragItem.y = dragItem.y * building.scaleY + building.y;
               }
               else
               {
                  dragItem.x = mouseX + dragOffsetX;
                  dragItem.y = mouseY + dragOffsetY;
                  adjustBuildingItemPosition(dragItem);
                  if(dragItem.scaleY != building.scaleY)
                  {
                     dragItem.scaleX = building.scaleX;
                     dragItem.scaleY = building.scaleY;
                     if(dragItem.flipped)
                     {
                        dragItem.scaleX = -dragItem.scaleX;
                     }
                  }
               }
            }
            else
            {
               scaleItemToButton(dragItem);
               setItemInventoryPosition();
            }
         }
      }
   }
}


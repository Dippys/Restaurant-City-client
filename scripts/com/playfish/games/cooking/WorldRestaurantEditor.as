package com.playfish.games.cooking
{
   import com.playfish.games.cooking.events.*;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.games.cooking.ui.mail.WorldWriteMessage;
   import com.playfish.rpc.cooking.Floor;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class WorldRestaurantEditor extends WorldRestaurant
   {
      
      private var itemPrevRotation:int = -1;
      
      public var buttonPlay:MovieClip;
      
      private var directionButton:MovieClip = null;
      
      private var curAttachedItems:Array;
      
      private var prevActiveRoomIndex:int;
      
      private var shopTransactionHandler:ShopTransactionHandler = new ShopTransactionHandler();
      
      private var itemPrevTileX:int = -1;
      
      private var itemPrevTileY:int = -1;
      
      private var itemChooser:ItemChooser;
      
      private var itemPrevHeight:int = -1;
      
      private var layoutChooser:RestaurantLayoutChooser;
      
      private var gridLayer:Shape;
      
      private var placingFloorTile:Boolean = false;
      
      private var cursorItemLayer:BaseObject;
      
      private var prevSelectedWall:RoomItem;
      
      private var bgMusic:GameSound;
      
      private var uiButton:MovieClip;
      
      private var curItem:RoomItem;
      
      private var zoomLever:ZoomLever;
      
      private var outsideAreaGridLayer:Shape;
      
      private var placeItemSound:GameSound = new GameSound("SfxPlaceItem",GameSound.TYPE_SOUND);
      
      public function WorldRestaurantEditor(param1:GameUser)
      {
         super(param1);
         bgMusic = new GameSound("MusicEditor",GameSound.TYPE_MUSIC);
      }
      
      private function addCursorRoomItem(param1:RoomItem) : void
      {
         var _loc2_:Number = NaN;
         param1.mouseChildren = false;
         param1.mouseEnabled = false;
         param1.drawPriority = int.MAX_VALUE / 2;
         cursorItemLayer.addObject(param1);
         if(param1.subItems != null)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.subItems.length)
            {
               param1.subItems[_loc2_].mouseChildren = false;
               param1.subItems[_loc2_].mouseEnabled = false;
               param1.subItems[_loc2_].drawPriority = param1.drawPriority + getTileDrawPriority(param1.subItems[_loc2_].subItemTileOffsetX,param1.subItems[_loc2_].subItemTileOffsetY);
               cursorItemLayer.addObject(param1.subItems[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      public function addListenerToEditableItem(param1:RoomItem) : void
      {
         var _loc2_:Number = NaN;
         param1.mouseEnabled = true;
         param1.mouseChildren = true;
         param1.buttonMode = true;
         param1.addEventListener(MouseEvent.MOUSE_DOWN,onItemClicked,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OVER,onItemRollOver,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OUT,onItemRollOut,false,0,true);
         if(param1.subItems != null)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.subItems.length)
            {
               param1.subItems[_loc2_].mouseEnabled = true;
               param1.subItems[_loc2_].mouseChildren = true;
               param1.subItems[_loc2_].buttonMode = true;
               param1.subItems[_loc2_].addEventListener(MouseEvent.MOUSE_DOWN,onItemClicked,false,0,true);
               param1.subItems[_loc2_].addEventListener(MouseEvent.ROLL_OVER,onItemRollOver,false,0,true);
               param1.subItems[_loc2_].addEventListener(MouseEvent.ROLL_OUT,onItemRollOut,false,0,true);
               _loc2_++;
            }
         }
      }
      
      public function onGiftCancel(param1:RoomItem) : void
      {
         if(param1.owned)
         {
            curItem = param1;
            if(!revertCurrentItem())
            {
               putItemInInventory(param1);
            }
         }
         curItem = null;
      }
      
      private function onSellItem(param1:MouseEvent) : void
      {
         var _loc2_:UserItem = null;
         var _loc3_:WorldPopUp = null;
         if(curItem != null && !curItem.notSellable)
         {
            if(curItem.owned)
            {
               putItemInInventory(curItem);
               _loc2_ = gameUser.getInventoryItem(curItem.itemConfig);
               _loc3_ = new WorldSellItemPopUp(_loc2_,onItemSellOK);
               _loc3_.show();
               removeCursorRoomItem(curItem);
               curItem = null;
            }
            else
            {
               removeCursorRoomItem(curItem);
               curItem = null;
            }
            param1.stopImmediatePropagation();
         }
      }
      
      private function rotateChairTowardTable(param1:RoomItem) : void
      {
         if(isTableTile(param1.tileX + 1,param1.tileY))
         {
            param1.setRotation(0);
         }
         else if(isTableTile(param1.tileX,param1.tileY + 1))
         {
            param1.setRotation(1);
         }
         else if(isTableTile(param1.tileX - 1,param1.tileY))
         {
            param1.setRotation(2);
         }
         else if(isTableTile(param1.tileX,param1.tileY - 1))
         {
            param1.setRotation(3);
         }
      }
      
      private function isTableTile(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         if(param1 >= 0 && param2 >= 0)
         {
            _loc3_ = getTileIndex(param1,param2);
            if(_loc3_ < itemMap.length && itemMap[_loc3_].length > 0 && Boolean(itemMap[_loc3_][0].tableItem))
            {
               return true;
            }
         }
         return false;
      }
      
      public function playMouseDown(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function putItemInInventory(param1:RoomItem, param2:Boolean = true) : void
      {
         var _loc3_:InventoryUserItem = null;
         var _loc4_:GameObject = null;
         if(Boolean(param1) && param1.owned)
         {
            _loc3_ = new InventoryUserItem(param1.itemConfig);
            _loc3_.serverUid = param1.serverUid;
            shopTransactionHandler.addChangedItem(_loc3_,param1.fromInventory);
            gameUser.addInventoryItem(_loc3_);
            itemChooser.refresh();
            if(param2)
            {
               _loc4_ = new GameObject("InventoryCrateAnim");
               _loc4_.x = param1.x;
               _loc4_.y = param1.y;
               _loc4_.drawPriority = param1.drawPriority;
               _loc4_.numLoops = 1;
               _loc4_.removeWhenComplete = true;
               cursorItemLayer.addObject(_loc4_);
            }
         }
      }
      
      override public function init() : void
      {
         var _loc1_:MovieClip = null;
         gridLayer = new Shape();
         outsideAreaGridLayer = new Shape();
         super.init();
         prevActiveRoomIndex = activeRoomIndex;
         room.addChildAt(gridLayer,room.getChildIndex(floorLayer) + 1);
         room.addChildAt(outsideAreaGridLayer,room.getChildIndex(gridLayer) + 1);
         addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveListener);
         room.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownListener);
         room.addEventListener(MouseEvent.MOUSE_UP,mouseUpListener);
         _loc1_ = Engine.getMovieClip("ItemChooserScene2");
         itemChooser = new ItemChooser(GameWorld.interiorItemDatabase,gameUser,_loc1_);
         itemChooser.drawPriority = 100;
         itemChooser.enableDragInstructionToolTip = true;
         itemChooser.y = Engine.getStageY() + Engine.getStageHeight() + itemChooser.height;
         itemChooser.addEventListener(ItemChooserEvent.EVENT_ITEM_MOUSE_DOWN,onNewItem);
         itemChooser.addEventListener(MouseEvent.MOUSE_UP,onItemChooserMouseUp);
         itemChooser.giftButton.addEventListener(MouseEvent.MOUSE_UP,onGiftItem);
         itemChooser.sellButton.addEventListener(MouseEvent.MOUSE_UP,onSellItem);
         addObject(itemChooser);
         itemChooser.setGroup(GameWorld.interiorItemDatabase.getGroup("Table"));
         setButtonMode(_loc1_.mc_removeAll,true);
         _loc1_.mc_removeAll.addEventListener(MouseEvent.CLICK,onRemoveAllItemsToInventory,false,0,true);
         _loc1_.mc_removeAll.tooltip = new ToolTip(_loc1_.mc_removeAll,GameWorld.textHandler.getTextFromId("ToolTipRemoveAllItems"));
         canvasHeight = Engine.STAGE_HEIGHT - itemChooser.height;
         cursorItemLayer = new BaseObject();
         cursorItemLayer.drawPriority = 200;
         cursorItemLayer.mouseEnabled = false;
         addObject(cursorItemLayer);
         uiButton = Engine.getMovieClip("RoomEditorUi");
         uiButton.y = Engine.getStageBottom();
         buttonLayer.addChild(uiButton);
         zoomLever = new ZoomLever(uiButton.mc_zoom,this);
         uiButton.mc_zoom.x = Engine.getStageRight() - 16;
         buttonPlay = uiButton.okButton;
         setButtonMode(buttonPlay,true);
         buttonPlay.addEventListener(MouseEvent.CLICK,playClicked,false,0,true);
         buttonPlay.addEventListener(MouseEvent.MOUSE_DOWN,playMouseDown,false,0,true);
         layoutChooser = new RestaurantLayoutChooser(uiButton.mc_layout,this);
         addEditableItemListener();
         GameWorld.stopGlobalRpcs();
      }
      
      private function onFullScreen(param1:Event) : void
      {
         GameWorld.hiredFriendsPanel.y = Engine.getStageBottom() + GameWorld.hiredFriendsPanel.height;
         itemChooser.y = Engine.getStageBottom();
         uiButton.y = Engine.getStageBottom();
         uiButton.mc_zoom.x = Engine.getStageRight() - 16;
         uiButton.mc_layout.x = Engine.getStageRight();
      }
      
      private function onPurchaseCashItemSuccess(param1:int) : void
      {
         GameWorld.cashPanel.showPlayfishCashPopUp(-curItem.itemConfig.cash);
         itemChooser.refresh();
         GameWorld.addAwardValue(GameAwards.AWARD_BUY_INDOOR_ITEM,1);
         addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(curItem.itemConfig));
         curItem = null;
      }
      
      public function onItemRollOut(param1:MouseEvent) : void
      {
         var _loc2_:RoomItem = RoomItem(param1.currentTarget);
         if(_loc2_.parentItem != null)
         {
            _loc2_ = _loc2_.parentItem;
         }
         if(!_loc2_.isRotatable())
         {
            _loc2_.glow(false);
            _loc2_.hideGrid();
         }
      }
      
      private function onPurchaseCashItemCancel(param1:int) : void
      {
         removeRoomItem(curItem);
         removeListenerFromEditableItem(curItem);
         gameUser.removeUsedRestaurantItem(curItem.serverUid);
         curItem = null;
         if(param1 == RpcClient.STATUS_NOT_ENOUGH_CASH)
         {
            itemChooser.refresh();
         }
      }
      
      public function onItemRollOver(param1:MouseEvent) : void
      {
         var _loc2_:RoomItem = null;
         Debug.out("onItemRollOver " + curItem);
         if(curItem == null)
         {
            _loc2_ = RoomItem(param1.currentTarget);
            _loc2_.fromInventory = false;
            if(_loc2_.parentItem != null)
            {
               _loc2_ = _loc2_.parentItem;
            }
            if(_loc2_.isRotatable())
            {
               if(!directionButton)
               {
                  directionButton = Engine.getMovieClip("DirectionWheel");
                  directionButton.visible = false;
                  directionButton.addEventListener(MouseEvent.MOUSE_DOWN,directionButtonClicked,false,0,true);
                  setButtonMode(directionButton,true);
                  room.addChild(directionButton);
               }
               if(directionButton.item != _loc2_)
               {
                  removePrevDirectionButton();
                  itemPrevRotation = _loc2_.getRotationCount();
                  itemPrevHeight = _loc2_.curHeight;
                  directionButton.visible = true;
                  directionButton.x = _loc2_.x;
                  directionButton.y = getScreenY(_loc2_.tileX + _loc2_.numTilesX,_loc2_.tileY + _loc2_.numTilesY) + directionButton.height / 2;
                  directionButton.item = _loc2_;
               }
            }
            else
            {
               removePrevDirectionButton();
            }
            _loc2_.glow(true);
            _loc2_.setGrid(true);
            _loc2_.showGrid();
         }
      }
      
      override public function showNotify() : void
      {
         super.showNotify();
         addObject(GameWorld.cashPanel);
         GameWorld.hiredFriendsPanel.y = Engine.getStageBottom();
         addObject(GameWorld.hiredFriendsPanel);
         bgMusic.play(-1);
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,0,true);
      }
      
      override public function hideNotify() : void
      {
         super.hideNotify();
         removeObject(GameWorld.cashPanel);
         bgMusic.stop();
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onFullScreen);
      }
      
      public function addEditableItemListener() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < placedItems.length)
         {
            if(placedItems[_loc1_].editable)
            {
               addListenerToEditableItem(placedItems[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      private function onItemChooserMouseUp(param1:MouseEvent) : void
      {
         Debug.out("onItemChooserMouseUp");
         if(curItem)
         {
            if(curItem.noInventory && curItem.owned)
            {
               if(!revertCurrentItem())
               {
                  Engine.showMessage("trying to revert no inventory item to previous position but there\'s no previous position(itemPrevTileX) defined");
               }
            }
            else
            {
               putItemInInventory(curItem);
               removeCursorRoomItem(curItem);
            }
            itemPrevTileX = -1;
            itemPrevTileY = -1;
            itemPrevRotation = -1;
            itemPrevHeight = -1;
            curItem = null;
         }
      }
      
      private function onCommitSuccess(param1:RpcEvent) : void
      {
         Debug.out("onCommitOK");
         shopTransactionHandler.removeEventListener(RpcEvent.SUCCESS,onCommitSuccess);
         shopTransactionHandler.removeEventListener(RpcEvent.FAIL,onCommitFail);
         buttonPlay.removeEventListener(MouseEvent.CLICK,playClicked);
         var _loc2_:WorldRestaurantPlay = new WorldRestaurantPlay(gameUser);
         _loc2_.room.x = room.x;
         _loc2_.room.y = room.y;
         GameWorld.startGlobalRpcs();
         destroy();
         Engine.setActiveWorld(_loc2_);
      }
      
      public function onItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:RoomItem = null;
         var _loc3_:Point = null;
         if(curItem == null)
         {
            removePrevDirectionButton();
            _loc2_ = RoomItem(param1.currentTarget);
            if(_loc2_.parentItem != null)
            {
               _loc2_ = _loc2_.parentItem;
            }
            removeRoomItem(_loc2_);
            removeListenerFromEditableItem(_loc2_);
            curItem = _loc2_;
            _loc3_ = cursorItemLayer.globalToLocal(room.localToGlobal(new Point(getScreenX(curItem.tileX,curItem.tileY),getScreenY(curItem.tileX,curItem.tileY))));
            curItem.setPosition(_loc3_.x,_loc3_.y);
            curItem.setGrid(true);
            curItem.showGrid();
            curItem.glow(false);
            curItem.owned = true;
            curItem.fromInventory = false;
            addCursorRoomItem(curItem);
            itemPrevTileX = curItem.tileX;
            itemPrevTileY = curItem.tileY;
            itemPrevRotation = curItem.getRotationCount();
            itemPrevHeight = curItem.curHeight;
            gameUser.removeUsedRestaurantItem(curItem.serverUid);
            param1.stopImmediatePropagation();
         }
      }
      
      public function revertCurrentItem() : Boolean
      {
         if(itemPrevTileX != -1)
         {
            curItem.setTilePosition(itemPrevTileX,itemPrevTileY);
            curItem.setRotation(itemPrevRotation);
            curItem.setHeight(itemPrevHeight);
            curItem.hideGrid();
            curItem.glow(false);
            placeCurrentItem();
            return true;
         }
         return false;
      }
      
      public function onGiftBuyCancelTickClick(param1:MouseEvent) : void
      {
         curItem = null;
      }
      
      private function onCommitFail(param1:RpcEvent) : void
      {
         Debug.out("onCommitFail");
         shopTransactionHandler.removeEventListener(RpcEvent.SUCCESS,onCommitSuccess);
         shopTransactionHandler.removeEventListener(RpcEvent.FAIL,onCommitFail);
      }
      
      public function placeCurrentItem() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:GameObject = null;
         var _loc4_:Point = null;
         var _loc5_:RoomItem = null;
         var _loc6_:InventoryUserItem = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:UserItem = null;
         var _loc10_:RoomItem = null;
         var _loc11_:PurchaseCashItemConfirmPopUp = null;
         itemPrevTileX = -1;
         itemPrevTileY = -1;
         if(curItem.owned || GameWorld.isItemAffordable(curItem.itemConfig) && GameWorld.isItemLevelReached(curItem.itemConfig))
         {
            if(curItem.floorTileItem)
            {
               _loc1_ = curItem.roomIndex;
               _loc2_ = getTileIndex(curItem.roomTileX,curItem.roomTileY);
               if(Boolean(gameUser.floors[_loc1_]) && gameUser.floors[_loc1_].tiles[_loc2_] == curItem.itemConfig.id)
               {
                  return true;
               }
            }
            if(!curItem.owned)
            {
               if(curItem.itemConfig.cash == 0)
               {
                  GameWorld.cashPanel.addCoins(-curItem.itemConfig.cost);
                  _loc3_ = new GameObject("MoneyLostAnim");
                  _loc3_.getChildMovieClipInstance("mc_content").tf_money.text = -curItem.itemConfig.cost;
                  _loc4_ = globalToLocal(cursorItemLayer.localToGlobal(new Point(curItem.x,curItem.y - tileHeightHalf)));
                  _loc3_.x = _loc4_.x;
                  _loc3_.y = _loc4_.y;
                  _loc3_.drawPriority = 1000;
                  _loc3_.numLoops = 1;
                  _loc3_.removeWhenComplete = true;
                  addObject(_loc3_);
                  GameWorld.addAwardValue(GameAwards.AWARD_SPEND_COIN,curItem.itemConfig.cost);
                  addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(curItem.itemConfig));
               }
            }
            if(curItem.floorTileItem)
            {
               _loc5_ = RoomItem.createRoomItems(curItem.itemConfig,null);
               placeRoomItem(_loc5_,curItem.tileX,curItem.tileY,curItem.curHeight);
               if(curItem.owned)
               {
                  if(gameUser.getInventoryItemCount(curItem.itemConfig) > 0)
                  {
                     gameUser.removeInventoryItemWithId(curItem.itemConfig.id);
                  }
                  else
                  {
                     curItem.owned = false;
                  }
               }
               else
               {
                  _loc6_ = new InventoryUserItem(curItem.itemConfig);
                  shopTransactionHandler.addBoughtItem(_loc6_);
               }
               _loc2_ = getTileIndex(_loc5_.roomTileX,_loc5_.roomTileY);
               if(gameUser.floors[_loc5_.roomIndex])
               {
                  _loc7_ = int(gameUser.floors[_loc5_.roomIndex].tiles[_loc2_]);
                  if((Boolean(_loc7_)) && _loc7_ != 0)
                  {
                     _loc8_ = GameWorld.interiorItemDatabase.getItemFromId(_loc7_);
                     gameUser.addInventoryItem(new InventoryUserItem(_loc8_));
                  }
               }
               gameUser.setFloorTile(_loc5_.roomIndex,_loc2_,curItem.itemConfig.id);
               itemChooser.refresh();
               shopTransactionHandler.saveFloor(_loc5_.roomIndex);
            }
            else
            {
               if(curItem.wallpaperItem)
               {
                  _loc10_ = getWallItem(curItem.tileX,curItem.tileY);
                  if(_loc10_.wallpaperRoomItem != null)
                  {
                     _loc10_.wallpaperRoomItem.owned = true;
                     _loc10_.wallpaperRoomItem.fromInventory = false;
                     putItemInInventory(_loc10_.wallpaperRoomItem);
                     removeRoomItem(_loc10_.wallpaperRoomItem);
                  }
               }
               placeRoomItem(curItem,curItem.tileX,curItem.tileY,curItem.curHeight);
               addListenerToEditableItem(curItem);
               _loc9_ = curItem.getUserItem();
               gameUser.addUsedRestaurantItem(_loc9_);
               removeCursorRoomItem(curItem);
               if(curItem.owned)
               {
                  shopTransactionHandler.addChangedItem(_loc9_,curItem.fromInventory);
                  curItem = null;
               }
               else
               {
                  if(curItem.itemConfig.cash > 0)
                  {
                     _loc11_ = new PurchaseCashItemConfirmPopUp(_loc9_,onPurchaseCashItemSuccess,onPurchaseCashItemCancel);
                     _loc11_.show();
                     return true;
                  }
                  GameWorld.addAwardValue(GameAwards.AWARD_BUY_INDOOR_ITEM,1);
                  shopTransactionHandler.addBoughtItem(_loc9_);
                  itemChooser.refresh();
                  curItem = null;
               }
            }
            return true;
         }
         if(GameWorld.isItemLevelReached(curItem.itemConfig) && !GameWorld.isItemAffordable(curItem.itemConfig))
         {
            if(curItem.itemConfig.cash > 0)
            {
               GameWorld.cashPanel.showPlayfishCashToolTip();
            }
            else
            {
               GameWorld.cashPanel.showCoinsToolTip();
            }
         }
         return false;
      }
      
      private function onCashGiftBuyCancel(param1:int) : void
      {
         curItem = null;
      }
      
      private function onCashGiftBuySuccess(param1:int) : void
      {
         GameWorld.cashPanel.showPlayfishCashPopUp(-curItem.itemConfig.cash);
         GameWorld.addAwardValue(GameAwards.AWARD_BUY_INDOOR_ITEM,1);
         addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(curItem.itemConfig));
         var _loc2_:InventoryUserItem = new InventoryUserItem(curItem.itemConfig);
         _loc2_.serverUid = curItem.serverUid;
         shopTransactionHandler.addChangedItem(_loc2_,curItem.fromInventory);
         itemChooser.refresh();
         curItem.fromInventory = true;
         curItem.owned = true;
         var _loc3_:WorldWriteMessage = new WorldWriteMessage(curItem,null,null,onGiftCancel,onGiftSent);
         _loc3_.show();
         curItem = null;
      }
      
      private function removePrevDirectionButton() : void
      {
         if(Boolean(directionButton) && directionButton.visible)
         {
            if(!isValid(directionButton.item,directionButton.item.tileX,directionButton.item.tileY))
            {
               rotateRoomItem(directionButton.item,itemPrevRotation,itemPrevHeight);
            }
            directionButton.item.hideGrid();
            directionButton.item.glow(false);
            directionButton.item = null;
            directionButton.visible = false;
            itemPrevRotation = -1;
            itemPrevHeight = -1;
         }
      }
      
      public function mouseDownListener(param1:MouseEvent) : void
      {
         Debug.out("mouseDownListener");
      }
      
      public function isRestaurantChanged() : Boolean
      {
         return shopTransactionHandler.hasChanges() || activeRoomIndex != prevActiveRoomIndex;
      }
      
      private function onRemoveAllItemsToInventory(param1:Event) : void
      {
         var _loc2_:ClearRoomConfirmPopUp = new ClearRoomConfirmPopUp(this);
         _loc2_.show();
      }
      
      private function removeWallGlows() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < wallItems.length)
         {
            wallItems[_loc1_].glow(false);
            _loc1_++;
         }
      }
      
      override public function setOutsideAreaSize(param1:int, param2:int) : void
      {
         super.setOutsideAreaSize(param1,param2);
         outsideAreaGridLayer.graphics.clear();
         paintGrid(outsideAreaGridLayer,1,0,param1,param2,10526880);
      }
      
      public function setLayout(param1:int) : void
      {
         var _loc2_:int = param1 * 2;
         var _loc3_:int = _loc2_ + 1;
         gameUser.activeFloorIndex = _loc2_;
         loadRoom(gameUser,_loc2_,_loc3_);
      }
      
      public function playClicked(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_BUTTON_CLICK,"layout_" + gameUser.activeFloorIndex / 2,function():void
         {
         },function():void
         {
         });
         shopTransactionHandler.addEventListener(RpcEvent.SUCCESS,onCommitSuccess,false,0,true);
         shopTransactionHandler.addEventListener(RpcEvent.FAIL,onCommitFail,false,0,true);
         if(isRestaurantChanged())
         {
            if(!shopTransactionHandler.commit())
            {
               onCommitSuccess(null);
            }
         }
         else
         {
            onCommitSuccess(null);
         }
         if(e)
         {
            e.stopImmediatePropagation();
         }
      }
      
      public function onGiftBuyTickClick(param1:MouseEvent) : void
      {
         GameWorld.cashPanel.addCoins(-curItem.itemConfig.cost);
         itemChooser.refresh();
         addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(curItem.itemConfig));
         GameWorld.addAwardValue(GameAwards.AWARD_SPEND_COIN,curItem.itemConfig.cost);
         if(!curItem.floorTileItem)
         {
            GameWorld.addAwardValue(GameAwards.AWARD_BUY_INDOOR_ITEM,1);
         }
         var _loc2_:InventoryUserItem = new InventoryUserItem(curItem.itemConfig);
         shopTransactionHandler.addBoughtItem(_loc2_);
         curItem.fromInventory = true;
         curItem.owned = true;
         var _loc3_:WorldWriteMessage = new WorldWriteMessage(curItem,null,null,onGiftCancel,onGiftSent);
         _loc3_.show();
         curItem = null;
      }
      
      private function removeCursorRoomItem(param1:RoomItem) : void
      {
         var _loc2_:Number = NaN;
         cursorItemLayer.removeObject(param1);
         if(param1.subItems != null)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.subItems.length)
            {
               cursorItemLayer.removeObject(param1.subItems[_loc2_]);
               _loc2_++;
            }
         }
         param1.hideGrid();
      }
      
      private function isMouseOnDirectionButton() : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc1_:RoomItem = directionButton.item;
         var _loc2_:Boolean = directionButton.hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY) || _loc1_.hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY);
         if(_loc1_.subItems != null)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc1_.subItems.length)
            {
               _loc2_ ||= Boolean(_loc1_.subItems[_loc3_].hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY));
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function removeListenerFromEditableItem(param1:RoomItem) : void
      {
         var _loc2_:Number = NaN;
         param1.buttonMode = false;
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,onItemClicked);
         param1.removeEventListener(MouseEvent.ROLL_OVER,onItemRollOver);
         param1.removeEventListener(MouseEvent.ROLL_OUT,onItemRollOut);
         if(param1.subItems != null)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.subItems.length)
            {
               param1.subItems[_loc2_].buttonMode = false;
               param1.subItems[_loc2_].removeEventListener(MouseEvent.MOUSE_DOWN,onItemClicked);
               param1.subItems[_loc2_].removeEventListener(MouseEvent.ROLL_OVER,onItemRollOver);
               param1.subItems[_loc2_].removeEventListener(MouseEvent.ROLL_OUT,onItemRollOut);
               _loc2_++;
            }
         }
      }
      
      override protected function setZoom(param1:Number) : void
      {
         super.setZoom(param1);
         cursorItemLayer.scaleX = param1;
         cursorItemLayer.scaleY = param1;
         mouseMoveListener(null);
      }
      
      private function addWallGlows(param1:RoomItem, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:RoomItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < curItem.numTilesX)
         {
            _loc4_ = 0;
            while(_loc4_ < curItem.numTilesY)
            {
               _loc5_ = wallMap[getTileIndex(param1.tileX + _loc3_,param1.tileY + _loc4_)];
               if(_loc5_)
               {
                  _loc5_.glow(true,param2);
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function removeAllItemsToInventory() : void
      {
         var _loc3_:UserItem = null;
         var _loc4_:int = 0;
         var _loc5_:RoomItem = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         removePrevDirectionButton();
         var _loc1_:* = int(gameUser.usedRestaurantItems.length - 1);
         while(_loc1_ >= 0)
         {
            _loc3_ = gameUser.usedRestaurantItems[_loc1_];
            _loc4_ = 0;
            while(_loc4_ < placedItems.length)
            {
               _loc5_ = placedItems[_loc4_];
               if(_loc5_.serverUid == _loc3_.serverUid)
               {
                  removeRoomItem(_loc5_);
                  removeListenerFromEditableItem(_loc5_);
                  gameUser.addInventoryItem(new InventoryUserItem(_loc3_.itemConfig,_loc3_.getOwnedItem()));
                  gameUser.removeUsedRestaurantItem(_loc3_.serverUid);
                  break;
               }
               _loc4_++;
            }
            _loc1_--;
         }
         setWallPaper(getWallItem(0,1),null);
         setWallPaper(getWallItem(1,0),null);
         GameWorld.saveProfileHandler.moveAllInGameItemsToInventory(activeRoomIndex,GameUser.ITEM_TYPE_RESTAURANT);
         GameWorld.saveProfileHandler.moveAllInGameItemsToInventory(activeOutsideAreaRoomIndex,GameUser.ITEM_TYPE_RESTAURANT);
         var _loc2_:Floor = gameUser.floors[activeRoomIndex];
         if(_loc2_)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_.tiles.length)
            {
               _loc6_ = int(_loc2_.tiles[_loc1_]);
               if(_loc6_ != 0)
               {
                  _loc7_ = GameWorld.interiorItemDatabase.getItemFromId(_loc6_);
                  gameUser.addInventoryItem(new InventoryUserItem(_loc7_));
                  _loc2_.tiles[_loc1_] = 0;
               }
               _loc1_++;
            }
            clearMainFloorTiles();
            GameWorld.saveProfileHandler.saveRestaurantFloor(activeRoomIndex);
         }
         _loc2_ = gameUser.floors[activeOutsideAreaRoomIndex];
         if(_loc2_)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_.tiles.length)
            {
               _loc6_ = int(_loc2_.tiles[_loc1_]);
               if(_loc6_ != 0)
               {
                  _loc7_ = GameWorld.interiorItemDatabase.getItemFromId(_loc6_);
                  gameUser.addInventoryItem(new InventoryUserItem(_loc7_));
                  _loc2_.tiles[_loc1_] = 0;
               }
               _loc1_++;
            }
            clearOutsideAreaFloorTiles();
            GameWorld.saveProfileHandler.saveRestaurantFloor(activeOutsideAreaRoomIndex);
         }
         itemChooser.refresh();
      }
      
      override public function loadRoom(param1:GameUser, param2:int, param3:int) : void
      {
         super.loadRoom(param1,param2,param3);
         addEditableItemListener();
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         super.tick(param1);
         if(this.contains(GameWorld.hiredFriendsPanel))
         {
            _loc2_ = Engine.getStageBottom() + GameWorld.hiredFriendsPanel.height;
            GameWorld.hiredFriendsPanel.y += 40;
            if(Math.round(GameWorld.hiredFriendsPanel.y) >= _loc2_)
            {
               GameWorld.hiredFriendsPanel.y = Engine.getStageBottom();
               removeObject(GameWorld.hiredFriendsPanel);
            }
         }
         else if(itemChooser.y > Engine.getStageBottom())
         {
            itemChooser.y -= (itemChooser.y - Engine.getStageBottom()) / 4;
            if(Math.round(itemChooser.y) == Engine.getStageBottom())
            {
               itemChooser.y = Engine.getStageBottom();
            }
         }
         if(Boolean(directionButton) && directionButton.visible)
         {
            if(!isMouseOnDirectionButton())
            {
               removePrevDirectionButton();
            }
         }
      }
      
      public function directionButtonClicked(param1:MouseEvent) : void
      {
         var _loc3_:UserItem = null;
         var _loc2_:RoomItem = directionButton.item;
         if(_loc2_)
         {
            rotateRoomItem(_loc2_);
            _loc2_.setGrid(isValid(_loc2_,_loc2_.tileX,_loc2_.tileY));
            _loc3_ = _loc2_.getUserItem();
            gameUser.removeUsedRestaurantItem(_loc3_.serverUid);
            gameUser.addUsedRestaurantItem(_loc3_);
            shopTransactionHandler.addChangedItem(_loc3_,_loc2_.fromInventory);
         }
         if(param1 != null)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      public function onGiftSent(param1:RoomItem) : void
      {
      }
      
      private function onGiftItem(param1:MouseEvent) : void
      {
         var _loc2_:WorldInfoPopUp = null;
         var _loc3_:WorldWriteMessage = null;
         var _loc4_:PurchaseCashItemConfirmPopUp = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:WorldPopUp = null;
         if(curItem != null)
         {
            if(curItem.notGiftable)
            {
               _loc2_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("ItemCanNotBeGifted"));
               _loc2_.show();
            }
            else if(!curItem.notSellable)
            {
               removeCursorRoomItem(curItem);
               if(curItem.owned)
               {
                  _loc3_ = new WorldWriteMessage(curItem,null,null,onGiftCancel,onGiftSent);
                  _loc3_.show();
                  curItem = null;
                  param1.stopImmediatePropagation();
               }
               else if(GameWorld.isItemAffordable(curItem.itemConfig))
               {
                  if(curItem.itemConfig.cash > 0)
                  {
                     _loc4_ = new PurchaseCashItemConfirmPopUp(curItem.getUserItem(),onCashGiftBuySuccess,onCashGiftBuyCancel);
                     _loc4_.show();
                  }
                  else
                  {
                     _loc5_ = Engine.getMovieClip("SellPopUpAnim");
                     _loc6_ = _loc5_.mc_content;
                     ItemChooser.setItemOnIconButton(curItem.itemConfig,_loc6_.mc_item);
                     _loc6_.mc_addCoins.stop();
                     _loc6_.mc_addCoins.visible = false;
                     setButtonMode(_loc6_.mc_tick,true);
                     setButtonMode(_loc6_.mc_cancel,true);
                     _loc6_.mc_tick.addEventListener(MouseEvent.CLICK,onGiftBuyTickClick,false,0,true);
                     _loc6_.mc_cancel.addEventListener(MouseEvent.CLICK,onGiftBuyCancelTickClick,false,0,true);
                     _loc6_.mc_count.visible = false;
                     GameWorld.textHandler.setReplaceString("ItemName",curItem.itemConfig.name);
                     GameWorld.textHandler.setReplaceString("ItemSellPrice",curItem.itemConfig.cost);
                     GameWorld.textHandler.setTextFieldWithId(_loc6_.tf_text,"BuyGiftItemWithCoins",true);
                     _loc7_ = new WorldPopUp(_loc5_,_loc6_.mc_tick,_loc6_.mc_cancel);
                     _loc7_.show();
                  }
                  param1.stopImmediatePropagation();
               }
               else if(curItem.itemConfig.cash > 0)
               {
                  GameWorld.cashPanel.showPlayfishCashToolTip();
               }
               else
               {
                  GameWorld.cashPanel.showCoinsToolTip();
               }
            }
         }
      }
      
      private function onItemSellOK(param1:UserItem, param2:int) : void
      {
         GameWorld.cashPanel.addCoins(GameWorld.getItemSellPrice(param1.itemConfig) * param2);
         addGourmetPoints(GameWorld.GOURMET_POINTS_SELL_ITEM * param2);
         shopTransactionHandler.addSoldItem(param1,param2,true);
         gameUser.removeInventoryItemWithId(param1.itemConfig.id,param2);
         itemChooser.refresh();
      }
      
      public function mouseMoveListener(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:RoomItem = null;
         var _loc5_:Number = NaN;
         var _loc6_:RoomItem = null;
         var _loc7_:Point = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         if(curItem != null)
         {
            if(!itemChooser.hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY,true))
            {
               _loc2_ = getTileIndexX(room.mouseX,room.mouseY);
               _loc3_ = getTileIndexY(room.mouseX,room.mouseY);
               if(curItem.wallDecorationItem || curItem.wallpaperItem)
               {
                  _loc5_ = 0;
                  while(_loc5_ < wallItems.length)
                  {
                     _loc6_ = wallItems[_loc5_];
                     if((_loc6_.tileX != 0 || _loc6_.tileY != 0) && _loc6_.hitTestPoint(Engine.instance.stage.mouseX,Engine.instance.stage.mouseY))
                     {
                        _loc4_ = _loc6_;
                        _loc2_ = _loc4_.tileX;
                        _loc3_ = _loc4_.tileY;
                        curItem.copyRotation(_loc4_);
                        break;
                     }
                     _loc5_++;
                  }
               }
               if(_loc4_ == null && isItemOutOfBound(curItem,_loc2_,_loc3_))
               {
                  curItem.setTilePosition(_loc2_,_loc3_);
                  curItem.setPosition(cursorItemLayer.mouseX,cursorItemLayer.mouseY);
                  curItem.y = cursorItemLayer.mouseY;
                  curItem.setHeight(0);
                  curItem.setGrid(false);
                  removeWallGlows();
               }
               else if(_loc2_ != curItem.tileX || _loc3_ != curItem.tileY)
               {
                  curItem.setTilePosition(_loc2_,_loc3_);
                  _loc7_ = cursorItemLayer.globalToLocal(room.localToGlobal(new Point(getScreenX(_loc2_,_loc3_),getScreenY(_loc2_,_loc3_))));
                  curItem.setPosition(_loc7_.x,_loc7_.y);
                  _loc8_ = isValid(curItem,_loc2_,_loc3_);
                  curItem.setGrid(_loc8_);
                  updateItemRoomPosition(curItem,_loc2_,_loc3_);
                  _loc9_ = 0;
                  if(!curItem.wallDecorationItem && !curItem.wallpaperItem && !curItem.floorTileItem)
                  {
                     _loc9_ = getItemHeightAtTile(curItem,_loc2_,_loc3_);
                  }
                  curItem.setHeight(_loc9_);
                  removeWallGlows();
                  if(_loc4_)
                  {
                     addWallGlows(curItem,_loc8_ ? 16777215 : 16711680);
                  }
                  if(curItem.chairItem)
                  {
                     rotateChairTowardTable(curItem);
                  }
               }
               curItem.showGrid();
            }
            else
            {
               curItem.setPosition(cursorItemLayer.mouseX,cursorItemLayer.mouseY);
               curItem.hideGrid();
            }
         }
      }
      
      public function onNewItem(param1:ItemChooserEvent) : void
      {
         if(curItem != null)
         {
            putItemInInventory(curItem);
            removeCursorRoomItem(curItem);
         }
         var _loc2_:InventoryUserItem = gameUser.getInventoryItem(param1.itemConfig);
         if(_loc2_)
         {
            curItem = RoomItem.createRoomItems(param1.itemConfig,_loc2_);
            curItem.owned = true;
            curItem.fromInventory = true;
            gameUser.removeInventoryItem(_loc2_);
            itemChooser.refresh();
         }
         else
         {
            curItem = RoomItem.createRoomItems(param1.itemConfig,new UserItem(param1.itemConfig));
         }
         if(curItem)
         {
            curItem.setPosition(cursorItemLayer.mouseX,cursorItemLayer.mouseY);
            addCursorRoomItem(curItem);
         }
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         zoomLever.setZoomLevel(ZoomLever.zoomLevel - param1.delta / Math.abs(param1.delta),false);
      }
      
      public function mouseUpListener(param1:MouseEvent) : void
      {
         Debug.out("mouseUpListener");
         if(curItem)
         {
            removeWallGlows();
            if(isValid(curItem,curItem.tileX,curItem.tileY))
            {
               if(placeCurrentItem())
               {
                  placeItemSound.play(1);
                  return;
               }
            }
            if(!revertCurrentItem())
            {
               putItemInInventory(curItem);
               removeCursorRoomItem(curItem);
            }
            curItem = null;
         }
      }
      
      override public function setRoomSize(param1:int, param2:int) : void
      {
         super.setRoomSize(param1,param2);
         gridLayer.graphics.clear();
         paintGrid(gridLayer,1,1,param1,param2,10526880);
         outsideAreaGridLayer.x = getScreenX(0,param2);
         outsideAreaGridLayer.y = getScreenY(0,param2);
      }
   }
}


package com.playfish.games.cooking
{
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.math.*;
   import away3d.core.render.*;
   import away3d.lights.DirectionalLight3D;
   import away3d.loaders.*;
   import com.playfish.games.cooking.events.ItemChooserEvent;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.games.cooking.ui.mail.WorldWriteMessage;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.text.*;
   
   public class WorldCustomiseAvatar extends BaseWorld
   {
      
      private static const BG_COLOUR_TOP:int = 11185326;
      
      private static const BG_COLOUR_BOTTOM:int = 14540511;
      
      private var dragItemMovieClip:MovieClip;
      
      private var debugTF:TextField;
      
      private var light:DirectionalLight3D;
      
      private var shopTransactionHandler:ShopTransactionHandler = new ShopTransactionHandler();
      
      public var okButton:MovieClip;
      
      private var hairButtons:Array = new Array();
      
      private var bg:MovieClip;
      
      private var skinButtons:Array = new Array();
      
      private var employeeOutfit:Boolean;
      
      private var avatar:Avatar3D;
      
      private var prevMouseX:int;
      
      private var dragItem:GameItemObject;
      
      private var prevMouseY:int;
      
      private var scene:MovieClip;
      
      private var avatarMouseDown:Boolean = false;
      
      public var itemChooser:ItemChooser;
      
      private var itemDatabase:ItemDatabase;
      
      private var buyItem:AvatarItem;
      
      private var clickedItemConfig:Object;
      
      private var itemIcons:Array;
      
      private var bgTop:Shape;
      
      private var bgBottom:Shape;
      
      private var gameUser:GameUser;
      
      private var bgMusic:GameSound;
      
      private var buyPopUp:WorldPopUp;
      
      private var prevItem:AvatarItem;
      
      private var itemButtons:Array = new Array();
      
      private var editUser:GameUser;
      
      private var view3d:View3D;
      
      public function WorldCustomiseAvatar(param1:GameUser, param2:GameUser)
      {
         super();
         this.editUser = param1;
         this.gameUser = param2;
         this.employeeOutfit = param1 != param2;
         if(employeeOutfit)
         {
            param1.employerUser = param2;
         }
         bgMusic = new GameSound("MusicEditor",GameSound.TYPE_MUSIC);
         init();
      }
      
      private function showBuyPopUp(param1:Object) : void
      {
         var _loc2_:MovieClip = Engine.getMovieClip("BuyAvatarUIAnim");
         if(param1.cash > 0)
         {
            _loc2_ = Engine.getMovieClip("BuyCashAvatarUIAnim");
         }
         else
         {
            _loc2_ = Engine.getMovieClip("BuyAvatarUIAnim");
         }
         var _loc3_:MovieClip = _loc2_.mc_content;
         if(param1.group.name == "HairColour")
         {
            GameWorld.textHandler.setReplaceString("ItemName","new hair colour");
         }
         else if(param1.group.name == "SkinColour")
         {
            GameWorld.textHandler.setReplaceString("ItemName","new skin colour");
         }
         else
         {
            GameWorld.textHandler.setReplaceString("ItemName",param1.name);
         }
         if(param1.cash > 0)
         {
            GameWorld.textHandler.setTextField(_loc3_.tf_text,GameWorld.textHandler.getTextFromId("BuyItem") + "\n" + param1.cash + " Playfish Cash",true);
         }
         else
         {
            GameWorld.textHandler.setTextField(_loc3_.tf_text,GameWorld.textHandler.getTextFromId("BuyItem") + "\n" + param1.cost + " Coins",true);
         }
         if(!GameWorld.isItemAffordable(param1))
         {
            _loc3_.mc_tick.stop();
            _loc3_.mc_tick.visible = false;
            setButtonMode(_loc3_.mc_addCoins,true);
            if(param1.cash > 0)
            {
               _loc3_.mc_addCoins.toolTip = new ToolTip(_loc3_.mc_addCoins,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughPlayfishCash"));
               _loc3_.mc_addCoins.addEventListener(MouseEvent.CLICK,onAddPlayfishCashClick,false,0,true);
            }
            else
            {
               _loc3_.mc_addCoins.toolTip = new ToolTip(_loc3_.mc_addCoins,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughCoins"));
               _loc3_.mc_addCoins.addEventListener(MouseEvent.CLICK,onAddMoneyClick,false,0,true);
            }
         }
         else if(!GameWorld.isItemLevelReached(param1))
         {
            setButtonMode(_loc3_.mc_tick,false);
            _loc3_.mc_tick.gotoAndStop("grey");
            GameWorld.textHandler.setReplaceString("level",param1.unlockLevel);
            _loc3_.mc_tick.toolTip = new ToolTip(_loc3_.mc_tick,GameWorld.textHandler.getTextFromId("UnlocksAtLevel"));
         }
         else
         {
            _loc3_.mc_addCoins.stop();
            _loc3_.mc_addCoins.visible = false;
            setButtonMode(_loc3_.mc_tick,true);
            _loc3_.mc_tick.addEventListener(MouseEvent.CLICK,onBuyClick,false,0,true);
         }
         setButtonMode(_loc3_.mc_cancel,true);
         _loc3_.mc_cancel.addEventListener(MouseEvent.CLICK,onBuyCancelClick,false,0,true);
         buyPopUp = new WorldPopUp(_loc2_,null,null,false);
         buyPopUp.x = 635;
         buyPopUp.y = scene.mc_ok.y - 17;
         buyPopUp.show();
      }
      
      public function onGiftCancel(param1:GameItemObject) : void
      {
         dragItem = param1;
         removeDragItem(false);
      }
      
      private function removeDragItem(param1:Boolean = true) : void
      {
         var _loc2_:InventoryUserItem = null;
         var _loc3_:GameObject = null;
         if(dragItem != null)
         {
            if(dragItem.owned)
            {
               _loc2_ = new InventoryUserItem(dragItem.itemConfig);
               _loc2_.serverUid = dragItem.serverUid;
               GameWorld.gameUser.addInventoryItem(_loc2_);
               itemChooser.refresh();
               if(param1 && dragItemMovieClip != null)
               {
                  _loc3_ = new GameObject("InventoryCrateAnim");
                  _loc3_.x = mouseX;
                  _loc3_.y = mouseY;
                  _loc3_.drawPriority = 1000;
                  _loc3_.numLoops = 1;
                  _loc3_.removeWhenComplete = true;
                  addObject(_loc3_);
               }
            }
            dragItem = null;
            removeDragItemMovieClip();
         }
      }
      
      public function mouseMoved(param1:MouseEvent) : void
      {
         if(avatarMouseDown)
         {
            avatar.model.yaw(prevMouseX - mouseX);
         }
         prevMouseX = mouseX;
         prevMouseY = mouseY;
      }
      
      public function init() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:Graphics = null;
         var _loc7_:Array = null;
         var _loc8_:MovieClip = null;
         itemDatabase = GameWorld.avatarItemDatabase;
         bgTop = new Shape();
         bgBottom = new Shape();
         addChild(bgTop);
         addChild(bgBottom);
         scene = Engine.getMovieClip("CustomiseAvatarUI");
         bg = Engine.getMovieClip("CustomiseAvatarBg");
         addChild(bg);
         addChild(scene);
         itemChooser = new ItemChooser(itemDatabase,GameWorld.gameUser,Engine.getMovieClip("AvatarItemChooserScene2"));
         itemChooser.drawPriority = 100;
         itemChooser.y = Engine.getStageBottom();
         itemChooser.selectedItems = gameUser.getAvatarItems(editUser.userInfo.id);
         itemChooser.addEventListener(ItemChooserEvent.EVENT_ITEM_MOUSE_DOWN,onDragItem);
         itemChooser.addEventListener(ItemChooserEvent.EVENT_ITEM_CLICK,onNewItem);
         itemChooser.addEventListener(MouseEvent.MOUSE_UP,onItemChooserMouseUp,false,0,true);
         itemChooser.giftButton.addEventListener(MouseEvent.MOUSE_UP,onGiftItem,false,0,true);
         itemChooser.sellButton.addEventListener(MouseEvent.MOUSE_UP,onSellItem,false,0,true);
         addObject(itemChooser);
         addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
         addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false,0,true);
         okButton = scene.mc_ok;
         setButtonMode(scene.rotateLeftButton,true);
         setButtonMode(scene.rotateRightButton,true);
         setButtonMode(scene.mc_ok,true);
         setHandCursor(scene.mc_ok,true);
         setButtonMode(scene.mc_default,true);
         scene.mc_ok.addEventListener(MouseEvent.CLICK,okButtonClicked);
         setButtonMode(scene.mc_photo,true);
         scene.mc_photo.addEventListener(MouseEvent.CLICK,onPhotoClick,false,0,true);
         scene.mc_photo.toolTip = new ToolTip(scene.mc_photo,GameWorld.textHandler.getTextFromId("ToolTipPhoto"));
         scene.mc_photo.mc_new.mouseEnabled = false;
         if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_PHOTO))
         {
            scene.mc_photo.mc_new.visible = false;
         }
         scene.mc_employee.stop();
         if(employeeOutfit)
         {
            itemChooser.disableGroups(["Hair","Eyes","Mouth","Eyebrows","FacialFeature","Beard"]);
            itemChooser.setGroup(itemDatabase.getGroup("Shirt"));
            scene.mc_default.tooltip = new ToolTip(scene.mc_default,GameWorld.textHandler.getTextFromId("ToolTipRemoveOutfit"));
            scene.mc_default.addEventListener(MouseEvent.CLICK,onDefaultButtonClick,false,0,true);
            _loc1_ = GameWorld.getUserFaceImage(editUser);
            if(_loc1_ != null)
            {
               scene.mc_employee.mc_frame.mc_face.addChild(_loc1_);
            }
            scene.mc_employee.tf_name.text = editUser.firstName;
            GameWorld.textHandler.setTextFieldWithId(scene.mc_employeeOutfitBanner.tf_employeeOutfit,"EmployeeOutfit");
         }
         else
         {
            itemChooser.setGroup(itemDatabase.getGroup("Eyes"));
            scene.mc_employeeOutfitBanner.visible = false;
            scene.mc_employee.visible = false;
            scene.mc_default.visible = false;
         }
         if(employeeOutfit)
         {
            scene.mc_skin.visible = false;
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(scene.mc_skin.tf_skinColour,"SkinColour");
            _loc2_ = GameWorld.avatarItemDatabase.getItems("SkinColour");
            _loc3_ = 0;
            while(_loc3_ < 16)
            {
               _loc4_ = scene.mc_skin["mc_skin" + _loc3_];
               if(_loc4_)
               {
                  if(_loc3_ < _loc2_.length)
                  {
                     _loc5_ = int(_loc2_[_loc3_].name);
                     _loc4_.mc_content.mc_colour.removeChildAt(0);
                     _loc4_.itemConfig = _loc2_[_loc3_];
                     _loc6_ = _loc4_.mc_content.mc_colour.graphics;
                     _loc6_.beginFill(_loc5_);
                     _loc6_.drawRect(-20,-20,40,40);
                     _loc6_.endFill();
                     skinButtons.push(_loc4_);
                  }
               }
               _loc3_++;
            }
            refreshSkinChooser();
         }
         if(employeeOutfit)
         {
            scene.mc_hair.visible = false;
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(scene.mc_hair.tf_hairColour,"HairColour");
            _loc7_ = GameWorld.avatarItemDatabase.getItems("HairColour");
            _loc3_ = 0;
            while(_loc3_ < 16)
            {
               _loc8_ = scene.mc_hair["mc_hair" + _loc3_];
               if(_loc8_)
               {
                  if(employeeOutfit)
                  {
                     _loc8_.visible = false;
                  }
                  else if(_loc3_ < _loc7_.length)
                  {
                     _loc5_ = int(_loc7_[_loc3_].name);
                     _loc8_.mc_content.mc_colour.removeChildAt(0);
                     _loc8_.itemConfig = _loc7_[_loc3_];
                     _loc6_ = _loc8_.mc_content.mc_colour.graphics;
                     _loc6_.beginFill(_loc5_);
                     _loc6_.drawRect(-20,-20,40,40);
                     _loc6_.endFill();
                     hairButtons.push(_loc8_);
                  }
               }
               _loc3_++;
            }
            refreshHairChooser();
         }
         view3d = GameWorld.view3d;
         view3d.visible = true;
         view3d.x = scene.avatarPanel.x + scene.avatarPanel.width / 2;
         view3d.y = scene.avatarPanel.y + 310;
         addChild(view3d);
         avatar = new Avatar3D(GameWorld.baseCustomiseAvatarModel);
         avatar.setAvatarItems(editUser.getAvatarItemsAsEmployee(),editUser.hairColour,editUser.skinColour);
         avatar.playAnimation(Avatar3D.ANIMATION_EDITOR_IDLE);
         view3d.scene.addChild(avatar.model);
         view3d.camera.position = new Number3D(0,12000,-30000);
         view3d.camera.lookAt(new Number3D(0,0,0));
         light = GameWorld.light;
         light.position = new Number3D(-100000,9000,-84000);
         view3d.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarMouseDown,false,0,true);
         view3d.buttonMode = true;
         addEventListener(MouseEvent.MOUSE_UP,onAvatarMouseUp,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,onAvatarMouseUp,false,0,true);
         addEventListener(MouseEvent.MOUSE_MOVE,mouseMoved,false,0,true);
         prevMouseX = mouseX;
         prevMouseY = mouseY;
         if(Debug.DEBUG)
         {
            debugTF = new TextField();
            debugTF.mouseEnabled = false;
            debugTF.text = getDebugText();
            debugTF.x = 0;
            debugTF.y = GameWorld.CANVAS_HEIGHT;
            debugTF.width = GameWorld.CANVAS_WIDTH;
            addChild(debugTF);
         }
         GameWorld.stopGlobalRpcs();
      }
      
      private function okButtonClicked(param1:MouseEvent) : void
      {
         shopTransactionHandler.addEventListener(RpcEvent.SUCCESS,onCommitSuccess,false,0,true);
         shopTransactionHandler.addEventListener(RpcEvent.FAIL,onCommitFail,false,0,true);
         if(shopTransactionHandler.hasChanges())
         {
            shopTransactionHandler.commit();
         }
         else
         {
            destroy();
            GameWorld.startGlobalRpcs();
            GameWorld.fadeToWorld(new WorldRestaurantPlay(GameWorld.gameUser,false));
         }
      }
      
      private function onPurchaseCashItemSuccess(param1:RpcEvent) : void
      {
         var _loc3_:WorldInfoPopUp = null;
         Debug.out("onPurchaseCashItemSuccess code=" + param1.successCode);
         var _loc2_:AvatarItem = AvatarItem(param1.currentTarget.item);
         if(param1.successCode == RpcClient.STATUS_OK || param1.successCode == RpcClient.PURCHASE_CASH_ITEM_EXISTS)
         {
            GameWorld.cashPanel.showPlayfishCashPopUp(-int(_loc2_.itemConfig.cash));
            itemChooser.refresh();
            GameWorld.addAwardValue(GameAwards.AWARD_BUY_AVATAR_ITEM,1);
            GameWorld.addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(_loc2_.itemConfig));
         }
         else
         {
            gameUser.removeUsedAvatarItem(_loc2_.serverUid);
            refreshAvatarChange(_loc2_.itemConfig.group.name);
            if(param1.successCode == RpcClient.STATUS_NOT_ENOUGH_CASH)
            {
               _loc3_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("NotEnoughPlayfishCashToBuyItem"));
               itemChooser.refresh();
            }
            else if(param1.successCode == RpcClient.STATUS_INVALID_TOKEN)
            {
               _loc3_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("ErrorBuyingPlayfishCashItem"));
            }
            else if(param1.successCode == RpcClient.STATUS_SHARD_OFFLINE)
            {
               _loc3_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("UserMaintenance"));
            }
            _loc3_.show();
         }
      }
      
      public function refreshHairChooser() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:Number = 0;
         while(_loc1_ < hairButtons.length)
         {
            _loc2_ = hairButtons[_loc1_];
            if(_loc2_.itemConfig.name == editUser.hairColour)
            {
               setButtonMode(_loc2_,false);
               _loc2_.gotoAndStop("selected");
               _loc2_.removeEventListener(MouseEvent.CLICK,onHairColourClicked);
            }
            else
            {
               setButtonMode(_loc2_,true);
               _loc2_.addEventListener(MouseEvent.CLICK,onHairColourClicked,false,0,true);
            }
            _loc1_++;
         }
      }
      
      public function onSkinColourClicked(param1:MouseEvent) : void
      {
         Debug.out("onSkinColourClicked");
         preAddNewItem(param1.currentTarget.itemConfig);
      }
      
      public function refreshSkinChooser() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:Number = 0;
         while(_loc1_ < skinButtons.length)
         {
            _loc2_ = skinButtons[_loc1_];
            if(_loc2_.itemConfig.name == editUser.skinColour)
            {
               setButtonMode(_loc2_,false);
               _loc2_.gotoAndStop("selected");
               _loc2_.removeEventListener(MouseEvent.CLICK,onSkinColourClicked);
            }
            else
            {
               setButtonMode(_loc2_,true);
               _loc2_.addEventListener(MouseEvent.CLICK,onSkinColourClicked,false,0,true);
            }
            _loc1_++;
         }
      }
      
      override public function hideNotify() : void
      {
         removeObject(GameWorld.cashPanel);
         bgMusic.stop();
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onStageFullScreen);
      }
      
      private function onCommitSuccess(param1:RpcEvent) : void
      {
         var _loc2_:RpcStoreImage = null;
         editUser.cacheAvatarFrame();
         GameWorld.hiredFriendsPanel.refreshUser(editUser);
         if(!employeeOutfit)
         {
            _loc2_ = new RpcStoreImage();
            _loc2_.commit();
         }
         editUser.clearAnimationFrames();
         destroy();
         GameWorld.startGlobalRpcs();
         GameWorld.fadeToWorld(new WorldRestaurantPlay(GameWorld.gameUser,false));
      }
      
      private function onCommitFail(param1:RpcEvent) : void
      {
      }
      
      public function onGiftBuyCancelTickClick(param1:MouseEvent) : void
      {
         dragItem = null;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(dragItem != null)
         {
            preAddNewItem(dragItem.itemConfig);
         }
      }
      
      private function onCashGiftBuySuccess(param1:int) : void
      {
         GameWorld.cashPanel.showPlayfishCashPopUp(-dragItem.itemConfig.cash);
         GameWorld.addAwardValue(GameAwards.AWARD_BUY_AVATAR_ITEM,1);
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
      
      public function onGiftBuyTickClick(param1:MouseEvent) : void
      {
         GameWorld.cashPanel.addCoins(-dragItem.itemConfig.cost);
         itemChooser.refresh();
         GameWorld.addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(dragItem.itemConfig));
         GameWorld.addAwardValue(GameAwards.AWARD_SPEND_COIN,dragItem.itemConfig.cost);
         GameWorld.addAwardValue(GameAwards.AWARD_BUY_AVATAR_ITEM,1);
         var _loc2_:InventoryUserItem = new InventoryUserItem(dragItem.itemConfig);
         shopTransactionHandler.addBoughtItem(_loc2_);
         dragItem.fromInventory = true;
         dragItem.owned = true;
         var _loc3_:WorldWriteMessage = new WorldWriteMessage(dragItem,null,null,onGiftCancel,onGiftSent);
         _loc3_.show();
         dragItem = null;
      }
      
      private function onGiftItem(param1:MouseEvent) : void
      {
         var _loc2_:WorldWriteMessage = null;
         var _loc3_:PurchaseCashItemConfirmPopUp = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:WorldPopUp = null;
         if(dragItem != null)
         {
            removeDragItemMovieClip();
            if(dragItem.owned)
            {
               _loc2_ = new WorldWriteMessage(dragItem,null,null,onGiftCancel,onGiftSent);
               _loc2_.show();
               dragItem = null;
            }
            else if(isItemFree(dragItem.itemConfig))
            {
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
                  GameWorld.textHandler.setReplaceString("ItemName",dragItem.itemConfig.name);
                  GameWorld.textHandler.setReplaceString("ItemSellPrice",dragItem.itemConfig.cost);
                  GameWorld.textHandler.setTextFieldWithId(_loc5_.tf_text,"BuyGiftItemWithCoins",true);
                  _loc5_.mc_count.visible = false;
                  _loc6_ = new WorldPopUp(_loc4_,_loc5_.mc_tick,_loc5_.mc_cancel);
                  _loc6_.show();
               }
            }
            param1.stopImmediatePropagation();
         }
      }
      
      private function isItemFree(param1:Object) : Boolean
      {
         return param1.cash == 0 && param1.cost == 0;
      }
      
      private function getDebugText() : String
      {
         return "specular: " + light.specular + " ambient: " + light.ambient + " diffuse: " + light.diffuse + " brightness: " + light.brightness + "\nx:" + light.x + " y:" + light.y + " z:" + light.z;
      }
      
      private function onDragItem(param1:ItemChooserEvent) : void
      {
         clickedItemConfig = param1.itemConfig;
      }
      
      private function onSellItem(param1:MouseEvent) : void
      {
         var _loc2_:UserItem = null;
         var _loc3_:WorldPopUp = null;
         if(dragItem)
         {
            if(dragItem.owned)
            {
               _loc2_ = dragItem.getUserItem();
               removeDragItem();
               _loc3_ = new WorldSellItemPopUp(_loc2_,onItemSellOK);
               _loc3_.show();
            }
            else
            {
               removeDragItem();
            }
            param1.stopImmediatePropagation();
         }
      }
      
      private function onBuyCancelClick(param1:MouseEvent) : void
      {
         Debug.out("onBuyCancelClick");
         gameUser.removeUsedAvatarItem(buyItem.serverUid);
         if(prevItem != null)
         {
            gameUser.addUsedAvatarItem(prevItem);
            refreshAvatarChange(prevItem.itemConfig.group.name);
         }
         else
         {
            refreshAvatarChange("");
         }
         buyItem = null;
         prevItem = null;
         buyPopUp.remove();
         buyPopUp = null;
         okButton.visible = true;
         scene.mc_photo.visible = true;
         if(employeeOutfit)
         {
            scene.mc_default.visible = true;
         }
      }
      
      private function onAddMoneyClick(param1:MouseEvent) : void
      {
         onBuyCancelClick(null);
         GameWorld.cashPanel.showAddCoinsPopUp();
      }
      
      private function onItemChooserMouseUp(param1:MouseEvent) : void
      {
         removeDragItem();
         param1.stopImmediatePropagation();
      }
      
      private function onStageFullScreen(param1:Event) : void
      {
         itemChooser.y = Engine.getStageBottom();
         bg.x = Engine.getStageX();
         bg.width = Engine.getStageWidth();
         refreshBgTop();
         refreshBgBottom();
      }
      
      override public function tick(param1:uint) : void
      {
         if(scene != null)
         {
            if(scene.rotateLeftButton.currentLabel == "down")
            {
               avatar.model.rotationY += 10;
            }
            else if(scene.rotateRightButton.currentLabel == "down")
            {
               avatar.model.rotationY -= 10;
            }
         }
         if(avatar != null)
         {
            avatar.tickAnimation(param1);
         }
         if(view3d != null)
         {
            view3d.clear();
            view3d.render();
         }
      }
      
      private function onBuyClick(param1:MouseEvent) : void
      {
         gameUser.removeUsedAvatarItem(buyItem.serverUid);
         if(prevItem != null)
         {
            gameUser.addUsedAvatarItem(prevItem);
         }
         addNewItem(buyItem.itemConfig);
         buyItem = null;
         prevItem = null;
         buyPopUp.remove();
         buyPopUp = null;
         okButton.visible = true;
         scene.mc_photo.visible = true;
         if(employeeOutfit)
         {
            scene.mc_default.visible = true;
         }
      }
      
      override public function showNotify() : void
      {
         addObject(GameWorld.cashPanel);
         bgMusic.play(-1);
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onStageFullScreen,false,0,true);
         onStageFullScreen(null);
      }
      
      private function playAnimationForNewItem(param1:String) : void
      {
         if(param1 == "Pants" || param1 == "Skirt")
         {
            avatar.playAnimation(Avatar3D.ANIMATION_EDITOR_PANTS_CHANGE,1);
         }
         else if(param1 == "Shirt")
         {
            avatar.playAnimation(Avatar3D.ANIMATION_EDITOR_OUTFIT_CHANGE,1);
         }
         else
         {
            avatar.playAnimation(Avatar3D.ANIMATION_EDITOR_HEAD_CHANGE,1);
         }
         avatar.queueAnimation(Avatar3D.ANIMATION_EDITOR_IDLE);
      }
      
      public function onAvatarMouseDown(param1:MouseEvent) : void
      {
         avatarMouseDown = true;
      }
      
      override public function keyDown(param1:int, param2:int) : void
      {
         if(Debug.DEBUG)
         {
            if(param2 == "1".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_IDLE);
            }
            else if(param2 == "2".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_WALK);
            }
            else if(param2 == "3".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_DEAD);
            }
            else if(param2 == "4".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_EDITOR_IDLE);
            }
            else if(param2 == "5".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_HIRE_BENCE);
            }
            else if(param2 == "6".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_HIRE_BUS);
            }
            else if(param2 == "7".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_HIRE_TRASHCAN);
            }
            else if(param2 == "8".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_CLEAN);
            }
            else if(param2 == "9".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_CLEANER_WALK);
            }
            else if(param2 == "0".charCodeAt(0))
            {
               avatar.playAnimation(Avatar3D.ANIMATION_CLEANER_REPAIR);
            }
            else if(param1 != Engine.KEY_SPACE)
            {
               if(param2 == "q".charCodeAt(0))
               {
                  light.specular += 0.1;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "a".charCodeAt(0))
               {
                  light.specular -= 0.1;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "w".charCodeAt(0))
               {
                  light.ambient += 0.1;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "s".charCodeAt(0))
               {
                  light.ambient -= 0.1;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "e".charCodeAt(0))
               {
                  light.diffuse += 0.1;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "d".charCodeAt(0))
               {
                  light.diffuse -= 0.1;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "r".charCodeAt(0))
               {
                  light.x += 100000;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "f".charCodeAt(0))
               {
                  light.x -= 100000;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "t".charCodeAt(0))
               {
                  light.y += 100000;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "g".charCodeAt(0))
               {
                  light.y -= 100000;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "y".charCodeAt(0))
               {
                  light.z += 100000;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "h".charCodeAt(0))
               {
                  light.z -= 100000;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "u".charCodeAt(0))
               {
                  light.brightness += 0.1;
                  debugTF.text = getDebugText();
               }
               else if(param2 == "j".charCodeAt(0))
               {
                  light.brightness -= 0.1;
                  debugTF.text = getDebugText();
               }
            }
         }
      }
      
      private function onDefaultButtonClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:AvatarItem = null;
         var _loc5_:Object = null;
         var _loc6_:InventoryUserItem = null;
         var _loc2_:Array = gameUser.getAvatarItems(editUser.userInfo.id);
         if(_loc2_.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_];
               _loc5_ = _loc4_.itemConfig;
               if(isItemFree(_loc5_) || _loc5_.group.name == "SkinColour" || _loc5_.group.name == "HairColour")
               {
                  shopTransactionHandler.addSoldItem(_loc4_,1,false);
               }
               else
               {
                  _loc6_ = new InventoryUserItem(_loc5_);
                  _loc6_.serverUid = _loc4_.serverUid;
                  gameUser.addInventoryItem(_loc6_);
                  shopTransactionHandler.addChangedItem(_loc6_,false);
               }
               gameUser.removeUsedAvatarItem(_loc4_.serverUid);
               _loc3_++;
            }
            avatar.setAvatarItems(editUser.getAvatarItemsAsEmployee(),editUser.hairColour,editUser.skinColour);
            itemChooser.selectedItems = new Array();
            itemChooser.refresh();
         }
      }
      
      private function refreshBgTop() : void
      {
         bgTop.graphics.clear();
         var _loc1_:Number = -Engine.getStageY();
         if(_loc1_ > 0)
         {
            bgTop.graphics.beginFill(BG_COLOUR_TOP);
            bgTop.graphics.drawRect(Engine.getStageX(),Engine.getStageY(),Engine.getStageWidth(),_loc1_);
            bgTop.graphics.endFill();
         }
      }
      
      private function getAvatarItemFromUser(param1:Object) : AvatarItem
      {
         var _loc2_:Array = gameUser.getAvatarItems(editUser.userInfo.id);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].itemConfig.id == param1.id)
            {
               return _loc2_[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      private function onCashGiftBuyCancel(param1:int) : void
      {
         dragItem = null;
      }
      
      private function onPhotoClick(param1:MouseEvent) : void
      {
         scene.mc_photo.mc_new.visible = false;
         var _loc2_:BitmapData = GameWorld.convertToBitmapData(view3d,1,new Rectangle(-80,-310,160,320),WorldPhotoPreviewPopUp.MAX_PHOTO_WIDTH,WorldPhotoPreviewPopUp.MAX_PHOTO_HEIGHT);
         var _loc3_:WorldPhotoPreviewPopUp = new WorldPhotoPreviewPopUp([_loc2_]);
         _loc3_.x = GameWorld.CANVAS_CENTER_X;
         _loc3_.y = GameWorld.CANVAS_CENTER_Y;
         _loc3_.show();
      }
      
      private function refreshBgBottom() : void
      {
         bgBottom.graphics.clear();
         var _loc1_:Number = Engine.getStageBottom() - GameWorld.CANVAS_HEIGHT;
         if(_loc1_ > 0)
         {
            bgBottom.graphics.beginFill(BG_COLOUR_BOTTOM);
            bgBottom.graphics.drawRect(Engine.getStageX(),GameWorld.CANVAS_HEIGHT,Engine.getStageWidth(),_loc1_);
            bgBottom.graphics.endFill();
         }
      }
      
      private function removeDragItemMovieClip() : void
      {
         if(dragItemMovieClip != null)
         {
            dragItemMovieClip.stopDrag();
            removeChild(dragItemMovieClip);
            dragItemMovieClip = null;
         }
      }
      
      private function onAddPlayfishCashClick(param1:MouseEvent) : void
      {
         onBuyCancelClick(null);
         GameWorld.cashPanel.showAddPlayfishCashPopUp();
      }
      
      public function onHairColourClicked(param1:MouseEvent) : void
      {
         Debug.out("onHairColourClicked");
         preAddNewItem(param1.currentTarget.itemConfig);
      }
      
      private function getItemWithGroup(param1:Array, param2:String) : AvatarItem
      {
         var _loc4_:AvatarItem = null;
         var _loc5_:Object = null;
         var _loc3_:Number = param1.length - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = _loc4_.itemConfig;
            if(_loc5_.group.name == param2 || _loc5_.group.parent == param2)
            {
               return _loc4_;
            }
            _loc3_--;
         }
         return null;
      }
      
      private function refreshAvatarChange(param1:String) : void
      {
         avatar.avatarItems = editUser.getAvatarItemsAsEmployee();
         avatar.refreshObjects();
         if(param1 == "SkinColour")
         {
            avatar.setSkinColour(gameUser.skinColour);
            refreshSkinChooser();
         }
         else if(param1 == "HairColour")
         {
            avatar.setHairColour(gameUser.hairColour);
            refreshHairChooser();
         }
         else
         {
            avatar.updateTextureMaterial();
            itemChooser.selectedItems = gameUser.getAvatarItems(editUser.userInfo.id);
            itemChooser.refresh();
         }
      }
      
      private function onItemSellOK(param1:UserItem, param2:int) : void
      {
         GameWorld.cashPanel.addCoins(GameWorld.getItemSellPrice(param1.itemConfig) * param2);
         GameWorld.addGourmetPoints(GameWorld.GOURMET_POINTS_SELL_ITEM * param2);
         shopTransactionHandler.addSoldItem(param1,1,true);
         gameUser.removeInventoryItemWithId(param1.itemConfig.id,param2);
         itemChooser.refresh();
      }
      
      public function onAvatarMouseUp(param1:MouseEvent) : void
      {
         avatarMouseDown = false;
      }
      
      private function addNewItem(param1:Object) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc6_:AvatarItem = null;
         var _loc7_:AvatarItem = null;
         var _loc8_:Object = null;
         var _loc9_:InventoryUserItem = null;
         var _loc10_:WorldLoadingPopUp = null;
         var _loc11_:RpcRequestManager = null;
         var _loc12_:RpcPurchaseCashItem = null;
         var _loc2_:InventoryUserItem = gameUser.getInventoryItem(param1);
         if(GameWorld.isItemAffordable(param1) && GameWorld.isItemLevelReached(param1) || Boolean(_loc2_))
         {
            _loc3_ = param1.group.name;
            if(param1.group.parent)
            {
               _loc3_ = param1.group.parent;
            }
            _loc4_ = gameUser.getAvatarItems(editUser.userInfo.id);
            _loc5_ = int(_loc4_.length - 1);
            while(_loc5_ >= 0)
            {
               _loc7_ = _loc4_[_loc5_];
               _loc8_ = _loc7_.itemConfig;
               if(_loc7_.groupName == _loc3_)
               {
                  if(isItemFree(_loc8_) || _loc8_.group.name == "SkinColour" || _loc8_.group.name == "HairColour")
                  {
                     shopTransactionHandler.addSoldItem(_loc7_,1,false);
                  }
                  else
                  {
                     _loc9_ = new InventoryUserItem(_loc8_);
                     _loc9_.serverUid = _loc7_.serverUid;
                     gameUser.addInventoryItem(_loc9_);
                     shopTransactionHandler.addChangedItem(_loc9_,false);
                  }
                  gameUser.removeUsedAvatarItem(_loc7_.serverUid);
               }
               _loc5_--;
            }
            _loc6_ = new AvatarItem(param1);
            if(gameUser != editUser)
            {
               _loc6_.employeeId = editUser.userInfo.id;
            }
            gameUser.addUsedAvatarItem(_loc6_);
            if(_loc2_ == null)
            {
               if(param1.cash > 0)
               {
                  _loc10_ = new WorldLoadingPopUp("Purchasing...",WorldLoadingPopUp.PURCHASE_CASH_ITEM);
                  _loc10_.x = GameWorld.CANVAS_CENTER_X;
                  _loc10_.y = GameWorld.CANVAS_CENTER_Y;
                  _loc11_ = new RpcRequestManager();
                  _loc11_.loadingPopUp = _loc10_;
                  _loc11_.retryText = GameWorld.textHandler.getTextFromId("PurchaseCashItemRetryText");
                  _loc12_ = _loc11_.purchaseCashItem(_loc6_);
                  _loc12_.addEventListener(RpcEvent.SUCCESS,onPurchaseCashItemSuccess,false,0,true);
                  _loc11_.commit();
               }
               else
               {
                  if(param1.cost > 0)
                  {
                     GameWorld.cashPanel.addCoins(-int(param1.cost));
                     GameWorld.addAwardValue(GameAwards.AWARD_SPEND_COIN,param1.cost);
                     GameWorld.addAwardValue(GameAwards.AWARD_BUY_AVATAR_ITEM,1);
                     GameWorld.addGourmetPoints(GameWorld.getPurchaseItemGourmetPoint(param1));
                  }
                  shopTransactionHandler.addBoughtItem(_loc6_);
               }
            }
            else
            {
               gameUser.removeInventoryItem(_loc2_);
               _loc6_.serverUid = _loc2_.serverUid;
               shopTransactionHandler.addChangedItem(_loc6_,true);
            }
            refreshAvatarChange(_loc3_);
            return true;
         }
         return false;
      }
      
      private function onNewItem(param1:ItemChooserEvent) : void
      {
         preAddNewItem(param1.itemConfig);
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:InventoryUserItem = null;
         if(clickedItemConfig)
         {
            dragItem = new GameItemObject(clickedItemConfig,new UserItem(clickedItemConfig));
            clickedItemConfig = null;
            _loc2_ = GameWorld.gameUser.getInventoryItem(dragItem.itemConfig);
            if(_loc2_)
            {
               GameWorld.gameUser.removeInventoryItem(_loc2_);
               dragItem.owned = true;
               dragItem.fromInventory = true;
               dragItem.serverUid = _loc2_.serverUid;
               itemChooser.refresh();
            }
         }
         if(dragItem != null)
         {
            if(dragItemMovieClip == null)
            {
               dragItemMovieClip = ItemChooser.getItemMovieClip(dragItem.itemConfig);
               if(dragItemMovieClip != null)
               {
                  dragItemMovieClip.mouseEnabled = false;
                  dragItemMovieClip.x += mouseX;
                  dragItemMovieClip.y += mouseY;
                  dragItemMovieClip.startDrag();
                  addChild(dragItemMovieClip);
               }
            }
         }
      }
      
      override public function destroy() : void
      {
         view3d.scene.removeChild(avatar.model);
         if(view3d.parent == this)
         {
            removeChild(view3d);
            view3d = null;
         }
      }
      
      private function preAddNewItem(param1:Object) : void
      {
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc6_:AvatarItem = null;
         var _loc7_:Object = null;
         clickedItemConfig = null;
         if(getAvatarItemFromUser(param1) != null)
         {
            removeDragItem(true);
            return;
         }
         removeDragItem(false);
         if(buyPopUp != null)
         {
            if(prevItem != null && param1.id == prevItem.itemConfig.id)
            {
               onBuyCancelClick(null);
               return;
            }
            onBuyCancelClick(null);
         }
         var _loc2_:String = param1.group.name;
         if(param1.group.parent)
         {
            _loc2_ = param1.group.parent;
         }
         var _loc3_:InventoryUserItem = gameUser.getInventoryItem(param1);
         if(!isItemFree(param1) && _loc3_ == null)
         {
            _loc4_ = gameUser.getAvatarItems(editUser.userInfo.id);
            _loc5_ = int(_loc4_.length - 1);
            while(_loc5_ >= 0)
            {
               _loc6_ = _loc4_[_loc5_];
               _loc7_ = _loc6_.itemConfig;
               if(_loc6_.groupName == _loc2_)
               {
                  gameUser.removeUsedAvatarItem(_loc6_.serverUid);
                  prevItem = _loc6_;
                  break;
               }
               _loc5_--;
            }
            buyItem = new AvatarItem(param1);
            if(employeeOutfit)
            {
               buyItem.employeeId = editUser.userInfo.id;
            }
            gameUser.addUsedAvatarItem(buyItem);
            refreshAvatarChange(_loc2_);
            playAnimationForNewItem(_loc2_);
            showBuyPopUp(param1);
            okButton.visible = false;
            scene.mc_photo.visible = false;
            if(employeeOutfit)
            {
               scene.mc_default.visible = false;
            }
         }
         else
         {
            addNewItem(param1);
            playAnimationForNewItem(_loc2_);
         }
      }
      
      public function onGiftSent(param1:GameItemObject) : void
      {
      }
   }
}


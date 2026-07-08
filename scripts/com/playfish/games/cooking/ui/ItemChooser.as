package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.debug.DebugShowAllShopItems;
   import com.playfish.games.cooking.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Rectangle;
   import flash.text.*;
   import flash.utils.getQualifiedClassName;
   
   public class ItemChooser extends BaseObject
   {
      
      private static const ICON_WIDTH:int = 65;
      
      private static const ICON_HEIGHT:int = 65;
      
      private static const GREY_FILTER_MATRIX:Array = [0.3,0.3,0.3,0,70,0.3,0.3,0.3,0,70,0.3,0.3,0.3,0,70,0,0,0,1,0];
      
      public static const TAB_NEW:int = 0;
      
      public static const TAB_SHOP:int = 1;
      
      public static const TAB_OWN:int = 2;
      
      public static const TAB_CASH:int = 3;
      
      public static var currentBuildingTileClassName:String;
      
      public var giftButton:MovieClip;
      
      private var groupButtons:Array;
      
      private var scene:MovieClip;
      
      public var leftButton:MovieClip;
      
      private var curGroup:Object;
      
      public var sellButton:MovieClip;
      
      public var tabButtons:Array;
      
      private var curGroupButton:MovieClip;
      
      private var curTab:int = -1;
      
      public var enableDragInstructionToolTip:Boolean;
      
      private var curGroupItemConfigs:Array;
      
      private var dragInstructionToolTip:ToolTip;
      
      private var gameUser:GameUser;
      
      private var itemDescriptionTextField:TextField;
      
      public var selectedItems:Array;
      
      private var itemsPerPage:int = 0;
      
      public var rightButton:MovieClip;
      
      private var curPage:int = 0;
      
      private var itemButtons:Array;
      
      public function ItemChooser(param1:ItemDatabase, param2:GameUser, param3:MovieClip, param4:TextField = null)
      {
         var _loc6_:MovieClip = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:MovieClip = null;
         tabButtons = new Array();
         groupButtons = new Array();
         itemButtons = new Array();
         super();
         this.scene = param3;
         this.gameUser = param2;
         if(!param3.parent)
         {
            addChild(param3);
         }
         this.itemDescriptionTextField = param4;
         if(param4)
         {
            param4.text = "";
         }
         var _loc5_:Number = 0;
         while(_loc5_ < param1.itemGroups.length)
         {
            _loc7_ = param1.itemGroups[_loc5_].buttonName;
            _loc8_ = param1.itemGroups[_loc5_].name;
            if(_loc7_ == null)
            {
               _loc7_ = _loc8_;
            }
            _loc9_ = param3["tab" + _loc7_];
            if(_loc9_ != null)
            {
               groupButtons.push(_loc9_);
               setButtonMode(_loc9_,true);
               _loc9_.group = param1.itemGroups[_loc5_];
               _loc9_.addEventListener(MouseEvent.CLICK,groupButtonClicked,false,0,true);
               _loc9_.tooltip = new ToolTip(_loc9_,_loc8_);
               _loc9_.groupName = _loc7_;
            }
            _loc5_++;
         }
         if(param3.mc_tabNew)
         {
            tabButtons[TAB_NEW] = param3.mc_tabNew;
            tabButtons[TAB_NEW].tooltip = new ToolTip(tabButtons[TAB_NEW],GameWorld.textHandler.getTextFromId("ToolTipNewThisWeek"));
            tabButtons[TAB_SHOP] = param3.mc_tabShop;
            tabButtons[TAB_SHOP].tooltip = new ToolTip(tabButtons[TAB_SHOP],GameWorld.textHandler.getTextFromId("ToolTipShop"));
            tabButtons[TAB_OWN] = param3.mc_tabOwn;
            tabButtons[TAB_OWN].tooltip = new ToolTip(tabButtons[TAB_OWN],GameWorld.textHandler.getTextFromId("ToolTipYourItems"));
            tabButtons[TAB_CASH] = param3.mc_tabCash;
            tabButtons[TAB_CASH].tooltip = new ToolTip(tabButtons[TAB_CASH],GameWorld.textHandler.getTextFromId("ToolTipCashShop"));
            _loc5_ = 0;
            while(_loc5_ < tabButtons.length)
            {
               tabButtons[_loc5_].index = _loc5_;
               setButtonMode(tabButtons[_loc5_],true);
               tabButtons[_loc5_].addEventListener(MouseEvent.CLICK,onTabClick,false,0,true);
               _loc5_++;
            }
            setTab(TAB_SHOP);
         }
         else
         {
            setTab(TAB_SHOP);
         }
         while(true)
         {
            _loc6_ = param3["mc_item" + itemsPerPage];
            if(!_loc6_)
            {
               break;
            }
            if(_loc6_)
            {
               itemButtons.push(_loc6_);
               _loc6_.stop();
            }
            ++itemsPerPage;
         }
         leftButton = param3.mc_left;
         rightButton = param3.mc_right;
         if(param3.mc_left)
         {
            setButtonMode(param3.mc_left,true);
            leftButton.addEventListener(MouseEvent.MOUSE_DOWN,onLeft1MouseDown,false,0,true);
         }
         if(param3.mc_right)
         {
            setButtonMode(param3.mc_right,true);
            rightButton.addEventListener(MouseEvent.MOUSE_DOWN,onRight1MouseDown,false,0,true);
         }
         if(param3.mc_gift)
         {
            giftButton = param3.mc_gift;
            setButtonMode(giftButton,true);
            param3.mc_gift.toolTip = new ToolTip(param3.mc_gift,GameWorld.textHandler.getTextFromId("ToolTipGiftFriend"));
            param3.mc_gift.addEventListener(MouseEvent.CLICK,onGiftClick,false,0,true);
         }
         if(param3.mc_sell)
         {
            sellButton = param3.mc_sell;
            setButtonMode(sellButton,true);
            param3.mc_sell.toolTip = new ToolTip(param3.mc_sell,GameWorld.textHandler.getTextFromId("ToolTipSellAnItem"));
            param3.mc_sell.addEventListener(MouseEvent.CLICK,onSellClick,false,0,true);
         }
      }
      
      public static function setItemOnIconButton(param1:Object, param2:MovieClip) : void
      {
         var _loc4_:MovieClip = null;
         param2.stop();
         var _loc3_:MovieClip = getItemMovieClip(param1);
         if(_loc3_)
         {
            param2.image = _loc3_;
            param2.addChild(_loc3_);
            _loc4_ = Engine.getMovieClip(getQualifiedClassName(param2));
            _loc4_.stop();
            _loc3_.mask = _loc4_;
            param2.addChild(_loc4_);
         }
      }
      
      public static function getItemMovieClip(param1:Object, param2:Number = 65, param3:Number = 65) : MovieClip
      {
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Rectangle = null;
         var _loc8_:MovieClip = null;
         var _loc9_:Rectangle = null;
         var _loc10_:int = 0;
         var _loc11_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(param1.iconName)
         {
            _loc4_ = Engine.getMovieClip(param1.iconName);
            _loc5_ = _loc4_["mc_texture"];
            if(_loc5_)
            {
               _loc6_ = Engine.getMovieClip(param1.className);
               _loc7_ = _loc6_.getBounds(null);
               _loc6_.width = _loc5_.width;
               _loc6_.height = _loc5_.height;
               _loc6_.x = -_loc6_.width / 2;
               _loc6_.y = -_loc6_.height / 2;
               _loc5_.addChild(_loc6_);
            }
         }
         else if(param1.className)
         {
            if(Boolean(param1.group) && param1.group.name == "Body")
            {
               _loc4_ = getBodyItemMovieClip(param1);
            }
            else
            {
               _loc4_ = Engine.getMovieClip(param1.className);
            }
         }
         else if(param1.texture)
         {
            _loc4_ = Engine.getMovieClip(param1.texture);
         }
         if(_loc4_)
         {
            if(GameWorld.getItemType(param1.id) == GameUser.ITEM_TYPE_RESTAURANT)
            {
               _loc4_.stop();
               _loc10_ = 0;
               while(true)
               {
                  _loc11_ = _loc4_["sub" + _loc10_];
                  if(!_loc11_)
                  {
                     break;
                  }
                  _loc11_.stop();
                  _loc10_++;
               }
            }
            _loc4_.mouseEnabled = false;
            _loc4_.mouseChildren = false;
            _loc8_ = _loc4_["mc_rect"];
            if(_loc8_)
            {
               if(Boolean(param1.group) && param1.group.name == "Body" && _loc8_.parent == _loc4_)
               {
                  _loc4_.removeChild(_loc8_);
               }
               else
               {
                  _loc8_.visible = false;
               }
            }
            if(_loc4_["mc_mask"] != null)
            {
               _loc4_["mc_mask"].visible = false;
            }
            _loc9_ = GameWorld.getVisibleBound(_loc4_);
            if(_loc9_.width > _loc9_.height)
            {
               _loc4_.scaleX = param2 / _loc9_.width;
               _loc4_.scaleY = _loc4_.scaleX;
            }
            else
            {
               _loc4_.scaleY = param3 / _loc9_.height;
               _loc4_.scaleX = _loc4_.scaleY;
            }
            _loc4_.x = _loc4_.x - _loc9_.left * _loc4_.scaleX - _loc9_.width * _loc4_.scaleX / 2;
            _loc4_.y = _loc4_.y - _loc9_.top * _loc4_.scaleY - _loc9_.height * _loc4_.scaleY / 2;
         }
         return _loc4_;
      }
      
      private static function getBodyItemMovieClip(param1:Object) : MovieClip
      {
         var _loc6_:Sprite = null;
         var _loc7_:MovieClip = null;
         var _loc2_:MovieClip = Engine.getMovieClip(param1.className);
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:MovieClip = _loc2_["mc_rect"];
         if(_loc3_)
         {
            if(_loc3_.parent == _loc2_)
            {
               _loc2_.removeChild(_loc3_);
            }
            else
            {
               _loc3_.visible = false;
            }
         }
         var _loc4_:MovieClip = Engine.getMovieClip(getCurrentBuildingTileClassName());
         if(!_loc4_)
         {
            return _loc2_;
         }
         var _loc5_:Rectangle = _loc2_.getBounds(null);
         _loc6_ = new Sprite();
         _loc7_ = new MovieClip();
         _loc7_.tileBitmapData = new BitmapData(Math.max(1,_loc4_.width),Math.max(1,_loc4_.height),true,0);
         _loc7_.tileBitmapData.draw(_loc4_);
         _loc6_.graphics.beginBitmapFill(_loc7_.tileBitmapData,null,true,false);
         _loc6_.graphics.drawRect(_loc5_.left,_loc5_.top,_loc5_.width,_loc5_.height);
         _loc6_.graphics.endFill();
         _loc6_.mask = _loc2_;
         _loc7_.addChild(_loc6_);
         _loc7_.addChild(_loc2_);
         return _loc7_;
      }
      
      private static function getCurrentBuildingTileClassName() : String
      {
         var _loc2_:UserItem = null;
         var _loc1_:int = 0;
         if(currentBuildingTileClassName)
         {
            return currentBuildingTileClassName;
         }
         if(GameWorld.gameUser)
         {
            while(_loc1_ < GameWorld.gameUser.usedBuildingItems.length)
            {
               _loc2_ = GameWorld.gameUser.usedBuildingItems[_loc1_];
               if(Boolean(_loc2_.itemConfig) && Boolean(_loc2_.itemConfig.group) && _loc2_.itemConfig.group.name == "Tile")
               {
                  return _loc2_.itemConfig.className;
               }
               _loc1_++;
            }
         }
         return "Tile09";
      }
      
      private function compareShopItems(param1:Object, param2:Object) : int
      {
         if(param1.cost == 0 && param1.cash == 0)
         {
            if(param2.cost == 0 && param2.cash == 0)
            {
               return 0;
            }
            return -1;
         }
         if(param1.isLimited)
         {
            if(!param2.isLimited)
            {
               return -1;
            }
         }
         else if(param1.isNew)
         {
            if(param2.isLimited)
            {
               return 1;
            }
            if(!param2.isNew)
            {
               return -1;
            }
         }
         else if(Boolean(param2.isLimited) || Boolean(param2.isNew))
         {
            return 1;
         }
         var _loc3_:int = int(param1.cost);
         var _loc4_:int = int(param2.cost);
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         _loc3_ = int(param1.cash);
         _loc4_ = int(param2.cash);
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      private function getGroupButton(param1:Object) : MovieClip
      {
         var _loc2_:int = 0;
         while(_loc2_ < groupButtons.length)
         {
            if(groupButtons[_loc2_].group == param1)
            {
               return groupButtons[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function onIconRollOver(param1:MouseEvent) : void
      {
         GameWorld.textHandler.setTextField(itemDescriptionTextField,param1.currentTarget.itemConfig.text);
      }
      
      private function onItemButtonClick(param1:MouseEvent) : void
      {
         var _loc3_:ItemChooserEvent = null;
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         if(hasEventListener(ItemChooserEvent.EVENT_ITEM_CLICK))
         {
            _loc3_ = new ItemChooserEvent(ItemChooserEvent.EVENT_ITEM_CLICK);
            _loc3_.itemConfig = _loc2_.itemConfig;
            dispatchEvent(_loc3_);
         }
         if(enableDragInstructionToolTip)
         {
            if(dragInstructionToolTip)
            {
               dragInstructionToolTip.remove();
            }
            dragInstructionToolTip = new ToolTip(_loc2_,GameWorld.textHandler.getTextFromId("ToolTipDragItemIntoGame"),false,false,false);
            dragInstructionToolTip.show();
            if(_loc2_.tooltip)
            {
               _loc2_.tooltip.remove();
            }
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,onDragInstructionToolTipRemove,false,0,true);
         }
         param1.stopImmediatePropagation();
      }
      
      private function onInfoClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldItemInfoPopUp = new WorldItemInfoPopUp(param1.currentTarget.itemConfig,null);
         _loc2_.show();
         param1.stopImmediatePropagation();
      }
      
      private function isItemSelected(param1:Object) : Boolean
      {
         var _loc2_:Number = NaN;
         if(selectedItems)
         {
            _loc2_ = 0;
            while(_loc2_ < selectedItems.length)
            {
               if(selectedItems[_loc2_].itemConfig.id == param1.id)
               {
                  return true;
               }
               _loc2_++;
            }
         }
         return false;
      }
      
      private function onGiftClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldInfoPopUp = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("GiftItemInstruction"));
         _loc2_.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.y = GameWorld.CANVAS_CENTER_Y;
         _loc2_.show();
      }
      
      private function getItemConfigsInGroup(param1:Object) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:Array = new Array();
         if(param1 != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.items.length)
            {
               _loc4_ = param1.items[_loc3_];
               if(Debug.DEBUG && DebugShowAllShopItems.on)
               {
                  _loc2_.push(_loc4_);
               }
               else if(curTab == TAB_OWN)
               {
                  if(gameUser.getInventoryItemCount(_loc4_) > 0)
                  {
                     _loc2_.push(_loc4_);
                  }
               }
               else if(!_loc4_.invisible || gameUser.getInventoryItemCount(_loc4_) > 0)
               {
                  if(curTab == TAB_NEW)
                  {
                     if(Boolean(_loc4_.isNew) || Boolean(_loc4_.isLimited))
                     {
                        _loc2_.push(_loc4_);
                     }
                  }
                  else if(curTab == TAB_SHOP)
                  {
                     _loc2_.push(_loc4_);
                  }
                  else if(curTab == TAB_CASH)
                  {
                     if(_loc4_.cash > 0)
                     {
                        _loc2_.push(_loc4_);
                     }
                  }
               }
               _loc3_++;
            }
            _loc2_.sort(compareShopItems);
         }
         return _loc2_;
      }
      
      private function onSellClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldInfoPopUp = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("SellItemInstruction"));
         _loc2_.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.y = GameWorld.CANVAS_CENTER_Y;
         _loc2_.show();
      }
      
      private function onLeft1MouseDown(param1:MouseEvent) : void
      {
         setGroup(curGroup,Math.max(curPage - 1,0));
      }
      
      public function setGroup(param1:Object, param2:int = 0, param3:Boolean = true) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:int = 0;
         var _loc9_:MovieClip = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         if(groupButtons.length > 0)
         {
            _loc5_ = getGroupButton(param1);
            if(param3 && (!_loc5_ || _loc5_.groupItems.length == 0))
            {
               param1 = null;
               _loc5_ = null;
               _loc6_ = 0;
               while(_loc6_ < groupButtons.length)
               {
                  if(groupButtons[_loc6_].groupItems.length > 0)
                  {
                     _loc5_ = groupButtons[_loc6_];
                     param1 = _loc5_.group;
                     break;
                  }
                  _loc6_++;
               }
            }
         }
         if(curGroupButton)
         {
            if(curGroupButton.groupItems.length == 0)
            {
               setButtonMode(curGroupButton,false);
            }
            else
            {
               setButtonMode(curGroupButton,true);
               curGroupButton.addEventListener(MouseEvent.CLICK,groupButtonClicked,false,0,true);
            }
         }
         if(_loc5_)
         {
            setButtonMode(_loc5_,false);
            _loc5_.removeEventListener(MouseEvent.CLICK,groupButtonClicked);
            _loc5_.gotoAndStop("selected");
         }
         curGroupButton = _loc5_;
         curGroup = param1;
         curPage = param2;
         _loc6_ = 0;
         while(_loc6_ < itemButtons.length)
         {
            _loc7_ = itemButtons[_loc6_];
            _loc7_.removeEventListener(MouseEvent.MOUSE_DOWN,onItemButtonMouseDown);
            _loc7_.removeEventListener(MouseEvent.CLICK,onItemButtonClick);
            if(_loc7_.mc_base.image)
            {
               _loc7_.mc_base.removeChild(itemButtons[_loc6_].mc_base.image);
               _loc7_.mc_base.image = null;
            }
            if(_loc7_.tooltip)
            {
               _loc7_.tooltip.destroy();
               _loc7_.tooltip = null;
            }
            _loc7_.mc_info.removeEventListener(MouseEvent.CLICK,onInfoClick);
            _loc7_.mc_info.removeEventListener(MouseEvent.MOUSE_DOWN,onInfoMouseDown);
            setButtonMode(_loc7_.mc_info,false);
            _loc7_.mc_info.itemConfig = null;
            _loc6_++;
         }
         curGroupItemConfigs = getItemConfigsInGroup(param1);
         var _loc4_:int = param2 * itemsPerPage;
         _loc6_ = 0;
         while(_loc6_ < itemButtons.length)
         {
            _loc8_ = _loc6_ + _loc4_;
            if(_loc8_ < curGroupItemConfigs.length)
            {
               _loc9_ = itemButtons[_loc6_];
               _loc10_ = curGroupItemConfigs[_loc8_];
               _loc11_ = gameUser.getInventoryItemCount(_loc10_);
               if(_loc11_ > 0)
               {
                  _loc9_.tf_count.text = _loc11_;
                  _loc9_.tf_count.visible = true;
                  _loc9_.mc_crate.visible = true;
               }
               else
               {
                  _loc9_.tf_count.text = "";
                  _loc9_.tf_count.visible = false;
                  _loc9_.mc_crate.visible = false;
               }
               _loc9_.tf_count.mouseEnabled = false;
               _loc9_.tf_count.autoSize = TextFieldAutoSize.LEFT;
               _loc9_.mc_wear.visible = false;
               _loc9_.mc_info.stop();
               if(_loc10_.infoText)
               {
                  _loc9_.mc_info.addEventListener(MouseEvent.CLICK,onInfoClick,false,0,true);
                  _loc9_.mc_info.addEventListener(MouseEvent.MOUSE_DOWN,onInfoMouseDown,false,0,true);
                  setButtonMode(_loc9_.mc_info,true);
                  _loc9_.mc_info.visible = true;
                  _loc9_.mc_info.itemConfig = _loc10_;
               }
               else
               {
                  _loc9_.mc_info.visible = false;
               }
               if(Boolean(selectedItems) && isItemSelected(_loc10_))
               {
                  setButtonMode(_loc9_,false);
                  _loc9_.mc_wear.visible = true;
                  _loc9_.mc_base.gotoAndStop("grey");
               }
               if(_loc10_.cash > 0)
               {
                  _loc9_.mc_pfCash.visible = true;
                  _loc9_.tf_cost.visible = false;
                  _loc9_.tf_cash.visible = true;
                  _loc9_.tf_cash.text = _loc10_.cash;
               }
               else
               {
                  _loc9_.tf_cost.visible = true;
                  _loc9_.tf_cash.visible = false;
                  _loc9_.mc_pfCash.visible = false;
                  if(_loc10_.cost == 0)
                  {
                     GameWorld.textHandler.setTextFieldWithId(_loc9_.tf_cost,"ItemCostFree");
                  }
                  else
                  {
                     _loc9_.tf_cost.text = _loc10_.cost;
                  }
               }
               _loc9_.addEventListener(MouseEvent.MOUSE_DOWN,onItemButtonMouseDown,false,0,true);
               _loc9_.addEventListener(MouseEvent.CLICK,onItemButtonClick,false,0,true);
               setButtonMode(_loc9_,true);
               if(GameWorld.isItemAffordable(_loc10_) && GameWorld.isItemLevelReached(_loc10_) || _loc11_ > 0)
               {
                  _loc9_.mc_base.gotoAndStop("grey");
               }
               else
               {
                  _loc9_.mc_base.gotoAndStop("red");
               }
               _loc9_.tf_limited.mouseEnabled = false;
               if(!_loc10_.isLimited)
               {
                  _loc9_.tf_limited.visible = false;
               }
               else
               {
                  _loc9_.tf_limited.visible = true;
               }
               _loc9_.tf_new.mouseEnabled = false;
               if(!_loc10_.isNew)
               {
                  _loc9_.tf_new.visible = false;
               }
               else
               {
                  _loc9_.tf_new.visible = true;
               }
               if(!GameWorld.isItemLevelReached(_loc10_))
               {
                  _loc9_.mc_level.visible = true;
                  _loc9_.mc_level.tf_level.mouseEnabled = false;
                  _loc9_.mc_level.tf_level.text = _loc10_.unlockLevel;
                  GameWorld.textHandler.setReplaceString("level",_loc10_.unlockLevel);
                  _loc9_.tooltip = new ToolTip(_loc9_,_loc10_.name + "\n" + GameWorld.textHandler.getTextFromId("UnlocksAtLevel"));
               }
               else
               {
                  _loc9_.mc_level.visible = false;
                  _loc12_ = GameWorld.textHandler.getTextFromId("ItemToolTip" + _loc10_.className);
                  if(_loc12_ != null)
                  {
                     _loc9_.tooltip = new ToolTip(_loc9_,_loc10_.name + "\n\n<font color=\"#38C4E5\" size=\"18\">" + _loc12_ + "</font>");
                  }
                  else
                  {
                     _loc9_.tooltip = new ToolTip(_loc9_,_loc10_.name);
                  }
               }
               _loc9_.itemConfig = _loc10_;
               _loc9_.tf_cost.mouseEnabled = false;
               _loc9_.tf_cost.autoSize = TextFieldAutoSize.CENTER;
               if(itemDescriptionTextField)
               {
                  _loc9_.addEventListener(MouseEvent.ROLL_OVER,onIconRollOver,false,0,true);
                  _loc9_.addEventListener(MouseEvent.ROLL_OUT,onIconRollOut,false,0,true);
               }
               setItemOnIconButton(_loc10_,_loc9_.mc_base);
               itemButtons[_loc6_].visible = true;
            }
            else
            {
               itemButtons[_loc6_].visible = false;
            }
            _loc6_++;
         }
         if(leftButton)
         {
            if(param2 <= 0)
            {
               setButtonMode(leftButton,false);
               leftButton.gotoAndStop("disabled");
               leftButton.removeEventListener(MouseEvent.MOUSE_DOWN,onLeft1MouseDown);
            }
            else
            {
               setButtonMode(leftButton,true);
               leftButton.addEventListener(MouseEvent.MOUSE_DOWN,onLeft1MouseDown,false,0,true);
            }
         }
         if(rightButton)
         {
            if(param2 >= getMaxPageIndex(curGroup))
            {
               setButtonMode(rightButton,false);
               rightButton.gotoAndStop("disabled");
               rightButton.removeEventListener(MouseEvent.MOUSE_DOWN,onRight1MouseDown);
            }
            else
            {
               setButtonMode(rightButton,true);
               rightButton.addEventListener(MouseEvent.MOUSE_DOWN,onRight1MouseDown,false,0,true);
            }
         }
      }
      
      private function onInfoMouseDown(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function onDragInstructionToolTipRemove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         if(dragInstructionToolTip)
         {
            dragInstructionToolTip.destroy();
            dragInstructionToolTip = null;
         }
         _loc2_.removeEventListener(MouseEvent.ROLL_OUT,onDragInstructionToolTipRemove);
      }
      
      public function setTab(param1:int) : Boolean
      {
         var _loc4_:MovieClip = null;
         var _loc5_:Array = null;
         if(param1 != curTab)
         {
            if(curTab != -1)
            {
               if(tabButtons[curTab])
               {
                  tabButtons[curTab].addEventListener(MouseEvent.CLICK,onTabClick,false,0,true);
                  setButtonMode(tabButtons[curTab],true);
               }
            }
            curTab = param1;
            if(tabButtons[curTab])
            {
               tabButtons[curTab].removeEventListener(MouseEvent.CLICK,onTabClick);
               setButtonMode(tabButtons[curTab],false);
               tabButtons[curTab].gotoAndStop("selected");
            }
         }
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < groupButtons.length)
         {
            _loc4_ = groupButtons[_loc3_];
            _loc5_ = getItemConfigsInGroup(_loc4_.group);
            _loc4_.groupItems = _loc5_;
            if(_loc5_.length > 0)
            {
               setButtonMode(_loc4_,true);
               _loc4_.addEventListener(MouseEvent.CLICK,groupButtonClicked,false,0,true);
               _loc4_.filters = null;
               _loc2_ = true;
            }
            else
            {
               setButtonMode(_loc4_,false);
               _loc4_.removeEventListener(MouseEvent.CLICK,groupButtonClicked);
               _loc4_.filters = new Array(new ColorMatrixFilter(GREY_FILTER_MATRIX));
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function groupButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         if(_loc2_.group != curGroup)
         {
            setGroup(_loc2_.group,0);
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      public function refresh() : void
      {
         setTab(curTab);
         setGroup(curGroup,curPage,false);
      }
      
      public function disableGroups(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc2_:Number = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < groupButtons.length)
            {
               if(groupButtons[_loc4_].groupName == _loc3_)
               {
                  groupButtons[_loc4_].visible = false;
                  break;
               }
               _loc4_++;
            }
            _loc2_++;
         }
      }
      
      private function onTabClick(param1:MouseEvent) : void
      {
         setTab(param1.currentTarget.index);
         setGroup(curGroup,0);
      }
      
      private function onRight1MouseDown(param1:MouseEvent) : void
      {
         setGroup(curGroup,Math.min(curPage + 1,getMaxPageIndex(curGroup)));
      }
      
      private function getMaxPageIndex(param1:Object) : int
      {
         return Math.max(0,Math.floor((curGroupItemConfigs.length - 1) / itemsPerPage));
      }
      
      private function onIconRollOut(param1:MouseEvent) : void
      {
         itemDescriptionTextField.text = "";
      }
      
      private function onItemButtonMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:ItemChooserEvent = null;
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         if(hasEventListener(ItemChooserEvent.EVENT_ITEM_MOUSE_DOWN))
         {
            _loc3_ = new ItemChooserEvent(ItemChooserEvent.EVENT_ITEM_MOUSE_DOWN);
            _loc3_.itemConfig = _loc2_.itemConfig;
            dispatchEvent(_loc3_);
         }
         if(_loc2_.tooltip)
         {
            _loc2_.tooltip.remove();
         }
         param1.stopImmediatePropagation();
      }
   }
}


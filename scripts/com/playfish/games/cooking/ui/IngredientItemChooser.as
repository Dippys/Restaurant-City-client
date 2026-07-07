package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class IngredientItemChooser extends BaseObject
   {
      
      private static const ICON_WIDTH:int = 65;
      
      private static const ICON_HEIGHT:int = 65;
      
      private var lockItemsOnly:Boolean;
      
      private var ingredients:Array;
      
      private var itemsPerPage:int = 12;
      
      private var itemButtons:Array;
      
      private var curPage:int = 0;
      
      private var showCount:Boolean;
      
      private var lockEnabled:Boolean;
      
      public var scene:MovieClip;
      
      public function IngredientItemChooser(param1:Array, param2:MovieClip = null, param3:Boolean = true, param4:Boolean = false, param5:Boolean = true)
      {
         var _loc7_:MovieClip = null;
         itemButtons = new Array();
         super();
         this.ingredients = param1;
         this.lockEnabled = param3;
         this.lockItemsOnly = param4;
         this.showCount = param5;
         if(!param2)
         {
            scene = Engine.getMovieClip("IngredientItemChooserScene");
            addChild(scene);
         }
         else
         {
            scene = param2;
         }
         var _loc6_:Number = 0;
         while(_loc6_ < itemsPerPage)
         {
            _loc7_ = scene["mc_item" + _loc6_];
            if(!_loc7_)
            {
               itemsPerPage = _loc6_;
               break;
            }
            setButtonMode(_loc7_,true);
            itemButtons.push(_loc7_);
            _loc6_++;
         }
         refresh(param1);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function onRightMouseDown(param1:MouseEvent) : void
      {
         setPage(Math.min(curPage + 1,getMaxPageIndex()));
      }
      
      private function onItemMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:ItemChooserEvent = null;
         if(lockEnabled)
         {
            _loc2_ = MovieClip(param1.currentTarget);
            _loc2_.ingredientItem.lock = !_loc2_.ingredientItem.lock;
            if(_loc2_.ingredientItem.lock)
            {
               _loc2_.mc_lock.gotoAndPlay("lock");
               GameWorld.saveProfileHandler.addLockedIngredient(_loc2_.ingredientItem);
            }
            else
            {
               _loc2_.mc_lock.gotoAndPlay("unlock");
               GameWorld.saveProfileHandler.addUnlockedIngredient(_loc2_.ingredientItem);
            }
            _loc2_.mc_lock.visible = _loc2_.ingredientItem.lock;
         }
         if(hasEventListener(ItemChooserEvent.EVENT_ITEM_MOUSE_DOWN))
         {
            _loc3_ = new ItemChooserEvent(ItemChooserEvent.EVENT_ITEM_MOUSE_DOWN);
            _loc3_.itemConfig = param1.currentTarget.itemConfig;
            dispatchEvent(_loc3_);
         }
         param1.stopImmediatePropagation();
      }
      
      private function onLeftMouseDown(param1:MouseEvent) : void
      {
         setPage(Math.max(curPage - 1,0));
      }
      
      public function setPage(param1:int = 0) : void
      {
         var _loc5_:int = 0;
         var _loc6_:IngredientItem = null;
         var _loc7_:BaseObject = null;
         var _loc8_:int = 0;
         var _loc9_:MovieClip = null;
         var _loc10_:Rectangle = null;
         var _loc11_:MovieClip = null;
         curPage = param1;
         var _loc2_:Array = ingredients;
         var _loc3_:int = param1 * itemsPerPage;
         var _loc4_:Number = 0;
         while(_loc4_ < itemButtons.length)
         {
            if(itemButtons[_loc4_].image)
            {
               itemButtons[_loc4_].mc_base.removeChild(itemButtons[_loc4_].image);
               itemButtons[_loc4_].image = null;
               if(itemButtons[_loc4_].tooltip)
               {
                  itemButtons[_loc4_].tooltip.destroy();
                  itemButtons[_loc4_].tooltip = null;
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < itemButtons.length)
         {
            _loc5_ = _loc4_ + _loc3_;
            if(_loc5_ < _loc2_.length)
            {
               _loc6_ = _loc2_[_loc5_];
               _loc7_ = new BaseObject(_loc6_.className);
               _loc7_.stop();
               _loc8_ = 0;
               while(true)
               {
                  _loc11_ = MovieClip(_loc7_.getChildMovieClipInstance("sub" + _loc8_));
                  if(_loc11_ == null)
                  {
                     break;
                  }
                  _loc11_.stop();
                  _loc8_++;
               }
               _loc9_ = itemButtons[_loc4_];
               if(_loc7_.width > _loc7_.height)
               {
                  _loc7_.scaleX = ICON_WIDTH / _loc7_.width;
                  _loc7_.scaleY = _loc7_.scaleX;
               }
               else
               {
                  _loc7_.scaleY = ICON_HEIGHT / _loc7_.height;
                  _loc7_.scaleX = _loc7_.scaleY;
               }
               _loc10_ = _loc7_.getBounds(_loc7_);
               _loc7_.x = _loc7_.x - _loc10_.left * _loc7_.scaleX - _loc7_.width / 2;
               _loc7_.y = _loc7_.y - _loc10_.top * _loc7_.scaleY - _loc7_.height / 2;
               _loc9_.ingredientItem = _loc6_;
               _loc9_.itemConfig = _loc6_.itemConfig;
               _loc9_.image = _loc7_;
               _loc9_.tf_count.text = _loc6_.count;
               _loc9_.tf_count.mouseEnabled = false;
               _loc9_.tf_count.autoSize = TextFieldAutoSize.LEFT;
               _loc9_.mc_rarity.gotoAndStop(_loc6_.rarity);
               _loc9_.mc_base.addChild(_loc7_);
               _loc9_.addEventListener(MouseEvent.MOUSE_DOWN,onItemMouseDown,false,0,true);
               _loc9_.mc_lock.visible = _loc6_.lock;
               if(!showCount)
               {
                  _loc9_.tf_count.visible = false;
                  _loc9_.mc_crate.visible = false;
               }
               _loc9_.tooltip = new ToolTip(_loc9_,_loc6_.itemConfig.name);
               itemButtons[_loc4_].visible = true;
            }
            else
            {
               itemButtons[_loc4_].visible = false;
            }
            _loc4_++;
         }
         if(param1 == 0)
         {
            setButtonMode(scene.mc_left,false);
            scene.mc_left.gotoAndStop("disabled");
            scene.mc_left.removeEventListener(MouseEvent.MOUSE_DOWN,onLeftMouseDown);
         }
         else
         {
            setButtonMode(scene.mc_left,true);
            scene.mc_left.addEventListener(MouseEvent.MOUSE_DOWN,onLeftMouseDown,false,0,true);
         }
         if(param1 == getMaxPageIndex())
         {
            setButtonMode(scene.mc_right,false);
            scene.mc_right.gotoAndStop("disabled");
            scene.mc_right.removeEventListener(MouseEvent.MOUSE_DOWN,onRightMouseDown);
         }
         else
         {
            setButtonMode(scene.mc_right,true);
            scene.mc_right.addEventListener(MouseEvent.MOUSE_DOWN,onRightMouseDown,false,0,true);
         }
      }
      
      private function getMaxPageIndex() : int
      {
         return Math.max(0,Math.floor((ingredients.length - 1) / itemsPerPage));
      }
      
      public function refresh(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         if(param1 != null)
         {
            if(lockItemsOnly)
            {
               ingredients = new Array();
               _loc2_ = 0;
               while(_loc2_ < param1.length)
               {
                  if(param1[_loc2_].lock)
                  {
                     ingredients.push(param1[_loc2_]);
                  }
                  _loc2_++;
               }
            }
            else
            {
               ingredients = param1;
            }
         }
         setPage(Math.min(curPage,getMaxPageIndex()));
      }
   }
}


package com.playfish.games.cooking
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class StreetBuilding extends BaseObject
   {
      
      public var items:Array = new Array();
      
      public var tileLayer:Sprite = new Sprite();
      
      public var user:GameUser;
      
      public var loadingBuilding:MovieClip;
      
      public var roof:BuildingItem;
      
      public var tileBitmapData:BitmapData;
      
      public var overrideBuilding:BuildingItem;
      
      public var body:BuildingItem;
      
      public var banner:BuildingItem;
      
      private var itemDatabase:ItemDatabase;
      
      public var tile:BuildingItem;
      
      private var bannerText:String = "";
      
      private var bannerTextEditButton:MovieClip;
      
      private var bannerTextEditable:Boolean;
      
      public function StreetBuilding(param1:ItemDatabase, param2:GameUser, param3:BuildingItem = null)
      {
         super();
         this.itemDatabase = param1;
         this.user = param2;
         this.overrideBuilding = param3;
      }
      
      private function removeAllItems() : void
      {
         roof = null;
         body = null;
         tile = null;
         banner = null;
         var _loc1_:int = 0;
         while(_loc1_ < items.length)
         {
            items[_loc1_].destroyFunctions();
            if(items[_loc1_].wallTile)
            {
               removeWallTile();
            }
            else
            {
               removeObject(items[_loc1_]);
            }
            _loc1_++;
         }
         items.splice(0,items.length);
      }
      
      public function save() : void
      {
         user.bannerText = bannerText;
      }
      
      public function startItemFunctions() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < items.length)
         {
            items[_loc1_].initFunctions(this);
            _loc1_++;
         }
      }
      
      private function resetRoof() : void
      {
         if(roof != null)
         {
            positionRoof(roof);
         }
      }
      
      public function setBannerTextEditable(param1:Boolean) : void
      {
         bannerTextEditable = param1;
         if(banner != null)
         {
            if(bannerTextEditable)
            {
               if(bannerTextEditButton == null)
               {
                  addBannerTextEditor();
               }
            }
            else if(bannerTextEditButton != null)
            {
               removeBannerTextEditor();
            }
         }
      }
      
      public function setWallTile(param1:BuildingItem) : void
      {
         removeWallTile();
         tileBitmapData = new BitmapData(param1.width,param1.height);
         tileBitmapData.draw(param1);
         tileLayer.graphics.clear();
         tileLayer.graphics.beginBitmapFill(tileBitmapData,null,true,false);
         var _loc2_:Rectangle = body.getBounds(null);
         tileLayer.graphics.drawRect(_loc2_.left,_loc2_.top,_loc2_.width,_loc2_.height);
         tileLayer.graphics.endFill();
         var _loc3_:MovieClip = Engine.getMovieClip(body.itemConfig.className);
         if(_loc3_.mc_rect)
         {
            _loc3_.removeChild(_loc3_.mc_rect);
         }
         tileLayer.mask = _loc3_;
         body.addChild(_loc3_);
         body.addChild(tileLayer);
      }
      
      public function addItem(param1:BuildingItem) : void
      {
         if(param1.roof)
         {
            if(roof != null)
            {
               removeItem(roof);
               roof = null;
            }
            roof = param1;
            if(body != null)
            {
               resetRoof();
            }
         }
         else if(param1.body)
         {
            if(body != null)
            {
               removeItem(body);
               body = null;
            }
            body = param1;
            body.x = 0;
            body.y = 0;
            if(roof != null)
            {
               resetRoof();
            }
            if(tile != null)
            {
               setWallTile(tile);
            }
         }
         else if(param1.wallTile)
         {
            if(tile != null)
            {
               removeItem(tile);
            }
            tile = param1;
            if(body != null)
            {
               setWallTile(param1);
            }
         }
         else if(param1.banner)
         {
            if(banner != null)
            {
               removeItem(banner);
            }
            banner = param1;
            if(banner.flipped)
            {
               banner.flip();
            }
            setBannerText(bannerText);
            if(bannerTextEditable)
            {
               addBannerTextEditor();
            }
         }
         if(param1.y > 0)
         {
            param1.y = 0;
         }
         else if(param1.y < -240)
         {
            param1.y = -240;
         }
         if(param1.x > 200)
         {
            param1.x = 200;
         }
         else if(param1.x < -200)
         {
            param1.x = -200;
         }
         if(!param1.wallTile)
         {
            if(param1.flipped)
            {
               param1.manipulate(FLIP_HORIZONTAL);
            }
            addObject(param1);
         }
         items.push(param1);
      }
      
      private function onNameTextChanged(param1:Event) : void
      {
         setBannerText(param1.currentTarget.text);
      }
      
      public function isLoaded() : Boolean
      {
         return items.length != 0;
      }
      
      public function positionRoof(param1:BuildingItem) : void
      {
         var _loc2_:MovieClip = roof.getChildMovieClipInstance("mc_rect");
         param1.x = body.x;
         param1.y = body.y - body.height;
         var _loc3_:MovieClip = body.getChildMovieClipInstance("mc_rect");
         if(_loc3_)
         {
            param1.scaleX = _loc3_.width / _loc2_.width;
            param1.scaleY = param1.scaleX;
         }
         else
         {
            param1.scaleX = body.width / _loc2_.width;
            param1.scaleY = param1.scaleX;
         }
      }
      
      private function onEditMouseDown(param1:MouseEvent) : void
      {
         Engine.setFullScreen(false);
         var _loc2_:TextField = banner.getChildTextFieldInstance("tf_name");
         _loc2_.selectable = true;
         Engine.setFocus(_loc2_);
         _loc2_.setSelection(_loc2_.text.length,_loc2_.text.length);
         param1.stopImmediatePropagation();
      }
      
      public function load() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BuildingItem = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:UserItem = null;
         var _loc8_:Array = null;
         var _loc9_:UserItem = null;
         if(overrideBuilding)
         {
            addItem(overrideBuilding);
         }
         else if(user != null)
         {
            if(user.usedBuildingItems.length > 0)
            {
               removeAllItems();
               _loc1_ = 0;
               while(_loc1_ < user.usedBuildingItems.length)
               {
                  _loc2_ = new BuildingItem(user.usedBuildingItems[_loc1_]);
                  _loc2_.owned = true;
                  addItem(_loc2_);
                  _loc1_++;
               }
               setBannerText(user.bannerText);
            }
            else
            {
               _loc3_ = itemDatabase.getItems("Body");
               placeDefaultItem(new UserItem(_loc3_[Engine.rnd(0,_loc3_.length)]),0,0);
               _loc4_ = itemDatabase.getItems("Roof");
               placeDefaultItem(new UserItem(_loc4_[Engine.rnd(0,_loc4_.length)]),0,0);
               _loc5_ = itemDatabase.getItems("Door");
               placeDefaultItem(new UserItem(_loc5_[Engine.rnd(0,_loc5_.length)]),0,0);
               _loc6_ = itemDatabase.getItems("Banner");
               _loc7_ = new UserItem(_loc6_[Engine.rnd(0,_loc6_.length)]);
               placeDefaultItem(_loc7_,0,-100);
               _loc8_ = itemDatabase.getItems("Tile");
               _loc9_ = new UserItem(_loc8_[Engine.rnd(0,_loc8_.length)]);
               placeDefaultItem(_loc9_,0,0);
               setBannerText(user.bannerText);
            }
         }
      }
      
      private function removeWallTile() : void
      {
         if(tileBitmapData != null)
         {
            tileBitmapData.dispose();
            tileBitmapData = null;
         }
         if(tileLayer.mask != null)
         {
            if(body != null)
            {
               if(body.contains(tileLayer.mask))
               {
                  body.removeChild(tileLayer.mask);
               }
               if(body.contains(tileLayer))
               {
                  body.removeChild(tileLayer);
               }
            }
            tileLayer.mask = null;
         }
         tileLayer.graphics.clear();
      }
      
      private function placeDefaultItem(param1:UserItem, param2:int, param3:int) : void
      {
         var _loc4_:BuildingItem = null;
         _loc4_ = new BuildingItem(param1);
         _loc4_.owned = true;
         _loc4_.x = param2;
         _loc4_.y = param3;
         addItem(_loc4_);
         if(user != null)
         {
            user.addUsedBuildingItem(param1);
         }
      }
      
      private function removeBannerTextEditor() : void
      {
         var _loc1_:TextField = banner.getChildTextFieldInstance("tf_name");
         _loc1_.type = TextFieldType.DYNAMIC;
         _loc1_.removeEventListener(Event.CHANGE,onNameTextChanged);
         if(bannerTextEditButton)
         {
            banner.removeChild(bannerTextEditButton);
            bannerTextEditButton = null;
         }
      }
      
      private function addBannerTextEditor() : void
      {
         var _loc1_:TextField = banner.getChildTextFieldInstance("tf_name");
         _loc1_.type = TextFieldType.INPUT;
         _loc1_.maxChars = 16;
         _loc1_.addEventListener(Event.CHANGE,onNameTextChanged,false,0,true);
         _loc1_.mouseEnabled = false;
         var _loc2_:Rectangle = banner.getBounds(null);
         bannerTextEditButton = Engine.getMovieClip("ButtonEditBannerName");
         bannerTextEditButton.x = _loc2_.right + bannerTextEditButton.width / 2;
         bannerTextEditButton.addEventListener(MouseEvent.MOUSE_DOWN,onEditMouseDown,false,0,true);
         GameWorld.textHandler.setTextFieldWithId(bannerTextEditButton.mc_content.tf_text,"Edit");
         setButtonMode(bannerTextEditButton,true);
         banner.addChild(bannerTextEditButton);
      }
      
      public function removeItem(param1:BuildingItem) : void
      {
         if(param1 == roof)
         {
            roof = null;
         }
         else if(param1 == body)
         {
            body = null;
         }
         else if(param1 == tile)
         {
            tile = null;
         }
         else if(param1 == banner)
         {
            removeBannerTextEditor();
            banner = null;
         }
         if(param1.wallTile)
         {
            removeWallTile();
         }
         else
         {
            removeObject(param1);
         }
         var _loc2_:int = items.indexOf(param1);
         if(Debug.assert(_loc2_ != -1,"StreetBuilding.removeItem(item): removing item \"" + param1.itemConfig.name + "\" which is already removed"))
         {
            items.splice(_loc2_,1);
         }
      }
      
      public function setBannerText(param1:String) : void
      {
         var _loc2_:TextField = null;
         this.bannerText = param1;
         if(banner != null)
         {
            _loc2_ = banner.getChildTextFieldInstance("tf_name");
            _loc2_.mouseEnabled = false;
            GameWorld.textHandler.setTextField(_loc2_,bannerText,false);
         }
      }
      
      public function stopItemFunctions() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < items.length)
         {
            items[_loc1_].destroyFunctions();
            _loc1_++;
         }
      }
      
      public function unload() : void
      {
         removeAllItems();
      }
   }
}


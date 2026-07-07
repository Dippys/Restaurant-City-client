package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class WorldMusicShopPopUp extends WorldPopUp
   {
      
      private static const NUM_TRACKS_PER_PAGE:int = 3;
      
      private var pageIndex:int;
      
      private var playingMusicItem:UserItem;
      
      private var sceneContent:MovieClip;
      
      private var trackIcons:Array;
      
      private var musicItems:Array;
      
      private var prevMusicItem:UserItem;
      
      private var bought:Boolean = false;
      
      private var numPages:int;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function WorldMusicShopPopUp(param1:WorldRestaurantPlay)
      {
         var _loc5_:MovieClip = null;
         trackIcons = new Array();
         super(null,null,null);
         this.restaurant = param1;
         this.playingMusicItem = param1.getPlayingMusicForUser(GameWorld.gameUser);
         var _loc2_:MovieClip = Engine.getMovieClip("MusicPopupAnim");
         addChild(_loc2_);
         sceneContent = _loc2_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"ToolTipMusicPlayer");
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title2,"SelectACD");
         musicItems = GameWorld.interiorItemDatabase.getItems("Music");
         numPages = Math.ceil(musicItems.length / NUM_TRACKS_PER_PAGE);
         var _loc3_:int = 0;
         while(_loc3_ < NUM_TRACKS_PER_PAGE)
         {
            _loc5_ = sceneContent["mc_track" + _loc3_];
            trackIcons.push(_loc5_);
            _loc5_.addEventListener(MouseEvent.CLICK,onMusicIconClick,false,0,true);
            _loc3_++;
         }
         setButtonMode(sceneContent.mc_tick,true);
         sceneContent.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < musicItems.length)
         {
            if(playingMusicItem.itemConfig.id == musicItems[_loc3_].id)
            {
               _loc4_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         setPage(_loc4_ / NUM_TRACKS_PER_PAGE);
      }
      
      private function onBuyCancelClick(param1:MouseEvent) : void
      {
         playingMusicItem = prevMusicItem;
         restaurant.playBgMusic(playingMusicItem.itemConfig);
         prevMusicItem = null;
         setPage(pageIndex);
      }
      
      private function onAddCoinsClick(param1:MouseEvent) : void
      {
         onBuyCancelClick(null);
         GameWorld.cashPanel.showAddCoinsPopUp();
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         remove();
         GameWorld.gameUser.musicId = playingMusicItem.itemConfig.id;
         if(bought)
         {
            GameWorld.forceAutoSave();
         }
      }
      
      private function onRightClick(param1:MouseEvent) : void
      {
         if(pageIndex < numPages - 1)
         {
            setPage(pageIndex + 1);
         }
      }
      
      private function setPage(param1:int) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         this.pageIndex = param1;
         var _loc2_:int = param1 * NUM_TRACKS_PER_PAGE;
         var _loc3_:int = 0;
         while(_loc3_ < trackIcons.length)
         {
            _loc4_ = trackIcons[_loc3_];
            _loc4_.mc_content.mc_disc.stop();
            if(_loc4_.coverMovieClip)
            {
               _loc4_.mc_content.mc_disc.removeChild(_loc4_.coverMovieClip);
               _loc4_.coverMovieClip = null;
            }
            _loc5_ = _loc2_ + _loc3_;
            if(_loc5_ < musicItems.length)
            {
               _loc6_ = musicItems[_loc5_];
               _loc4_.musicItemConfig = _loc6_;
               setMusicIcon(_loc4_,_loc6_);
               if(getOwnedMusicItem(_loc6_.id) != null || _loc6_.cost <= 0)
               {
                  _loc4_.tf_price.visible = false;
               }
               else
               {
                  _loc4_.tf_price.visible = true;
               }
               if(playingMusicItem.itemConfig.id == _loc6_.id)
               {
                  _loc4_.mc_content.play();
                  setButtonMode(_loc4_,false);
                  _loc4_.gotoAndStop("selected");
               }
               else
               {
                  _loc4_.mc_content.stop();
                  setButtonMode(_loc4_,true);
               }
               _loc4_.visible = true;
            }
            else
            {
               _loc4_.mc_content.stop();
               setButtonMode(_loc4_,false);
               _loc4_.visible = false;
            }
            _loc3_++;
         }
         if(param1 <= 0)
         {
            setButtonMode(sceneContent.mc_left,false);
            sceneContent.mc_left.gotoAndStop("disabled");
            sceneContent.mc_left.removeEventListener(MouseEvent.CLICK,onLeftClick);
         }
         else
         {
            setButtonMode(sceneContent.mc_left,true);
            sceneContent.mc_left.addEventListener(MouseEvent.CLICK,onLeftClick,false,0,true);
         }
         if(param1 >= numPages - 1)
         {
            setButtonMode(sceneContent.mc_right,false);
            sceneContent.mc_right.gotoAndStop("disabled");
            sceneContent.mc_right.removeEventListener(MouseEvent.CLICK,onRightClick);
         }
         else
         {
            setButtonMode(sceneContent.mc_right,true);
            sceneContent.mc_right.addEventListener(MouseEvent.CLICK,onRightClick,false,0,true);
         }
      }
      
      private function onBuyClick(param1:MouseEvent) : void
      {
         if(GameWorld.gameUser.money.value >= playingMusicItem.itemConfig.cost)
         {
            prevMusicItem = null;
            GameWorld.gameUser.musicItems.push(playingMusicItem);
            GameWorld.cashPanel.addCoins(-playingMusicItem.itemConfig.cost,true);
            restaurant.cashSound.play(1);
            GameWorld.saveProfileHandler.purchaseItem(playingMusicItem);
            bought = true;
            setPage(pageIndex);
         }
      }
      
      private function onLeftClick(param1:MouseEvent) : void
      {
         if(pageIndex > 0)
         {
            setPage(pageIndex - 1);
         }
      }
      
      private function onMusicIconClick(param1:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:WorldPopUp = null;
         var _loc2_:Object = param1.currentTarget.musicItemConfig;
         restaurant.playBgMusic(_loc2_);
         prevMusicItem = playingMusicItem;
         playingMusicItem = getOwnedMusicItem(_loc2_.id);
         if(playingMusicItem != null || _loc2_.cost <= 0)
         {
            if(playingMusicItem == null)
            {
               playingMusicItem = new UserItem(_loc2_);
            }
         }
         else
         {
            playingMusicItem = new UserItem(_loc2_);
            _loc3_ = Engine.getMovieClip("MusicPurchaseAnim");
            _loc4_ = _loc3_.mc_content;
            GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_title,"BuyHeader");
            setMusicIcon(_loc4_.mc_track,_loc2_);
            _loc4_.mc_track.stop();
            _loc4_.mc_cancel.addEventListener(MouseEvent.CLICK,onBuyCancelClick,false,0,true);
            if(GameWorld.gameUser.money.value < _loc2_.cost)
            {
               _loc4_.mc_tick.stop();
               _loc4_.mc_tick.visible = false;
               _loc4_.mc_addCoins.toolTip = new ToolTip(_loc4_.mc_addCoins,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughCoins"));
               _loc4_.mc_addCoins.addEventListener(MouseEvent.CLICK,onAddCoinsClick,false,0,true);
               _loc5_ = new WorldPopUp(_loc3_,_loc4_.mc_addCoins,_loc4_.mc_cancel);
            }
            else
            {
               _loc4_.mc_addCoins.stop();
               _loc4_.mc_addCoins.visible = false;
               _loc4_.mc_tick.addEventListener(MouseEvent.CLICK,onBuyClick,false,0,true);
               _loc5_ = new WorldPopUp(_loc3_,_loc4_.mc_tick,_loc4_.mc_cancel);
            }
            _loc5_.x = GameWorld.CANVAS_CENTER_X;
            _loc5_.y = GameWorld.CANVAS_CENTER_Y;
            _loc5_.show();
         }
         setPage(pageIndex);
      }
      
      private function getOwnedMusicItem(param1:int) : UserItem
      {
         var _loc3_:UserItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < GameWorld.gameUser.musicItems.length)
         {
            _loc3_ = GameWorld.gameUser.musicItems[_loc2_];
            if(_loc3_.itemConfig.id == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function setMusicIcon(param1:MovieClip, param2:Object) : void
      {
         var _loc3_:MovieClip = null;
         param1.mc_content.mc_disc.stop();
         if(Boolean(param2.coverName) && param2.coverName.length > 0)
         {
            _loc3_ = Engine.getMovieClip(param2.coverName);
            param1.mc_content.mc_disc.addChild(_loc3_);
            param1.coverMovieClip = _loc3_;
         }
         param1.tf_name.mouseEnabled = false;
         param1.tf_name.text = param2.name;
         param1.tf_price.mouseEnabled = false;
         param1.tf_price.text = param2.cost;
      }
   }
}


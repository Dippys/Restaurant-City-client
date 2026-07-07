package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.rpc.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WorldRatePopUp extends WorldPopUp
   {
      
      private var stars:Array;
      
      private const DEFAULT_STARS:int = 0;
      
      private var userToRate:GameUser;
      
      private var sceneContent:MovieClip;
      
      private const MAX_STARS:int = 5;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function WorldRatePopUp(param1:GameUser, param2:WorldRestaurantPlay)
      {
         var _loc5_:MovieClip = null;
         stars = new Array();
         super(null,null,null);
         this.userToRate = param1;
         this.restaurant = param2;
         var _loc3_:MovieClip = Engine.getMovieClip("RatingsPopupAnim");
         addChild(_loc3_);
         sceneContent = _loc3_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"AssignRatingToRestaurant");
         var _loc4_:int = 0;
         while(_loc4_ < MAX_STARS)
         {
            _loc5_ = sceneContent["mc_star" + _loc4_];
            setButtonMode(_loc5_,true);
            _loc5_.addEventListener(MouseEvent.MOUSE_DOWN,onStarMouseDown,false,0,true);
            _loc5_.index = _loc4_;
            stars.push(_loc5_);
            _loc4_++;
         }
         setButtonMode(sceneContent.mc_tick,false);
         sceneContent.mc_tick.gotoAndStop("grey");
         sceneContent.mc_tick.toolTip = new ToolTip(sceneContent.mc_tick,GameWorld.textHandler.getTextFromId("ToolTipSelectARating"));
         setRating(DEFAULT_STARS);
      }
      
      private function getRating() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < stars.length)
         {
            if(stars[_loc2_].mc_content.mc_mask.scaleX != 0)
            {
               break;
            }
            _loc1_++;
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function onRankRestaurantOK(param1:Event) : void
      {
         restaurant.hideRateButton();
         userToRate.rated = true;
         ++userToRate.userInfo.nbVote;
         userToRate.userInfo.totalMark += getRating();
         WorldRestaurantPlay.setRating(restaurant.uiVisitBanner.mc_userStars,userToRate);
         GameWorld.addAwardValue(GameAwards.AWARD_RATE_COUNT,1);
      }
      
      private function onStarMouseDown(param1:MouseEvent) : void
      {
         if(getRating() == 0)
         {
            setButtonMode(sceneContent.mc_tick,true);
            sceneContent.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
            if(sceneContent.mc_tick.toolTip)
            {
               sceneContent.mc_tick.toolTip.destroy();
               sceneContent.mc_tick.toolTip = null;
            }
         }
         setRating(param1.currentTarget.index + 1);
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RpcRequestManager = null;
         var _loc4_:RpcRankRestaurant = null;
         _loc2_ = getRating();
         if(_loc2_ > 0)
         {
            remove();
            _loc3_ = new RpcRequestManager();
            _loc3_.loadingPopUp = new WorldLoadingPopUp("Saving...",WorldLoadingPopUp.RATING);
            _loc3_.loadingPopUp.x = GameWorld.CANVAS_CENTER_X;
            _loc3_.loadingPopUp.y = GameWorld.CANVAS_CENTER_Y;
            _loc3_.retryText = GameWorld.textHandler.getTextFromId("RateRestaurantRetryText");
            _loc4_ = _loc3_.rankRestaurant(userToRate.userInfo.id,_loc2_);
            _loc4_.addEventListener(RpcEvent.SUCCESS,onRankRestaurantOK);
            _loc3_.commit();
         }
      }
      
      private function setRating(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < stars.length)
         {
            if(_loc2_ < param1)
            {
               stars[_loc2_].mc_content.mc_mask.scaleX = 0;
            }
            else
            {
               stars[_loc2_].mc_content.mc_mask.scaleX = 1;
            }
            _loc2_++;
         }
         if(param1 == 0)
         {
            GameWorld.textHandler.setTextField(sceneContent.tf_rate,"");
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_rate,"Rating" + param1);
         }
      }
   }
}


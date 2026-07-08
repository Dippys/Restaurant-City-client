package com.playfish.games.cooking
{
   import com.playfish.coretech.platform.socialplatform.*;
   import com.playfish.external.ExternalPage;
   import com.playfish.external.ExternalPageEvent;
   import com.playfish.games.cooking.actors.StreetActor;
   import com.playfish.games.cooking.events.FriendListEvent;
   import com.playfish.games.cooking.foodking.FoodKing;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.tutorials.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.utils.*;
   
   public class WorldStreet extends BaseWorld
   {
      
      public static var streetUserList:WorldFriendsList;
      
      public static var streetUsers:Array;
      
      public static const STREET_TYPE_FRIENDS:int = 0;
      
      public static const STREET_TYPE_RANDOM:int = 1;
      
      public static const STREET_TYPE_GOURMET:int = 2;
      
      public static var streetType:int = STREET_TYPE_FRIENDS;
      
      public static const STREET_ROAD_COLOUR:Array = [8684672,10065807,10065807];
      
      private static const BECOME_A_FAN_ITEM_ID:int = 2090000;
      
      private static const LOOKING_FOR_ARTISTS_ITEM_ID:int = 2090001;
      
      private static const WALLGREENS_ITEM_ID:int = 2090002;
      
      private static const UK_CASH_CARD_ITEM_ID:int = 2090003;
      
      private static const FOODKING_BILLBOARD_ITEM_ID:int = 2090004;
      
      private static const STATE_NORMAL:int = 0;
      
      private static const STATE_PANNING:int = 1;
      
      private static const STATE_ZOOMING_IN:int = 2;
      
      private static const STATE_ZOOMING_OUT:int = 3;
      
      private static const STATE_ZOOMING_IN_TO_RESTAURANT:int = 4;
      
      private static const STATE_ZOOMING_OUT_FROM_RESTAURANT:int = 5;
      
      private static const STATE_INTRO:int = 6;
      
      private static const STATE_LOADING_RESTAURANT:int = 7;
      
      private static const STATE_PANNING_TO_BUILDING:int = 8;
      
      private static const NUM_GOURMET_STREET_USERS:int = 50;
      
      private static const NUM_RANDOM_STREET_USERS:int = 10;
      
      private static const NUM_BUILDINGS_TO_LOAD_IN_A_BATCH:int = 50;
      
      public static const BUILDING_GAP:int = 420;
      
      public static const PORTRAIT_Y:int = -310;
      
      public static var cachedActors:Array = new Array();
      
      private var searchBox:MovieClip;
      
      private var bgRoad:Shape;
      
      private var bgLayer:BackgroundLayer;
      
      private var matchedUserIndex:int = 0;
      
      private var targetUser:GameUser;
      
      private var foodKing:FoodKing;
      
      public var actors:Array = new Array();
      
      private var buildingY:Number = 0;
      
      private var sceneLayer:ScrollPanel;
      
      private var logoMovieClip:MovieClip;
      
      private var curStreetType:int;
      
      private var buttonLayer:MovieClip;
      
      private var userFaceBitmaps:BitmapBatch = new BitmapBatch();
      
      private var buildings:Array;
      
      private var canvasWidth:int = 760;
      
      private var actorTimer:int = 0;
      
      private var targetBuilding:StreetBuilding;
      
      private var curUserList:WorldFriendsList;
      
      private var intro:Boolean = false;
      
      private var visibleBuildingIndices:Array = new Array();
      
      private var buildingItemsLoaded:Array;
      
      private var state:int = 0;
      
      private var sceneParentLayer:BaseObject;
      
      private var canvasHeight:int = 600;
      
      private var bgSky:MovieClip;
      
      private var curUsers:Array;
      
      private var facePanels:Array;
      
      private var itemDatabase:ItemDatabase;
      
      private var playerBuilding:StreetBuilding;
      
      private var bgMusic:GameSound = new GameSound("MusicStreet",GameSound.TYPE_MUSIC);
      
      private var loadingPopUp:WorldLoadingPopUp;
      
      private var topLayer:BaseObject;
      
      private var buildingLayer:BaseObject;
      
      public function WorldStreet(param1:GameUser, param2:Boolean, param3:Boolean = false)
      {
         var _loc4_:int = getTimer();
         PerfTrace.mark("WorldStreet begin intro=" + param2 + " zoomOut=" + param3 + " users=" + (streetUsers == null ? 0 : streetUsers.length));
         super();
         this.targetUser = param1;
         this.intro = param2;
         this.curStreetType = streetType;
         this.curUsers = streetUsers;
         this.curUserList = streetUserList;
         if(param3)
         {
            state = STATE_ZOOMING_OUT;
         }
         init(null);
         PerfTrace.slow("WorldStreet constructor/init",_loc4_,5);
         PerfTrace.mark("WorldStreet end");
      }
      
      private function onButtonOptInClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldOptiInPopUp = new WorldOptiInPopUp();
         _loc2_.show();
      }
      
      private function onSearchCrossClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         if(searchBox.tf_searchText.text.length > 0)
         {
            _loc2_ = searchUsers(searchBox.tf_searchText.text);
            if(_loc2_.length > 1)
            {
               matchedUserIndex = (matchedUserIndex + 1) % _loc2_.length;
               focusOnBuilding(_loc2_[matchedUserIndex]);
            }
            Engine.setFocus(searchBox.tf_searchText);
         }
      }
      
      private function onGetGourmetStreetUsersOK(param1:RpcEvent) : void
      {
         var _loc2_:RpcGetGourmetStreetUsers = RpcGetGourmetStreetUsers(param1.currentTarget);
         var _loc3_:Array = _loc2_.newUsers;
         destroy();
         WorldStreet.streetType = STREET_TYPE_GOURMET;
         WorldStreet.streetUsers = _loc3_;
         WorldStreet.streetUserList = new WorldFriendsList(_loc3_,false);
         WorldStreet.streetUserList.y = Engine.STAGE_HEIGHT;
         WorldStreet.streetUserList.drawPriority = 10000;
         GameWorld.fadeToWorld(new WorldStreet(null,false,false));
      }
      
      private function onNetPromoterOKClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentLabel != "grey")
         {
            logoMovieClip.play();
         }
      }
      
      private function onFriendsInvitePopUpComplete(param1:ExternalPageEvent) : void
      {
         logoMovieClip.play();
      }
      
      public function init(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         var _loc7_:GameUser = null;
         var _loc8_:StreetBuilding = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:MovieClip = null;
         var _loc15_:BaseObject = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:WorldNetPromoter = null;
         var _loc19_:EmailPermissionReminderPopUp = null;
         itemDatabase = GameWorld.buildingItemDatabase;
         canvasHeight = Engine.STAGE_HEIGHT - curUserList.height;
         if(curStreetType == STREET_TYPE_RANDOM)
         {
            _loc2_ = Engine.getMovieClip("RandomStreetViewScene");
         }
         else if(curStreetType == STREET_TYPE_GOURMET)
         {
            _loc2_ = Engine.getMovieClip("GourmetStreetViewScene");
         }
         else
         {
            _loc2_ = Engine.getMovieClip("StreetViewScene");
         }
         buildingY = _loc2_.mc_road.y + _loc2_.mc_road.getBounds(null).top;
         buildingLayer = new BaseObject();
         sceneLayer = new ScrollPanel(buildingLayer,this);
         sceneLayer.y = buildingY;
         sceneLayer.x = canvasWidth / 2;
         addObject(sceneLayer);
         bgLayer = new BackgroundLayer();
         bgLayer.addLayer(getQualifiedClassName(_loc2_.mc_cloud),_loc2_.mc_cloud.y - buildingY,4);
         bgLayer.addLayer(getQualifiedClassName(_loc2_.mc_city),_loc2_.mc_city.y - buildingY,3);
         bgLayer.addLayer(getQualifiedClassName(_loc2_.mc_cityClose),_loc2_.mc_cityClose.y - buildingY,2);
         bgLayer.addLayer(getQualifiedClassName(_loc2_.mc_road),_loc2_.mc_road.y - buildingY,1);
         bgLayer.x = -Engine.getStageWidth() / 2;
         bgSky = Engine.getMovieClip(getQualifiedClassName(_loc2_.mc_sky));
         bgRoad = new Shape();
         sceneLayer.addChild(bgRoad);
         sceneLayer.addObject(bgLayer);
         sceneLayer.addObject(buildingLayer);
         sceneParentLayer = new BaseObject();
         sceneParentLayer.addChild(bgSky);
         sceneParentLayer.addObject(sceneLayer);
         addObject(sceneParentLayer);
         topLayer = new BaseObject();
         topLayer.drawPriority = 20000;
         addObject(topLayer);
         buildings = new Array();
         facePanels = new Array();
         if(intro)
         {
            curUsers = [GameWorld.gameUser];
         }
         else if(streetType == STREET_TYPE_FRIENDS)
         {
            curUsers = GameWorld.sortUsers(curUsers,GameWorld.compareUserPointAscending);
         }
         if(targetUser == null)
         {
            targetUser = curUsers[curUsers.length - 1];
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < curUsers.length)
         {
            _loc7_ = null;
            if(intro || _loc4_ % 5 != 0)
            {
               _loc7_ = curUsers[_loc6_];
            }
            _loc8_ = new StreetBuilding(itemDatabase,_loc7_);
            _loc8_.x = _loc3_;
            _loc8_.visible = false;
            buildingLayer.addObject(_loc8_);
            facePanels[_loc4_] = null;
            if(_loc7_ == null)
            {
               _loc9_ = Math.abs(_loc4_ / 5);
               if(streetType != STREET_TYPE_GOURMET && _loc9_ % 2 == 0)
               {
                  _loc8_.buttonMode = true;
                  _loc8_.addEventListener(MouseEvent.CLICK,onInviteClick,false,0,true);
                  _loc10_ = itemDatabase.getItems("InviteBuilding");
                  _loc8_.overrideBuilding = new BuildingItem(new UserItem(_loc10_[Engine.rnd(0,_loc10_.length)]));
               }
               else
               {
                  _loc8_.buttonMode = true;
                  _loc12_ = Engine.instance.getParameter("pf_user_country").toLowerCase();
                  if(_loc12_ == "us")
                  {
                     _loc11_ = [BECOME_A_FAN_ITEM_ID,WALLGREENS_ITEM_ID,FOODKING_BILLBOARD_ITEM_ID];
                  }
                  else if(_loc12_ == "uk" || _loc12_ == "gb")
                  {
                     _loc11_ = [BECOME_A_FAN_ITEM_ID,LOOKING_FOR_ARTISTS_ITEM_ID,UK_CASH_CARD_ITEM_ID,FOODKING_BILLBOARD_ITEM_ID];
                  }
                  else
                  {
                     _loc11_ = [BECOME_A_FAN_ITEM_ID,LOOKING_FOR_ARTISTS_ITEM_ID,FOODKING_BILLBOARD_ITEM_ID];
                  }
                  _loc13_ = int(_loc11_[Engine.rnd(0,_loc11_.length)]);
                  _loc8_.overrideBuilding = new BuildingItem(new UserItem(itemDatabase.getItemFromId(_loc13_)));
                  if(_loc8_.overrideBuilding.itemConfig.url)
                  {
                     _loc8_.addEventListener(MouseEvent.CLICK,onSpecialBannerClick,false,0,true);
                  }
                  else
                  {
                     _loc8_.buttonMode = false;
                  }
               }
            }
            else
            {
               if(!intro)
               {
                  _loc14_ = Engine.getMovieClip("HiscoreEntry");
                  _loc14_.tf_point.text = _loc7_.getGourmetPoints();
                  _loc14_.tf_level.text = _loc7_.level.value;
                  _loc14_.x = _loc3_;
                  _loc14_.y = PORTRAIT_Y;
                  _loc14_.tf_name.text = _loc7_.firstName;
                  _loc14_.tf_rank.text = curUsers.length - _loc6_;
                  buildingLayer.addChild(_loc14_);
                  _loc14_.visible = false;
                  facePanels[_loc4_] = _loc14_;
                  if(streetType == STREET_TYPE_RANDOM)
                  {
                     _loc14_.tf_rank.visible = false;
                  }
                  WorldRestaurantPlay.setRating(_loc14_.mc_stars,_loc7_);
                  if(streetType != STREET_TYPE_GOURMET && !_loc7_.userInfo.isInStreet)
                  {
                     _loc14_.mc_stars.visible = false;
                  }
                  _loc8_.buttonMode = true;
                  _loc8_.addEventListener(MouseEvent.CLICK,onBuildingClick,false,0,true);
               }
               if(NetworkUid.areEqual(_loc7_.userInfo.id,GameWorld.gameUser.userInfo.id))
               {
                  playerBuilding = _loc8_;
               }
               if(Boolean(targetUser) && NetworkUid.areEqual(_loc7_.userInfo.id,targetUser.userInfo.id))
               {
                  targetBuilding = _loc8_;
               }
               _loc6_++;
            }
            var _loc20_:Number;
            buildings[_loc20_ = _loc4_++] = _loc8_;
            _loc3_ += BUILDING_GAP;
         }
         sceneLayer.setBounds(BUILDING_GAP - canvasWidth / 2,BUILDING_GAP - canvasWidth / 2 + _loc3_ - BUILDING_GAP,canvasWidth - BUILDING_GAP * 2);
         if(targetBuilding)
         {
            buildingLayer.x = -targetBuilding.x;
         }
         tickBgLayer();
         if(intro)
         {
            _loc15_ = new BaseObject();
            _loc15_.drawPriority = 5000;
            addObject(_loc15_);
            logoMovieClip = Engine.getMovieClip("LogoAnimation");
            logoMovieClip.mc_street.visible = false;
            _loc15_.addChild(logoMovieClip);
            sceneLayer.y = logoMovieClip.mc_street.y;
            sceneLayer.keyboardEnabled = false;
            sceneLayer.scrollEnabled = false;
            GameWorld.cashPanel.visible = false;
            if(GameWorld.gameUser.level.value > 0)
            {
               _loc16_ = 0;
               if(GameWorld.gameUser.userInfo.lastSurveyTime)
               {
                  _loc16_ = Math.floor(GameWorld.gameUser.userInfo.lastSurveyTime.time / (1000 * 60 * 60 * 24));
               }
               _loc17_ = Math.floor(GameWorld.serverTime.time / (1000 * 60 * 60 * 24));
               if(Debug.TEST_NET_PROMOTER || _loc17_ > _loc16_ && Math.random() < GameWorld.NETPROMOTER_POP_UP_CHANCE)
               {
                  logoMovieClip.stop();
                  _loc18_ = new WorldNetPromoter();
                  _loc18_.sceneContent.mc_tick.addEventListener(MouseEvent.CLICK,onNetPromoterOKClick,false,0,true);
                  _loc18_.sceneContent.mc_cancel.addEventListener(MouseEvent.CLICK,onNetPromoterCancelClick,false,0,true);
                  _loc18_.show();
               }
               else if(!SocialPlatform.instance.application.isPermissionGranted(SocialPlatformApp.PERMISSION_EMAIL_ACCESS))
               {
                  if(Math.random() < GameWorld.EMAIL_PERMISSION_REMINDER_POP_UP_CHANCE)
                  {
                     logoMovieClip.stop();
                     _loc19_ = new EmailPermissionReminderPopUp(this);
                     _loc19_.show();
                  }
               }
            }
         }
         else
         {
            if(state == STATE_ZOOMING_OUT)
            {
               sceneLayer.scaleX = WorldCustomiseBuilding.ZOOM_SCALE;
               sceneLayer.scaleY = WorldCustomiseBuilding.ZOOM_SCALE;
               setZoomingTransparency();
            }
            else
            {
               state = STATE_NORMAL;
            }
            if(curStreetType == STREET_TYPE_RANDOM)
            {
               buttonLayer = Engine.getMovieClip("RandomStreetViewButtonLayer2");
            }
            else if(curStreetType == STREET_TYPE_GOURMET)
            {
               buttonLayer = Engine.getMovieClip("GourmetStreetViewButtonLayer2");
            }
            else
            {
               buttonLayer = Engine.getMovieClip("StreetViewButtonLayer2");
            }
            topLayer.addChild(buttonLayer);
            sceneLayer.setButtons(buttonLayer.leftButton,buttonLayer.rightButton);
            setButtonMode(buttonLayer.leftButton,true);
            setButtonMode(buttonLayer.rightButton,true);
            setButtonMode(buttonLayer.buttonMyRestaurant,true);
            buttonLayer.buttonMyRestaurant.addEventListener(MouseEvent.CLICK,myRestaurantClicked);
            buttonLayer.buttonMyRestaurant.toolTip = new ToolTip(buttonLayer.buttonMyRestaurant,GameWorld.textHandler.getTextFromId("ToolTipMyRestaurant"));
            if(curStreetType == STREET_TYPE_RANDOM)
            {
               setButtonMode(buttonLayer.buttonOptIn,true);
               buttonLayer.buttonOptIn.addEventListener(MouseEvent.CLICK,onButtonOptInClick,false,0,true);
               buttonLayer.buttonOptIn.toolTip = new ToolTip(buttonLayer.buttonOptIn,GameWorld.textHandler.getTextFromId("ToolTipJoinGourmetClub"));
               if(GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_RANDOM_STREET))
               {
                  onButtonOptInClick(null);
                  GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_RANDOM_STREET);
               }
            }
            else if(curStreetType == STREET_TYPE_GOURMET)
            {
               if(GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GOURMET_STREET))
               {
                  GameWorld.showTutorialTextPopUp(GameWorld.textHandler.getTextFromId("TutorialGourmetStreet"));
                  GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GOURMET_STREET);
               }
            }
            else
            {
               setButtonMode(buttonLayer.buttonRestaurantDesigner,true);
               buttonLayer.buttonRestaurantDesigner.addEventListener(MouseEvent.CLICK,restaurantDesignerClicked);
               buttonLayer.buttonRestaurantDesigner.toolTip = new ToolTip(buttonLayer.buttonRestaurantDesigner,GameWorld.textHandler.getTextFromId("ToolTipDecorateTheBuilding"));
               searchBox = buttonLayer.mc_search;
               searchBox.tf_searchText.addEventListener(Event.CHANGE,onSearchTextChanged,false,0,true);
               searchBox.mc_cross.gotoAndStop("grey");
               if(GameWorld.gameUser.settings.getValue(GameSettings.TYPE_STREET_TUTORIAL_STEP) == 0)
               {
                  new TutorialStreet();
               }
            }
            if(buttonLayer.buttonStreet)
            {
               setButtonMode(buttonLayer.buttonStreet,true);
               buttonLayer.buttonStreet.addEventListener(MouseEvent.CLICK,onButtonStreetClick,false,0,true);
               buttonLayer.buttonStreet.toolTip = new ToolTip(buttonLayer.buttonStreet,GameWorld.textHandler.getTextFromId("ToolTipBackToMyStreet"));
            }
            if(buttonLayer.buttonRandomStreet)
            {
               setButtonMode(buttonLayer.buttonRandomStreet,true);
               buttonLayer.buttonRandomStreet.addEventListener(MouseEvent.CLICK,onRandomStreetClick,false,0,true);
               buttonLayer.buttonRandomStreet.toolTip = new ToolTip(buttonLayer.buttonRandomStreet,GameWorld.textHandler.getTextFromId("ToolTipGoToRandomStreet"));
               buttonLayer.buttonRandomStreet.mc_new.mouseEnabled = false;
               if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_RANDOM_STREET))
               {
                  buttonLayer.buttonRandomStreet.mc_new.visible = false;
               }
            }
            if(buttonLayer.buttonGourmetStreet)
            {
               setButtonMode(buttonLayer.buttonGourmetStreet,true);
               buttonLayer.buttonGourmetStreet.addEventListener(MouseEvent.CLICK,onGourmetStreetClick,false,0,true);
               buttonLayer.buttonGourmetStreet.toolTip = new ToolTip(buttonLayer.buttonGourmetStreet,GameWorld.textHandler.getTextFromId("ToolTipGourmetStreet"));
               buttonLayer.buttonGourmetStreet.mc_new.mouseEnabled = false;
               if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GOURMET_STREET))
               {
                  buttonLayer.buttonGourmetStreet.mc_new.visible = false;
               }
            }
            if(buttonLayer.buttonPhoto)
            {
               setButtonMode(buttonLayer.buttonPhoto,true);
               buttonLayer.buttonPhoto.addEventListener(MouseEvent.CLICK,onPhotoClick);
               buttonLayer.buttonPhoto.toolTip = new ToolTip(buttonLayer.buttonPhoto,GameWorld.textHandler.getTextFromId("ToolTipPhoto"));
               buttonLayer.buttonPhoto.mc_new.mouseEnabled = false;
               if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_PHOTO))
               {
                  buttonLayer.buttonPhoto.mc_new.visible = false;
               }
            }
            if(buildings.length > 0)
            {
               foodKing = new FoodKing(null,this);
               foodKing.addToStreet();
            }
            GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_STREET);
         }
      }
      
      private function onFullScreen(param1:Event) : void
      {
         bgSky.x = Engine.getStageX();
         bgSky.y = Engine.getStageY();
         bgSky.width = Engine.getStageWidth();
         bgSky.height = Engine.getStageHeight();
         createBgRoad();
         bgLayer.x = -Engine.getStageWidth() / 2;
         curUserList.y = Engine.getStageBottom();
         if(!intro)
         {
            buttonLayer.y = Engine.getStageBottom();
            buttonLayer.leftButton.x = Engine.getStageX() - buttonLayer.leftButton.getBounds(null).left + 5;
            buttonLayer.rightButton.x = Engine.getStageRight() - buttonLayer.rightButton.getBounds(null).right - 5;
         }
         if(searchBox)
         {
            if(Engine.isFullScreen())
            {
               searchBox.visible = false;
            }
            else
            {
               searchBox.visible = true;
            }
         }
      }
      
      private function createBgRoad() : void
      {
         bgRoad.graphics.clear();
         var _loc1_:Number = canvasHeight;
         var _loc2_:Number = Engine.getStageBottom() - _loc1_;
         if(_loc2_ > 0)
         {
            bgRoad.graphics.beginFill(STREET_ROAD_COLOUR[curStreetType]);
            bgRoad.graphics.drawRect(Engine.getStageX(),_loc1_,Engine.getStageWidth(),_loc2_);
            bgRoad.graphics.endFill();
         }
         bgRoad.x = -bgRoad.width / 2;
         bgRoad.y = -buildingY;
      }
      
      override public function hideNotify() : void
      {
         var _loc2_:int = getTimer();
         PerfTrace.mark("WorldStreet.hideNotify begin actors=" + actors.length);
         var _loc1_:Number = actors.length - 1;
         while(_loc1_ >= 0)
         {
            removeStreetActor(actors[_loc1_]);
            _loc1_--;
         }
         if(!intro)
         {
            removeObject(curUserList);
            curUserList.removeEventListener(FriendListEvent.USER_CLICKED,onFriendListUserClicked);
         }
         GameWorld.cashPanel.visible = true;
         removeObject(GameWorld.cashPanel);
         GameWorld.cashPanel.showPlayfishCash();
         userFaceBitmaps.releaseAll();
         bgMusic.stop();
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onFullScreen);
         PerfTrace.slow("WorldStreet.hideNotify end",_loc2_,5);
      }
      
      private function searchUsers(param1:String) : Array
      {
         var _loc4_:GameUser = null;
         var _loc5_:String = null;
         var _loc2_:Array = new Array();
         param1 = param1.toLowerCase();
         var _loc3_:Number = 0;
         while(_loc3_ < streetUsers.length)
         {
            _loc4_ = streetUsers[_loc3_];
            _loc5_ = _loc4_.firstName.toLowerCase();
            if(_loc5_.indexOf(param1) == 0)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function onFriendsInvitePopUpCancelClick(param1:MouseEvent) : void
      {
         logoMovieClip.play();
      }
      
      public function getBuildingLayer() : BaseObject
      {
         return buildingLayer;
      }
      
      private function onFriendListUserClicked(param1:FriendListEvent) : void
      {
         focusOnBuilding(param1.user);
      }
      
      private function onEmployeesLoadOK(param1:RpcEvent) : void
      {
         destroy();
         GameWorld.fadeToWorld(new WorldRestaurantPlay(targetUser,targetUser != GameWorld.gameUser,streetType == STREET_TYPE_RANDOM));
      }
      
      private function onRandomStreetClick(param1:MouseEvent) : void
      {
         var _loc2_:RpcRequestManager = new RpcRequestManager();
         _loc2_.loadingPopUp = new WorldLoadingPopUp("Loading...",WorldLoadingPopUp.RANDOM_STREET);
         _loc2_.retryText = GameWorld.textHandler.getTextFromId("EnterStreetRetryText");
         var _loc3_:RpcGetStreetRestaurant = _loc2_.getStreetRestaurant(NUM_RANDOM_STREET_USERS);
         _loc3_.addEventListener(RpcEvent.SUCCESS,onGetStreetRestaurantOK);
         _loc2_.commit();
      }
      
      private function setZoomingTransparency() : void
      {
         var _loc1_:int = buildings.indexOf(targetBuilding);
         var _loc2_:Number = _loc1_ - 1;
         while(_loc2_ <= _loc1_ + 1)
         {
            if(_loc2_ != _loc1_ && Boolean(buildings[_loc2_]))
            {
               buildings[_loc2_].alpha = 1 - (sceneLayer.scaleX - 1) / 0.4;
            }
            _loc2_++;
         }
      }
      
      private function onSpecialBannerClick(param1:MouseEvent) : void
      {
         var _loc2_:StreetBuilding = null;
         if(!sceneLayer.moveGesture)
         {
            _loc2_ = StreetBuilding(param1.currentTarget);
            if(_loc2_.overrideBuilding.itemConfig.url)
            {
               GameWorld.openUrl(_loc2_.overrideBuilding.itemConfig.url);
            }
         }
      }
      
      public function getBuildings() : Array
      {
         return buildings;
      }
      
      private function buildingNeedLoadItemContext(param1:StreetBuilding) : Boolean
      {
         return param1 != null && param1.user != null && !param1.user.userInfo.offlineShard && param1.user.needLoadItemContext(GameUser.ITEM_CONTEXT_BUILDING);
      }
      
      public function removeStreetActor(param1:StreetActor) : void
      {
         buildingLayer.removeObject(param1);
         actors.splice(actors.indexOf(param1),1);
         param1.street = null;
         cachedActors.push(param1);
      }
      
      public function removeObjectFromStreet(param1:BaseObject) : void
      {
         buildingLayer.removeObject(param1);
      }
      
      public function avaterClicked(param1:MouseEvent) : void
      {
         Engine.setActiveWorld(new WorldCustomiseAvatar(GameWorld.gameUser,GameWorld.gameUser));
      }
      
      private function onButtonStreetClick(param1:MouseEvent) : void
      {
         destroy();
         WorldStreet.streetType = STREET_TYPE_FRIENDS;
         WorldStreet.streetUsers = GameWorld.getPlayingFriendUsers();
         WorldStreet.streetUserList = GameWorld.friendsListPanel;
         GameWorld.fadeToWorld(new WorldStreet(null,false,false));
      }
      
      private function onBuildingClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldInfoPopUp = null;
         var _loc3_:RpcRequestManager = null;
         if(!sceneLayer.moveGesture)
         {
            targetUser = param1.currentTarget.user;
            if(targetUser.userInfo.offlineShard)
            {
               _loc2_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("UserMaintenance"));
               _loc2_.show();
            }
            else if(targetUser == GameWorld.gameUser)
            {
               destroy();
               GameWorld.fadeToWorld(new WorldRestaurantPlay(targetUser,false));
            }
            else if(targetUser.hasItemContextLoaded(GameUser.ITEM_CONTEXT_RESTAURANT) && GameWorld.gameUser.hasVisitedFriend(targetUser))
            {
               onRestaurantLoadOK(null);
            }
            else
            {
               state = STATE_LOADING_RESTAURANT;
               _loc3_ = new RpcRequestManager();
               loadingPopUp = new WorldLoadingPopUp("Entering...",WorldLoadingPopUp.ENTERING);
               _loc3_.loadingPopUp = loadingPopUp;
               _loc3_.keepLoadingPopUpOnSuccess = true;
               _loc3_.retryText = GameWorld.textHandler.getTextFromId("LoadRestaurantRetryText");
               _loc3_.retryCancelCallBack = onRetryCancel;
               _loc3_.getFriendsDetails([targetUser],GameUser.ITEM_CONTEXT_RESTAURANT);
               if(curStreetType == STREET_TYPE_FRIENDS && !GameWorld.gameUser.hasVisitedFriend(targetUser))
               {
                  _loc3_.firstTimeVisitFriend(targetUser);
               }
               _loc3_.addEventListener(RpcEvent.SUCCESS,onRestaurantLoadOK);
               _loc3_.commit();
            }
         }
      }
      
      public function startIntroMovieClip() : void
      {
         logoMovieClip.play();
      }
      
      private function onBookmarkReminderRemoved() : void
      {
         logoMovieClip.play();
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:WorldRestaurantPlay = null;
         var _loc3_:StreetActor = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         if(logoMovieClip != null)
         {
            sceneLayer.y = logoMovieClip.mc_street.y;
            sceneLayer.scaleX = logoMovieClip.mc_street.scaleX;
            sceneLayer.scaleY = logoMovieClip.mc_street.scaleY;
            if(logoMovieClip.currentFrame >= logoMovieClip.totalFrames)
            {
               logoMovieClip.stop();
               logoMovieClip = null;
               destroy();
               _loc2_ = new WorldRestaurantPlay(GameWorld.gameUser);
               GameWorld.fadeToWorld(_loc2_);
               if(Debug.FORCE_ENABLE_TUTORIAL || GameWorld.gameUser.userInfo.playCount <= 1 || GameWorld.gameUser.level.value == 0)
               {
                  if(GameWorld.gameUser.employeeUsers.length < 2)
                  {
                     new Tutorial1(_loc2_);
                  }
                  else
                  {
                     GameWorld.hiredFriendsPanel.show();
                     new Tutorial5(_loc2_);
                  }
               }
               else
               {
                  GameWorld.hiredFriendsPanel.show();
               }
            }
            return;
         }
         if(actors.length < 10)
         {
            if(cachedActors.length > 0)
            {
               _loc4_ = Engine.rnd(0,cachedActors.length);
               _loc3_ = cachedActors[_loc4_];
               cachedActors.splice(_loc4_,1);
               _loc3_.reset();
            }
            else
            {
               _loc3_ = new StreetActor(new GameUser(null));
            }
            _loc3_.street = this;
            actors.push(_loc3_);
            if(Engine.rnd(0,2) == 0)
            {
               _loc3_.x = -buildingLayer.x - Engine.rnd(canvasWidth / 2,2 * canvasWidth);
               _loc3_.moveRight();
            }
            else
            {
               _loc3_.x = -buildingLayer.x + Engine.rnd(canvasWidth / 2,2 * canvasWidth);
               _loc3_.moveLeft();
            }
            _loc3_.y = buildingLayer.y;
            _loc3_.scaleX = 0.6;
            _loc3_.scaleY = 0.6;
            _loc3_.drawPriority = 100;
            buildingLayer.addObject(_loc3_);
         }
         if(state == STATE_PANNING)
         {
            _loc5_ = -targetBuilding.x;
            if(Math.abs(buildingLayer.x - _loc5_) > 2)
            {
               buildingLayer.x += (_loc5_ - buildingLayer.x) / 4;
            }
            else
            {
               buildingLayer.x = _loc5_;
               state = STATE_ZOOMING_IN;
            }
         }
         else if(state == STATE_PANNING_TO_BUILDING)
         {
            _loc5_ = -targetBuilding.x;
            if(Math.abs(buildingLayer.x - _loc5_) > 2)
            {
               buildingLayer.x += (_loc5_ - buildingLayer.x) / 4;
            }
            else
            {
               sceneLayer.scrollEnabled = true;
               state = STATE_NORMAL;
            }
         }
         else if(state == STATE_ZOOMING_IN)
         {
            sceneLayer.scaleX += 0.05;
            sceneLayer.scaleY += 0.05;
            setZoomingTransparency();
            if(sceneLayer.scaleX >= WorldCustomiseBuilding.ZOOM_SCALE)
            {
               sceneLayer.scaleX = WorldCustomiseBuilding.ZOOM_SCALE;
               sceneLayer.scaleY = WorldCustomiseBuilding.ZOOM_SCALE;
               setZoomingTransparency();
               sceneLayer.scrollEnabled = false;
               sceneLayer.keyboardEnabled = false;
               sceneLayer.removeChild(bgRoad);
               sceneLayer.removeObject(buildingLayer);
               Engine.setActiveWorld(new WorldCustomiseBuilding(itemDatabase,playerBuilding,sceneLayer,bgLayer));
               return;
            }
         }
         else if(state == STATE_ZOOMING_OUT)
         {
            sceneLayer.scaleX -= 0.05;
            sceneLayer.scaleY -= 0.05;
            setZoomingTransparency();
            if(sceneLayer.scaleX <= 1)
            {
               sceneLayer.scaleX = 1;
               sceneLayer.scaleY = 1;
               setZoomingTransparency();
               state = STATE_NORMAL;
            }
         }
         else if(state == STATE_ZOOMING_IN_TO_RESTAURANT)
         {
            sceneLayer.scaleX += 0.1;
            sceneLayer.scaleY += 0.1;
            if(sceneLayer.scaleX >= 4)
            {
               sceneLayer.scaleX = 4;
               sceneLayer.scaleY = 4;
                PerfTrace.mark("WorldStreet entering restaurant");
                Engine.setActiveWorld(new WorldRestaurantPlay(GameWorld.gameUser));
            }
         }
         else if(state == STATE_ZOOMING_OUT_FROM_RESTAURANT)
         {
            sceneLayer.scaleX -= 0.4;
            sceneLayer.scaleY -= 0.4;
            if(sceneLayer.scaleX <= 1)
            {
               sceneLayer.scaleX = 1;
               sceneLayer.scaleY = 1;
               state = STATE_NORMAL;
            }
         }
         else if(state == STATE_NORMAL)
         {
         }
         tickBgLayer();
      }
      
      override public function showNotify() : void
      {
         var _loc1_:int = getTimer();
         PerfTrace.mark("WorldStreet.showNotify begin intro=" + intro);
         if(!intro)
         {
            curUserList.refresh();
            addObject(curUserList);
            curUserList.addEventListener(FriendListEvent.USER_CLICKED,onFriendListUserClicked,false,0,true);
         }
         addObject(GameWorld.cashPanel);
         GameWorld.cashPanel.hidePlayfishCash();
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,0,true);
         onFullScreen(null);
         bgMusic.play(-1);
         PerfTrace.slow("WorldStreet.showNotify end",_loc1_,5);
      }
      
      private function onInviteClick(param1:MouseEvent) : void
      {
         if(!sceneLayer.moveGesture)
         {
            GameWorld.onInviteClicked();
         }
      }
      
      private function focusOnBuilding(param1:GameUser) : void
      {
         var _loc2_:Number = NaN;
         if(state == STATE_NORMAL || state == STATE_PANNING_TO_BUILDING)
         {
            _loc2_ = 0;
            while(_loc2_ < buildings.length)
            {
               if(param1 == buildings[_loc2_].user)
               {
                  targetBuilding = buildings[_loc2_];
                  sceneLayer.scrollEnabled = false;
                  state = STATE_PANNING_TO_BUILDING;
                  break;
               }
               _loc2_++;
            }
         }
      }
      
      private function tickBgLayer() : void
      {
         var _loc5_:int = 0;
         var _loc6_:GameUser = null;
         var _loc7_:MovieClip = null;
         var _loc8_:RpcGetFriendsDetails = null;
         var _loc1_:int = Math.floor(Engine.getStageWidth() / BUILDING_GAP) + 1;
         var _loc2_:int = Math.max(Math.floor(-buildingLayer.x / BUILDING_GAP) - 1,0);
         var _loc3_:int = Math.min(_loc2_ + _loc1_ + 1,facePanels.length - 1);
         var _loc4_:int = 0;
         while(_loc4_ < visibleBuildingIndices.length)
         {
            _loc5_ = int(visibleBuildingIndices[_loc4_]);
            if(_loc5_ < _loc2_ || _loc5_ > _loc3_)
            {
               Debug.out("unload building " + _loc5_);
               if(facePanels[_loc4_])
               {
                  facePanels[_loc4_].visible = false;
               }
               buildings[_loc5_].visible = false;
               buildings[_loc5_].unload();
            }
            _loc4_++;
         }
         visibleBuildingIndices.splice(0,visibleBuildingIndices.length);
         _loc4_ = _loc2_;
         while(_loc4_ <= _loc3_)
         {
            _loc6_ = buildings[_loc4_].user;
            if(_loc6_ != null)
            {
               if(facePanels[_loc4_] != null && facePanels[_loc4_].faceImage == null)
               {
                  facePanels[_loc4_].faceImage = userFaceBitmaps.getBitmap(_loc6_.imageUrl);
                  if(facePanels[_loc4_].faceImage)
                  {
                     facePanels[_loc4_].mc_frame.mc_face.addChild(facePanels[_loc4_].faceImage);
                  }
               }
               if(Debug.GENERATE_RANDOM_STREET_BUILDING || _loc6_.hasItemContextLoaded(GameUser.ITEM_CONTEXT_BUILDING))
               {
                  if(!buildings[_loc4_].isLoaded())
                  {
                     if(buildings[_loc4_].loadingBuilding != null)
                     {
                        buildings[_loc4_].removeChild(buildings[_loc4_].loadingBuilding);
                        buildings[_loc4_].loadingBuilding = null;
                     }
                     buildings[_loc4_].load();
                     buildings[_loc4_].startItemFunctions();
                     Debug.out("load building " + _loc4_);
                  }
               }
               else
               {
                  if(buildings[_loc4_].loadingBuilding == null)
                  {
                     _loc7_ = Engine.getMovieClip("LoadingHouse");
                     buildings[_loc4_].addChild(_loc7_);
                     buildings[_loc4_].loadingBuilding = _loc7_;
                  }
                  if(!intro)
                  {
                     if(_loc6_.needLoadItemContext(GameUser.ITEM_CONTEXT_BUILDING))
                     {
                        _loc8_ = new RpcGetFriendsDetails(getUsersWithoutBuildingItems(_loc4_),GameUser.ITEM_CONTEXT_BUILDING,false);
                        _loc8_.commit();
                     }
                  }
               }
            }
            else if(!buildings[_loc4_].isLoaded())
            {
               buildings[_loc4_].load();
            }
            if(facePanels[_loc4_])
            {
               facePanels[_loc4_].visible = true;
            }
            buildings[_loc4_].visible = true;
            visibleBuildingIndices.push(_loc4_);
            _loc4_++;
         }
         bgLayer.y = buildingLayer.y - buildingLayer.y * buildingLayer.scaleY;
         bgLayer.setX(buildingLayer.x - 1000);
      }
      
      private function onPhotoClick(param1:MouseEvent) : void
      {
         buttonLayer.buttonPhoto.mc_new.visible = false;
         var _loc2_:BitmapData = GameWorld.convertToBitmapData(sceneParentLayer,1,new Rectangle(0,0,canvasWidth,canvasHeight),WorldPhotoPreviewPopUp.MAX_PHOTO_WIDTH,WorldPhotoPreviewPopUp.MAX_PHOTO_HEIGHT);
         var _loc3_:WorldPhotoPreviewPopUp = new WorldPhotoPreviewPopUp([_loc2_]);
         _loc3_.show();
      }
      
      public function addObjectToStreet(param1:BaseObject) : void
      {
         buildingLayer.addObject(param1);
      }
      
      public function restaurantDesignerClicked(param1:MouseEvent) : void
      {
         if(playerBuilding == null)
         {
            Debug.out("WorldStreet.restaurantDesignerClicked: player building is missing from street roster");
            return;
         }
         if(buttonLayer.buttonRestaurantDesigner)
         {
            buttonLayer.buttonRestaurantDesigner.removeEventListener(MouseEvent.CLICK,restaurantDesignerClicked);
         }
         buttonLayer.buttonMyRestaurant.removeEventListener(MouseEvent.CLICK,myRestaurantClicked);
         targetBuilding = playerBuilding;
         var _loc2_:Number = 0;
         while(_loc2_ < buildings.length)
         {
            buildings[_loc2_].buttonMode = false;
            buildings[_loc2_].removeEventListener(MouseEvent.CLICK,onBuildingClick);
            _loc2_++;
         }
         state = STATE_PANNING;
      }
      
      private function onFriendsInvitePopUpOKClick(param1:MouseEvent) : void
      {
         var ep:ExternalPage = null;
         var e:MouseEvent = param1;
         try
         {
            ep = GameWorld.onInviteClicked();
            ep.addEventListener(ExternalPageEvent.COMPLETE,onFriendsInvitePopUpComplete);
         }
         catch(e:Error)
         {
            logoMovieClip.play();
         }
      }
      
      private function onGourmetStreetClick(param1:MouseEvent) : void
      {
         var _loc2_:RpcRequestManager = new RpcRequestManager();
         _loc2_.loadingPopUp = new WorldLoadingPopUp("Loading...",WorldLoadingPopUp.GOURMET_STREET);
         _loc2_.retryText = GameWorld.textHandler.getTextFromId("EnterStreetRetryText");
         var _loc3_:RpcGetGourmetStreetUsers = _loc2_.getGourmetStreetUsers(NUM_GOURMET_STREET_USERS);
         _loc3_.addEventListener(RpcEvent.SUCCESS,onGetGourmetStreetUsersOK);
         _loc2_.commit();
      }
      
      private function onGetStreetRestaurantOK(param1:RpcEvent) : void
      {
         var _loc2_:RpcGetStreetRestaurant = RpcGetStreetRestaurant(param1.currentTarget);
         var _loc3_:Array = _loc2_.newUsers;
         destroy();
         WorldStreet.streetType = STREET_TYPE_RANDOM;
         WorldStreet.streetUsers = _loc3_;
         WorldStreet.streetUserList = new WorldFriendsList(_loc3_,false);
         WorldStreet.streetUserList.y = Engine.STAGE_HEIGHT;
         WorldStreet.streetUserList.drawPriority = 10000;
         GameWorld.fadeToWorld(new WorldStreet(null,false,false));
      }
      
      private function onRestaurantLoadOK(param1:RpcEvent) : void
      {
         if(loadingPopUp != null)
         {
            loadingPopUp.remove();
            loadingPopUp = null;
         }
         targetUser.setEmployeesFromProfile(targetUser.userInfo);
         destroy();
         GameWorld.fadeToWorld(new WorldRestaurantPlay(targetUser,targetUser != GameWorld.gameUser,streetType == STREET_TYPE_RANDOM));
      }
      
      private function onRetryCancel() : void
      {
         state = STATE_NORMAL;
         sceneLayer.scrollEnabled = true;
      }
      
      public function myRestaurantClicked(param1:MouseEvent) : void
      {
         if(buttonLayer.buttonRestaurantDesigner)
         {
            buttonLayer.buttonRestaurantDesigner.removeEventListener(MouseEvent.CLICK,restaurantDesignerClicked);
         }
         buttonLayer.buttonMyRestaurant.removeEventListener(MouseEvent.CLICK,myRestaurantClicked);
         destroy();
         WorldStreet.streetType = STREET_TYPE_FRIENDS;
         WorldStreet.streetUsers = GameWorld.getPlayingFriendUsers();
         WorldStreet.streetUserList = GameWorld.friendsListPanel;
         GameWorld.fadeToWorld(new WorldRestaurantPlay(GameWorld.gameUser,false));
      }
      
      public function hireFriendsClicked(param1:MouseEvent) : void
      {
         Engine.setActiveWorld(new WorldHire());
      }
      
      private function onSearchTextChanged(param1:Event) : void
      {
         var _loc2_:Array = null;
         if(searchBox.tf_searchText.text.length > 0)
         {
            matchedUserIndex = 0;
            _loc2_ = searchUsers(searchBox.tf_searchText.text);
            if(_loc2_.length > 0)
            {
               focusOnBuilding(_loc2_[0]);
               if(_loc2_.length > 1 && searchBox.mc_cross.currentLabel == "grey")
               {
                  setButtonMode(searchBox.mc_cross,true);
                  searchBox.mc_cross.addEventListener(MouseEvent.CLICK,onSearchCrossClick,false,0,true);
                  return;
               }
            }
         }
         setButtonMode(searchBox.mc_cross,false);
         searchBox.mc_cross.gotoAndStop("grey");
         searchBox.mc_cross.removeEventListener(MouseEvent.CLICK,onSearchCrossClick);
      }
      
      private function getUsersWithoutBuildingItems(param1:int) : Array
      {
         var _loc4_:StreetBuilding = null;
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < buildings.length)
         {
            _loc4_ = buildings[param1 - _loc3_];
            if(buildingNeedLoadItemContext(_loc4_))
            {
               _loc2_.push(_loc4_.user);
            }
            _loc4_ = buildings[param1 + 1 + _loc3_];
            if(buildingNeedLoadItemContext(_loc4_))
            {
               _loc2_.push(_loc4_.user);
            }
            if(_loc2_.length >= NUM_BUILDINGS_TO_LOAD_IN_A_BATCH)
            {
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function destroy() : void
      {
         IsoCacherQueue.clearQueue();
      }
      
      private function onNetPromoterCancelClick(param1:MouseEvent) : void
      {
         logoMovieClip.play();
      }
   }
}


package com.playfish.games.cooking
{
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class WorldHire extends BaseWorld
   {
      
      private static const USER_BG_OBJECT_NAMES:Array = ["ParkBench","FireHydrant","TrashBin","BusStop"];
      
      private static const USER_ANIMATION_FOR_BG_OBJECT:Array = [Avatar3D.ANIMATION_HIRE_BENCE,Avatar3D.ANIMATION_HIRE_TRASHCAN,Avatar3D.ANIMATION_HIRE_TRASHCAN,Avatar3D.ANIMATION_HIRE_BUS];
      
      private static const BG_OBJECT_NAMES:Array = ["JobCenter","JunkYard"];
      
      public static const STREET_ROAD_COLOUR:int = 8684672;
      
      public static const NUM_USERS_TO_LOAD_IN_A_BATCH:int = 50;
      
      public static const BG_OBJECT_Y_OFFSET:int = -15;
      
      public static const USER_GAP:Number = Engine.STAGE_WIDTH / 3;
      
      private var searchBox:MovieClip;
      
      private var bgRoad:Shape;
      
      private var users:Array;
      
      public var buttonGourmetStreet:MovieClip;
      
      private var visibleUserIndices:Array;
      
      public var userInfoPopup:Array;
      
      private var leftButton:MovieClip;
      
      private var bgSky:MovieClip;
      
      private var frontLayer:Sprite;
      
      private var userAvatarSprites:Array;
      
      private var scrollPanel:ScrollPanel;
      
      private var groundY:Number = 0;
      
      private var userAvatarImage:Array;
      
      private var buttonLayer:BaseObject;
      
      private var userBgObject:Array;
      
      private var bgMusic:GameSound;
      
      public var buttonMyRestaurant:MovieClip;
      
      private var saveProfile:Boolean = false;
      
      private var rightButton:MovieClip;
      
      private var userFaceImage:Array;
      
      private var parallaxBgLayer:BackgroundLayer;
      
      public function WorldHire()
      {
         var _loc2_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:GameUser = null;
         var _loc11_:int = 0;
         var _loc12_:MovieClip = null;
         users = new Array();
         userAvatarImage = new Array();
         userAvatarSprites = new Array();
         userFaceImage = new Array();
         userInfoPopup = new Array();
         userBgObject = new Array();
         visibleUserIndices = new Array();
         bgMusic = new GameSound("MusicStreet",GameSound.TYPE_MUSIC);
         super();
         var _loc1_:MovieClip = Engine.getMovieClip("HireViewScene");
         groundY = _loc1_.mc_road.y;
         bgRoad = new Shape();
         bgSky = Engine.getMovieClip("StreetSky");
         addChild(bgRoad);
         addChild(bgSky);
         parallaxBgLayer = new BackgroundLayer();
         parallaxBgLayer.addLayer("Clouds",_loc1_.mc_cloud.y,4);
         parallaxBgLayer.addLayer("Bushes",_loc1_.mc_bush.y,2);
         parallaxBgLayer.addLayer("SideWalk",_loc1_.mc_road.y,1);
         addObject(parallaxBgLayer);
         _loc2_ = Engine.getMovieClip("HireFriendsButtons");
         leftButton = _loc2_.mc_left;
         rightButton = _loc2_.mc_right;
         frontLayer = new Sprite();
         frontLayer.x = USER_GAP / 2;
         addChild(frontLayer);
         scrollPanel = new ScrollPanel(frontLayer,this,_loc2_.mc_left,_loc2_.mc_right);
         addObject(scrollPanel);
         var _loc3_:Array = GameWorld.cachedGameUsers[RpcClient.USER_CONTEXT_FRIENDS | RpcClient.TIME_CONTEXT_ALL];
         _loc3_ = GameWorld.sortUsers(_loc3_,GameWorld.compareUserAlphabetAscending);
         var _loc4_:int = Math.floor(_loc3_.length / 10 + 1);
         var _loc5_:Number = USER_GAP * _loc3_.length / _loc4_;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc9_ = Engine.getMovieClip(BG_OBJECT_NAMES[Engine.rnd(0,BG_OBJECT_NAMES.length)]);
            _loc9_.x = _loc5_ * _loc6_ + Engine.rnd(0,_loc5_);
            _loc9_.y = groundY + BG_OBJECT_Y_OFFSET;
            frontLayer.addChild(_loc9_);
            _loc6_++;
         }
         var _loc7_:Number = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc10_ = _loc3_[_loc6_];
            if(!isUserHired(_loc10_,GameWorld.gameUser))
            {
               _loc11_ = Engine.rnd(0,USER_BG_OBJECT_NAMES.length);
               _loc9_ = Engine.getMovieClip(USER_BG_OBJECT_NAMES[_loc11_]);
               _loc9_.x = _loc7_;
               _loc9_.y = groundY;
               _loc9_.index = _loc11_;
               frontLayer.addChild(_loc9_);
               userBgObject.push(_loc9_);
               _loc12_ = Engine.getMovieClip("HirePopup");
               _loc12_.x = _loc7_;
               _loc12_.y = 120;
               _loc12_.tf_name.text = _loc10_.firstName;
               _loc12_.mc_ok.addEventListener(MouseEvent.CLICK,onHireButtonClicked);
               _loc12_.mc_ok.user = _loc10_;
               _loc12_.mc_ok.mc_content.tf_text.mouseEnabled = false;
               setButtonMode(_loc12_.mc_ok,true);
               userInfoPopup.push(_loc12_);
               _loc7_ += USER_GAP;
               users.push(_loc10_);
            }
            _loc6_++;
         }
         scrollPanel.setBounds(USER_GAP / 2,USER_GAP / 2 + _loc7_ - USER_GAP,GameWorld.CANVAS_WIDTH - USER_GAP);
         scrollPanel.setScrollStep(USER_GAP);
         var _loc8_:int = users.indexOf(GameWorld.gameUser);
         if(_loc8_ != -1)
         {
            scrollPanel.focus(USER_GAP * Math.min(Math.max(0,_loc8_ - 1),users.length - 3),true);
         }
         buttonLayer = new BaseObject();
         buttonLayer.drawPriority = 20000;
         addObject(buttonLayer);
         buttonGourmetStreet = _loc2_.mc_gourmetStreet;
         buttonMyRestaurant = _loc2_.mc_myRestaurant;
         buttonLayer.addChild(_loc2_);
         setButtonMode(_loc2_.mc_left,true);
         setButtonMode(_loc2_.mc_right,true);
         setButtonMode(_loc2_.mc_myRestaurant,true);
         setHandCursor(_loc2_.mc_myRestaurant,true);
         setButtonMode(_loc2_.mc_cross,true);
         _loc2_.mc_myRestaurant.addEventListener(MouseEvent.CLICK,onMyRestaurantClick);
         searchBox = _loc2_.mc_search;
         searchBox.tf_searchText.addEventListener(KeyboardEvent.KEY_DOWN,onSearchTextKeyInputDown,false,0,true);
         searchBox.tf_searchText.addEventListener(KeyboardEvent.KEY_UP,onSearchTextKeyInputUp,false,0,true);
         tickBgLayer();
      }
      
      private function setSortedUsers(param1:Array) : void
      {
         var _loc7_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Number = 0;
         while(_loc6_ < users.length)
         {
            _loc7_ = param1.indexOf(users[_loc6_]);
            if(userAvatarImage[_loc6_])
            {
               userAvatarImage[_loc6_].x = userAvatarImage[_loc6_].x - _loc6_ * USER_GAP + _loc7_ * USER_GAP;
               _loc2_[_loc7_] = userAvatarImage[_loc6_];
            }
            userInfoPopup[_loc6_].x = _loc7_ * USER_GAP;
            userBgObject[_loc6_].x = _loc7_ * USER_GAP;
            _loc3_[_loc7_] = userInfoPopup[_loc6_];
            _loc4_[_loc7_] = userFaceImage[_loc6_];
            _loc5_[_loc7_] = userBgObject[_loc6_];
            _loc6_++;
         }
         users = param1;
         userAvatarImage = _loc2_;
         userInfoPopup = _loc3_;
         userBgObject = _loc5_;
      }
      
      private function userNeedToLoadAvatarItem(param1:GameUser) : Boolean
      {
         return param1 && param1.userInfo.playCount >= 1 && !param1.userInfo.offlineShard && param1.needLoadItemContext(GameUser.ITEM_CONTEXT_AVATAR);
      }
      
      public function enableButton(param1:MovieClip) : void
      {
         param1.mouseEnabled = true;
         param1.mouseChildren = true;
         param1.alpha = 1;
      }
      
      private function onStageFullScreen(param1:Event) : void
      {
         GameWorld.hiredFriendsPanel.y = Engine.getStageBottom();
         buttonLayer.y = Engine.getStageBottom();
         parallaxBgLayer.x = Engine.getStageX();
         refreshBgRoad();
         bgSky.y = Engine.getStageY();
         bgSky.x = Engine.getStageX();
         bgSky.width = Engine.getStageWidth();
         bgSky.height = GameWorld.CANVAS_HEIGHT - Engine.getStageY();
         leftButton.x = Engine.getStageX() - leftButton.getBounds(null).left + 5;
         rightButton.x = Engine.getStageRight() - rightButton.getBounds(null).right - 5;
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
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:GameUser = null;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:Avatar3D = null;
         var _loc10_:Object = null;
         var _loc11_:Bitmap = null;
         var _loc12_:RpcGetFriendsDetails = null;
         var _loc13_:Sprite = null;
         if(!GameWorld.isFading())
         {
            _loc2_ = Math.max(0,Math.floor((-frontLayer.x + USER_GAP / 2) / USER_GAP));
            _loc3_ = Math.min(_loc2_ + 4,users.length);
            _loc4_ = int(visibleUserIndices.length - 1);
            while(_loc4_ >= 0)
            {
               _loc5_ = int(visibleUserIndices[_loc4_]);
               if(_loc5_ < _loc2_ || _loc5_ >= _loc3_)
               {
                  if(frontLayer.contains(userInfoPopup[_loc5_]))
                  {
                     frontLayer.removeChild(userInfoPopup[_loc5_]);
                  }
                  if(userAvatarSprites[_loc5_])
                  {
                     userAvatarSprites[_loc5_].addEventListener(MouseEvent.CLICK,onAvatarSpriteClicked,false,0,true);
                     frontLayer.removeChild(userAvatarSprites[_loc5_]);
                     userAvatarSprites[_loc5_] = null;
                  }
                  visibleUserIndices.splice(_loc4_,1);
               }
               _loc4_--;
            }
            _loc4_ = _loc2_;
            while(_loc4_ < _loc3_)
            {
               _loc6_ = users[_loc4_];
               if(_loc6_)
               {
                  if(userFaceImage[_loc4_] == undefined)
                  {
                     _loc8_ = GameWorld.getUserFaceImage(_loc6_);
                     if(_loc8_ != null)
                     {
                        userInfoPopup[_loc4_].mc_face.mc_face.addChild(_loc8_);
                     }
                     userFaceImage[_loc4_] = _loc8_;
                  }
                  _loc7_ = _loc4_ * USER_GAP;
                  if(userAvatarImage[_loc4_] == undefined)
                  {
                     if(_loc6_.userInfo.playCount < 1 || _loc6_.hasItemContextLoaded(GameUser.ITEM_CONTEXT_AVATAR) || _loc6_.userInfo.offlineShard)
                     {
                        _loc9_ = new Avatar3D(GameWorld.baseModel,true);
                        _loc9_.setAvatarItems(_loc6_.getAvatarItems(_loc6_.userInfo.id),_loc6_.hairColour,_loc6_.skinColour);
                        _loc9_.cacheSingleFrame(USER_ANIMATION_FOR_BG_OBJECT[userBgObject[_loc4_].index]);
                        _loc10_ = _loc9_.cachedFrameShape;
                        _loc9_.cachedFrameShape = null;
                        _loc9_.destroy();
                        _loc9_ = null;
                        _loc11_ = new Bitmap(_loc10_.bitmapData);
                        _loc11_.x = _loc10_.x + _loc7_;
                        _loc11_.y = _loc10_.y + groundY;
                        userAvatarImage[_loc4_] = _loc11_;
                        break;
                     }
                     if(_loc6_.needLoadItemContext(GameUser.ITEM_CONTEXT_AVATAR))
                     {
                        _loc12_ = new RpcGetFriendsDetails(getUsersWithoutAvatarItems(_loc4_),GameUser.ITEM_CONTEXT_AVATAR,false);
                        _loc12_.commit();
                     }
                  }
                  if(Boolean(userAvatarImage[_loc4_]) && userAvatarSprites[_loc4_] == null)
                  {
                     _loc13_ = new Sprite();
                     _loc13_.addChild(userAvatarImage[_loc4_]);
                     _loc13_.buttonMode = true;
                     _loc13_.addEventListener(MouseEvent.CLICK,onAvatarSpriteClicked,false,0,true);
                     userAvatarSprites[_loc4_] = _loc13_;
                     frontLayer.addChild(_loc13_);
                  }
                  if(visibleUserIndices.indexOf(_loc4_) == -1)
                  {
                     frontLayer.addChild(userInfoPopup[_loc4_]);
                     visibleUserIndices.push(_loc4_);
                  }
               }
               _loc4_++;
            }
         }
         tickBgLayer();
      }
      
      override public function keyDown(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(Engine.instance.stage.focus != searchBox.tf_searchText)
         {
            if(param2 >= 48 && param2 <= 57 || param2 >= 97 && param2 <= 122)
            {
               searchBox.tf_searchText.appendText(String.fromCharCode(param2));
               _loc3_ = searchUser(searchBox.tf_searchText.text);
               if(_loc3_ != -1)
               {
                  scrollPanel.focus(USER_GAP * Math.min(Math.max(0,_loc3_ - 1),users.length - 3));
               }
            }
            else if(param1 == Engine.KEY_DEL)
            {
               _loc4_ = searchBox.tf_searchText.text;
               if(_loc4_.length > 0)
               {
                  _loc4_ = _loc4_.substring(0,_loc4_.length - 1);
                  searchBox.tf_searchText.text = _loc4_;
                  if(_loc4_.length > 0)
                  {
                     _loc3_ = searchUser(_loc4_);
                     if(_loc3_ != -1)
                     {
                        scrollPanel.focus(USER_GAP * Math.min(Math.max(0,_loc3_ - 1),users.length - 3));
                     }
                  }
               }
            }
         }
      }
      
      private function searchUser(param1:String) : int
      {
         var _loc3_:GameUser = null;
         var _loc4_:String = null;
         param1 = param1.toLowerCase();
         var _loc2_:Number = 0;
         while(_loc2_ < users.length)
         {
            _loc3_ = users[_loc2_];
            _loc4_ = _loc3_.firstName.toLowerCase();
            if(param1 <= _loc4_)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      override public function showNotify() : void
      {
         addObject(GameWorld.hiredFriendsPanel);
         addObject(GameWorld.cashPanel);
         bgMusic.play(-1);
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onStageFullScreen,false,0,true);
         onStageFullScreen(null);
      }
      
      override public function hideNotify() : void
      {
         removeObject(GameWorld.cashPanel);
         var _loc1_:Number = 0;
         while(_loc1_ < userAvatarImage.length)
         {
            if(userAvatarImage[_loc1_])
            {
               userAvatarImage[_loc1_].bitmapData.dispose();
            }
            _loc1_++;
         }
         bgMusic.stop();
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onStageFullScreen);
      }
      
      private function tickBgLayer() : void
      {
         var _loc1_:Number = frontLayer.x - 1000;
         parallaxBgLayer.setX(_loc1_);
      }
      
      public function disableButton(param1:MovieClip) : void
      {
         param1.mouseEnabled = false;
         param1.mouseChildren = false;
         param1.alpha = 0.5;
      }
      
      private function onSearchTextKeyInputDown(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function onInviteClicked(param1:MouseEvent) : void
      {
         if(!scrollPanel.moveGesture)
         {
            GameWorld.onInviteClicked();
         }
      }
      
      private function refreshBgRoad() : void
      {
         bgRoad.graphics.clear();
         var _loc1_:Number = Engine.getStageBottom() - GameWorld.CANVAS_HEIGHT;
         if(_loc1_ > 0)
         {
            bgRoad.graphics.beginFill(STREET_ROAD_COLOUR);
            bgRoad.graphics.drawRect(Engine.getStageX(),GameWorld.CANVAS_HEIGHT,Engine.getStageWidth(),_loc1_);
            bgRoad.graphics.endFill();
         }
      }
      
      private function onGourmetStreetClick(param1:MouseEvent) : void
      {
         GameWorld.fadeToWorld(new WorldStreet(GameWorld.gameUser,false));
      }
      
      public function isUserHired(param1:GameUser, param2:GameUser) : Boolean
      {
         var _loc3_:NetworkUid = param1.userInfo.id;
         var _loc4_:Number = 0;
         while(_loc4_ < param2.employeeUsers.length)
         {
            if(NetworkUid.areEqual(param2.employeeUsers[_loc4_].gameUser.userInfo.id,_loc3_))
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function onHireUser(param1:GameUser) : void
      {
         var _loc2_:WorldInfoPopUp = null;
         var _loc3_:WorldHireEmployeePopUp = null;
         if(GameWorld.gameUser.employeeCount.value >= GameWorld.maxEmployees)
         {
            _loc2_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("NoSlotsToHireEmployees"));
            _loc2_.show();
         }
         else
         {
            _loc3_ = new WorldHireEmployeePopUp(this,param1);
            _loc3_.show();
         }
      }
      
      private function onMyRestaurantClick(param1:MouseEvent) : void
      {
         GameWorld.fadeToWorld(new WorldRestaurantPlay(GameWorld.gameUser));
      }
      
      private function onHireButtonClicked(param1:MouseEvent) : void
      {
         if(!scrollPanel.moveGesture)
         {
            onHireUser(param1.currentTarget.user);
         }
      }
      
      public function removeUser(param1:GameUser) : void
      {
         var _loc2_:int = users.indexOf(param1);
         if(_loc2_ != -1)
         {
            if(userAvatarSprites[_loc2_] != null)
            {
               frontLayer.removeChild(userAvatarSprites[_loc2_]);
               userAvatarSprites[_loc2_] = null;
            }
            frontLayer.removeChild(userInfoPopup[_loc2_]);
            users[_loc2_] = null;
         }
      }
      
      private function onAvatarSpriteClicked(param1:MouseEvent) : void
      {
         var _loc2_:GameUser = null;
         if(!scrollPanel.moveGesture)
         {
            _loc2_ = users[userAvatarSprites.indexOf(param1.currentTarget)];
            if(Debug.assert(_loc2_ != null,"user object not specified for this user"))
            {
               onHireUser(_loc2_);
            }
         }
      }
      
      private function getUsersWithoutAvatarItems(param1:int) : Array
      {
         var _loc4_:GameUser = null;
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < users.length)
         {
            _loc4_ = users[param1 - _loc3_];
            if(userNeedToLoadAvatarItem(_loc4_))
            {
               _loc2_.push(_loc4_);
            }
            _loc4_ = users[param1 + 1 + _loc3_];
            if(userNeedToLoadAvatarItem(_loc4_))
            {
               _loc2_.push(_loc4_);
            }
            if(_loc2_.length >= NUM_USERS_TO_LOAD_IN_A_BATCH)
            {
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function onSearchTextKeyInputUp(param1:KeyboardEvent) : void
      {
         var _loc2_:int = searchUser(searchBox.tf_searchText.text);
         if(_loc2_ != -1)
         {
            scrollPanel.focus(USER_GAP * Math.min(Math.max(0,_loc2_ - 1),users.length - 3));
         }
         param1.stopImmediatePropagation();
      }
   }
}


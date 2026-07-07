package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.rpc.RpcEvent;
   import com.playfish.games.cooking.rpc.RpcRequestManager;
   import com.playfish.games.cooking.rpc.RpcSendMail;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.cooking.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   
   public class WorldWriteMessage extends WorldPopUp
   {
      
      private var userSelectionPanel:ScrollPanel;
      
      private var messageTextField:TextField;
      
      private var searchBox:MovieClip;
      
      private var filteredUserPanels:Array;
      
      private var sceneContent:MovieClip;
      
      private var prevPopUp:WorldPopUp;
      
      private var selectedUserPanel:MovieClip;
      
      private var giftItem:GameItemObject;
      
      private var panelStartX:Number;
      
      private var panelLayer:Sprite;
      
      private var panelGap:Number;
      
      private var giftSentCallBack:Function;
      
      private var userPanels:Array;
      
      private var cancelCallBack:Function;
      
      public function WorldWriteMessage(param1:GameItemObject, param2:GameUser, param3:WorldPopUp, param4:Function = null, param5:Function = null)
      {
         var _loc9_:Array = null;
         var _loc10_:MovieClip = null;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         var _loc13_:MovieClip = null;
         userPanels = new Array();
         super(null,null,null);
         this.prevPopUp = param3;
         this.giftItem = param1;
         this.cancelCallBack = param4;
         this.giftSentCallBack = param5;
         var _loc6_:MovieClip = Engine.getMovieClip("WriteMessageAnim");
         addChild(_loc6_);
         sceneContent = _loc6_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_chooseFriend,"PleaseChooseAFriend");
         messageTextField = sceneContent.tf_message;
         messageTextField.text = "";
         messageTextField.maxChars = 500;
         messageTextField.addEventListener(Event.CHANGE,onMessageTextFieldChange,false,0,true);
         if(param1)
         {
            GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"SendAGift");
            sceneContent.mc_messageIcon.visible = false;
            sceneContent.mc_item.removeChildAt(0);
            _loc10_ = ItemChooser.getItemMovieClip(param1.itemConfig);
            sceneContent.mc_item.addChild(_loc10_);
            sceneContent.tf_itemName.text = param1.itemConfig.name;
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"WriteMessage");
            sceneContent.mc_item.visible = false;
            sceneContent.tf_itemName.visible = false;
         }
         sceneContent.mc_user0.visible = false;
         sceneContent.mc_user1.visible = false;
         sceneContent.mc_user2.visible = false;
         sceneContent.mc_user3.visible = false;
         panelStartX = sceneContent.mc_user0.x;
         panelGap = sceneContent.mc_user1.x - sceneContent.mc_user0.x;
         panelLayer = new Sprite();
         panelLayer.x = panelStartX;
         panelLayer.y = sceneContent.mc_user0.y;
         sceneContent.addChildAt(panelLayer,1);
         var _loc7_:Shape = new Shape();
         _loc7_.graphics.beginFill(0);
         _loc7_.graphics.drawRect(sceneContent.mc_left.x - 20,sceneContent.mc_user0.y - 70,sceneContent.mc_right.x - sceneContent.mc_left.x + 40,140);
         _loc7_.graphics.endFill();
         panelLayer.mask = _loc7_;
         sceneContent.addChild(_loc7_);
         var _loc8_:Number = 0;
         if(param2 != null)
         {
            _loc9_ = [param2];
         }
         else
         {
            _loc11_ = GameWorld.sortUsers(GameWorld.cachedGameUsers[RpcClient.USER_CONTEXT_FRIENDS | RpcClient.TIME_CONTEXT_ALL],GameWorld.compareUserAlphabetAscending);
            _loc9_ = new Array();
            _loc12_ = 0;
            while(_loc12_ < _loc11_.length)
            {
               if(Boolean(_loc11_[_loc12_].userInfo.offlineShard) || _loc11_[_loc12_].userInfo.playCount > 0)
               {
                  _loc9_.push(_loc11_[_loc12_]);
               }
               _loc12_++;
            }
         }
         _loc12_ = 0;
         while(_loc12_ < _loc9_.length)
         {
            _loc13_ = Engine.getMovieClip("UserNameContainer");
            _loc13_.stop();
            _loc13_.x = _loc8_;
            _loc13_.user = _loc9_[_loc12_];
            _loc13_.tf_name.text = _loc9_[_loc12_].firstName;
            _loc13_.tf_name.mouseEnabled = false;
            _loc13_.addEventListener(MouseEvent.MOUSE_DOWN,onUserPanelMouseDown,false,0,true);
            _loc13_.buttonMode = true;
            panelLayer.addChild(_loc13_);
            userPanels.push(_loc13_);
            _loc8_ += panelGap;
            _loc12_++;
         }
         userSelectionPanel = new ScrollPanel(panelLayer,null,sceneContent.mc_left,sceneContent.mc_right);
         userSelectionPanel.setBounds(sceneContent.mc_user0.x,sceneContent.mc_user0.x + _loc8_ - panelGap,panelGap * 3);
         userSelectionPanel.setScrollStep(panelGap);
         userSelectionPanel.keyboardEnabled = false;
         addObject(userSelectionPanel);
         if(userPanels.length == 1)
         {
            selectedUserPanel = userPanels[0];
            selectedUserPanel.gotoAndStop("selected");
            sceneContent.tf_chooseFriend.visible = false;
            sceneContent.mc_left.visible = false;
            sceneContent.mc_right.visible = false;
         }
         filteredUserPanels = userPanels;
         setButtonMode(sceneContent.mc_left,true);
         setButtonMode(sceneContent.mc_right,true);
         setButtonMode(sceneContent.mc_cancel,true);
         setButtonMode(sceneContent.mc_tick,true);
         sceneContent.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         sceneContent.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
         if(param2)
         {
            sceneContent.mc_search.visible = false;
         }
         else
         {
            searchBox = sceneContent.mc_search;
            searchBox.tf_searchText.addEventListener(Event.CHANGE,onSearchTextChanged,false,0,true);
         }
         Engine.setFocus(messageTextField);
         refreshTickButton();
      }
      
      override public function remove() : void
      {
         super.remove();
         if(prevPopUp)
         {
            prevPopUp.show();
         }
         FullScreenTextFieldHandler.unlockTextFieldInFullScreenMode(messageTextField);
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onFullScreen);
      }
      
      private function onUserPanelMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         if(_loc2_ != selectedUserPanel)
         {
            if(selectedUserPanel)
            {
               selectedUserPanel.gotoAndStop("idle");
            }
            selectedUserPanel = _loc2_;
            selectedUserPanel.gotoAndStop("selected");
            refreshTickButton();
         }
      }
      
      private function filterWithString(param1:String) : void
      {
         var _loc4_:GameUser = null;
         param1 = param1.toLowerCase();
         var _loc2_:Number = 0;
         filteredUserPanels = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < userPanels.length)
         {
            _loc4_ = userPanels[_loc3_].user;
            if(_loc4_.firstName.toLowerCase().indexOf(param1) != -1)
            {
               filteredUserPanels.push(userPanels[_loc3_]);
               userPanels[_loc3_].x = _loc2_;
               userPanels[_loc3_].visible = true;
               _loc2_ += panelGap;
            }
            else
            {
               userPanels[_loc3_].visible = false;
            }
            _loc3_++;
         }
         userSelectionPanel.setBounds(sceneContent.mc_user0.x,sceneContent.mc_user0.x + _loc2_ - panelGap,panelGap * 3);
      }
      
      private function onRetryCancel() : void
      {
         GameWorld.error();
      }
      
      private function onFullScreen(param1:Event) : void
      {
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
         if(Engine.isFullScreen())
         {
            FullScreenTextFieldHandler.lockTextFieldInFullScreenMode(messageTextField);
         }
         else
         {
            FullScreenTextFieldHandler.unlockTextFieldInFullScreenMode(messageTextField);
         }
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         var _loc2_:RpcRequestManager = null;
         var _loc3_:RpcSendMail = null;
         if(selectedUserPanel)
         {
            if(giftItem != null)
            {
               _loc2_ = GameWorld.globalRpcs;
               _loc2_.loadingPopUp = new WorldLoadingPopUp("Sending...",giftItem == null ? WorldLoadingPopUp.MESSAGE : WorldLoadingPopUp.GIFTING);
               _loc2_.loadingPopUp.x = GameWorld.CANVAS_CENTER_X;
               _loc2_.loadingPopUp.y = GameWorld.CANVAS_CENTER_Y;
               _loc2_.retryText = GameWorld.textHandler.getTextFromId("SendMailRetryText");
               _loc2_.retryCancelCallBack = onRetryCancel;
               _loc3_ = _loc2_.sendMail(selectedUserPanel.user.userInfo.id,messageTextField.text,giftItem);
               _loc3_.addEventListener(RpcEvent.SUCCESS,onSendMailSuccess);
               GameWorld.commitGlobalRpcs();
            }
            else if(messageTextField.text.length > 0)
            {
               _loc2_ = new RpcRequestManager();
               _loc2_.loadingPopUp = new WorldLoadingPopUp("Sending...",giftItem == null ? WorldLoadingPopUp.MESSAGE : WorldLoadingPopUp.GIFTING);
               _loc2_.loadingPopUp.x = GameWorld.CANVAS_CENTER_X;
               _loc2_.loadingPopUp.y = GameWorld.CANVAS_CENTER_Y;
               _loc2_.retryText = GameWorld.textHandler.getTextFromId("SendMailRetryText");
               _loc2_.retryCancelCallBack = onRetryCancel;
               _loc3_ = _loc2_.sendMail(selectedUserPanel.user.userInfo.id,messageTextField.text,null);
               _loc3_.addEventListener(RpcEvent.SUCCESS,onSendMailSuccess);
               _loc2_.commit();
            }
         }
      }
      
      private function onMessageTextFieldChange(param1:Event) : void
      {
         if(messageTextField.scrollV > 1)
         {
            messageTextField.text = messageTextField.text.substring(0,messageTextField.text.length - 1);
            messageTextField.scrollV = 1;
         }
      }
      
      private function onSendMailSuccess(param1:RpcEvent) : void
      {
         var _loc2_:GameSound = null;
         var _loc3_:WorldInfoPopUp = null;
         Debug.out("onSendMailSuccess");
         if(param1.successCode == RpcClient.STATUS_OK)
         {
            _loc2_ = new GameSound("SfxMessage",GameSound.TYPE_SOUND);
            _loc2_.play(1);
            remove();
            if(giftSentCallBack != null)
            {
               giftSentCallBack(giftItem);
               GameWorld.addGourmetPoints(GameWorld.GOURMET_POINTS_SEND_GIFT);
               GameWorld.addAwardValue(GameAwards.AWARD_GIFT,1);
            }
         }
         else if(param1.successCode == RpcClient.SEND_GIFT_FAIL_RECIPIENT_IN_OFFLINE_SHARD || param1.successCode == RpcClient.SEND_GIFT_FAIL_SENDER_IN_OFFLINE_SHARD)
         {
            _loc3_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("UserMaintenance"));
            _loc3_.show();
         }
      }
      
      private function onSearchTextChanged(param1:Event) : void
      {
         filterWithString(searchBox.tf_searchText.text);
         if(Boolean(selectedUserPanel) && filteredUserPanels.indexOf(selectedUserPanel) == -1)
         {
            selectedUserPanel.gotoAndStop("idle");
            selectedUserPanel = null;
            refreshTickButton();
         }
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
         if(cancelCallBack != null)
         {
            cancelCallBack(giftItem);
         }
      }
      
      private function refreshTickButton() : void
      {
         if(selectedUserPanel)
         {
            setButtonMode(sceneContent.mc_tick,true);
            if(sceneContent.mc_tick.tooltip)
            {
               sceneContent.mc_tick.tooltip.destroy();
               sceneContent.mc_tick.tooltip = null;
            }
         }
         else
         {
            setButtonMode(sceneContent.mc_tick,false);
            sceneContent.mc_tick.gotoAndStop("grey");
            sceneContent.mc_tick.tooltip = new ToolTip(sceneContent.mc_tick,GameWorld.textHandler.getTextFromId("ToolTipSelectAFriendFirst"));
         }
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc2_:int = Math.max(0,Math.ceil((panelStartX - panelLayer.x) / panelGap));
         var _loc3_:int = Math.min(_loc2_ + 4,filteredUserPanels.length);
         var _loc4_:Number = _loc2_;
         while(_loc4_ < _loc3_)
         {
            if(!filteredUserPanels[_loc4_].faceImage)
            {
               _loc5_ = GameWorld.getUserFaceImage(filteredUserPanels[_loc4_].user);
               if(_loc5_ != null)
               {
                  filteredUserPanels[_loc4_].mc_frame.mc_face.addChild(_loc5_);
               }
               filteredUserPanels[_loc4_].faceImage = _loc5_;
            }
            _loc4_++;
         }
      }
      
      override public function show() : void
      {
         super.show();
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,0,true);
         onFullScreen(null);
      }
   }
}


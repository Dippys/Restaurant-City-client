package com.playfish.games.cooking
{
   import com.playfish.games.cooking.debug.DebugOverrideFullScreenAspectRatio;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.games.cooking.utils.LocalStorage;
   import com.playfish.rpc.cooking.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   
   public class OverlaySetting extends BaseWorld
   {
      
      public static const SOUND:int = 0;
      
      public static const MUSIC:int = 1;
      
      public static const QUALITY:int = 2;
      
      public static const FULLSCREEN:int = 3;
      
      public static const LANGUAGE:int = 4;
      
      public static const NUM_SETTINGS:int = 5;
      
      private static const SETTING_NAME:Array = new Array("sound","music","quality","fullscreen","lang");
      
      public static var settingValues:Array = new Array(true,true,true,false,"en");
      
      private static var localStorage:LocalStorage = new LocalStorage("blockz");
      
      private static var hasSentFullScreenEvent:Boolean = false;
      
      private var saveGameTextId:String = "GameSavedStaffNeedsWork";
      
      private var scene:MovieClip;
      
      public function OverlaySetting()
      {
         super();
         scene = Engine.getMovieClip("GameOverlay");
         scene.x = GameWorld.CANVAS_CENTER_X;
         scene.y = GameWorld.CANVAS_CENTER_Y;
         addChild(scene);
         if(!settingValues[SOUND])
         {
            GameSound.setGlobalVolume(0,GameSound.TYPE_SOUND);
         }
         if(!settingValues[MUSIC])
         {
            GameSound.setGlobalVolume(0,GameSound.TYPE_MUSIC);
         }
         if(!settingValues[QUALITY])
         {
            Engine.instance.stage.quality = StageQuality.LOW;
         }
         refreshIcons();
         setButtonMode(scene.saveButton,true);
         scene.soundButton.addEventListener(MouseEvent.CLICK,soundButtonClickListener);
         scene.musicButton.addEventListener(MouseEvent.CLICK,musicButtonClickListener);
         scene.qualityButton.addEventListener(MouseEvent.CLICK,qualityButtonClickListener);
         scene.fullScreenButton.addEventListener(MouseEvent.CLICK,fullScreenButtonClickListener);
         scene.saveButton.addEventListener(MouseEvent.CLICK,saveButtonClickListener);
         scene.soundButton.tooltip = new ToolTip(scene.soundButton,GameWorld.textHandler.getTextFromId("ToolTipSoundFX"),true);
         scene.musicButton.tooltip = new ToolTip(scene.musicButton,GameWorld.textHandler.getTextFromId("ToolTipMusic"),true);
         scene.qualityButton.tooltip = new ToolTip(scene.qualityButton,GameWorld.textHandler.getTextFromId("ToolTipQuality"),true);
         scene.fullScreenButton.tooltip = new ToolTip(scene.fullScreenButton,GameWorld.textHandler.getTextFromId("ToolTipFullScreen"),true);
         scene.saveButton.tooltip = new ToolTip(scene.saveButton,GameWorld.textHandler.getTextFromId("ToolTipSaveGame"),true);
         hideSaveButton();
      }
      
      public static function loadSettings() : void
      {
         var _loc3_:Object = null;
         var _loc1_:String = Engine.instance.getParameterString("pf_lang");
         if(_loc1_ != null)
         {
            settingValues[LANGUAGE] = _loc1_;
         }
         var _loc2_:Number = 0;
         while(_loc2_ < NUM_SETTINGS)
         {
            _loc3_ = localStorage.load(SETTING_NAME[_loc2_]);
            if(_loc3_ != null)
            {
               settingValues[_loc2_] = _loc3_;
            }
            _loc2_++;
         }
         settingValues[FULLSCREEN] = false;
      }
      
      private function onGlobalRpcsRetryCancel() : void
      {
         GameWorld.startGlobalRpcs();
         showSaveButton();
         GameWorld.error();
      }
      
      private function onGlobalRpcsSuccess(param1:RpcEvent) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Bitmap = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:String = null;
         var _loc7_:WorldPopUp = null;
         Debug.out("onGlobalRpcsSuccess");
         if(param1.successCode == RpcClient.STATUS_SAVE_FAIL)
         {
            GameWorld.error();
         }
         else
         {
            _loc2_ = new BitmapData(Engine.getStageWidth(),Engine.getStageHeight());
            _loc2_.draw(Engine.curWorld,new Matrix(1,0,0,1,-Engine.getStageX(),-Engine.getStageY()));
            _loc3_ = new Bitmap(_loc2_);
            _loc3_.x = Engine.getStageX();
            _loc3_.y = Engine.getStageY();
            _loc3_.filters = [new BlurFilter(4,4,BitmapFilterQuality.HIGH)];
            Engine.curWorld.destroy();
            Engine.setActiveWorld(null);
            Engine.worldContainer.addChildAt(_loc3_,0);
            _loc4_ = Engine.getMovieClip("RetryPopupAnim");
            _loc5_ = _loc4_.mc_content;
            checkAllEmployeesResting();
            _loc6_ = GameWorld.textHandler.getTextFromId("GameSaved") + "\n\n" + GameWorld.textHandler.getTextFromId(saveGameTextId) + "\n\n" + GameWorld.textHandler.getTextFromId("GameSavedCrossPromotion" + Engine.rnd(1,4));
            GameWorld.textHandler.setTextField(_loc5_.tf_text,_loc6_,true);
            _loc5_.mc_tick.visible = false;
            _loc5_.mc_cancel.visible = false;
            _loc7_ = new WorldPopUp(_loc4_,null,null);
            _loc7_.show();
         }
      }
      
      public function saveButtonVisible() : Boolean
      {
         return scene.saveButton.visible;
      }
      
      private function abuseButtonClickListener(param1:MouseEvent) : void
      {
      }
      
      public function musicButtonClickListener(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         if(GameSound.getGlobalVolume(GameSound.TYPE_MUSIC) == 0)
         {
            GameSound.setGlobalVolume(1,GameSound.TYPE_MUSIC);
            setButtonMode(scene.musicButton,true,"");
            _loc2_ = true;
         }
         else
         {
            GameSound.setGlobalVolume(0,GameSound.TYPE_MUSIC);
            setButtonMode(scene.musicButton,true,"2");
            _loc2_ = false;
         }
         if(_loc2_ != settingValues[MUSIC])
         {
            saveSetting(MUSIC,_loc2_);
         }
      }
      
      private function checkAllEmployeesResting() : void
      {
         var _loc1_:GameUserEmployee = null;
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < GameWorld.gameUser.employeeUsers.length)
         {
            _loc1_ = GameWorld.gameUser.employeeUsers[_loc3_];
            if(_loc1_.job != GameUserEmployee.JOB_REST)
            {
               _loc2_ = false;
               saveGameTextId = "GameSavedStaffFriendNeedsFeeding";
            }
            _loc3_++;
         }
         determineTextDisplay(_loc2_);
      }
      
      private function determineTextDisplay(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:GameUserEmployee = null;
         var _loc5_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:String = "";
         _loc3_ = GameUserEmployee.MAX_WORK_TIME;
         if(param1)
         {
            _loc9_ = 0;
            while(_loc9_ < GameWorld.gameUser.employeeUsers.length)
            {
               _loc4_ = GameWorld.gameUser.employeeUsers[_loc9_];
               _loc10_ = GameUserEmployee.MAX_WORK_TIME - _loc4_.workTime;
               if(_loc10_ < _loc3_)
               {
                  _loc3_ = _loc10_;
                  _loc5_ = _loc4_.gameUser.firstName;
               }
               _loc9_++;
            }
         }
         else
         {
            _loc11_ = 0;
            while(_loc11_ < GameWorld.gameUser.employeeUsers.length)
            {
               _loc4_ = GameWorld.gameUser.employeeUsers[_loc11_];
               if(_loc4_.workTime < _loc3_)
               {
                  _loc3_ = _loc4_.workTime;
                  _loc5_ = _loc4_.gameUser.firstName;
               }
               _loc11_++;
            }
         }
         GameWorld.textHandler.setReplaceString("friendName",_loc5_);
         _loc3_ += GameWorld.SECOND_MILLIS - 1;
         var _loc6_:int = Math.floor(_loc3_ / GameWorld.HOUR_MILLIS);
         _loc3_ %= GameWorld.HOUR_MILLIS;
         var _loc7_:int = Math.floor(_loc3_ / GameWorld.MINUTE_MILLIS);
         _loc3_ %= GameWorld.MINUTE_MILLIS;
         var _loc8_:int = Math.floor(_loc3_ / GameWorld.SECOND_MILLIS);
         GameWorld.textHandler.setReplaceString("hoursLeft",_loc6_.toString());
         if(_loc3_ < GameWorld.SECOND_MILLIS)
         {
            GameWorld.textHandler.setReplaceString("minutesLeft","1");
         }
         else
         {
            GameWorld.textHandler.setReplaceString("minutesLeft",_loc7_.toString());
         }
      }
      
      public function soundButtonClickListener(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         if(GameSound.getGlobalVolume(GameSound.TYPE_SOUND) == 0)
         {
            GameSound.setGlobalVolume(1,GameSound.TYPE_SOUND);
            setButtonMode(scene.soundButton,true,"");
            _loc2_ = true;
         }
         else
         {
            GameSound.setGlobalVolume(0,GameSound.TYPE_SOUND);
            setButtonMode(scene.soundButton,true,"2");
            _loc2_ = false;
         }
         if(_loc2_ != settingValues[SOUND])
         {
            saveSetting(SOUND,_loc2_);
         }
      }
      
      public function qualityButtonClickListener(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         if(Engine.instance.stage.quality.toUpperCase() == StageQuality.HIGH.toUpperCase())
         {
            Engine.instance.stage.quality = StageQuality.LOW;
            setButtonMode(scene.qualityButton,true,"2");
            _loc2_ = false;
         }
         else
         {
            Engine.instance.stage.quality = StageQuality.HIGH;
            setButtonMode(scene.qualityButton,true);
            _loc2_ = true;
         }
         if(_loc2_ != settingValues[QUALITY])
         {
            saveSetting(QUALITY,_loc2_);
         }
      }
      
      public function showSaveButton() : void
      {
         scene.saveButton.visible = true;
      }
      
      private function saveButtonClickListener(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = Engine.getMovieClip("RetryPopupAnim");
         var _loc3_:MovieClip = _loc2_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_text,"DoYouWantToSaveAndQuit");
         _loc3_.mc_tick.addEventListener(MouseEvent.CLICK,onSaveClick,false,0,true);
         _loc3_.mc_cancel.addEventListener(MouseEvent.CLICK,onSaveCancelClick,false,0,true);
         var _loc4_:WorldPopUp = new WorldPopUp(_loc2_,_loc3_.mc_tick,_loc3_.mc_cancel);
         _loc4_.x = GameWorld.CANVAS_CENTER_X;
         _loc4_.y = GameWorld.CANVAS_CENTER_Y;
         _loc4_.show();
         hideSaveButton();
      }
      
      private function fullScreenButtonClickListener(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(Engine.isFullScreen())
         {
            Engine.setFullScreen(false);
            setButtonMode(scene.fullScreenButton,true,"2");
         }
         else
         {
            if(!hasSentFullScreenEvent)
            {
               GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_FULL_SCREEN_MODE,"fullscreen_entered",function():void
               {
               },function():void
               {
               });
               hasSentFullScreenEvent = true;
            }
            if(Debug.DEBUG && DebugOverrideFullScreenAspectRatio.overrideWidth != 0)
            {
               Engine.setFullScreen(true,DebugOverrideFullScreenAspectRatio.overrideWidth,DebugOverrideFullScreenAspectRatio.overrideHeight);
            }
            else
            {
               Engine.setFullScreen(true,Engine.instance.stage.fullScreenWidth,Engine.instance.stage.fullScreenHeight);
            }
            setButtonMode(scene.fullScreenButton,true,"1");
         }
      }
      
      public function hideSaveButton() : void
      {
         scene.saveButton.visible = false;
      }
      
      private function onSaveCancelClick(param1:MouseEvent) : void
      {
         showSaveButton();
      }
      
      public function saveSetting(param1:int, param2:Object) : void
      {
         settingValues[param1] = param2;
         localStorage.save(SETTING_NAME[param1],param2);
      }
      
      private function onSaveClick(param1:MouseEvent) : void
      {
         GameWorld.stopGlobalRpcs();
         GameWorld.saveProfileHandler.displayMaintenance = false;
         GameWorld.saveProfileHandler.addEventListener(RpcEvent.SUCCESS,onGlobalRpcsSuccess);
         GameWorld.globalRpcs.loadingPopUp = new WorldLoadingPopUp("Saving...",WorldLoadingPopUp.SAVING);
         GameWorld.globalRpcs.loadingPopUp.x = GameWorld.CANVAS_CENTER_X;
         GameWorld.globalRpcs.loadingPopUp.y = GameWorld.CANVAS_CENTER_Y;
         GameWorld.globalRpcs.retryText = GameWorld.textHandler.getTextFromId("ManualSaveRetryText");
         GameWorld.globalRpcs.retryCancelCallBack = onGlobalRpcsRetryCancel;
         GameWorld.commitGlobalRpcs();
      }
      
      public function refreshIcons() : void
      {
         if(GameSound.getGlobalVolume(GameSound.TYPE_SOUND) == 0)
         {
            setButtonMode(scene.soundButton,true,"2");
         }
         else
         {
            setButtonMode(scene.soundButton,true);
         }
         if(GameSound.getGlobalVolume(GameSound.TYPE_MUSIC) == 0)
         {
            setButtonMode(scene.musicButton,true,"2");
         }
         else
         {
            setButtonMode(scene.musicButton,true);
         }
         var _loc1_:String = Engine.instance.stage.quality.toUpperCase();
         if(_loc1_ == StageQuality.HIGH.toUpperCase() || _loc1_ == StageQuality.BEST.toUpperCase())
         {
            setButtonMode(scene.qualityButton,true);
         }
         else
         {
            setButtonMode(scene.qualityButton,true,"2");
         }
         if(Engine.instance.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            setButtonMode(scene.fullScreenButton,true);
         }
         else
         {
            setButtonMode(scene.fullScreenButton,true,"2");
         }
      }
   }
}


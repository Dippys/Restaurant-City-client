package com.playfish.games.cooking
{
   import com.playfish.coretech.billing.*;
   import com.playfish.coretech.engine.PFEngine;
   import com.playfish.coretech.platform.socialnetwork.SocialNetwork;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.utils.*;
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.RpcClientBase;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.*;
   import flash.net.URLVariables;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class Engine extends PFEngine
   {
      
      public static var worldContainer:BaseObject;
      
      public static var instance:Engine;
      
      public static var curWorld:BaseWorld;
      
      public static var stageHeight:uint;
      
      private static var versionBox:MovieClip;
      
      public static var stageWidth:uint;
      
      public static const GAME_VERSION:String = "0.9.143";
      
      // RC Reborn widescreen test (branch widescreen-support): the logical
      // stage width is widened from the shipped 760 to 1067 (16:9 at the
      // shipped 600 height). Every getStage*/STAGE_WIDTH consumer follows.
      public static const STAGE_WIDTH:int = 1067;
      
      public static const STAGE_HEIGHT:int = 600;
      
      public static const PRODUCT_TYPE_RC_COINS:int = 2001;
      
      public static var errorDialogs:Array = new Array();
      
      private static var rand:Random = new Random();
      
      public static const KEY_UP:int = 1 << 0;
      
      public static const KEY_DOWN:int = 1 << 1;
      
      public static const KEY_LEFT:int = 1 << 2;
      
      public static const KEY_RIGHT:int = 1 << 3;
      
      public static const KEY_SPACE:int = 1 << 4;
      
      public static const KEY_DEL:int = 1 << 5;
      
      public static const KEY_F1:int = 1 << 6;
      
      public static const KEY_OTHER:int = 1 << 7;
      
      public static var keyBuffer:int = 0;
      
      public var lastTickTime:int;
      
      public var fpsTextField:TextField;
      
      public var resHandler:ResourceHandler;
      
      public var startServerTime:Date;
      
      public var gameOffsetX:int;
      
      private var gameInitLoader:GameInitLoader;
      
      public var gameOffsetY:int;
      
      public var debugExtra:String;
      
      public function Engine()
      {
         super();
         instance = this;
         this.addEventListener(Event.ADDED_TO_STAGE,init);
      }
      
      public static function isKeyPressed(param1:int) : Boolean
      {
         return (keyBuffer & param1) != 0;
      }
      
      public static function getStageX() : Number
      {
         if(instance.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            return getSafeFullScreenSourceRect().x - instance.gameOffsetX;
         }
         return 0;
      }

      /**
       * RC Reborn: Ruffle can enter browser fullscreen through the page before
       * ActionScript has assigned Stage.fullScreenSourceRect.  Every HUD
       * geometry helper assumes that rectangle exists; a null value throws
       * after CashPanel has already mutated the balance, leaving customer
       * payout state live and repeating the award on every frame.  Fall back
       * to the shipped 760x600 stage and persist it on Stage so all fullscreen
       * listeners observe one valid rectangle.
       */
      private static function getSafeFullScreenSourceRect() : Rectangle
      {
         var _loc1_:Rectangle = instance.stage.fullScreenSourceRect;
         if(_loc1_ == null || _loc1_.width <= 0 || _loc1_.height <= 0)
         {
            _loc1_ = new Rectangle(instance.gameOffsetX,instance.gameOffsetY,STAGE_WIDTH,STAGE_HEIGHT);
            instance.stage.fullScreenSourceRect = _loc1_;
         }
         return _loc1_;
      }
      
      public static function getStageBottom() : Number
      {
         if(instance.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            return getSafeFullScreenSourceRect().bottom - instance.gameOffsetY;
         }
         return STAGE_HEIGHT;
      }
      
      public static function rndFloat(param1:Number, param2:Number) : Number
      {
         return Math.random() * (param2 - param1) + param1;
      }
      
      public static function setFocus(param1:InteractiveObject) : void
      {
         instance.stage.focus = param1;
      }
      
      public static function getStageY() : Number
      {
         if(instance.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            return getSafeFullScreenSourceRect().y - instance.gameOffsetY;
         }
         return 0;
      }
      
      public static function showVersion() : void
      {
         if(versionBox == null)
         {
            versionBox = Engine.getMovieClip("VersionBox");
            versionBox.textField.text += GAME_VERSION;
            versionBox.textField.mouseEnabled = false;
            versionBox.mouseEnabled = false;
            instance.addChild(versionBox);
         }
         else
         {
            instance.removeChild(versionBox);
            versionBox = null;
         }
      }
      
      public static function getAngle(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Number = param3 - param1;
         var _loc6_:Number = param2 - param4;
         if(_loc5_ < 0)
         {
            return Math.atan(_loc6_ / _loc5_) + Math.PI;
         }
         if(_loc5_ > 0)
         {
            if(_loc6_ < 0)
            {
               return 2 * Math.PI + Math.atan(_loc6_ / _loc5_);
            }
            return Math.atan(_loc6_ / _loc5_);
         }
         if(_loc6_ > 0)
         {
            return Math.PI / 2;
         }
         if(_loc6_ < 0)
         {
            return Math.PI + Math.PI / 2;
         }
         return 0;
      }
      
      public static function getStageHeight() : Number
      {
         if(instance.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            return getSafeFullScreenSourceRect().height;
         }
         return STAGE_HEIGHT;
      }
      
      public static function rnd(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         if(param1 == param2)
         {
            return param1;
         }
         if(param1 > param2)
         {
            _loc3_ = param1;
            param1 = param2;
            param2 = _loc3_;
         }
         return rand.nextInt(param2 - param1) + param1;
      }
      
      public static function trim(param1:String) : String
      {
         param1 = param1.replace(/^\s+/,"");
         return param1.replace(/\s+$/,"");
      }
      
      public static function isFullScreen() : Boolean
      {
         return instance.stage.displayState == StageDisplayState.FULL_SCREEN;
      }
      
      /**
       * RC Reborn: ground-truth fullscreen check. Ruffle's virtual
       * stage.displayState can lag the actual browser fullscreen state, which
       * breaks the in-game fullscreen button's toggle. Ask the page (which
       * knows document.fullscreenElement) via ExternalInterface, falling back
       * to the normal check when the bridge is unavailable.
       */
      public static function isBrowserFullScreen() : Boolean
      {
         try
         {
            if(ExternalInterface.available)
            {
               return ExternalInterface.call("rcIsFullscreen") == true;
            }
         }
         catch(e:Error)
         {
         }
         return isFullScreen();
      }
      
      public static function keyUpListener(param1:KeyboardEvent) : void
      {
         var _loc2_:int = translateKeyCode(param1.keyCode);
         keyBuffer &= ~_loc2_;
         if(curWorld != null)
         {
            curWorld.keyUp(_loc2_,param1.charCode);
         }
      }
      
      public static function showErrorDialog(param1:ErrorDialog) : void
      {
         errorDialogs.push(param1);
         param1.x = (instance.stage.stageWidth - param1.width) / 2;
         param1.y = (instance.stage.stageHeight - param1.height) / 2;
         instance.addChild(param1);
      }
      
      public static function getStageRight() : Number
      {
         if(instance.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            return getSafeFullScreenSourceRect().right - instance.gameOffsetX;
         }
         return STAGE_WIDTH;
      }
      
      public static function translateKeyCode(param1:int) : int
      {
         switch(param1)
         {
            case 32:
               return KEY_SPACE;
            case 37:
               return KEY_LEFT;
            case 38:
               return KEY_UP;
            case 39:
               return KEY_RIGHT;
            case 40:
               return KEY_DOWN;
            case 112:
               return KEY_F1;
            case 110:
            case 8:
            case 46:
               return KEY_DEL;
            default:
               return KEY_OTHER;
         }
      }
      
      public static function showMessage(param1:String) : void
      {
         var _loc2_:ErrorDialog = null;
         if(Debug.DEBUG)
         {
            _loc2_ = new ErrorDialog(param1,ErrorDialog.TYPE_MESSAGE);
            _loc2_.x = (instance.stage.stageWidth - _loc2_.width) / 2;
            _loc2_.y = (instance.stage.stageHeight - _loc2_.height) / 2;
            instance.addChild(_loc2_);
         }
      }
      
      public static function quit() : void
      {
         instance.removeChild(worldContainer);
         instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
         instance.stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpListener);
         instance.stage.removeEventListener(Event.ENTER_FRAME,instance.tick);
      }
      
      private static function getBestFitFullScreenSourceRect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Rectangle
      {
         var _loc7_:Number = param3 / param4;
         var _loc8_:Number = param5 / param6;
         if(_loc7_ < _loc8_)
         {
            param5 = param5 * param4 / param6;
            param6 = param4;
         }
         else
         {
            param6 = param6 * param3 / param5;
            param5 = param3;
         }
         return new Rectangle((param3 - param5) / 2 + param1,(param4 - param6) / 2 + param2,param5,param6);
      }
      
      public static function anyKey() : Boolean
      {
         return keyBuffer != 0;
      }
      
      public static function removeErrorDialog(param1:ErrorDialog) : void
      {
         errorDialogs.splice(errorDialogs.indexOf(param1),1);
         instance.removeChild(param1);
      }
      
      public static function getStageWidth() : Number
      {
         if(instance.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            return getSafeFullScreenSourceRect().width;
         }
         return STAGE_WIDTH;
      }
      
      public static function resetKeys() : void
      {
         keyBuffer = 0;
      }
      
      public static function setActiveWorld(param1:BaseWorld) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:int = 0;
         PerfTrace.mark("setActiveWorld begin " + param1);
         if(curWorld != null)
         {
            _loc3_ = getTimer();
            curWorld.hideNotify();
            PerfTrace.slow("setActiveWorld old hideNotify " + curWorld,_loc3_,5);
            _loc3_ = getTimer();
            worldContainer.removeObject(curWorld);
            PerfTrace.slow("setActiveWorld old removeObject " + curWorld,_loc3_,5);
            PerfTrace.mark("setActiveWorld detach snapshot before sync old=" + worldContainer.baseObjects.indexOf(curWorld) + " live=" + worldContainer.newObjects.indexOf(curWorld));
            // BaseObject keeps a second, frame-stable child snapshot in
            // baseObjects. removeObject() only updates newObjects immediately;
            // the old world otherwise remains strongly reachable through the
            // snapshot until the next tick, which is after the explicit GC
            // boundary below. Synchronize it now so the detached restaurant is
            // actually collectible during this transition.
            _loc3_ = getTimer();
            worldContainer.addAndRemoveObjects();
            PerfTrace.slow("setActiveWorld old sync tick snapshot " + curWorld,_loc3_,5);
            PerfTrace.mark("setActiveWorld detach snapshot after sync old=" + worldContainer.baseObjects.indexOf(curWorld));
            // The stage focus is a strong runtime root. Clear it before the
            // collection request; otherwise the outgoing restaurant (and an
            // unfinished visit activity/task/display tree) is still reachable
            // for this GC pass even after removeObject() and curWorld = null.
            instance.stage.focus = null;
            curWorld = null;
            // RC Reborn: a world owns every sound that was started while it
            // was active. Ruffle keeps stopped/completed audio resources in
            // WASM longer than Flash did; letting short restaurant SFX cross
            // world boundaries therefore compounds the emulator's open audio
            // allocation leak during repeated friend visits. Stop the old
            // world's remaining channels and release GameSound's static roots
            // before the replacement world starts its own music and SFX.
            PerfTrace.mark("setActiveWorld cleanup sounds=" + GameSound.activeGameSounds.length + " memory=" + System.totalMemory);
            while(GameSound.activeGameSounds.length > 0)
            {
               GameSound.activeGameSounds[GameSound.activeGameSounds.length - 1].stop();
            }
            GameSound.activeSoundChannels.length = 0;
            GameSound.activeGameSounds.length = 0;
            System.gc();
         }
         curWorld = param1;
         if(curWorld != null)
         {
            _loc3_ = getTimer();
            curWorld.drawPriority = -1;
            PerfTrace.slow("setActiveWorld drawPriority " + curWorld,_loc3_,5);
            _loc3_ = getTimer();
            worldContainer.addObject(curWorld);
            PerfTrace.slow("setActiveWorld worldContainer.addObject " + curWorld,_loc3_,5);
            _loc3_ = getTimer();
            instance.stage.focus = curWorld;
            PerfTrace.slow("setActiveWorld stage.focus " + curWorld,_loc3_,5);
            _loc3_ = getTimer();
            curWorld.showNotify();
            PerfTrace.slow("setActiveWorld showNotify " + curWorld,_loc3_,5);
         }
         _loc3_ = getTimer();
         resetKeys();
         PerfTrace.slow("setActiveWorld resetKeys " + param1,_loc3_,5);
         PerfTrace.slow("setActiveWorld end " + param1,_loc2_,5);
      }
      
      public static function setFullScreen(param1:Boolean, param2:Number = -1, param3:Number = -1) : void
      {
         if(param1)
         {
            if(!isFullScreen())
            {
               if(param2 == -1)
               {
                  param2 = instance.stage.fullScreenWidth;
               }
               if(param3 == -1)
               {
                  param3 = instance.stage.fullScreenHeight;
               }
               instance.stage.fullScreenSourceRect = getBestFitFullScreenSourceRect(instance.gameOffsetX,instance.gameOffsetY,Engine.STAGE_WIDTH,Engine.STAGE_HEIGHT,param2,param3);
               instance.stage.scaleMode = StageScaleMode.SHOW_ALL;
               instance.stage.displayState = StageDisplayState.FULL_SCREEN;
            }
         }
         else
         {
            // RC Reborn: exit through the page when the bridge is available —
            // Ruffle's virtual stage.displayState can be out of sync with the
            // browser, which would make the old `else if(isFullScreen())`
            // guard skip the exit entirely.
            try
            {
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("rcExitFullscreen");
                  return;
               }
            }
            catch(e:Error)
            {
            }
            Engine.instance.stage.displayState = StageDisplayState.NORMAL;
         }
      }
      
      public static function getBitmapData(param1:String) : BitmapData
      {
         var _loc2_:Class = Class(getDefinitionByName(param1));
         return new _loc2_(0,0);
      }
      
      public static function getMovieClip(param1:String) : MovieClip
      {
         var mcClass:Class = null;
         var started:int = 0;
         var result:MovieClip = null;
         var name:String = param1;
         started = getTimer();
         try
         {
            mcClass = Class(getDefinitionByName(name));
            if(mcClass != null)
            {
               result = new mcClass();
               PerfTrace.slow("getMovieClip " + name,started);
               return result;
            }
         }
         catch(ex:Error)
         {
            Debug.out(ex.getStackTrace());
         }
         PerfTrace.slow("getMovieClip failed " + name,started);
         return null;
      }
      
      public static function isObjectVisibleInView(param1:DisplayObject) : Boolean
      {
         var _loc2_:Rectangle = param1.getBounds(instance);
         return _loc2_.right > 0 && _loc2_.bottom > 0 && _loc2_.left < STAGE_WIDTH && _loc2_.top < STAGE_HEIGHT;
      }
      
      public static function keyDownListener(param1:KeyboardEvent) : void
      {
         Debug.out("keycode=" + param1.keyCode + " charCode=" + param1.charCode);
         var _loc2_:int = translateKeyCode(param1.keyCode);
         keyBuffer |= _loc2_;
         if(_loc2_ == KEY_F1)
         {
            showVersion();
         }
         if(curWorld != null)
         {
            curWorld.keyDown(_loc2_,param1.charCode);
         }
      }
      
      private function onGameInitComplete(param1:Event) : void
      {
         var e:Event = param1;
         GameWorld.rpcClient.beginBatch(RpcClient.BATCHMODE_INORDER);
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_INIT_DONE,"country=" + getParameter("pf_user_country"),function():void
         {
         },function():void
         {
         });
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_START,null,function():void
         {
         },function():void
         {
         });
         GameWorld.rpcClient.endBatch();
         if(hasEventListener("init_complete"))
         {
            addEventListener("preload_complete",onPreloadComplete);
            dispatchEvent(new Event("init_complete"));
         }
         else
         {
            onPreloadComplete(null);
         }
      }
      
      private function onPreloadComplete(param1:Event) : void
      {
         PerfTrace.mark("Engine.onPreloadComplete begin");
         Debug.out("preloadComplete");
         gameInitLoader.destroy();
         gameInitLoader = null;
         stage.addEventListener(Event.ENTER_FRAME,tick);
         lastTickTime = new Date().time;
         GameWorld.start();
         PerfTrace.mark("Engine.onPreloadComplete after GameWorld.start");
      }
      
      private function tick(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:int = Math.max(0,_loc2_ - lastTickTime);
         lastTickTime = _loc2_;
         // RC Reborn: cap the frame delta. A single stalled frame (tab
         // throttling, browser freeze, reconnect hiccup) would otherwise hand
         // a huge elapsed-time chunk to GameWorld.tick and drain every
         // employee's stamina in one frame.
         if(_loc3_ > 1000)
         {
            _loc3_ = 1000;
         }
         if(errorDialogs.length == 0)
         {
            GameWorld.tick(_loc3_);
            worldContainer.tickBase(_loc3_);
         }
         if(Debug.DEBUG)
         {
            fpsTextField.height = 500;
            fpsTextField.multiline = true;
            fpsTextField.wordWrap = true;
            fpsTextField.text = "FPS: " + (1000 / _loc3_).toFixed(2) + " MEM: " + System.totalMemory + " Active sounds: " + GameSound.activeGameSounds.length + " " + debugExtra;
         }
      }
      
      public function isLoadingComplete() : Boolean
      {
         return gameInitLoader.fileLoader.completed;
      }
      
      private function init(param1:Event) : void
      {
         // RC Reborn domain lock: the game only boots from the official
         // domain (plus localhost for development). Any other host gets a
         // block screen and the game never starts.
         if(!isDomainAllowed())
         {
            showDomainBlocked();
            return;
         }
         PerfTrace.mark("Engine.init begin");
         initialize();
         stageWidth = STAGE_WIDTH;
         stageHeight = STAGE_HEIGHT;
         var _loc2_:Point = localToGlobal(new Point(0,0));
         gameOffsetX = _loc2_.x;
         gameOffsetY = _loc2_.y;
         stage.stageFocusRect = false;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
         stage.addEventListener(KeyboardEvent.KEY_UP,keyUpListener);
         if(!Debug.DEBUG)
         {
            stage.showDefaultContextMenu = false;
         }
         RpcClientBase.debug = Debug.out;
         RpcClientBase.disableRetryAsGet = true;
         RpcClientBase.responseInitialTimeoutMillis = 90000;
         worldContainer = new BaseObject();
         addChild(worldContainer);
         if(!Debug.NETWORK_ONLY)
         {
            flashVars = new URLVariables(Debug.NETWORK_TEST_FLASH_VARS);
            // RC Reborn: the test flashvars hardcode http://localhost:8090 as
            // the server host. On the live site that would point the game at
            // the visitor's own machine, so every localhost URL is rewritten
            // to this SWF's own origin — works on any domain.
            rewriteServerHost(flashVars);
         }
         GameWorld.rpcClient = new RpcClient(flashVars);
         GameWorld.registerServerEvents();
         SocialNetwork.initialize();
         SocialPlatform.initialize();
         PFBillingSystem.create();
         PFBillingSystem.instance.setGamePrimaryProductType(PRODUCT_TYPE_RC_COINS);
         PFBillingSystem.instance.registerProductType(new PFProductType(PFProductType.PLAYFISH_CASH,"Playfish Cash","AddPlayfishCashWith","NumberOfPlayfishCash","BankMenuPfCashPopup"));
         PFBillingSystem.instance.registerProductType(new PFProductType(PRODUCT_TYPE_RC_COINS,"RC Coins","AddCoinsWith","NumberOfCoins","BankMenuPopup"));
         gameInitLoader = new GameInitLoader();
         gameInitLoader.addEventListener(Event.COMPLETE,onGameInitComplete);
         if(Debug.DEBUG)
         {
            fpsTextField = new TextField();
            fpsTextField.x = 200;
            fpsTextField.width = stageWidth;
            fpsTextField.textColor = 5263440;
            fpsTextField.selectable = false;
            fpsTextField.mouseEnabled = false;
            addChild(fpsTextField);
         }
         PerfTrace.mark("Engine.init end");
      }
      
      public function getTotalLoadingBytes() : int
      {
         return gameInitLoader.fileLoader.getTotalBytes();
      }
      
      public function getLoadedBytes() : int
      {
         return gameInitLoader.fileLoader.getLoadedBytes();
      }
      
      public function hasLoadingStarted() : Boolean
      {
         return gameInitLoader != null && gameInitLoader.fileLoader.isTotalBytesReady();
      }
      
      /**
       * RC Reborn: rewrite the localhost:8090 server URLs in the test flashvars
       * to this SWF's own origin, so the game talks to whatever host served it.
       */
      private static function rewriteServerHost(param1:Object) : void
      {
         var _loc2_:String = "";
         try
         {
            _loc2_ = Engine.instance.loaderInfo.url;
         }
         catch(e:Error)
         {
            _loc2_ = "";
         }
         var _loc3_:Array = _loc2_.match(/^([a-zA-Z][a-zA-Z0-9+.-]*:\/\/[^\/]+)/);
         if(_loc3_ == null || _loc3_.length < 2)
         {
            return;
         }
         var _loc4_:String = _loc3_[1];
         var _loc5_:Array = ["pf_url","pf_res_base_url","pf_game_swf_url","pf_lang_url","pf_billing_config","pf_feed_list","pf_purchase_base"];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            var _loc7_:String = String(param1[_loc5_[_loc6_]]);
            if(_loc7_ != null && _loc7_ != "")
            {
               param1[_loc5_[_loc6_]] = _loc7_.split("http://localhost:8090").join(_loc4_);
            }
            _loc6_++;
         }
      }
      
      /**
       * RC Reborn domain lock. Allowed hosts are the official domain and the
       * local development hosts; anything else is blocked in init().
       */
      private static function isDomainAllowed() : Boolean
      {
         var _loc1_:String = "";
         try
         {
            _loc1_ = instance.loaderInfo.url;
         }
         catch(e:Error)
         {
            _loc1_ = "";
         }
         if(_loc1_ == null || _loc1_ == "")
         {
            // No URL available (local-file or unusual runtime): fail open so
            // the official site can never lock itself out. Re-hosted copies
            // always carry a URL with a foreign host, which is blocked below.
            return true;
         }
         var _loc2_:Array = _loc1_.match(/^[a-zA-Z][a-zA-Z0-9+.-]*:\/\/([^\/?#]+)/);
         var _loc3_:String = (_loc2_ != null && _loc2_.length > 1) ? _loc2_[1] : _loc1_;
         var _loc4_:int = _loc3_.indexOf(":");
         if(_loc4_ >= 0)
         {
            _loc3_ = _loc3_.substring(0,_loc4_);
         }
         _loc3_ = _loc3_.toLowerCase();
         var _loc5_:Array = ["rc-reborn.uk","www.rc-reborn.uk","localhost","127.0.0.1"];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(_loc3_ == _loc5_[_loc6_])
            {
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      private function showDomainBlocked() : void
      {
         var _loc1_:TextField = new TextField();
         _loc1_.width = STAGE_WIDTH;
         _loc1_.height = STAGE_HEIGHT;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.textColor = 0xFFFFFF;
         _loc1_.background = true;
         _loc1_.backgroundColor = 0x1D5478;
         _loc1_.text = "Restaurant City Reborn is only available at rc-reborn.uk\n\nThis copy has been blocked because it is running outside the official domain.";
         addChild(_loc1_);
      }
   }
}


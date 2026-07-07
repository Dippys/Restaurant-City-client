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
      
      public static const STAGE_WIDTH:int = 760;
      
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
            return instance.stage.fullScreenSourceRect.x - instance.gameOffsetX;
         }
         return 0;
      }
      
      public static function getStageBottom() : Number
      {
         if(instance.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            return instance.stage.fullScreenSourceRect.bottom - instance.gameOffsetY;
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
            return instance.stage.fullScreenSourceRect.y - instance.gameOffsetY;
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
            return instance.stage.fullScreenSourceRect.height;
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
            return instance.stage.fullScreenSourceRect.right - instance.gameOffsetX;
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
            return instance.stage.fullScreenSourceRect.width;
         }
         return STAGE_WIDTH;
      }
      
      public static function resetKeys() : void
      {
         keyBuffer = 0;
      }
      
      public static function setActiveWorld(param1:BaseWorld) : void
      {
         if(curWorld != null)
         {
            curWorld.hideNotify();
            worldContainer.removeObject(curWorld);
            curWorld = null;
         }
         curWorld = param1;
         if(curWorld != null)
         {
            curWorld.drawPriority = -1;
            worldContainer.addObject(curWorld);
            instance.stage.focus = curWorld;
            curWorld.showNotify();
         }
         resetKeys();
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
         else if(isFullScreen())
         {
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
         var name:String = param1;
         try
         {
            mcClass = Class(getDefinitionByName(name));
            if(mcClass != null)
            {
               return new mcClass();
            }
         }
         catch(ex:Error)
         {
            Debug.out(ex.getStackTrace());
         }
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
         Debug.out("preloadComplete");
         gameInitLoader.destroy();
         gameInitLoader = null;
         stage.addEventListener(Event.ENTER_FRAME,tick);
         lastTickTime = new Date().time;
         GameWorld.start();
      }
      
      private function tick(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:int = Math.max(0,_loc2_ - lastTickTime);
         lastTickTime = _loc2_;
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
         }
         GameWorld.rpcClient = new RpcClient(flashVars);
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
   }
}


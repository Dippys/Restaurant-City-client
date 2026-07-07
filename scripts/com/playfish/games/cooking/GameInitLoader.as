package com.playfish.games.cooking
{
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.utils.BatchFileLoader;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.system.*;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class GameInitLoader extends EventDispatcher
   {
      
      public static const SWF_ASSET_NAMES:Array = ["game_asset","avatar_asset","indoor_asset","outdoor_asset","perk_asset","ingredient_asset","sound_asset"];
      
      public static const ASSET_NAMES:Array = ["ingredient_bin","model_bin","perk_bin","quiz_bin","recipe_bin","challenge_bin","lang_en","lang_fr","newsletter","avatar_bin","front_bin","restaurant_bin","appointment_bin"];
      
      private var socialNetworkSuccess:Boolean = false;
      
      private var swfsSuccess:Boolean = false;
      
      private var rpcInitRetryCount:int = 0;
      
      public var getAllFriendsRpc:RpcGetAllFriends;
      
      public var getUserProfileRpc:RpcGetUserProfile;
      
      private var swfLoaders:Array;
      
      public var getReceivedMailsRpc:RpcGetReceivedMails;
      
      public var fileLoader:BatchFileLoader;
      
      private var rpcsSuccess:Boolean = false;
      
      public var getCashBalance:RpcGetCashBalance;
      
      private var pendingSwfLoads:int = 0;
      
      public function GameInitLoader()
      {
         var socialNetworkHandler:FacebookHandler = null;
         swfLoaders = new Array();
         super();
         if(Engine.instance.getParameter("pf_network") == "facebook")
         {
            socialNetworkHandler = new FacebookHandler(Engine.instance.getParameterString("fb_sig_api_key"),Engine.instance.stage);
            socialNetworkHandler.addEventListener(Event.COMPLETE,onSocialNetworkInitComplete);
            socialNetworkHandler.addEventListener(FacebookHandler.EVENT_ERROR,onSocialNetworkInitError);
            socialNetworkHandler.init();
         }
         else
         {
            socialNetworkSuccess = true;
         }
         try
         {
            GameWorld.rpcClient.beginBatch(RpcClient.BATCHMODE_INORDER);
            GameWorld.rpcClient.getServerTime(onGetServerTimeSuccess,onGetServerTimeFail);
            GameWorld.rpcClient.init(rpcInitSuccess,rpcInitFail);
            GameWorld.rpcClient.endBatch();
         }
         catch(ex:Error)
         {
            if(Debug.NETWORK_ONLY)
            {
               onInitError(ex.getStackTrace());
            }
            else
            {
               rpcInitSuccess();
            }
         }
      }
      
      private function onGetServerTimeFail() : void
      {
         Debug.out("onGetServerTimeFail");
         Engine.instance.startServerTime = new Date();
      }
      
      private function onSwfLoaded(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.currentTarget);
         _loc2_.removeEventListener(Event.INIT,onSwfLoaded);
         --pendingSwfLoads;
         Debug.out("swf initialized " + pendingSwfLoads + " remaining");
         if(pendingSwfLoads <= 0)
         {
            swfsSuccess = true;
            onLoadSuccess();
         }
      }
      
      public function destroy() : void
      {
         if(fileLoader)
         {
            fileLoader.close();
         }
      }
      
      public function onGameWorldInitSuccess() : void
      {
         Debug.out("onGameWorldInitSuccess");
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onAssetFilesLoaded(param1:Event) : void
      {
         var _loc4_:Loader = null;
         Debug.out("onAssetFilesLoaded");
         var _loc2_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         swfLoaders = new Array();
         pendingSwfLoads = SWF_ASSET_NAMES.length;
         var _loc3_:int = 0;
         while(_loc3_ < SWF_ASSET_NAMES.length)
         {
            _loc4_ = new Loader();
            _loc4_.contentLoaderInfo.addEventListener(Event.INIT,onSwfLoaded,false,0,true);
            _loc4_.loadBytes(fileLoader.getBytes(SWF_ASSET_NAMES[_loc3_]),_loc2_);
            swfLoaders.push(_loc4_);
            _loc3_++;
         }
      }
      
      private function onSocialNetworkInitError(param1:Event) : void
      {
         Debug.out("onSocialNetworkInitError");
         if(Debug.NETWORK_ONLY)
         {
            onInitError("onSocialNetworkInitError " + param1.toString());
         }
         else
         {
            socialNetworkSuccess = true;
            onLoadSuccess();
         }
      }
      
      private function initGameWorld() : void
      {
         try
         {
            GameWorld.init(this);
         }
         catch(ex:Error)
         {
            GameWorld.destroy();
            onInitError(ex.getStackTrace());
         }
      }
      
      private function rpcInitFail() : void
      {
         Debug.out("rpcInitFail");
         if(rpcInitRetryCount >= 2)
         {
            if(Debug.NETWORK_ONLY)
            {
               onInitError("rpcInitFail");
            }
            else
            {
               rpcInitSuccess();
            }
         }
         else
         {
            ++rpcInitRetryCount;
            GameWorld.rpcClient.init(rpcInitSuccess,rpcInitFail);
         }
      }
      
      private function onRpcsSuccess(param1:RpcEvent) : void
      {
         Debug.out("onRpcsSuccess");
         rpcsSuccess = true;
         onLoadSuccess();
      }
      
      private function onAssetFilesIOError(param1:IOErrorEvent) : void
      {
         onInitError("onAssetFilesIOError " + param1.toString());
      }
      
      private function onResHandlerComplete(param1:Event) : void
      {
         var i:int = 0;
         var e:Event = param1;
         Debug.out("onResHandlerComplete");
         try
         {
            fileLoader = new BatchFileLoader();
            i = 0;
            while(i < SWF_ASSET_NAMES.length)
            {
               fileLoader.addFile(SWF_ASSET_NAMES[i],Engine.instance.resHandler.getResUrl(SWF_ASSET_NAMES[i]));
               i++;
            }
            i = 0;
            while(i < ASSET_NAMES.length)
            {
               fileLoader.addFile(ASSET_NAMES[i],Engine.instance.resHandler.getResUrl(ASSET_NAMES[i]));
               i++;
            }
            fileLoader.addEventListener(Event.COMPLETE,onAssetFilesLoaded);
            fileLoader.addEventListener(IOErrorEvent.IO_ERROR,onAssetFilesIOError);
            fileLoader.load();
         }
         catch(ex:Error)
         {
            onInitError(ex.toString());
         }
      }
      
      private function onRpcsFail(param1:RpcEvent) : void
      {
         if(Debug.NETWORK_ONLY)
         {
            onInitError("onRpcsFail " + param1.toString());
         }
         else
         {
            rpcsSuccess = true;
            onLoadSuccess();
         }
      }
      
      private function onLoadSuccess() : void
      {
         Debug.out("onLoadSuccess " + swfsSuccess + " " + rpcsSuccess + " " + socialNetworkSuccess);
         if(swfsSuccess && rpcsSuccess && socialNetworkSuccess)
         {
            initGameWorld();
         }
      }
      
      private function rpcInitSuccess() : void
      {
         var rpcs:RpcRequestManager = null;
         var resConfigUrl:String = null;
         var network:String = null;
         Debug.out("rpcInitSuccess");
         try
         {
            rpcs = new RpcRequestManager(RpcClient.BATCHMODE_CONDITIONAL);
            rpcs.getServerTime();
            getUserProfileRpc = rpcs.getUserProfile();
            getAllFriendsRpc = rpcs.getAllFriends();
            getCashBalance = rpcs.getCashBalance();
            getReceivedMailsRpc = rpcs.getReceivedMails();
            rpcs.getPricepoints(null);
            rpcs.readBookmarkCount();
            rpcs.addEventListener(RpcEvent.SUCCESS,onRpcsSuccess);
            rpcs.addEventListener(RpcEvent.FAIL,onRpcsFail);
            rpcs.commit();
            if(Engine.instance.resHandler == null)
            {
               resConfigUrl = Engine.instance.getParameterString("pf_res_config");
               if(resConfigUrl == null)
               {
                  resConfigUrl = "resconfig.xml";
               }
               network = Engine.instance.getParameterString("pf_network");
               if(network == null)
               {
                  network = "facebook";
               }
               Engine.instance.resHandler = new ResourceHandler(resConfigUrl,network);
               Engine.instance.resHandler.addEventListener(Event.COMPLETE,onResHandlerComplete);
               Engine.instance.resHandler.addEventListener(IOErrorEvent.IO_ERROR,onResHandlerError);
            }
            else
            {
               onResHandlerComplete(null);
            }
         }
         catch(ex:Error)
         {
            onInitError(ex.getStackTrace());
         }
      }
      
      private function onSocialNetworkInitComplete(param1:Event) : void
      {
         Debug.out("onSocialNetworkInitComplete");
         var _loc2_:FacebookHandler = FacebookHandler(param1.currentTarget);
         GameWorld.socialNetworkHandler = _loc2_;
         SocialPlatform.setCurrent(SocialPlatform.createSocialPlatform("restaurantcity",onSocialPlatformCreate,_loc2_.session));
      }
      
      private function onInitError(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:TextField = null;
         Debug.out(param1);
         Engine.instance.dispatchEvent(new Event("init_complete"));
         destroy();
         _loc2_ = Engine.getMovieClip("NetworkError");
         if(_loc2_)
         {
            _loc2_.x = Engine.STAGE_WIDTH / 2;
            _loc2_.y = Engine.STAGE_HEIGHT / 2;
            Engine.instance.addChild(_loc2_);
         }
         _loc3_ = new TextField();
         _loc3_.width = Engine.stageWidth - 60;
         _loc3_.height = 80;
         _loc3_.x = 30;
         _loc3_.y = Engine.stageHeight - _loc3_.height;
         _loc3_.wordWrap = true;
         _loc3_.multiline = true;
         _loc3_.textColor = 5263440;
         _loc3_.text = "Error detail:\n" + param1;
         Engine.instance.addChild(_loc3_);
      }
      
      private function onGetServerTimeSuccess(param1:Date) : void
      {
         Debug.out("onGetServerTimeSuccess");
         Engine.instance.startServerTime = param1;
      }
      
      private function onSocialPlatformCreate() : Boolean
      {
         Debug.out("onSocialPlatformCreate");
         socialNetworkSuccess = true;
         GameWorld.SocialNetworkAvailable = true;
         onLoadSuccess();
         return true;
      }
      
      private function onResHandlerError(param1:IOErrorEvent) : void
      {
         Debug.out("onResHandlerError");
         onInitError("onResHandlerError " + param1.toString());
      }
   }
}


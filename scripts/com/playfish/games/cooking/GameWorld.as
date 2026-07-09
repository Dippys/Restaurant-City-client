package com.playfish.games.cooking
{
   import away3d.containers.ObjectContainer3D;
   import away3d.containers.View3D;
   import away3d.lights.DirectionalLight3D;
   import away3d.loaders.Collada;
   import away3d.materials.MovieMaterial;
   import com.playfish.coretech.platform.socialplatform.SocialFeed;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.SocialPlatformFeeds;
   import com.playfish.coretech.platform.socialstats.FriendshipMetric;
   import com.playfish.coretech.platform.socialstats.SocialStats;
   import com.playfish.external.*;
   import com.playfish.games.cooking.actors.*;
   import com.playfish.games.cooking.challenge.ChallengeDatabase;
   import com.playfish.games.cooking.debug.DebugAddShopTime;
   import com.playfish.games.cooking.debug.DebugToggleLevelGate;
   import com.playfish.games.cooking.events.*;
   import com.playfish.games.cooking.foodking.*;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.games.cooking.utils.*;
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   import com.playfish.rpc.share.RpcResponseBase;
   import com.playfish.stream.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.system.LoaderContext;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public class GameWorld
   {
      
      public static var view3d:View3D;
      
      public static var socialNetworkHandler:FacebookHandler;
      
      public static var rpcClient:RpcClient;
      
      public static var ingredientItemDatabase:ItemDatabase;
      
      public static var newsletterHandler:NewsletterHandler;
      
      public static var globalRpcsTimer:int;
      
      public static var recipeItemDatabase:ItemDatabase;
      
      public static var buildingItemDatabase:ItemDatabase;
      
      public static var cashPanel:CashPanel;
      
      public static var quizItemDatabase:ItemDatabase;
      
      public static var baseModel:ObjectContainer3D;
      
      public static var gameUser:GameUser;
      
      public static var localTime:Number;
      
      public static var challengeDatabase:ChallengeDatabase;
      
      public static var photoUploadPermission:Boolean;
      
      public static var albumCoverUploaded:Boolean;
      
      private static var fadeBitmapData:BitmapData;
      
      public static var light:DirectionalLight3D;
      
      public static var appointmentItemDatabase:ItemDatabase;
      
      public static var textHandler:TextHandler;
      
      public static var interiorItemDatabase:ItemDatabase;
      
      public static var hiredFriendsPanel:WorldHiredFriendsPanel;
      
      private static var fadeMask:BaseObject;
      
      private static var inactiveTimer:int;
      
      public static var bestFriendListFromSocialStats:Array;
      
      public static var albumExists:Boolean;
      
      public static var avatarItemDatabase:ItemDatabase;
      
      public static var perkItemDatabase:ItemDatabase;
      
      public static var placeholderUser:GameUser;
      
      public static var settingOverlay:OverlaySetting;
      
      public static var SocialNetworkAvailable:Boolean;
      
      public static var friendsListPanel:WorldFriendsList;
      
      public static var baseCustomiseAvatarModel:ObjectContainer3D;
      
      public static const DEBUG:Boolean = Debug.DEBUG;
      
      public static const CANVAS_WIDTH:int = 760;
      
      public static const CANVAS_HEIGHT:int = 600;
      
      public static const CANVAS_CENTER_X:int = CANVAS_WIDTH / 2;
      
      public static const CANVAS_CENTER_Y:int = CANVAS_HEIGHT / 2;
      
      public static const NETPROMOTER_POP_UP_CHANCE:Number = 0.0005;
      
      public static const FRIENDS_INVITE_POP_UP_CHANCE:Number = 0.05;
      
      public static const EMAIL_PERMISSION_REMINDER_POP_UP_CHANCE:Number = 0.5;
      
      private static const SERVER_ALERT_EVENT:uint = 1;
      
      public static const SHOP_UPDATE_DAY_IN_WEEK:int = 1;
      
      public static const SHOP_UPDATE_HOUR_IN_DAY:int = 8;
      
      public static const STREAM_FEED_GAME_LINK:String = "http://apps.facebook.com/restaurantcity/gameinfo?pf_ria=1";
      
      public static const FEED_FORM_GAME_LINK:String = "http://apps.facebook.com/restaurantcity/gameinfo?pf_ria=1&pf_ref=fp";
      
      public static const DRAW_PRIORITY_HIRE_PANEL:int = 1000;
      
      public static const DRAW_PRIORITY_UI:int = 1100;
      
      public static const DRAW_PRIORITY_POP_UP:int = 1200;
      
      public static const SHAKE_TREE_COIN:int = 1;
      
      public static const FIRE_EMPLOYEE_PENALTY:int = -200;
      
      public static const WATER_FRIENDS_PLOT:int = 1;
      
      public static const VISIT_ACTIVITY_PAYOUT_MATRIX:Array = [[1,500],[2,100],[5,50]];
      
      public static const MIN_VISIT_ACTIVITY_PAYOUT:int = 15;
      
      public static const MAX_VISIT_ACTIVITY_GP:int = 15;
      
      public static const DEFAULT_DEMAND:Number = 120;
      
      public static const MIN_DEMAND:Number = 40;
      
      public static const DEFAULT_MAX_DEMAND:Number = 500;
      
      public static const MAX_DEMAND:Number = 550;
      
      public static const RESTAURANT_CLOSED_DEMAND_DECREASE_RATE_PER_HOUR:int = 10;
      
      public static const MIN_DEMAND_FOR_EMPLOYEE:Array = [6,6,6,9,14,16,17,20,23,25];
      
      public static const COST_PER_DISH:int = 2;
      
      public static const MAX_OFFLINE_EARNING:ProtectedInt = new ProtectedInt(7000);
      
      public static const COINS_PAYOUT_FUNCTIONAL_ITEMS:int = 1;
      
      public static const GOURMET_POINTS_PER_TRADE_RARITY:int = 1;
      
      public static const GOURMET_POINTS_SEND_GIFT:int = 5;
      
      public static const GOURMET_POINTS_HIRE_EMPLOYEE:int = 10;
      
      public static const GOURMET_POINTS_SELL_ITEM:int = 2;
      
      public static const GOURMET_POINTS_TRASH:int = 1;
      
      public static const GOURMET_POINTS_PER_DISH:Number = 1;
      
      public static const GOURMET_POINTS_PER_DISH_LEVEL:Number = 0.2;
      
      public static const GOURMET_POINTS_BUY_ITEM_PER_COIN:Number = 0.05;
      
      public static const GOURMET_POINTS_BUY_ITEM_PER_PLAYFISH_CASH:Number = 2;
      
      public static const GOURMET_POINTS_BUY_ITEM_MAX:int = 50;
      
      public static const GOURMET_POINTS_PER_FUNCTIONAL_ITEM_PAYOUT:int = 1;
      
      public static const GOURMET_POINTS_PER_LEARN_RECIPE_LEVEL:Array = [25,50,100,200,300,400,500,600,700,800];
      
      public static const TRASH_APPEAR_RATE:ProtectedInt = new ProtectedInt(3600000);
      
      public static const TRASH_APPEAR_RATE_RANDOM_DELTA:int = 60000;
      
      public static const MAX_TRASH:int = 15;
      
      public static const ITEM_ID_MAILBOX:int = 3300000;
      
      public static const ITEM_ID_ACHIEVEMENT:int = 3200000;
      
      public static const ITEM_ID_MENU:int = 3100000;
      
      public static const FIRST_TIME_ACCESS_BIT_EMPLOYEE_OUTFIT:int = 0;
      
      public static const FIRST_TIME_ACCESS_BIT_INGRADIANT_SHOP:int = 1;
      
      public static const FIRST_TIME_ACCESS_BIT_RANDOM_STREET:int = 2;
      
      public static const FIRST_TIME_ACCESS_BIT_MUSIC_PLAYER:int = 3;
      
      public static const FIRST_TIME_ACCESS_BIT_GOURMET_STREET:int = 4;
      
      public static const FIRST_TIME_ACCESS_BIT_PHOTO:int = 5;
      
      public static const FIRST_TIME_ACCESS_BIT_2_DISHES_PER_COURSE:int = 6;
      
      public static const FIRST_TIME_ACCESS_BIT_ASK_FOR_INGREDIENT:int = 7;
      
      public static const FIRST_TIME_ACCESS_BIT_DRINK_TUTORIAL:int = 8;
      
      public static const FIRST_TIME_ACCESS_BIT_GARDEN_PLOT:int = 9;
      
      public static const FIRST_TIME_ACCESS_BIT_GIFT_INVITE_FOOD:int = 10;
      
      public static const FIRST_TIME_ACCESS_BIT_BOOKMARK:int = 11;
      
      public static const FIRST_TIME_ACCESS_BIT_STREET:int = 12;
      
      public static const LEVEL_THRESHOLDS:Array = [{
         "points":0,
         "roomSizeX":8,
         "roomSizeY":8,
         "employees":2,
         "numDishes":1,
         "gardenPlots":0,
         "layouts":1,
         "coinReward":0
      },{
         "points":50,
         "roomSizeX":8,
         "roomSizeY":8,
         "employees":2,
         "numDishes":1,
         "gardenPlots":0,
         "layouts":1,
         "coinReward":3500
      },{
         "points":70,
         "roomSizeX":8,
         "roomSizeY":8,
         "employees":3,
         "numDishes":1,
         "gardenPlots":0,
         "layouts":1,
         "coinReward":2500
      },{
         "points":100,
         "roomSizeX":9,
         "roomSizeY":8,
         "employees":3,
         "numDishes":1,
         "gardenPlots":0,
         "layouts":1,
         "coinReward":1000
      },{
         "points":200,
         "roomSizeX":9,
         "roomSizeY":9,
         "employees":3,
         "numDishes":1,
         "gardenPlots":0,
         "layouts":1,
         "coinReward":1000
      },{
         "points":500,
         "roomSizeX":9,
         "roomSizeY":9,
         "employees":4,
         "numDishes":1,
         "gardenPlots":0,
         "layouts":1,
         "coinReward":1000
      },{
         "points":1000,
         "roomSizeX":10,
         "roomSizeY":9,
         "employees":4,
         "numDishes":1,
         "gardenPlots":1,
         "layouts":1,
         "coinReward":1000
      },{
         "points":2000,
         "roomSizeX":10,
         "roomSizeY":10,
         "employees":4,
         "numDishes":1,
         "gardenPlots":1,
         "layouts":1,
         "coinReward":1000
      },{
         "points":4000,
         "roomSizeX":10,
         "roomSizeY":10,
         "employees":5,
         "numDishes":1,
         "gardenPlots":1,
         "layouts":1,
         "coinReward":1000
      },{
         "points":6000,
         "roomSizeX":11,
         "roomSizeY":10,
         "employees":5,
         "numDishes":1,
         "gardenPlots":1,
         "layouts":1,
         "coinReward":1000
      },{
         "points":8000,
         "roomSizeX":11,
         "roomSizeY":11,
         "employees":5,
         "numDishes":2,
         "gardenPlots":1,
         "layouts":2,
         "coinReward":1000
      },{
         "points":10000,
         "roomSizeX":11,
         "roomSizeY":11,
         "employees":6,
         "numDishes":2,
         "gardenPlots":1,
         "layouts":2,
         "coinReward":1000
      },{
         "points":14000,
         "roomSizeX":12,
         "roomSizeY":11,
         "employees":6,
         "numDishes":2,
         "gardenPlots":1,
         "layouts":2,
         "coinReward":1000
      },{
         "points":18000,
         "roomSizeX":12,
         "roomSizeY":12,
         "employees":6,
         "numDishes":2,
         "gardenPlots":2,
         "layouts":2,
         "coinReward":1000
      },{
         "points":22000,
         "roomSizeX":12,
         "roomSizeY":12,
         "employees":7,
         "numDishes":2,
         "gardenPlots":2,
         "layouts":2,
         "coinReward":1000
      },{
         "points":30000,
         "roomSizeX":13,
         "roomSizeY":12,
         "employees":7,
         "numDishes":2,
         "gardenPlots":2,
         "layouts":2,
         "coinReward":1000
      },{
         "points":38000,
         "roomSizeX":13,
         "roomSizeY":13,
         "employees":7,
         "numDishes":2,
         "gardenPlots":2,
         "layouts":2,
         "coinReward":1000
      },{
         "points":46000,
         "roomSizeX":13,
         "roomSizeY":13,
         "employees":8,
         "numDishes":2,
         "gardenPlots":2,
         "layouts":2,
         "coinReward":1000
      },{
         "points":58000,
         "roomSizeX":14,
         "roomSizeY":13,
         "employees":8,
         "numDishes":2,
         "gardenPlots":3,
         "layouts":2,
         "coinReward":1000
      },{
         "points":70000,
         "roomSizeX":14,
         "roomSizeY":14,
         "employees":8,
         "numDishes":2,
         "gardenPlots":3,
         "layouts":2,
         "coinReward":1000
      },{
         "points":86000,
         "roomSizeX":15,
         "roomSizeY":14,
         "employees":8,
         "numDishes":3,
         "gardenPlots":3,
         "layouts":3,
         "coinReward":1000
      },{
         "points":102000,
         "roomSizeX":15,
         "roomSizeY":15,
         "employees":9,
         "numDishes":3,
         "gardenPlots":3,
         "layouts":3,
         "coinReward":1000
      },{
         "points":122000,
         "roomSizeX":16,
         "roomSizeY":15,
         "employees":9,
         "numDishes":3,
         "gardenPlots":4,
         "layouts":3,
         "coinReward":1000
      },{
         "points":142000,
         "roomSizeX":16,
         "roomSizeY":16,
         "employees":9,
         "numDishes":3,
         "gardenPlots":4,
         "layouts":3,
         "coinReward":1000
      },{
         "points":166000,
         "roomSizeX":17,
         "roomSizeY":16,
         "employees":9,
         "numDishes":3,
         "gardenPlots":5,
         "layouts":3,
         "coinReward":1000
      },{
         "points":190000,
         "roomSizeX":17,
         "roomSizeY":17,
         "employees":9,
         "numDishes":3,
         "gardenPlots":5,
         "layouts":3,
         "coinReward":1000
      },{
         "points":218000,
         "roomSizeX":18,
         "roomSizeY":17,
         "employees":9,
         "numDishes":3,
         "gardenPlots":6,
         "layouts":3,
         "coinReward":1000
      },{
         "points":246000,
         "roomSizeX":18,
         "roomSizeY":18,
         "employees":9,
         "numDishes":3,
         "gardenPlots":6,
         "layouts":3,
         "coinReward":1000
      },{
         "points":280000,
         "roomSizeX":18,
         "roomSizeY":18,
         "employees":9,
         "numDishes":3,
         "gardenPlots":7,
         "layouts":3,
         "coinReward":1000
      },{
         "points":320000,
         "roomSizeX":19,
         "roomSizeY":18,
         "employees":9,
         "numDishes":3,
         "gardenPlots":7,
         "layouts":3,
         "coinReward":1000
      },{
         "points":370000,
         "roomSizeX":19,
         "roomSizeY":18,
         "employees":9,
         "numDishes":3,
         "gardenPlots":8,
         "layouts":3,
         "coinReward":1000
      },{
         "points":430000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":8,
         "layouts":3,
         "coinReward":1000
      },{
         "points":500000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":580000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":661000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":743000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":826000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":910000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":995000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1081000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1168000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1256000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1345000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1435000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1526000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1618000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1711000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1805000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1900000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":1996000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":2093000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":2191000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":2290000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":2390000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":2491000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":2593000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":2696000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":2800000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":2905000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":3011000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":3118000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":3226000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":3335000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":3445000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":3556000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      },{
         "points":3668000,
         "roomSizeX":19,
         "roomSizeY":19,
         "employees":9,
         "numDishes":3,
         "gardenPlots":9,
         "layouts":3,
         "coinReward":1000
      }];
      
      public static const TOILET_START_LEVEL:int = 8;
      
      public static const DRINK_START_LEVEL:int = 15;
      
      public static const INGREDIENT_MARKET_UNLOCK_LEVEL:int = 1;
      
      public static var GLOBAL_RPC_COMMIT_INTERVAL:int = 60000;
      
      public static var GLOBAL_RPC_COMMIT_INTERVAL_INACTIVE:int = 300000;
      
      public static var INACTIVE_TIME:int = 60000;
      
      public static var serverTime:Date = new Date();
      
      public static var shopWeeks:Number = -1;
      
      public static var globalRpcs:RpcRequestManager = new RpcRequestManager();
      
      public static var saveProfileHandler:SaveProfileHandler = new SaveProfileHandler();
      
      public static var gameEventDispatcher:EventDispatcher = new EventDispatcher();
      
      public static var pricepoints:Array = new Array();
      
      public static var lastBookmarkPopUpTime:int = 0;
      
      public static var maxEmployees:int = 2;
      
      public static var checkNextLevelUp:Boolean = false;
      
      public static var offlineEarning:int = 0;
      
      public static var offlineGourmetPoints:Number = 0;
      
      public static var offlineEarningTimer:int = -1;
      
      public static var cachedGameUsers:Array = new Array();
      
      public static var cachedExtraUsers:Array = new Array();
      
      public static var bestFriendUsers:Array = new Array();
      
      public static var trashTimer:int = TRASH_APPEAR_RATE.value;
      
      public static var receivedFeedItems:Array = new Array();
      
      public static var invalidFeedItems:Array = new Array();
      
      public static const SECOND_MILLIS:Number = 1000;
      
      public static const MINUTE_MILLIS:Number = 60 * 1000;
      
      public static const HOUR_MILLIS:Number = 60 * MINUTE_MILLIS;
      
      public static const DAY_MILLIS:Number = 24 * HOUR_MILLIS;
      
      public static const WEEK_MILLIS:Number = 7 * DAY_MILLIS;
      
      public static const WEEK_OFFSET:Number = 3 * DAY_MILLIS;
      
      public function GameWorld(param1:Engine)
      {
         super();
      }
      
      public static function error() : void
      {
         Engine.quit();
         destroy();
         var _loc1_:MovieClip = Engine.getMovieClip("NetworkError");
         _loc1_.x = Engine.STAGE_WIDTH / 2;
         _loc1_.y = Engine.STAGE_HEIGHT / 2;
         Engine.instance.addChild(_loc1_);
      }
      
      public static function setMaxEmployees(param1:int) : void
      {
         if(maxEmployees != param1)
         {
            maxEmployees = param1;
            hiredFriendsPanel.refresh();
         }
      }
      
      public static function getFaceImageFromUrl(param1:String) : DisplayObject
      {
         var _loc2_:Loader = null;
         var _loc3_:URLRequest = null;
         var _loc4_:LoaderContext = null;
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = new Loader();
            _loc3_ = new URLRequest(param1);
            _loc4_ = new LoaderContext(true);
            _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,onFaceImageComplete);
            _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onFaceImageError);
            _loc2_.load(_loc3_,_loc4_);
            return _loc2_;
         }
         return null;
      }
      
      public static function commitGlobalRpcs() : Boolean
      {
         tickOfflineTime();
         var _loc1_:Number = 0;
         while(_loc1_ < gameUser.employeeUsers.length)
         {
            saveProfileHandler.addUpdatedEmployees(gameUser.employeeUsers[_loc1_]);
            _loc1_++;
         }
         globalRpcs.getServerTime();
         globalRpcs.addRequest(saveProfileHandler);
         var _loc2_:Boolean = globalRpcs.commit();
         globalRpcs = new RpcRequestManager();
         saveProfileHandler = new SaveProfileHandler();
         return _loc2_;
      }
      
      public static function setBlackSheepItems() : void
      {
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Array = null;
         var _loc13_:Object = null;
         var _loc14_:Array = null;
         var _loc15_:Object = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc1_:RandomBasket = new RandomBasket();
         var _loc2_:int = 0;
         while(_loc2_ < Recipe.MENU_RECIPE_TYPE_NAMES.length)
         {
            _loc8_ = GameWorld.recipeItemDatabase.getItems(Recipe.MENU_RECIPE_TYPE_NAMES[_loc2_]);
            _loc9_ = 0;
            while(_loc9_ < _loc8_.length)
            {
               _loc10_ = _loc8_[_loc9_];
               if(_loc10_.foodKingFeed)
               {
                  _loc1_.addItems(_loc10_);
               }
               _loc9_++;
            }
            _loc2_++;
         }
         var _loc3_:RandomBasket = new RandomBasket();
         var _loc4_:Array = GameWorld.ingredientItemDatabase.getItems("Ingredient");
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            _loc11_ = _loc4_[_loc2_];
            if(_loc11_.foodKingFeed)
            {
               _loc3_.addItems(_loc11_);
            }
            _loc2_++;
         }
         var _loc5_:RandomBasket = new RandomBasket();
         _loc2_ = 0;
         while(_loc2_ < GameWorld.interiorItemDatabase.itemGroups.length)
         {
            _loc12_ = GameWorld.interiorItemDatabase.getItems(GameWorld.interiorItemDatabase.itemGroups[_loc2_].name);
            _loc9_ = 0;
            while(_loc9_ < _loc12_.length)
            {
               _loc13_ = _loc12_[_loc9_];
               if(_loc13_.foodKingFeed)
               {
                  _loc5_.addItems(_loc13_);
               }
               _loc9_++;
            }
            _loc2_++;
         }
         var _loc6_:RandomBasket = new RandomBasket();
         _loc2_ = 0;
         while(_loc2_ < GameWorld.buildingItemDatabase.itemGroups.length)
         {
            _loc14_ = GameWorld.buildingItemDatabase.getItems(GameWorld.buildingItemDatabase.itemGroups[_loc2_].name);
            _loc9_ = 0;
            while(_loc9_ < _loc14_.length)
            {
               _loc15_ = _loc14_[_loc9_];
               if(_loc15_.foodKingFeed)
               {
                  _loc6_.addItems(_loc15_);
               }
               _loc9_++;
            }
            _loc2_++;
         }
         var _loc7_:Array = [GameUser.ITEM_TYPE_RECIPE,GameUser.ITEM_TYPE_INGREDIENT,GameUser.ITEM_TYPE_RESTAURANT];
         _loc2_ = 0;
         while(_loc2_ < FoodKingPopUp.MAX_ITEMS)
         {
            _loc16_ = Engine.rnd(0,_loc7_.length);
            _loc17_ = int(_loc7_[_loc16_]);
            _loc7_.splice(_loc7_.indexOf(_loc17_),1);
            if(_loc17_ == GameUser.ITEM_TYPE_RECIPE)
            {
               FoodKingPopUp.blackSheepItems.push(new FoodKingItem(_loc1_.getNextItem().id));
            }
            if(_loc17_ == GameUser.ITEM_TYPE_INGREDIENT)
            {
               FoodKingPopUp.blackSheepItems.push(new FoodKingItem(_loc3_.getNextItem().id));
            }
            if(_loc17_ == GameUser.ITEM_TYPE_RESTAURANT)
            {
               if(Engine.rnd(0,2))
               {
                  FoodKingPopUp.blackSheepItems.push(new FoodKingItem(_loc6_.getNextItem().id));
               }
               else
               {
                  FoodKingPopUp.blackSheepItems.push(new FoodKingItem(_loc5_.getNextItem().id));
               }
            }
            _loc2_++;
         }
      }
      
      public static function isFading() : Boolean
      {
         return fadeMask != null;
      }
      
      private static function generateLevelThresholds() : void
      {
         var _loc1_:int = 500000;
         var _loc2_:int = 80000;
         var _loc3_:int = 0;
         while(_loc3_ < 69)
         {
            Debug.out("{points : " + _loc1_ + ",\troomSizeX : 19, roomSizeY : 19, employees : 9,\tnumDishes : 3, gardenPlots : 9, coinReward : 1000 }, // " + (32 + _loc3_));
            _loc1_ += _loc2_;
            _loc2_ += 1000;
            _loc3_++;
         }
      }
      
      public static function getEarnings(param1:int) : Number
      {
         var _loc2_:int = param1 * COST_PER_DISH;
         return Math.min(_loc2_,MAX_OFFLINE_EARNING.value);
      }
      
      public static function destroy() : void
      {
         if(placeholderUser)
         {
            placeholderUser.destroy();
         }
         GameSound.stopAll();
         if(settingOverlay)
         {
            Engine.instance.removeChild(settingOverlay);
         }
      }
      
      public static function getItemConfig(param1:int) : Object
      {
         var _loc2_:int = getItemType(param1);
         if(_loc2_ == GameUser.ITEM_TYPE_RESTAURANT)
         {
            return interiorItemDatabase.getItemFromId(param1);
         }
         if(_loc2_ == GameUser.ITEM_TYPE_BUILDING)
         {
            return buildingItemDatabase.getItemFromId(param1);
         }
         if(_loc2_ == GameUser.ITEM_TYPE_AVATAR)
         {
            return avatarItemDatabase.getItemFromId(param1);
         }
         if(_loc2_ == GameUser.ITEM_TYPE_INGREDIENT)
         {
            return ingredientItemDatabase.getItemFromId(param1);
         }
         if(_loc2_ == GameUser.ITEM_TYPE_RECIPE)
         {
            return recipeItemDatabase.getItemFromId(param1);
         }
         if(_loc2_ == GameUser.ITEM_TYPE_PERK)
         {
            return perkItemDatabase.getItemFromId(param1);
         }
         return null;
      }
      
      public static function getDummyUserInfo(param1:int) : UserInfo
      {
         var _loc5_:OwnedItem = null;
         var _loc6_:Object = null;
         var _loc2_:NetworkUid = new NetworkUid(NetworkUid.FACEBOOK,param1.toString(),param1);
         var _loc3_:UserInfo = new UserInfo();
         _loc3_.firstName = "Dummy" + param1;
         _loc3_.fullName = "Dummy" + param1 + " Tummy";
         _loc3_.id = _loc2_;
         _loc3_.playCount = 2;
         _loc3_.demandPoint = DEFAULT_DEMAND;
         _loc3_.trashPoint = 1;
         _loc3_.gourmetPoint = 10000;
         _loc3_.userLevel = getLevel(_loc3_.gourmetPoint);
         _loc3_.gender = Engine.rnd(0,3);
         _loc3_.ingredients = new Array();
         _loc3_.visitedFriend = new Array();
         _loc3_.visitedFriendsToday = new Array();
         _loc3_.awards = null;
         _loc3_.employees = new Array();
         _loc3_.floors = new Array();
         _loc3_.garden = new Array();
         _loc3_.imageUrl = "";
         _loc3_.inventoryItem = new Array();
         _loc3_.ownedItem = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < WorldCustomiseBuilding.DEFAULT_BUILDING_ITEMS.length)
         {
            _loc5_ = new OwnedItem();
            _loc6_ = WorldCustomiseBuilding.DEFAULT_BUILDING_ITEMS[_loc4_];
            _loc5_.globalItemId = _loc6_.id;
            _loc5_.id = UserItem.getNextLocalUid();
            _loc5_.positionX = _loc6_.x;
            _loc5_.positionY = _loc6_.y;
            _loc3_.ownedItem.push(_loc5_);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < WorldRestaurant.DEFAULT_RESTAURANT_ITEMS.length)
         {
            _loc5_ = new OwnedItem();
            _loc6_ = WorldRestaurant.DEFAULT_RESTAURANT_ITEMS[_loc4_];
            _loc5_.globalItemId = _loc6_.id;
            _loc5_.id = UserItem.getNextLocalUid();
            _loc5_.positionX = _loc6_.tileX;
            _loc5_.positionY = _loc6_.tileY;
            _loc5_.data = _loc6_.rotation;
            _loc3_.ownedItem.push(_loc5_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function forceAutoSave() : void
      {
         saveProfileHandler.addEventListener(RpcEvent.SUCCESS,onGlobalRpcsSuccess);
         globalRpcs.retryText = textHandler.getTextFromId("AutoSaveRetryText");
         globalRpcs.retryCancelCallBack = onGlobalRpcsRetryCancel;
         commitGlobalRpcs();
         if(globalRpcsTimer >= 0)
         {
            globalRpcsTimer = -1;
         }
      }
      
      public static function compareUserAlphabetDescending(param1:GameUser, param2:GameUser) : int
      {
         return -compareUserAlphabetAscending(param1,param2);
      }
      
      private static function onFaceImageComplete(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget.content);
         param1.currentTarget.removeEventListener(Event.COMPLETE,onFaceImageComplete);
         param1.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,onFaceImageError);
         _loc2_.x = -_loc2_.width / 2;
         _loc2_.y = -_loc2_.height / 2;
      }
      
      private static function onFaceImageError(param1:IOErrorEvent) : void
      {
         Debug.out("Face image load failed: " + param1.text);
         param1.currentTarget.removeEventListener(Event.COMPLETE,onFaceImageComplete);
         param1.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,onFaceImageError);
      }
      
      private static function onProtectedIntChecksumMismatch(param1:Event) : void
      {
         Debug.out("onProtectedIntChecksumMismatch");
         error();
      }
      
      public static function addVisitedFriendToday(param1:NetworkUid) : void
      {
         gameUser.addVisitedFriendToday(param1);
      }
      
      public static function compareUserPointDescending(param1:GameUser, param2:GameUser) : int
      {
         return -compareUserPointAscending(param1,param2);
      }
      
      public static function start() : void
      {
         var _loc2_:int = 0;
         var _loc3_:NetworkUid = null;
         var _loc4_:GameUser = null;
         var _loc5_:Mail = null;
         var _loc6_:MailItem = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Recipe = null;
         var _loc12_:int = getTimer();
         PerfTrace.mark("GameWorld.start begin");
         settingOverlay = new OverlaySetting();
         Engine.instance.addChild(settingOverlay);
         PerfTrace.slow("GameWorld.start overlay/debug",_loc12_,5);
         Debug.init();
         ProtectedInt.addEventListener(ProtectedInt.EVENT_CHECKSUM_MISMATCH,onProtectedIntChecksumMismatch);
         _loc12_ = getTimer();
         if(bestFriendListFromSocialStats)
         {
            _loc2_ = 0;
            while(_loc2_ < bestFriendListFromSocialStats.length)
            {
               _loc3_ = SocialPlatform.instance.getNetworkID(bestFriendListFromSocialStats[_loc2_].uid);
               _loc4_ = getGameUserWithId(_loc3_);
               if(_loc4_)
               {
                  bestFriendUsers.push(_loc4_);
               }
               _loc2_++;
            }
         }
         PerfTrace.slow("GameWorld.start best friends",_loc12_,5);
         _loc12_ = getTimer();
         _loc2_ = 0;
         while(_loc2_ < newsletterHandler.ids.length)
         {
            _loc5_ = new Mail();
            _loc5_.type = RpcClient.MAIL_TYPE_PLAYFISH;
            _loc5_.id = 0;
            _loc5_.read = newsletterHandler.isRead(newsletterHandler.ids[_loc2_],gameUser);
            _loc5_.message = newsletterHandler.texts[_loc2_];
            _loc5_.sendDate = newsletterHandler.dates[_loc2_];
            _loc6_ = addNewMail(_loc5_);
            _loc6_.newsletterId = newsletterHandler.ids[_loc2_];
            _loc2_++;
         }
         PerfTrace.slow("GameWorld.start newsletters",_loc12_,5);
         _loc12_ = getTimer();
         gameUser.refreshBedStatusForRestingEmployees();
         maxEmployees = LEVEL_THRESHOLDS[gameUser.level.value].employees;
         if(gameUser.userInfo.playCount > 1 && gameUser.level.value > 0)
         {
            Debug.out("last save=" + gameUser.userInfo.lastSave);
            _loc7_ = int(gameUser.userInfo.lastSave);
            _loc8_ = _loc7_ * 1000;
            if(_loc8_ > 0)
            {
               _loc10_ = getOfflineCustomers(_loc7_);
               offlineEarning = getEarnings(_loc10_);
               offlineGourmetPoints = getOfflineGourmetPoints(_loc10_);
               saveProfileHandler.addOffLineMoney(offlineEarning);
               addGourmetPoints(offlineGourmetPoints,false);
               tickOfflineTimeForUser(gameUser,_loc8_);
            }
            _loc9_ = 0;
            _loc2_ = 0;
            while(_loc2_ < gameUser.ownedRecipeItems.length)
            {
               _loc11_ = gameUser.ownedRecipeItems[_loc2_];
               if(_loc11_.level >= 10)
               {
                  _loc9_++;
               }
               _loc2_++;
            }
            Debug.out("level 10 recipes=" + _loc9_);
            gameUser.awards.setValue(GameAwards.AWARD_RECIPE_LEVEL_10,_loc9_);
            checkTrophiesItems();
            checkRestaurantItems();
            checkBuildingItems();
            ensureItemNumber(ITEM_ID_MAILBOX,1);
            ensureItemNumber(ITEM_ID_MENU,1);
            ensureItemNumber(ITEM_ID_ACHIEVEMENT,1);
            forceAutoSave();
         }
         else
         {
            gameUser.setDemandPoints(DEFAULT_DEMAND);
            gameUser.money.value = 0;
            gameUser.bannerText = gameUser.firstName;
            stopGlobalRpcs();
         }
         PerfTrace.slow("GameWorld.start offline/profile repair",_loc12_,5);
         _loc12_ = getTimer();
         if(hiredFriendsPanel == null)
         {
            hiredFriendsPanel = new WorldHiredFriendsPanel(gameUser,maxEmployees);
            hiredFriendsPanel.drawPriority = 10000;
            hiredFriendsPanel.x = 0;
            hiredFriendsPanel.y = Engine.STAGE_HEIGHT;
            hiredFriendsPanel.hide();
         }
         PerfTrace.slow("GameWorld.start hired friends panel",_loc12_,5);
         _loc12_ = getTimer();
         var _loc1_:Array = getPlayingFriendUsers();
         friendsListPanel = new WorldFriendsList(_loc1_);
         friendsListPanel.y = Engine.STAGE_HEIGHT;
         friendsListPanel.drawPriority = 10000;
         if(GameWorld.cashPanel == null)
         {
            GameWorld.cashPanel = new CashPanel();
            GameWorld.cashPanel.drawPriority = 10000;
         }
         PerfTrace.slow("GameWorld.start panels",_loc12_,5);
         _loc12_ = getTimer();
         Engine.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove,false,0,true);
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,0,true);
         WorldStreet.streetType = WorldStreet.STREET_TYPE_FRIENDS;
         WorldStreet.streetUsers = _loc1_;
         WorldStreet.streetUserList = friendsListPanel;
         Engine.setActiveWorld(new WorldStreet(gameUser,true));
         setBlackSheepItems();
         startServerEventDelivery();
         PerfTrace.slow("GameWorld.start street/setBlackSheep",_loc12_,5);
         PerfTrace.mark("GameWorld.start end");
       }
      
      public static function registerServerEvents() : void
      {
         try
         {
            rpcClient.registerEventType(SERVER_ALERT_EVENT,readServerAlertEvent);
            rpcClient.setEventHandler(SERVER_ALERT_EVENT,showServerAlert);
         }
         catch(e:Error)
         {
            Debug.out("registerServerEvents failed: " + e);
         }
      }
      
      private static function startServerEventDelivery() : void
      {
         try
         {
            rpcClient.startEventDelivery(function():void
            {
               Debug.out("server event delivery stopped");
            });
         }
         catch(e:Error)
         {
            Debug.out("startServerEventDelivery failed: " + e);
         }
      }
      
      private static function readServerAlertEvent(param1:RpcResponseBase, param2:Function) : Function
      {
         var title:String = param1.readString();
         var body:String = param1.readString();
         var handler:Function = param2;
         return function():void
         {
            handler(title,body);
         };
      }
      
      private static function showServerAlert(param1:String, param2:String) : void
      {
         var _loc3_:MovieClip = Engine.getMovieClip("HelpPopup");
         var _loc4_:MovieClip = _loc3_.mc_content;
         textHandler.setTextField(_loc4_.tf_title,param1);
         textHandler.setTextField(_loc4_.tf_body,param2,true);
         var _loc5_:WorldPopUp = new WorldPopUp(_loc3_,_loc4_.mc_ok,null);
         _loc5_.drawPriority = DRAW_PRIORITY_POP_UP;
         _loc5_.queueToShow();
      }
      
      public static function getItemType(param1:int) : int
      {
         return param1 / 1000000;
      }
      
      public static function showTutorialTextPopUp(param1:String) : void
      {
         var _loc2_:MovieClip = Engine.getMovieClip("HelpPopup");
         var _loc3_:MovieClip = _loc2_.mc_content;
         textHandler.setTextField(_loc3_.tf_body,param1,true);
         _loc3_.tf_title.text = "";
         var _loc4_:WorldPopUp = new WorldPopUp(_loc2_,_loc3_.mc_ok,null);
         _loc4_.drawPriority = 100;
         _loc4_.queueToShow();
      }
      
      public static function showLevelUpPopUp(param1:int, param2:String, param3:String, param4:int) : void
      {
         var popup:WorldPopUp = null;
         var level:int = param1;
         var text:String = param2;
         var iconLabel:String = param3;
         var cashBonus:int = param4;
         var popupScene:MovieClip = Engine.getMovieClip("LevelUpPopUp");
         popup = new WorldPopUp(popupScene,popupScene.mc_skip,popupScene.mc_next);
         popupScene.mc_icon.gotoAndStop(iconLabel);
         textHandler.setReplaceString("RestaurantLevel",level.toString());
         textHandler.setTextFieldWithId(popupScene.tf_title,"LevelUp",true);
         textHandler.setTextField(popupScene.tf_text,text,true);
         if(cashBonus > 0)
         {
            textHandler.setTextFieldWithId(popupScene.tf_cashBonus,"LevelUpCashBonus");
            popupScene.tf_amount.text = cashBonus;
            popupScene.mc_next.visible = false;
            popup.setButtonMode(popupScene.mc_share,true);
            popup.setButtonMode(popupScene.mc_next,true);
            popup.setButtonMode(popupScene.mc_skip,true);
            popupScene.mc_skip.mc_content.tf_text.mouseEnabled = false;
            if(GameWorld.isUserInSplitTestingGroupA(GameWorld.gameUser))
            {
               GameWorld.textHandler.setTextFieldWithId(popupScene.mc_share.mc_content.tf_text,"ButtonContinueText");
            }
            else
            {
               GameWorld.textHandler.setTextFieldWithId(popupScene.mc_share.mc_content.tf_text,"ButtonShareText");
            }
            popupScene.mc_share.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               onShareLevelUpClick(level,popup);
            });
         }
         else
         {
            popupScene.mc_skip.visible = false;
            popupScene.mc_share.visible = false;
            popupScene.tf_cashBonus.visible = false;
            popupScene.tf_amount.visible = cashBonus;
            popupScene.mc_share.visible = false;
            popupScene.tf_sharenews.visible = false;
         }
         popup.queueToShow();
      }
      
      public static function isFriendUser(param1:GameUser) : Boolean
      {
         var _loc2_:Array = cachedGameUsers[RpcClient.USER_CONTEXT_FRIENDS | RpcClient.TIME_CONTEXT_ALL];
         return _loc2_.indexOf(param1) != -1;
      }
      
      private static function onGlobalRpcsRetryCancel() : void
      {
         Debug.out("onGlobalRpcsRetryCancel");
         if(Debug.NETWORK_ONLY)
         {
            error();
         }
      }
      
      public static function checkRestaurantItems() : void
      {
         var _loc4_:UserItem = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:* = int(gameUser.usedRestaurantItems.length - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = gameUser.usedRestaurantItems[_loc3_];
            if(isItemOfType(_loc4_.itemConfig,"wallpaperItem"))
            {
               if(_loc4_.x <= 0 && _loc4_.y <= 0 || _loc4_.x > 0 && _loc4_.y > 0)
               {
                  Debug.out("moving extra wallpaper " + _loc4_.itemConfig.name + " to inventory");
                  moveUsedRestaurantItemToInventory(_loc4_);
               }
               else if(_loc4_.y > 0)
               {
                  if(_loc1_[_loc4_.roomIndex] == null)
                  {
                     _loc1_[_loc4_.roomIndex] = _loc4_;
                  }
                  else
                  {
                     Debug.out("moving extra wallpaper " + _loc4_.itemConfig.name + " to inventory");
                     moveUsedRestaurantItemToInventory(_loc4_);
                  }
               }
               else if(_loc4_.x > 0)
               {
                  if(_loc2_[_loc4_.roomIndex] == null)
                  {
                     _loc2_[_loc4_.roomIndex] = _loc4_;
                  }
                  else
                  {
                     Debug.out("moving extra wallpaper " + _loc4_.itemConfig.name + " to inventory");
                     moveUsedRestaurantItemToInventory(_loc4_);
                  }
               }
            }
            _loc3_--;
         }
      }
      
      public static function postFeed(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:String, param10:String, param11:String, param12:String, param13:String, param14:Array) : void
      {
         var streamEnabled:Boolean = false;
         var streamFeed:SocialFeed = null;
         var i:int = 0;
         var localStory:SocialFeed = null;
         var title:String = param1;
         var information:String = param2;
         var caption:String = param3;
         var description:String = param4;
         var linkText:String = param5;
         var linkUrl:String = param6;
         var dashboardText:String = param7;
         var userInput:String = param8;
         var feedTitle:String = param9;
         var feedBody:String = param10;
         var feedLinkText:String = param11;
         var feedLinkUrl:String = param12;
         var feedCaption:String = param13;
         var imageNames:Array = param14;
         try
         {
            Engine.setFullScreen(false);
            streamEnabled = true;
            if(streamEnabled)
            {
               streamFeed = SocialPlatform.current.feeds.createFeed(SocialPlatformFeeds.DEFAULT_TYPE,true);
               streamFeed.addStreamData(streamFeed.createTitleText(title));
               streamFeed.addStreamData(streamFeed.createInformationText(information,linkUrl));
               streamFeed.addStreamData(streamFeed.createCaptionText(caption));
               streamFeed.addStreamData(streamFeed.createDescriptionText(description));
               streamFeed.addStreamData(streamFeed.createLink(linkText,linkUrl));
               if(userInput)
               {
                  streamFeed.addStreamData(streamFeed.createUserInput(userInput));
               }
               i = 0;
               while(i < imageNames.length)
               {
                  streamFeed.addStreamData(streamFeed.createMediaImage("http://static.playfish.com/game/cooking/feed/v1/" + imageNames[i],linkUrl,null));
                  i++;
               }
               streamFeed.publish();
               localStory = SocialPlatform.current.feeds.createFeed("nudge");
               localStory.addStreamData(localStory.createLink("Play Restaurant City!","http://apps.facebook.com/restaurantcity/?pf_ref=fp_rc_gd"));
               localStory.addStreamData(localStory.createDescriptionText(dashboardText));
               localStory.publish();
            }
         }
         catch(e:Error)
         {
            Debug.out("GameWorld.postFeed() error " + e.toString());
         }
      }
      
      private static function onStageMouseMove(param1:MouseEvent) : void
      {
         inactiveTimer = 0;
      }
      
      public static function onFeedComplete(param1:ExternalPageEvent) : void
      {
      }
      
      public static function getMinDemand(param1:GameUser) : int
      {
         return MIN_DEMAND;
      }
      
      public static function isUserInSplitTestingGroupA(param1:GameUser) : Boolean
      {
         var _loc2_:String = param1.userInfo.id.networkUid;
         return int(_loc2_.charAt(_loc2_.length - 1)) % 2 == 0;
      }
      
      public static function addAwardValue(param1:int, param2:int) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:WorldAwardPopUp = null;
         var _loc7_:Object = null;
         var _loc3_:Object = gameUser.awards.addValue(param1,param2);
         if(_loc3_ != null)
         {
            _loc4_ = getItemConfig(_loc3_.itemId);
            _loc5_ = GameAwards.AWARD_PARAMS[param1].length - 1;
            while(_loc5_ >= 0)
            {
               _loc7_ = GameAwards.AWARD_PARAMS[param1][_loc5_];
               if(_loc7_.itemId == _loc3_.itemId)
               {
                  ensureItemNumber(_loc7_.itemId,1);
               }
               else
               {
                  ensureItemNumber(_loc7_.itemId,0);
               }
               _loc5_--;
            }
            _loc6_ = new WorldAwardPopUp(_loc4_);
            _loc6_.queueToShow();
         }
      }
      
      public static function getVisitRewardAmount() : int
      {
         var _loc1_:Array = null;
         var _loc2_:int = gameUser.getNumberOfCompletedActivities();
         var _loc3_:int = 0;
         while(_loc3_ < VISIT_ACTIVITY_PAYOUT_MATRIX.length)
         {
            _loc1_ = VISIT_ACTIVITY_PAYOUT_MATRIX[_loc3_];
            if(_loc2_ < _loc1_[0])
            {
               return _loc1_[1];
            }
            _loc3_++;
         }
         return MIN_VISIT_ACTIVITY_PAYOUT;
      }
      
      public static function setFirstTimeAccess(param1:int) : void
      {
         var _loc2_:int = Math.floor(param1 / 8) + GameSettings.TYPE_FIRST_TIME_ACCESS;
         var _loc3_:int = 1 << param1 % 8;
         var _loc4_:int = gameUser.settings.getValue(_loc2_);
         gameUser.settings.setValue(_loc2_,_loc4_ | _loc3_);
      }
      
      public static function getVisibleBound(param1:DisplayObject) : Rectangle
      {
         var _loc2_:Rectangle = param1.getBounds(null);
         var _loc3_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         _loc3_.draw(param1,new Matrix(1,0,0,1,-_loc2_.left,-_loc2_.top));
         var _loc4_:Rectangle = _loc3_.getColorBoundsRect(4278190080,0,false);
         _loc4_.offset(_loc2_.left,_loc2_.top);
         _loc3_.dispose();
         return _loc4_;
      }
      
      public static function getGameUserWithId(param1:NetworkUid) : GameUser
      {
         var _loc2_:Array = cachedGameUsers[RpcClient.USER_CONTEXT_FRIENDS | RpcClient.TIME_CONTEXT_ALL].concat(cachedExtraUsers);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(NetworkUid.areEqual(_loc2_[_loc3_].userInfo.id,param1))
            {
               return _loc2_[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      private static function hasEntrancesToRestaurant() : Boolean
      {
         var _loc3_:UserItem = null;
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < gameUser.usedRestaurantItems.length)
         {
            _loc3_ = gameUser.usedRestaurantItems[_loc2_];
            if(isItemOfType(_loc3_.itemConfig,"doorItem"))
            {
               return true;
            }
            _loc2_++;
         }
         if(gameUser.outsideAreaSizeItems.length > 0)
         {
            return true;
         }
         return false;
      }
      
      public static function openUrl(param1:String) : void
      {
         var _loc2_:URLRequest = new URLRequest(param1);
         navigateToURL(_loc2_,"_blank");
      }
      
      public static function getWeekCount(param1:Number, param2:int, param3:int) : int
      {
         var _loc4_:int = param2 * DAY_MILLIS + param3 * HOUR_MILLIS;
         return (param1 + WEEK_OFFSET - _loc4_) / WEEK_MILLIS;
      }
      
      public static function addGourmetPoints(param1:Number, param2:Boolean = true) : void
      {
         gameUser.gourmetPoints.value += Math.floor(param1 * 10);
         if(param2)
         {
            checkLevelUp();
         }
      }
      
      public static function getPurchaseItemGourmetPoint(param1:Object) : int
      {
         if(Boolean(param1.cash) && param1.cash > 0)
         {
            return Math.min(GOURMET_POINTS_BUY_ITEM_MAX,Math.floor(GOURMET_POINTS_BUY_ITEM_PER_PLAYFISH_CASH * param1.cash));
         }
         return Math.min(GOURMET_POINTS_BUY_ITEM_MAX,Math.floor(GOURMET_POINTS_BUY_ITEM_PER_COIN * param1.cost));
      }
      
      private static function onEvaluateFriendshipComplete() : void
      {
         var _loc1_:int = 0;
         var _loc2_:NetworkUid = null;
         var _loc3_:GameUser = null;
         Debug.out("onEvaluateFriendshipComplete");
         bestFriendListFromSocialStats = SocialStats.getBestFriendList();
         if(bestFriendListFromSocialStats)
         {
            _loc1_ = 0;
            while(_loc1_ < bestFriendListFromSocialStats.length)
            {
               _loc2_ = SocialPlatform.instance.getNetworkID(bestFriendListFromSocialStats[_loc1_].uid);
               _loc3_ = getGameUserWithId(_loc2_);
               if(_loc3_)
               {
                  bestFriendUsers.push(_loc3_);
               }
               _loc1_++;
            }
         }
      }
      
      public static function hireUser(param1:GameUser, param2:Boolean) : GameUserEmployee
      {
         var _loc3_:GameUserEmployee = new GameUserEmployee();
         _loc3_.gameUser = param1;
         _loc3_.gameUser.employerUser = gameUser;
         _loc3_.gameUser.cacheAvatarFrame();
         _loc3_.workTime = GameUserEmployee.MAX_WORK_TIME;
         _loc3_.job = GameUserEmployee.JOB_NONE;
         saveProfileHandler.addHiredEmployees(_loc3_,param2);
         gameUser.employeeUsers.push(_loc3_);
         gameUser.employeeCount.value += 1;
         hiredFriendsPanel.addHiredUser(_loc3_);
         return _loc3_;
      }
      
      private static function onShareLevelUpClick(param1:int, param2:WorldPopUp) : void
      {
         var level:int = param1;
         var popup:WorldPopUp = param2;
         var popupScene:MovieClip = popup.getPopupContent();
         var shareButton:MovieClip = popupScene.mc_share;
         var logParam:String = shareButton.mc_content.tf_text.text;
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_BUTTON_CLICK,logParam.toLocaleLowerCase(),function():void
         {
         },function():void
         {
         });
         Debug.out("Logging Button Click Event: " + logParam.toLocaleLowerCase());
         textHandler.setReplaceString("FeedFormGameLink",FEED_FORM_GAME_LINK);
         textHandler.setReplaceString("Level",gameUser.level.value.toString());
         textHandler.setReplaceString("PlayerName",gameUser.firstName);
         if(level == 1)
         {
            postFeed(textHandler.getTextFromId("Level1StreamTitle"),textHandler.getTextFromId("Level1StreamInformation"),textHandler.getTextFromId("Level1StreamCaption"),textHandler.getTextFromId("Level1StreamDescription"),textHandler.getTextFromId("Level1StreamLinkText"),STREAM_FEED_GAME_LINK + "&" + textHandler.getTextFromId("Level1StreamLinkRef"),textHandler.getTextFromId("Level1StreamDashboardText"),null,textHandler.getTextFromId("LevelUpFeedTitle"),textHandler.getTextFromId("LevelUpFeedBody"),textHandler.getTextFromId("FeedLinkText"),FEED_FORM_GAME_LINK,"",["levelup.png"]);
         }
         else
         {
            postFeed(textHandler.getTextFromId("LevelUpStreamTitle"),textHandler.getTextFromId("LevelUpStreamInformation"),textHandler.getTextFromId("LevelUpStreamCaption"),textHandler.getTextFromId("LevelUpStreamDescription"),textHandler.getTextFromId("LevelUpStreamLinkText"),STREAM_FEED_GAME_LINK + "&" + textHandler.getTextFromId("LevelUpStreamLinkRef"),textHandler.getTextFromId("LevelUpStreamDashboardText"),null,textHandler.getTextFromId("LevelUpFeedTitle"),textHandler.getTextFromId("LevelUpFeedBody"),textHandler.getTextFromId("FeedLinkText"),FEED_FORM_GAME_LINK,"",["levelup.png"]);
         }
         popup.remove();
         Debug.out("popup.remove()");
      }
      
      private static function clearFadeMask() : void
      {
         if(fadeMask != null)
         {
            Engine.worldContainer.removeObject(fadeMask);
            fadeBitmapData.dispose();
            fadeBitmapData = null;
            fadeMask = null;
         }
      }
      
      public static function getUserAtIndex(param1:int, param2:Array) : UserInfo
      {
         if(param2 != null)
         {
            return param2[param1];
         }
         return null;
      }
      
      public static function isItemAffordable(param1:Object) : Boolean
      {
         if(param1.cash > 0)
         {
            return gameUser.playfishCash.value >= param1.cash;
         }
         return gameUser.money.value >= param1.cost;
      }
      
      public static function getPlayingFriendUsers() : Array
      {
         var _loc1_:Array = GameWorld.cachedGameUsers[RpcClient.USER_CONTEXT_FRIENDS | RpcClient.TIME_CONTEXT_ALL];
         if(_loc1_ == null || _loc1_.length == 0)
         {
            _loc1_ = [GameWorld.gameUser];
         }
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(Boolean(_loc1_[_loc3_].userInfo.offlineShard) || _loc1_[_loc3_].userInfo.playCount > 0)
            {
               _loc2_.push(_loc1_[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function init(param1:GameInitLoader) : void
      {
         OverlaySetting.loadSettings();
         textHandler = new TextHandler();
         textHandler.curLangCode = "en";
         var _loc2_:ByteArray = param1.fileLoader.getBytes("lang_en");
         _loc2_.uncompress();
         var _loc3_:TextGroup = textHandler.load("en",_loc2_,true);
         var _loc4_:Number = Engine.instance.startServerTime.time;
         if(Debug.DEBUG)
         {
            _loc4_ += DebugAddShopTime.dayAdded * 24 * 60 * 60 * 1000;
         }
         var _loc5_:int = getShopWeek(_loc4_);
         Debug.out("shop week=" + _loc5_ + " shop time=" + _loc4_ + " shop date=" + new Date(_loc4_).toString());
         _loc2_ = param1.fileLoader.getBytes("front_bin");
         _loc2_.uncompress();
         buildingItemDatabase = new ItemDatabase(_loc2_);
         _loc2_ = param1.fileLoader.getBytes("avatar_bin");
         _loc2_.uncompress();
         avatarItemDatabase = new ItemDatabase(_loc2_);
         _loc2_ = param1.fileLoader.getBytes("restaurant_bin");
         _loc2_.uncompress();
         interiorItemDatabase = new ItemDatabase(_loc2_);
         _loc2_ = param1.fileLoader.getBytes("perk_bin");
         _loc2_.uncompress();
         perkItemDatabase = new ItemDatabase(_loc2_);
         _loc2_ = param1.fileLoader.getBytes("ingredient_bin");
         _loc2_.uncompress();
         ingredientItemDatabase = new ItemDatabase(_loc2_);
         _loc2_ = param1.fileLoader.getBytes("recipe_bin");
         _loc2_.uncompress();
         recipeItemDatabase = new ItemDatabase(_loc2_);
         _loc2_ = param1.fileLoader.getBytes("quiz_bin");
         _loc2_.uncompress();
         quizItemDatabase = new ItemDatabase(_loc2_);
         _loc2_ = param1.fileLoader.getBytes("challenge_bin");
         _loc2_.uncompress();
         challengeDatabase = new ChallengeDatabase(_loc2_);
         _loc2_ = param1.fileLoader.getBytes("appointment_bin");
         _loc2_.uncompress();
         appointmentItemDatabase = new ItemDatabase(_loc2_);
         newsletterHandler = new NewsletterHandler(param1.fileLoader.getBytes("newsletter"));
         view3d = new View3D();
         light = new DirectionalLight3D();
         light.specular = 0;
         light.ambient = 0.5;
         light.diffuse = 1;
         view3d.scene.addChild(light);
         _loc2_ = param1.fileLoader.getBytes("model_bin");
         _loc2_.uncompress();
         baseModel = Collada.parse(_loc2_,{"materials":{
            "tray":Engine.getMovieClip("Tray") || "Tray",
            "cleaner":Engine.getMovieClip("Cleaner") || "Cleaner",
            "repair":Engine.getMovieClip("Repair") || "Repair"
         }});
         var propMaterialClip:MovieClip = Engine.getMovieClip("Tray");
         if(propMaterialClip != null && baseModel.materialLibrary.getMaterial("tray") != null)
         {
            baseModel.materialLibrary.getMaterial("tray").material = new MovieMaterial(propMaterialClip);
         }
         propMaterialClip = Engine.getMovieClip("Cleaner");
         if(propMaterialClip != null && baseModel.materialLibrary.getMaterial("cleaner") != null)
         {
            baseModel.materialLibrary.getMaterial("cleaner").material = new MovieMaterial(propMaterialClip);
         }
         propMaterialClip = Engine.getMovieClip("Repair");
         if(propMaterialClip != null && baseModel.materialLibrary.getMaterial("repair") != null)
         {
            baseModel.materialLibrary.getMaterial("repair").material = new MovieMaterial(propMaterialClip);
         }
         baseCustomiseAvatarModel = ObjectContainer3D(baseModel.cloneAll());
         placeholderUser = new GameUser(null);
         placeholderUser.skinColour = 16777215;
         placeholderUser.hairColour = 16777215;
         placeholderUser.usedAvatarItems = new Array();
         placeholderUser.addUsedAvatarItem(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Placeholder Pants","Pants")));
         placeholderUser.addUsedAvatarItem(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Placeholder Shirt","Shirt")));
         placeholderUser.addUsedAvatarItem(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Placeholder Hair","Hair")));
         var _loc6_:CacheUserAnimationQueueItem = placeholderUser.loadAnimationFrames([Avatar3D.ANIMATION_IDLE,Avatar3D.ANIMATION_WALK,Avatar3D.ANIMATION_SIT,Avatar3D.ANIMATION_EAT,Avatar3D.ANIMATION_COOKING,Avatar3D.ANIMATION_WAITOR_WALK,Avatar3D.ANIMATION_WAITOR_WORKING,Avatar3D.ANIMATION_DEAD,Avatar3D.ANIMATION_STREET_IDLE,Avatar3D.ANIMATION_STREET_WALK,Avatar3D.ANIMATION_CLEAN,Avatar3D.ANIMATION_CLEANER_IDLE,Avatar3D.ANIMATION_CLEANER_WALK,Avatar3D.ANIMATION_CLEANER_DEAD,Avatar3D.ANIMATION_CLEANER_REPAIR]);
         param1.getUserProfileRpc.applyData();
         param1.getAllFriendsRpc.applyData();
         param1.getCashBalance.applyData();
         param1.getReceivedMailsRpc.applyData();
         if(SocialNetworkAvailable && SocialPlatform.current.user.getFriendIDList().length > 0)
         {
            SocialPlatform.instance.application.setFriendshipMetric(FriendshipMetric.PHOTOGRAPHIC_SUBJECT);
            SocialPlatform.current.user.evaluateFriendship(SocialPlatform.current.user.getFriendIDList()[0],onEvaluateFriendshipComplete);
            SocialPlatform.instance.feeds.registerFeedType("nudge","fb::news");
         }
         param1.onGameWorldInitSuccess();
      }
      
      public static function stopGlobalRpcs() : void
      {
         Debug.out("stopGlobalRpcs");
         globalRpcsTimer = -2;
      }
      
      public static function greyOutDisplayObject(param1:DisplayObject) : void
      {
         var _loc2_:Array = [0.3,0.3,0.3,0,70,0.3,0.3,0.3,0,70,0.3,0.3,0.3,0,70,0,0,0,1,0];
         param1.filters = new Array(new ColorMatrixFilter(_loc2_));
      }
      
      public static function checkLevelUp() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:GameSound = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Plot = null;
         var _loc10_:GardenPlot = null;
         var _loc11_:GameUserEmployee = null;
         var _loc1_:int = gameUser.level.value;
         var _loc2_:int = getLevel(gameUser.getGourmetPoints());
         if(_loc2_ > _loc1_)
         {
            _loc2_ = _loc1_ + 1;
            _loc3_ = LEVEL_THRESHOLDS[_loc1_];
            _loc4_ = LEVEL_THRESHOLDS[_loc2_];
            if(_loc2_ == 1)
            {
               showLevelUpPopUp(_loc2_,textHandler.getTextFromId("LevelUpFirst"),"roomSize",LEVEL_THRESHOLDS[_loc2_].coinReward);
            }
            else
            {
               _loc7_ = int(_loc4_.coinReward);
               if(_loc4_.roomSizeX > _loc3_.roomSizeX || _loc4_.roomSizeY > _loc3_.roomSizeY)
               {
                  showLevelUpPopUp(_loc2_,textHandler.getTextFromId("LevelUpBiggerRestaurant"),"roomSize",_loc7_);
                  _loc7_ = 0;
               }
               if(_loc4_.employees > _loc3_.employees)
               {
                  textHandler.setReplaceString("NumberOfEmployees",_loc4_.employees);
                  showLevelUpPopUp(_loc2_,textHandler.getTextFromId("LevelUpMoreEmployee"),"employees",_loc7_);
                  _loc7_ = 0;
               }
               if(_loc4_.numDishes > _loc3_.numDishes)
               {
                  textHandler.setReplaceString("NumberOfDishes",_loc4_.numDishes);
                  showLevelUpPopUp(_loc2_,textHandler.getTextFromId("LevelUpMoreDishes"),"numDishes",_loc7_);
                  _loc7_ = 0;
               }
               if(_loc4_.gardenPlots > _loc3_.gardenPlots)
               {
                  showLevelUpPopUp(_loc2_,textHandler.getTextFromId("LevelUpMoreGardenPlots"),"garden",_loc7_);
                  _loc7_ = 0;
               }
               if(_loc4_.layouts > _loc3_.layouts)
               {
                  showLevelUpPopUp(_loc2_,textHandler.getTextFromId("LevelUpMoreLayouts"),"layout",_loc7_);
                  _loc7_ = 0;
               }
               if(_loc2_ == DRINK_START_LEVEL)
               {
                  showLevelUpPopUp(_loc2_,textHandler.getTextFromId("LevelUpLearnAndServeDrinks"),"drinks",_loc7_);
                  _loc7_ = 0;
               }
               if(_loc7_)
               {
                  showLevelUpPopUp(_loc2_,textHandler.getTextFromId("LevelUpGeneric"),"roomSize",_loc7_);
                  _loc7_ = 0;
               }
            }
            if(_loc4_.employees != _loc3_.employees)
            {
               setMaxEmployees(_loc4_.employees);
            }
            _loc5_ = int(_loc4_.gardenPlots);
            if(_loc5_ > gameUser.gardenPlots.length)
            {
               _loc8_ = int(gameUser.gardenPlots.length);
               while(_loc8_ < _loc5_)
               {
                  _loc9_ = new Plot();
                  _loc9_.id = _loc8_;
                  _loc9_.ingredientId = 0;
                  _loc9_.plantWetTime = 0;
                  _loc9_.timeToDry = 0;
                  _loc10_ = new GardenPlot(_loc9_);
                  gameUser.gardenPlots.push(_loc10_);
                  _loc8_++;
               }
            }
            _loc8_ = 0;
            while(_loc8_ < gameUser.employeeUsers.length)
            {
               _loc11_ = gameUser.employeeUsers[_loc8_];
               _loc11_.workTime = GameUserEmployee.MAX_WORK_TIME;
               _loc8_++;
            }
            showNextLevelPopUp(_loc2_);
            if(_loc2_ != 1)
            {
               if(_loc2_ == 2)
               {
                  showTutorialTextPopUp(textHandler.getTextFromId("LevelUpHint2"));
               }
               else if(_loc2_ == 3)
               {
                  showTutorialTextPopUp(textHandler.getTextFromId("LevelUpHint3_1"));
               }
               else if(_loc2_ == TOILET_START_LEVEL)
               {
                  showTutorialTextPopUp(textHandler.getTextFromId("LevelUpHintToilet"));
               }
               else if(_loc2_ == DRINK_START_LEVEL)
               {
                  showTutorialTextPopUp(textHandler.getTextFromId("LevelUpHintDrinks"));
               }
            }
            saveProfileHandler.levelUp(_loc2_);
            cashPanel.addCoins(LEVEL_THRESHOLDS[_loc2_].coinReward);
            _loc6_ = new GameSound("SfxLevelUp",GameSound.TYPE_SOUND);
            _loc6_.play(1);
            gameUser.level.value = _loc2_;
            checkNextLevelUp = true;
            if(gameEventDispatcher.hasEventListener(GameEvent.LEVEL_UP))
            {
               gameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.LEVEL_UP));
            }
         }
         else
         {
            if(checkNextLevelUp)
            {
               forceAutoSave();
            }
            checkNextLevelUp = false;
         }
      }
      
      public static function sortUsers(param1:Array, param2:Function) : Array
      {
         return param1.sort(param2);
      }
      
      private static function onFullScreen(param1:Event) : void
      {
         cashPanel.y = Engine.getStageY();
         settingOverlay.y = Engine.getStageY();
         cashPanel.x = Engine.getStageX();
         settingOverlay.x = Engine.getStageX();
         settingOverlay.refreshIcons();
      }
      
      public static function isItemLevelReached(param1:Object) : Boolean
      {
         if(DebugToggleLevelGate.disabled)
         {
            return true;
         }
         if(param1.unlockLevel)
         {
            return gameUser.level.value >= int(param1.unlockLevel);
         }
         return true;
      }
      
      public static function getOfflineCustomers(param1:int) : int
      {
         var _loc10_:GameUserEmployee = null;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         while(_loc8_ < gameUser.employeeUsers.length)
         {
            _loc10_ = gameUser.employeeUsers[_loc8_];
            _loc11_ = _loc10_.job;
            if(_loc11_ != GameUserEmployee.JOB_NONE && _loc11_ != GameUserEmployee.JOB_REST)
            {
               if(_loc11_ == GameUserEmployee.JOB_WAITOR)
               {
                  _loc4_.push(_loc10_);
                  _loc3_ = Math.max(_loc10_.workTime,_loc3_);
               }
               else if(_loc11_ == GameUserEmployee.JOB_COOK)
               {
                  _loc5_.push(_loc10_);
                  _loc2_ = Math.max(_loc10_.workTime,_loc2_);
               }
            }
            if(_loc11_ == GameUserEmployee.JOB_REST)
            {
               _loc6_++;
            }
            _loc8_++;
         }
         _loc7_ = Math.min(_loc2_,_loc3_);
         var _loc9_:Boolean = hasEntrancesToRestaurant();
         Debug.out("hasEntrances=" + _loc9_);
         if(_loc9_ && _loc4_.length > 0 && _loc5_.length > 0 && _loc7_ > 0)
         {
            _loc12_ = _loc7_ / 1000;
            _loc13_ = 0;
            if(_loc12_ > param1)
            {
               _loc12_ = param1;
               _loc13_ = _loc7_ - _loc12_ * 1000;
            }
            _loc14_ = Math.min(gameUser.getDemandPoints(),MAX_DEMAND) - 1;
            _loc15_ = Math.floor(_loc14_ * WorldRestaurantPlay.CUSTOMERS_PER_MINUTE_PER_DEMAND * _loc12_ / 60);
            _loc16_ = _loc15_ * (_loc7_ + _loc13_) / GameUserEmployee.MAX_WORK_TIME / 2;
            _loc16_ = _loc16_ * (gameUser.employeeUsers.length - _loc6_) / gameUser.employeeUsers.length;
            Debug.out("start happiness " + _loc7_ + " end happiness=" + _loc13_ + " durationSecs=" + _loc12_ + " visiting customers=" + _loc15_ + " paying customers=" + _loc16_ + " working ratio=" + (gameUser.employeeUsers.length - _loc6_) / gameUser.employeeUsers.length);
            return _loc16_;
         }
         return 0;
      }
      
      public static function ensureItemNumber(param1:int, param2:int) : void
      {
         var _loc4_:* = 0;
         var _loc5_:UserItem = null;
         var _loc6_:InventoryUserItem = null;
         var _loc3_:Array = gameUser.getAllInventoryItemsWithId(param1);
         if(_loc3_ != null)
         {
            _loc3_ = _loc3_.concat(gameUser.getUsedRestaurantItems(param1));
         }
         else
         {
            _loc3_ = gameUser.getUsedRestaurantItems(param1);
         }
         if(_loc3_.length > param2)
         {
            _loc4_ = int(_loc3_.length - 1);
            while(_loc4_ >= param2)
            {
               _loc5_ = _loc3_[_loc4_];
               Debug.out("selling extra item " + _loc5_.itemConfig.name);
               if(_loc5_ is InventoryUserItem)
               {
                  gameUser.removeInventoryItem(_loc5_ as InventoryUserItem);
                  saveProfileHandler.sellItem(_loc5_,1,true);
               }
               else
               {
                  gameUser.removeUsedRestaurantItem(_loc5_.serverUid);
                  saveProfileHandler.sellItem(_loc5_,1,false);
               }
               _loc4_--;
            }
         }
         else if(_loc3_.length < param2)
         {
            _loc4_ = int(_loc3_.length);
            while(_loc4_ < param2)
            {
               _loc6_ = new InventoryUserItem(getItemConfig(param1));
               Debug.out("buying missing item " + _loc6_.itemConfig.name);
               gameUser.addInventoryItem(_loc6_);
               saveProfileHandler.purchaseItem(_loc6_);
               _loc4_++;
            }
         }
      }
      
      private static function onGlobalRpcsSuccess(param1:RpcEvent) : void
      {
         Debug.out("onGlobalRpcsSuccess");
         if(Debug.NETWORK_ONLY && param1.successCode == RpcClient.STATUS_SAVE_FAIL)
         {
            error();
         }
         else if(globalRpcsTimer == -1)
         {
            globalRpcsTimer = 0;
         }
      }
      
      public static function compareUserAlphabetAscending(param1:GameUser, param2:GameUser) : int
      {
         var _loc3_:String = param1.firstName.toLowerCase();
         var _loc4_:String = param2.firstName.toLowerCase();
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function onInviteClicked() : ExternalPage
      {
         Engine.setFullScreen(false);
         var _loc1_:ExternalPage = new ExternalPage("invite");
         _loc1_.show();
         return _loc1_;
      }
      
      public static function tickOfflineTimeForUser(param1:GameUser, param2:int) : void
      {
         var _loc3_:int = param2 / TRASH_APPEAR_RATE.value;
         param1.trashCount.value = Math.min(param1.trashCount.value + _loc3_,MAX_TRASH);
         trashTimer = TRASH_APPEAR_RATE.value - param2 % TRASH_APPEAR_RATE.value;
         param1.tick(param2);
      }
      
      public static function getShopResUrl(param1:String, param2:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         while(_loc4_ <= 10)
         {
            _loc3_ = Engine.instance.resHandler.getResUrl(param1 + "_" + (param2 - _loc4_).toString());
            if(_loc3_ != null)
            {
               break;
            }
            _loc4_++;
         }
         if(_loc3_ == null)
         {
            _loc3_ = Engine.instance.resHandler.getResUrl(param1);
         }
         Debug.out("shop res " + param1 + "_" + param2.toString() + " url=" + _loc3_);
         return _loc3_;
      }
      
      public static function checkBuildingItems() : void
      {
         var _loc1_:UserItem = null;
         var _loc2_:UserItem = null;
         var _loc3_:UserItem = null;
         var _loc4_:UserItem = null;
         var _loc6_:UserItem = null;
         var _loc5_:* = int(gameUser.usedBuildingItems.length - 1);
         while(_loc5_ >= 0)
         {
            _loc6_ = gameUser.usedBuildingItems[_loc5_];
            if(_loc6_.itemConfig.roof)
            {
               if(_loc1_ == null)
               {
                  _loc1_ = _loc6_;
               }
               else
               {
                  Debug.out("moving extra building roof " + _loc6_.itemConfig.name + " to inventory");
                  moveUsedBuildingItemToInventory(_loc6_);
               }
            }
            else if(_loc6_.itemConfig.body)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = _loc6_;
               }
               else
               {
                  Debug.out("moving extra building body " + _loc6_.itemConfig.name + " to inventory");
                  moveUsedBuildingItemToInventory(_loc6_);
               }
            }
            else if(_loc6_.itemConfig.wallTile)
            {
               if(_loc4_ == null)
               {
                  _loc4_ = _loc6_;
               }
               else
               {
                  Debug.out("moving extra building tile " + _loc6_.itemConfig.name + " to inventory");
                  moveUsedBuildingItemToInventory(_loc6_);
               }
            }
            else if(_loc6_.itemConfig.banner)
            {
               if(_loc3_ == null)
               {
                  _loc3_ = _loc6_;
               }
               else
               {
                  Debug.out("moving extra building banner " + _loc6_.itemConfig.name + " to inventory");
                  moveUsedBuildingItemToInventory(_loc6_);
               }
            }
            _loc5_--;
         }
      }
      
      public static function compareUserRatingAscending(param1:GameUser, param2:GameUser) : int
      {
         var _loc3_:UserInfo = param1.userInfo;
         var _loc4_:UserInfo = param2.userInfo;
         if(_loc3_.nbVote <= 0 && _loc4_.nbVote <= 0)
         {
            return compareUserPointAscending(param1,param2);
         }
         if(_loc3_.nbVote <= 0)
         {
            return -1;
         }
         if(_loc4_.nbVote <= 0)
         {
            return 1;
         }
         var _loc5_:Number = _loc3_.totalMark / _loc3_.nbVote;
         var _loc6_:Number = _loc4_.totalMark / _loc4_.nbVote;
         if(_loc5_ == _loc6_)
         {
            if(_loc3_.nbVote < _loc4_.nbVote)
            {
               return -1;
            }
            if(_loc3_.nbVote > _loc4_.nbVote)
            {
               return 1;
            }
         }
         else
         {
            if(_loc5_ < _loc6_)
            {
               return -1;
            }
            if(_loc5_ > _loc6_)
            {
               return 1;
            }
         }
         return 0;
      }
      
      public static function getOfflineGourmetPoints(param1:int) : Number
      {
         var _loc2_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         if(gameUser.level.value >= GameWorld.DRINK_START_LEVEL)
         {
            _loc2_ = Recipe.NUM_MENU_RECIPE_TYPE;
         }
         else
         {
            _loc2_ = Recipe.NUM_MENU_RECIPE_TYPE - 1;
         }
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = gameUser.getSelectedRecipes(_loc4_);
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc5_ += GOURMET_POINTS_PER_DISH + GOURMET_POINTS_PER_DISH_LEVEL * (_loc7_[_loc8_].level - 1);
               _loc6_++;
               _loc8_++;
            }
            _loc5_ /= _loc6_;
            Debug.out("averageCourseGP=" + _loc5_ + " count=" + _loc6_ + " course=" + _loc4_);
            _loc3_ += _loc5_;
            _loc4_++;
         }
         _loc3_ /= _loc2_;
         Debug.out("offline GP=" + _loc3_ * param1 + " customers=" + param1 + " gp per customer=" + _loc3_);
         return _loc3_ * param1;
      }
      
      public static function showNextLevelPopUp(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:MovieClip = null;
         var _loc2_:MovieClip = Engine.getMovieClip("NextLevelPopupAnim");
         var _loc3_:MovieClip = _loc2_.mc_content;
         textHandler.setTextFieldWithId(_loc3_.tf_title,"NextLevelAt");
         if(param1 < LEVEL_THRESHOLDS.length - 1)
         {
            _loc5_ = param1 + 1;
            _loc6_ = LEVEL_THRESHOLDS[param1];
            _loc7_ = LEVEL_THRESHOLDS[_loc5_];
            textHandler.setTextFieldWithId(_loc3_.tf_nextUpgrade,"NextUpgrade");
            _loc3_.tf_points.text = _loc7_.points;
            _loc8_ = new Array();
            if(_loc7_.roomSizeX > _loc6_.roomSizeX || _loc7_.roomSizeY > _loc6_.roomSizeY)
            {
               _loc14_ = Engine.getMovieClip("LevelUpIcons");
               _loc14_.gotoAndStop("roomSize");
               _loc14_.tooltip = new ToolTip(_loc14_,textHandler.getTextFromId("LevelUpLargerRestaurant"),false,true);
               _loc8_.push(_loc14_);
            }
            if(_loc7_.employees > _loc6_.employees)
            {
               _loc14_ = Engine.getMovieClip("LevelUpIcons");
               _loc14_.gotoAndStop("employees");
               _loc14_.tooltip = new ToolTip(_loc14_,textHandler.getTextFromId("LevelUpOneMoreEmployee"),false,true);
               _loc8_.push(_loc14_);
            }
            if(_loc7_.numDishes > _loc6_.numDishes)
            {
               _loc14_ = Engine.getMovieClip("LevelUpIcons");
               _loc14_.gotoAndStop("numDishes");
               _loc14_.tooltip = new ToolTip(_loc14_,textHandler.getTextFromId("LevelUpServeMoreDishes"),false,true);
               _loc8_.push(_loc14_);
            }
            if(_loc7_.gardenPlots > _loc6_.gardenPlots)
            {
               _loc14_ = Engine.getMovieClip("LevelUpIcons");
               _loc14_.gotoAndStop("garden");
               _loc14_.tooltip = new ToolTip(_loc14_,textHandler.getTextFromId("LevelUpPlotUnlocked"),false,true);
               _loc8_.push(_loc14_);
            }
            if(_loc7_.layouts > _loc6_.layouts)
            {
               _loc14_ = Engine.getMovieClip("LevelUpIcons");
               _loc14_.gotoAndStop("layout");
               _loc14_.tooltip = new ToolTip(_loc14_,textHandler.getTextFromId("LevelUpLayoutUnlocked"),false,true);
               _loc8_.push(_loc14_);
            }
            if(_loc5_ == DRINK_START_LEVEL)
            {
               _loc14_ = Engine.getMovieClip("LevelUpIcons");
               _loc14_.gotoAndStop("drinks");
               _loc14_.tooltip = new ToolTip(_loc14_,textHandler.getTextFromId("LevelUpDrinksUnlocked"),false,true);
               _loc8_.push(_loc14_);
            }
            _loc9_ = _loc3_.mc_icon.width / 3;
            _loc10_ = _loc3_.mc_icon.width + _loc9_;
            _loc11_ = _loc10_ * _loc8_.length - _loc9_;
            _loc12_ = -_loc11_ / 2 + _loc3_.mc_icon.width / 2;
            _loc13_ = 0;
            while(_loc13_ < _loc8_.length)
            {
               _loc8_[_loc13_].x = _loc12_;
               _loc8_[_loc13_].y = _loc3_.mc_icon.y;
               _loc8_[_loc13_].buttonMode = true;
               _loc12_ += _loc10_;
               _loc3_.addChild(_loc8_[_loc13_]);
               _loc13_++;
            }
         }
         else
         {
            _loc3_.stop();
            _loc3_.tf_points.text = "- - -";
            textHandler.setTextFieldWithId(_loc3_.tf_nextUpgrade,"LevelUpMaximumLevelReached");
         }
         _loc3_.mc_icon.visible = false;
         var _loc4_:WorldPopUp = new WorldPopUp(_loc2_,_loc3_.mc_tick,null);
         _loc4_.x = CANVAS_CENTER_X;
         _loc4_.y = CANVAS_CENTER_Y;
         _loc4_.queueToShow();
      }
      
      public static function firstTimeAccess(param1:int) : Boolean
      {
         var _loc2_:int = Math.floor(param1 / 8) + GameSettings.TYPE_FIRST_TIME_ACCESS;
         var _loc3_:int = 1 << param1 % 8;
         var _loc4_:int = gameUser.settings.getValue(_loc2_);
         return (_loc4_ & _loc3_) == 0;
      }
      
      public static function checkTrophiesItems() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc1_:Number = 0;
         while(_loc1_ < GameAwards.AWARD_PARAMS.length)
         {
            _loc2_ = gameUser.awards.getAwardLevel(_loc1_);
            _loc3_ = GameAwards.AWARD_PARAMS[_loc1_].length - 1;
            while(_loc3_ >= 0)
            {
               _loc4_ = GameAwards.AWARD_PARAMS[_loc1_][_loc3_];
               if(_loc3_ == _loc2_)
               {
                  ensureItemNumber(_loc4_.itemId,1);
               }
               else
               {
                  ensureItemNumber(_loc4_.itemId,0);
               }
               _loc3_--;
            }
            _loc1_++;
         }
      }
      
      public static function getUserWithRank(param1:Array, param2:Array, param3:int) : UserInfo
      {
         var _loc4_:Number = 0;
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_] == param3)
            {
               return param1[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      public static function clearHighscoreCaches() : void
      {
         cachedGameUsers = new Array();
      }
      
      public static function getShopWeek(param1:Number) : int
      {
         return getWeekCount(param1,SHOP_UPDATE_DAY_IN_WEEK,SHOP_UPDATE_HOUR_IN_DAY);
      }
      
      private static function moveUsedRestaurantItemToInventory(param1:UserItem) : void
      {
         var _loc2_:InventoryUserItem = new InventoryUserItem(param1.itemConfig,param1.getOwnedItem());
         gameUser.addInventoryItem(_loc2_);
         gameUser.removeUsedRestaurantItem(param1.serverUid);
         saveProfileHandler.moveItem(_loc2_,false);
      }
      
      public static function showBookmarkOverlay() : ExternalPage
      {
         Engine.setFullScreen(false);
         var _loc1_:ExternalPage = new ExternalPage("bookmark");
         _loc1_.show();
         return _loc1_;
      }
      
      public static function startGlobalRpcs() : void
      {
         Debug.out("startGlobalRpcs " + globalRpcsTimer);
         if(globalRpcsTimer == -2)
         {
            globalRpcsTimer = 0;
         }
      }
      
      public static function getItemSellPrice(param1:Object) : Number
      {
         if(param1.cash > 0)
         {
            return param1.cash * 330;
         }
         return Math.floor(param1.cost / 3);
      }
      
      public static function tickOfflineTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(offlineEarningTimer != -1)
         {
            _loc1_ = getTimer() - offlineEarningTimer;
            if(_loc1_ > 0)
            {
               _loc2_ = getOfflineCustomers(_loc1_ / 1000);
               _loc3_ = getEarnings(_loc2_);
               if(_loc3_ > 0)
               {
                  _loc5_ = _loc3_ / COST_PER_DISH;
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     GameWorld.saveProfileHandler.addPaidMeal(COST_PER_DISH);
                     _loc6_++;
                  }
                  offlineEarning += _loc3_;
               }
               _loc4_ = getOfflineGourmetPoints(_loc2_);
               offlineGourmetPoints += _loc4_;
               addGourmetPoints(_loc4_,false);
               tickOfflineTimeForUser(gameUser,_loc1_);
            }
            offlineEarningTimer = getTimer();
            Debug.out("tickOfflineTime earning=" + _loc3_ + " total=" + offlineEarning);
         }
      }
      
      public static function addNewMail(param1:Mail) : MailItem
      {
         var _loc3_:Number = NaN;
         var _loc4_:IngredientItem = null;
         var _loc5_:Number = NaN;
         var _loc6_:MailItem = null;
         var _loc2_:MailItem = new MailItem(param1);
         if(param1.type == RpcClient.MAIL_TYPE_DAILYINGREDIENT)
         {
            if(gameUser.userInfo.playCount > 1 && gameUser.level.value > 0)
            {
               WorldRestaurantPlay.dailyIngredientMail = _loc2_;
               if(Debug.DEBUG)
               {
                  Debug.out("Daily Bonus Mail, length=" + param1.globalItemIds.length);
                  for each(_loc3_ in param1.globalItemIds)
                  {
                     _loc4_ = new IngredientItem(GameWorld.getItemConfig(_loc3_));
                     Debug.out("\t#" + _loc3_ + " [" + _loc4_.name + "]");
                  }
               }
            }
         }
         else if(param1.type == RpcClient.MAIL_FOOD_KING_ITEM || param1.type == RpcClient.MAIL_FAN_PAGE_ITEM)
         {
            GameWorld.receivedFeedItems.push(new FoodKingItem(param1.globalItemIds[0],param1.type,param1.message));
            saveProfileHandler.addDeletedMail(_loc2_);
         }
         else if(param1.type == RpcClient.FOOD_KING_FEED_EXCEPTION || param1.type == RpcClient.FAN_PAGE_FEED_EXCEPTION)
         {
            GameWorld.invalidFeedItems.push(param1);
            saveProfileHandler.addDeletedMail(_loc2_);
         }
         else if(param1.type == RpcClient.MAIL_SPECIAL_DAY_ITEM)
         {
            WorldRestaurantPlay.specialDayPresentMails.push(_loc2_);
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < gameUser.mailItems.length)
            {
               _loc6_ = gameUser.mailItems[_loc5_];
               if(_loc2_.mailObject.sendDate > _loc6_.mailObject.sendDate)
               {
                  gameUser.mailItems.splice(_loc5_,0,_loc2_);
                  break;
               }
               _loc5_++;
            }
            if(_loc5_ == gameUser.mailItems.length)
            {
               gameUser.mailItems.push(_loc2_);
            }
         }
         return _loc2_;
      }
      
      public static function compareUserPointAscending(param1:GameUser, param2:GameUser) : int
      {
         var _loc3_:int = param1.gourmetPoints.value;
         var _loc4_:int = param2.gourmetPoints.value;
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function getUserProfileIndex(param1:Array) : int
      {
         var _loc2_:NetworkUid = null;
         var _loc3_:Number = NaN;
         if(param1 != null && gameUser != null)
         {
            _loc2_ = gameUser.userInfo.id;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(NetworkUid.areEqual(param1[_loc3_].id,_loc2_))
               {
                  return _loc3_;
               }
               _loc3_++;
            }
         }
         return -1;
      }
      
      public static function setUserInfo(param1:UserInfo) : void
      {
         gameUser = new GameUser(param1);
         gameUser.addItemsFromProfileObject(param1,GameUser.ITEM_CONTEXT_AVATAR | GameUser.ITEM_CONTEXT_BUILDING | GameUser.ITEM_CONTEXT_RESTAURANT);
         textHandler.setReplaceString("FirstName",param1.firstName);
         textHandler.setReplaceString("LastName",param1.fullName);
      }
      
      public static function tick(param1:uint) : void
      {
         inactiveTimer += param1;
         if(globalRpcsTimer >= 0)
         {
            globalRpcsTimer += param1;
            if(inactiveTimer >= INACTIVE_TIME)
            {
               if(globalRpcsTimer >= GLOBAL_RPC_COMMIT_INTERVAL_INACTIVE)
               {
                  forceAutoSave();
               }
            }
            else if(globalRpcsTimer >= GLOBAL_RPC_COMMIT_INTERVAL)
            {
               forceAutoSave();
            }
         }
         if(fadeMask != null)
         {
            fadeMask.alpha -= 0.1;
            if(fadeMask.alpha <= 0)
            {
               clearFadeMask();
            }
         }
         if(checkNextLevelUp)
         {
            if(WorldPopUp.activePopUp.length == 0)
            {
               checkLevelUp();
            }
         }
         if(Debug.DEBUG)
         {
            if(Engine.isKeyPressed(Engine.KEY_SPACE))
            {
               Debug.showDebugPanel();
               Engine.resetKeys();
            }
         }
      }
      
      private static function moveUsedBuildingItemToInventory(param1:UserItem) : void
      {
         var _loc2_:InventoryUserItem = new InventoryUserItem(param1.itemConfig,param1.getOwnedItem());
         gameUser.addInventoryItem(_loc2_);
         gameUser.removeUsedBuildingItem(param1.serverUid);
         saveProfileHandler.moveItem(_loc2_,false);
      }
      
      public static function isItemOfType(param1:Object, param2:String) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:Array = param1.group.types;
         if(_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_] == param2)
               {
                  return true;
               }
               _loc4_++;
            }
         }
         _loc3_ = param1.types;
         if(_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_] == param2)
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return false;
      }
      
      public static function fadeToWorld(param1:BaseWorld) : void
      {
         var _loc2_:Bitmap = null;
         clearFadeMask();
         if(Engine.curWorld != null)
         {
            fadeBitmapData = new BitmapData(Engine.getStageWidth(),Engine.getStageHeight());
            fadeBitmapData.draw(Engine.curWorld,new Matrix(1,0,0,1,-Engine.getStageX(),-Engine.getStageY()));
            _loc2_ = new Bitmap(fadeBitmapData);
            _loc2_.x = Engine.getStageX();
            _loc2_.y = Engine.getStageY();
            fadeMask = new BaseObject();
            fadeMask.addChild(_loc2_);
            fadeMask.mouseChildren = false;
            fadeMask.mouseEnabled = false;
            fadeMask.drawPriority = 100;
            fadeMask.alpha = 1;
            Engine.worldContainer.addObject(fadeMask);
         }
         Engine.setActiveWorld(param1);
      }
      
      public static function getUserFaceImage(param1:GameUser) : DisplayObject
      {
         return getFaceImageFromUrl(param1.imageUrl);
      }
      
      public static function convertToBitmapData(param1:DisplayObject, param2:Number, param3:Rectangle, param4:Number, param5:Number) : BitmapData
      {
         Engine.instance.stage.quality = StageQuality.BEST;
         var _loc6_:Number = param3.width;
         var _loc7_:Number = param3.height;
         var _loc8_:Number = 1;
         if(_loc6_ / _loc7_ > param4 / param5)
         {
            if(_loc6_ > param4)
            {
               _loc8_ = param4 / _loc6_;
               _loc7_ *= _loc8_;
               _loc6_ = param4;
            }
         }
         else if(_loc7_ > param5)
         {
            _loc8_ = param5 / _loc7_;
            _loc6_ *= _loc8_;
            _loc7_ = param5;
         }
         var _loc9_:BitmapData = new BitmapData(_loc6_,_loc7_);
         var _loc10_:Boolean = param2 * _loc8_ != 1;
         _loc9_.draw(param1,new Matrix(_loc8_ * param2,0,0,_loc8_ * param2,-param3.x * _loc8_,-param3.y * _loc8_),null,null,null,_loc10_);
         if(!OverlaySetting.settingValues[OverlaySetting.QUALITY])
         {
            Engine.instance.stage.quality = StageQuality.LOW;
         }
         else
         {
            Engine.instance.stage.quality = StageQuality.HIGH;
         }
         return _loc9_;
      }
      
      public static function getItemSubType(param1:int) : int
      {
         return param1 / 10000;
      }
      
      public static function applyPerkReward(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = GameWorld.getItemSubType(param1.id);
         if(_loc2_ == GameUser.PERK_ITEM_TYPE_COIN_REWARD)
         {
            _loc3_ = int(param1.cost);
            GameWorld.cashPanel.addCoins(_loc3_,true);
         }
         else if(_loc2_ == GameUser.PERK_ITEM_TYPE_DEMAND_REWARD)
         {
            _loc4_ = GameWorld.gameUser.getDemandPoints();
            _loc3_ = int(param1.value);
            GameWorld.gameUser.setDemandPoints(Math.min(_loc4_ + _loc3_,GameWorld.DEFAULT_MAX_DEMAND));
            if(WorldRestaurantPlay.instance)
            {
               WorldRestaurantPlay.instance.refreshDemand();
            }
         }
      }
      
      public static function getLevel(param1:int) : int
      {
         var _loc2_:* = int(LEVEL_THRESHOLDS.length - 1);
         while(_loc2_ >= 0)
         {
            if(param1 >= LEVEL_THRESHOLDS[_loc2_].points)
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return 0;
      }
      
      public static function getDummyUser(param1:int) : GameUser
      {
         var _loc2_:UserInfo = getDummyUserInfo(param1);
         var _loc3_:GameUser = new GameUser(_loc2_);
         _loc3_.loadedItemContext = GameUser.ITEM_CONTEXT_AVATAR | GameUser.ITEM_CONTEXT_BUILDING | GameUser.ITEM_CONTEXT_RESTAURANT;
         return _loc3_;
      }
   }
}


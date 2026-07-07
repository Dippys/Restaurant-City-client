package com.playfish.rpc.cooking
{
   import com.playfish.rpc.share.NetworkUid;
   import com.playfish.rpc.share.RpcClientBase;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class RpcClient extends RpcClientBase
   {
      
      public static const BATCHMODE_ASYNC:uint = RpcClientBase.BATCHMODE_ASYNC;
      
      public static const BATCHMODE_INORDER:uint = RpcClientBase.BATCHMODE_INORDER;
      
      public static const BATCHMODE_CONDITIONAL:uint = RpcClientBase.BATCHMODE_CONDITIONAL;
      
      public static const USER_CONTEXT_ALL:uint = 1;
      
      public static const USER_CONTEXT_FRIENDS:uint = 2;
      
      public static const USER_CONTEXT_REGION:uint = 4;
      
      public static const TIME_CONTEXT_ALL:uint = 0;
      
      public static const TIME_CONTEXT_WEEK:uint = 16;
      
      public static const TIME_CONTEXT_MONTH:uint = 32;
      
      public static const USER_CONTEXT_CHALLENGE_ALL:uint = 5;
      
      public static const USER_CONTEXT_CHALLENGE_FRIENDS:uint = 6;
      
      public static const USER_CONTEXT_CHALLENGE_REGION:uint = 7;
      
      public static const GAME_EVENT_INIT_DONE:uint = 0;
      
      public static const GAME_EVENT_START:uint = 1;
      
      public static const GAME_EVENT_DEBUG:uint = 2;
      
      public static const GAME_SURVEY_DONE:uint = 3;
      
      public static const GAME_FULL_SCREEN_MODE:uint = 4;
      
      public static const GAME_EVENT_BUTTON_CLICK:uint = 5;
      
      public static const ITEM_CONTEXT:uint = 1;
      
      public static const FLOOR_CONTEXT:uint = 2;
      
      public static var HIRE_EMPLOYEE:Number = 1;
      
      public static var UPDATE_EMPLOYEE:Number = 2;
      
      public static var FIRE_EMPLOYEE:Number = 3;
      
      public static var CLOTHES:Number = 1;
      
      public static var RESTAURANT_FACADE:Number = 2;
      
      public static var RESTAURANT_INSIDE:Number = 4;
      
      public static var INGREDIENT:Number = 8;
      
      public static const AVATAR_TYPE_PROFILE_NARROW:uint = 1;
      
      public static const AVATAR_TYPE_PROFILE_WIDE:uint = 2;
      
      public static const AVATAR_TYPE_PROFILE_GAME:uint = 3;
      
      public static const SAVE_USER_PROFILE_OK:uint = 1;
      
      public static const SAVE_USER_PROFILE_FAIL_INTERNAL_ERROR:uint = 0;
      
      public static const SAVE_USER_PROFILE_FAIL_ALREADY_DONE:uint = 2;
      
      public static const SAVE_USER_PROFILE_FAIL_MISSED_INGREDIENT:uint = 4;
      
      public static const SAVE_USER_PROFILE_FAIL_ADD_RECIPE:uint = 8;
      
      public static const MAIL_TYPE_EMAIL:uint = 1;
      
      public static const MAIL_TYPE_QUIZZ:uint = 2;
      
      public static const MAIL_TYPE_PLAYFISH:uint = 3;
      
      public static const MAIL_TYPE_GIFT:uint = 4;
      
      public static const MAIL_TYPE_DAILYINGREDIENT:uint = 5;
      
      public static const MAIL_TYPE_SECURECHANGE:uint = 6;
      
      public static const MAIL_TYPE_CASH:uint = 7;
      
      public static const MAIL_TYPE_SECUREECHANGE_OK:uint = 8;
      
      public static const MAIL_TYPE_GIFT_INVITE:uint = 9;
      
      public static const MAIL_FOOD_KING_ITEM:uint = 10;
      
      public static const MAIL_FAN_PAGE_ITEM:uint = 11;
      
      public static const FOOD_KING_FEED_EXCEPTION:uint = 12;
      
      public static const MAIL_SPECIAL_DAY_ITEM:uint = 13;
      
      public static const FAN_PAGE_FEED_EXCEPTION:uint = 14;
      
      public static const OFFLINE_SHARD_FAILURE:uint = 7;
      
      public static const STATUS_OK:uint = 0;
      
      public static const STATUS_NOT_ENOUGH_CASH:uint = 1;
      
      public static const STATUS_INVALID_TOKEN:uint = 4;
      
      public static const STATUS_SHARD_OFFLINE:uint = 7;
      
      public static const STATUS_SAVE_FAIL:uint = 1;
      
      public static const SEND_GIFT_FAIL_RECIPIENT_IN_OFFLINE_SHARD:uint = 7;
      
      public static const SEND_GIFT_FAIL_SENDER_IN_OFFLINE_SHARD:uint = 8;
      
      public static const PURCHASE_CASH_ITEM_EXISTS:uint = 10;
      
      internal static const CALL_TYPE_getAllFriends:uint = 2;
      
      internal static const CALL_TYPE_getUserProfile:uint = 3;
      
      internal static const CALL_TYPE_getUsers:uint = 4;
      
      internal static const CALL_TYPE_saveProfile:uint = 5;
      
      internal static const CALL_TYPE_swapIngredient:uint = 17;
      
      internal static const CALL_TYPE_sendMail:uint = 19;
      
      internal static const CALL_TYPE_getMails:uint = 20;
      
      internal static const CALL_TYPE_quizzReply:uint = 25;
      
      internal static const CALL_TYPE_buyMystryBox:uint = 32;
      
      internal static const CALL_TYPE_storeImage:uint = 34;
      
      internal static const CALL_TYPE_rankRestaurant:uint = 35;
      
      internal static const CALL_TYPE_firstTimeVisitFriend:uint = 36;
      
      internal static const CALL_TYPE_getRandomStreetUsers:uint = 37;
      
      internal static const CALL_TYPE_getGourmetStreetUsers:uint = 38;
      
      internal static const CALL_TYPE_purchaseCoinsWithPfCash:uint = 40;
      
      internal static const CALL_TYPE_purchaseCashItem:uint = 41;
      
      internal static const CALL_TYPE_purchaseCashItemIngredients:uint = 42;
      
      internal static const CALL_TYPE_waterFriendGarden:uint = 43;
      
      internal static const CALL_TYPE_readBookmarkCount:uint = 44;
      
      internal static const CALL_TYPE_writeBookmarkCount:uint = 45;
      
      internal static const CALL_TYPE_sendNotification:uint = 46;
      
      private static var INIT_TIME:uint = 0;
      
      public static const ITEM_CONTEXT_CLOTHES:int = 1;
      
      public static const ITEM_CONTEXT_RESTAURANT_FACADE:int = 2;
      
      public static const ITEM_CONTEXT_RESTAURANT_INSIDE:int = 4;
      
      public static const ITEM_CONTEXT_INGREDIENT:int = 8;
      
      public function RpcClient(param1:Object, param2:uint = 0)
      {
         var loaderParameters:Object = param1;
         var defaultNumResourceCopies:uint = param2;
         super(loaderParameters,defaultNumResourceCopies,function():RpcRequest
         {
            return new RpcRequest();
         },function():RpcResponse
         {
            return new RpcResponse();
         });
      }
      
      private static function getMailsResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var mails:Array = null;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         mails = response.readArray(response.readMail);
         return function():void
         {
            successCallback(mails);
         };
      }
      
      private static function purchaseCashItemIngredientsResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var status:uint = 0;
         var credit:uint = 0;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         status = response.readUint8();
         credit = response.readUintvar31();
         return function():void
         {
            successCallback(status,credit);
         };
      }
      
      private static function purchaseCashItemResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var status:uint = 0;
         var credit:uint = 0;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         status = response.readUint8();
         credit = response.readUintvar31();
         return function():void
         {
            successCallback(status,credit);
         };
      }
      
      private static function getUsersResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var allUsers:Array = null;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         allUsers = response.readArray(response.readProfile);
         return function():void
         {
            successCallback(allUsers);
         };
      }
      
      private static function quizzReplyGameResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var credits:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         credits = response.readUintvar32();
         return function():void
         {
            successCallback(credits);
         };
      }
      
      private static function getGardenResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var plots:Array = null;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         plots = response.readArray(response.readPlot);
         return function():void
         {
            successCallback(plots);
         };
      }
      
      private static function getGourmetStreetUsersResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var users:Array = null;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         users = response.readArray(response.readProfile);
         return function():void
         {
            successCallback(users);
         };
      }
      
      private static function savePlayerProfileResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var success:Number = NaN;
         var savedVersion:Number = NaN;
         var mails:Array = null;
         var ingredients:Array = null;
         var timeToMaintenance:uint = 0;
         var garden:Array = null;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         if(INIT_TIME == 0)
         {
            INIT_TIME = getTimer();
         }
         success = response.readUint8();
         savedVersion = response.readUintvar31();
         mails = response.readArray(response.readMail);
         if(response.readBoolean())
         {
            ingredients = response.readArray(response.readIngredient);
         }
         timeToMaintenance = response.readUintvar32();
         garden = response.readArray(response.readPlot);
         return function():void
         {
            successCallback(success,savedVersion,mails,ingredients,timeToMaintenance,garden);
         };
      }
      
      private static function swapIngredientResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var success:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         success = response.readUint8();
         return function():void
         {
            successCallback(success);
         };
      }
      
      private static function storeImageResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var success:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         success = response.readUint8();
         return function():void
         {
            successCallback(success);
         };
      }
      
      private static function sendMailResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var accepted:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         accepted = response.readUint8();
         return function():void
         {
            successCallback(accepted);
         };
      }
      
      private static function firstTimeVisitFriendResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var success:Number = NaN;
         var ingredient:Ingredient = null;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         success = response.readUint8();
         var item:InventoryItem = response.readInventoryItem();
         ingredient = new Ingredient();
         ingredient.globalItemId = item.globalItemId;
         ingredient.isLocked = false;
         ingredient.number = 1;
         return function():void
         {
            successCallback(success,ingredient);
         };
      }
      
      private static function getPurchaseCoinsWithPfCashResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var status:uint = 0;
         var credit:uint = 0;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         status = response.readUint8();
         credit = response.readUintvar31();
         return function():void
         {
            successCallback(status,credit);
         };
      }
      
      private static function buyMystryBoxGameResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var itemId:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         itemId = response.readUintvar31();
         return function():void
         {
            successCallback(itemId);
         };
      }
      
      private static function writeBookmarkCountResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var success:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         success = response.readUint8();
         return function():void
         {
            successCallback(success);
         };
      }
      
      private static function sendNotificationResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var success:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         success = response.readUint8();
         return function():void
         {
            successCallback(success);
         };
      }
      
      private static function waterFriendGardenResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var success:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         success = response.readUint8();
         return function():void
         {
            successCallback(success);
         };
      }
      
      private static function getUserProfileResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var userProfile:UserInfo = null;
         var ingredientMarketItems:Array = null;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         userProfile = response.readProfile();
         ingredientMarketItems = response.readArray(response.readIngredientMarketItem);
         return function():void
         {
            successCallback(userProfile,ingredientMarketItems);
         };
      }
      
      private static function readBookmarkCountResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var success:Number = NaN;
         var bookmarkCount:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         success = response.readUint8();
         bookmarkCount = response.readIntvar32();
         return function():void
         {
            successCallback(success,bookmarkCount);
         };
      }
      
      private static function getAllFriendsResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var allFriends:Array = null;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         allFriends = response.readArray(response.readProfile);
         return function():void
         {
            successCallback(allFriends);
         };
      }
      
      private static function rankResponseHandler(param1:RpcResponse, param2:Function) : Function
      {
         var success:Number = NaN;
         var response:RpcResponse = param1;
         var successCallback:Function = param2;
         success = response.readUint8();
         return function():void
         {
            successCallback(success);
         };
      }
      
      public function storeImage(param1:uint, param2:ByteArray, param3:Number, param4:Number, param5:Function, param6:Function) : void
      {
         var _loc7_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_storeImage,storeImageResponseHandler,param5,param6));
         _loc7_.writeUintvar31(param1);
         _loc7_.writeByteArray(param2);
         _loc7_.writeUintvar31(param3);
         _loc7_.writeUintvar31(param4);
         _loc7_.perform();
      }
      
      public function sendNotification(param1:NetworkUid, param2:Function, param3:Function) : void
      {
         var _loc4_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_sendNotification,sendNotificationResponseHandler,param2,param3));
         _loc4_.writeNetworkUid(param1);
         _loc4_.perform();
      }
      
      public function readBookmarkCount(param1:Function, param2:Function) : void
      {
         var _loc3_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_readBookmarkCount,readBookmarkCountResponseHandler,param1,param2));
         _loc3_.perform();
      }
      
      public function swapIngredient(param1:NetworkUid, param2:String, param3:String, param4:Boolean, param5:Number, param6:Boolean, param7:Function, param8:Function) : void
      {
         var _loc9_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_swapIngredient,swapIngredientResponseHandler,param7,param8));
         _loc9_.writeNetworkUid(param1);
         _loc9_.writeString(param2);
         _loc9_.writeString(param3);
         _loc9_.writeBoolean(param4);
         _loc9_.writeUintvar32(param5);
         _loc9_.writeBoolean(param6);
         _loc9_.perform();
      }
      
      public function getReceivedMails(param1:Function, param2:Function) : void
      {
         var _loc3_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_getMails,getMailsResponseHandler,param1,param2));
         _loc3_.perform();
      }
      
      public function purchaseCashItem(param1:String, param2:Number, param3:OwnedItem, param4:Boolean, param5:Function, param6:Function) : void
      {
         var _loc7_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_purchaseCashItem,purchaseCashItemResponseHandler,param5,param6));
         _loc7_.writeString(param1);
         _loc7_.writeUintvar31(param2);
         _loc7_.writeOwnedItem(param3);
         _loc7_.writeBoolean(param4);
         _loc7_.perform();
      }
      
      public function getUserProfile(param1:Function, param2:Function) : void
      {
         var _loc3_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_getUserProfile,getUserProfileResponseHandler,param1,param2));
         _loc3_.perform();
      }
      
      public function rankRestaurant(param1:NetworkUid, param2:Number, param3:Function, param4:Function) : void
      {
         var _loc5_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_rankRestaurant,rankResponseHandler,param3,param4));
         _loc5_.writeNetworkUid(param1);
         _loc5_.writeUint8(param2);
         _loc5_.perform();
      }
      
      public function waterFriendGarden(param1:NetworkUid, param2:NetworkUid, param3:uint, param4:Function, param5:Function) : void
      {
         var _loc6_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_waterFriendGarden,waterFriendGardenResponseHandler,param4,param5));
         _loc6_.writeNetworkUid(param1);
         _loc6_.writeNetworkUid(param2);
         _loc6_.writeUintvar31(param3);
         _loc6_.perform();
      }
      
      public function savePlayerProfile(param1:UserInfo, param2:AuditChangeBatch, param3:Function, param4:Function) : void
      {
         var _loc5_:Number = 0;
         _loc5_ = getTimer() - INIT_TIME;
         var _loc6_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_saveProfile,savePlayerProfileResponseHandler,param3,param4));
         param2.timeOnClient = _loc5_;
         _loc6_.writeProfile(param1);
         _loc6_.writeAuditChangeBatch(param2);
         _loc6_.perform();
      }
      
      public function firstTimeVisitFriend(param1:NetworkUid, param2:Function, param3:Function) : void
      {
         var _loc4_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_firstTimeVisitFriend,firstTimeVisitFriendResponseHandler,param2,param3));
         _loc4_.writeNetworkUid(param1);
         _loc4_.perform();
      }
      
      public function getRandomStreetUsers(param1:Number, param2:Function, param3:Function) : void
      {
         var _loc4_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_getRandomStreetUsers,getUsersResponseHandler,param2,param3));
         _loc4_.writeUintvar31(param1);
         _loc4_.perform();
      }
      
      public function purchaseCoinsWithPfCash(param1:String, param2:Function, param3:Function) : void
      {
         var _loc4_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_purchaseCoinsWithPfCash,getPurchaseCoinsWithPfCashResponseHandler,param2,param3));
         _loc4_.writeString(param1);
         _loc4_.perform();
      }
      
      public function getAllFriends(param1:Function, param2:Function) : void
      {
         var _loc3_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_getAllFriends,getAllFriendsResponseHandler,param1,param2));
         _loc3_.perform();
      }
      
      public function getUsers(param1:Number, param2:Array, param3:Function, param4:Function) : void
      {
         var _loc5_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_getUsers,getUsersResponseHandler,param3,param4));
         _loc5_.writeUint8(param1);
         _loc5_.writeArray(param2,_loc5_.writeNetworkUid);
         _loc5_.perform();
      }
      
      public function buyMystryBox(param1:String, param2:Array, param3:Boolean, param4:Function, param5:Function) : void
      {
         var _loc6_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_buyMystryBox,buyMystryBoxGameResponseHandler,param4,param5));
         _loc6_.writeString(param1);
         _loc6_.writeArray(param2,_loc6_.writeString);
         _loc6_.perform();
      }
      
      public function writeBookmarkCount(param1:Number, param2:Function, param3:Function) : void
      {
         var _loc4_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_writeBookmarkCount,writeBookmarkCountResponseHandler,param2,param3));
         _loc4_.writeIntvar32(param1);
         _loc4_.perform();
      }
      
      public function purchaseCashItemIngredients(param1:Array, param2:Function, param3:Function) : void
      {
         var _loc4_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_purchaseCashItemIngredients,purchaseCashItemIngredientsResponseHandler,param2,param3));
         _loc4_.writeArray(param1,_loc4_.writeString);
         _loc4_.perform();
      }
      
      public function getGourmetStreetUsers(param1:Number, param2:Function, param3:Function) : void
      {
         var _loc4_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_getGourmetStreetUsers,getGourmetStreetUsersResponseHandler,param2,param3));
         _loc4_.writeUintvar31(param1);
         _loc4_.perform();
      }
      
      public function replyQuizz(param1:Number, param2:String, param3:Boolean, param4:Function, param5:Function) : void
      {
         var _loc6_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_quizzReply,quizzReplyGameResponseHandler,param4,param5));
         _loc6_.writeUintvar32(param1);
         _loc6_.writeString(param2);
         _loc6_.writeBoolean(param3);
         _loc6_.perform();
      }
      
      public function sendMail(param1:Mail, param2:Function, param3:Function) : void
      {
         var _loc4_:RpcRequest = RpcRequest(newRpcRequest(CALL_TYPE_sendMail,sendMailResponseHandler,param2,param3));
         _loc4_.writeMail(param1);
         _loc4_.perform();
      }
   }
}


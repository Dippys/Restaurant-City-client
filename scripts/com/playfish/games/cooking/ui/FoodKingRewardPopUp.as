package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.GameUser;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.foodking.FoodKingItem;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class FoodKingRewardPopUp extends WorldPopUp
   {
      
      public static const SOURCE_FOODKING_INGREDIENT_FEED:int = 0;
      
      public static const SOURCE_FOODKING_RECIPE_FEED:int = 1;
      
      public static const SOURCE_FOODKING_ITEM_FEED:int = 2;
      
      public static const SOURCE_FANPAGE_INGREDIENT_FEED:int = 3;
      
      public static const SOURCE_FANPAGE_RECIPE_FEED:int = 4;
      
      public static const SOURCE_FANPAGE_ITEM_FEED:int = 5;
      
      public static const SOURCE_FANPAGE_3MFANGIFT_FEED:int = 6;
      
      public static const FEED_NAME:Array = ["FoodKingIngredientReward","FoodKingRecipeReward","FoodKingItemReward","FanPageIngredientReward","FanPageRecipeReward","FanPageItemReward","FanPage3mFanGiftReward"];
      
      private static const THREE_MILLION_FAN_GIFT_ITEM_ID:int = 3500093;
      
      private static const IMG_IDENTIFIER:String = "received.png";
      
      private var rewardObject:Object;
      
      private var item:FoodKingItem;
      
      private var coinRewardAmount:int = 0;
      
      private var popupSceneContent:MovieClip;
      
      private var source:int;
      
      public function FoodKingRewardPopUp(param1:FoodKingItem, param2:MovieClip, param3:MovieClip, param4:MovieClip, param5:Boolean = true)
      {
         var _loc6_:MovieClip = null;
         var _loc7_:Object = null;
         super(param2,param3,param4,param5);
         setHandCursor(param3,true);
         this.item = param1;
         popupSceneContent = param2.mc_content;
         GameWorld.textHandler.setReplaceString("ItemType",param1.typeToString());
         if(param1.mailType == RpcClient.MAIL_FOOD_KING_ITEM)
         {
            GameWorld.textHandler.setTextFieldWithId(popupSceneContent.tf_text,"FoodKingCongrats");
            if(param1.itemType == GameUser.ITEM_TYPE_INGREDIENT)
            {
               source = SOURCE_FOODKING_INGREDIENT_FEED;
            }
            else if(param1.itemType == GameUser.ITEM_TYPE_RECIPE)
            {
               source = SOURCE_FOODKING_RECIPE_FEED;
            }
            else
            {
               source = SOURCE_FOODKING_ITEM_FEED;
            }
         }
         else if(param1.mailType == RpcClient.MAIL_FAN_PAGE_ITEM)
         {
            GameWorld.textHandler.setTextFieldWithId(popupSceneContent.tf_text,"FanPageCongrats");
            if(param1.itemId == THREE_MILLION_FAN_GIFT_ITEM_ID)
            {
               source = SOURCE_FANPAGE_3MFANGIFT_FEED;
            }
            else if(param1.itemType == GameUser.ITEM_TYPE_INGREDIENT)
            {
               source = SOURCE_FANPAGE_INGREDIENT_FEED;
            }
            else if(param1.itemType == GameUser.ITEM_TYPE_RECIPE)
            {
               source = SOURCE_FANPAGE_RECIPE_FEED;
            }
            else
            {
               source = SOURCE_FANPAGE_ITEM_FEED;
            }
         }
         _loc6_ = ItemChooser.getItemMovieClip(param1.itemConfig,popupSceneContent.mc_item.width,popupSceneContent.mc_item.height);
         _loc6_.stop();
         _loc6_.x = popupSceneContent.mc_item.x;
         _loc6_.y = popupSceneContent.mc_item.y;
         popupSceneContent.mc_item.stop();
         popupSceneContent.mc_item.visible = false;
         popupSceneContent.mc_tick.stop();
         popupSceneContent.mc_tick.visible = false;
         popupSceneContent.tf_name.text = param1.name;
         if(param1.itemType == GameUser.ITEM_TYPE_RECIPE)
         {
            _loc6_.mc_plate.gotoAndStop(1);
         }
         else if(param1.itemType == GameUser.ITEM_TYPE_PERK)
         {
            _loc7_ = GameWorld.perkItemDatabase.getItemFromId(param1.itemId);
            rewardObject = _loc7_;
         }
         popupSceneContent.mc_rarity.visible = false;
         popupSceneContent.addChild(_loc6_);
         setButtonMode(popupSceneContent.mc_share,true);
         setHandCursor(popupSceneContent.mc_share,true);
         if(GameWorld.isUserInSplitTestingGroupA(GameWorld.gameUser))
         {
            GameWorld.textHandler.setTextFieldWithId(popupSceneContent.mc_share.mc_content.tf_text,"ButtonContinueText");
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(popupSceneContent.mc_share.mc_content.tf_text,"ButtonShareText");
         }
         popupSceneContent.mc_share.addEventListener(MouseEvent.CLICK,onShareClick);
      }
      
      private function getPNGFileName(param1:FoodKingItem) : String
      {
         var _loc2_:int = GameWorld.getItemSubType(param1.itemId);
         if(_loc2_ == GameUser.PERK_ITEM_TYPE_COIN_REWARD)
         {
            return GameUser.PERK_ITEM_TYPE_COIN_REWARD.toString();
         }
         return param1.itemId.toString();
      }
      
      override public function remove() : void
      {
         if(rewardObject)
         {
            GameWorld.applyPerkReward(rewardObject);
         }
         super.remove();
      }
      
      private function onShareClick(param1:MouseEvent) : void
      {
         var ref:String;
         var linkUrl:String;
         var logParam:String;
         var feedName:String = null;
         var e:MouseEvent = param1;
         popupSceneContent.mc_share.removeEventListener(MouseEvent.CLICK,onShareClick);
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         GameWorld.textHandler.setReplaceString("ItemType",item.typeToString());
         GameWorld.textHandler.setReplaceString("ItemName",item.name);
         GameWorld.textHandler.setReplaceString("FeedFormGameLink",GameWorld.FEED_FORM_GAME_LINK);
         linkUrl = GameWorld.STREAM_FEED_GAME_LINK;
         if(item.mailType == RpcClient.MAIL_FAN_PAGE_ITEM)
         {
            linkUrl = item.claimLink;
         }
         ref = GameWorld.textHandler.getTextFromId(feedName + "StreamLinkRef");
         if(Boolean(ref) && ref.length > 0)
         {
            linkUrl += "&" + ref;
         }
         Debug.out("food king reward feed url=" + linkUrl + " image url=" + (item.itemId.toString() + IMG_IDENTIFIER));
         logParam = popupSceneContent.mc_share.mc_content.tf_text.text;
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_BUTTON_CLICK,logParam.toLocaleLowerCase(),function():void
         {
         },function():void
         {
         });
         Debug.out("Logging Button Click Event: " + logParam.toLocaleLowerCase());
         feedName = FEED_NAME[source];
         GameWorld.postFeed(GameWorld.textHandler.getTextFromId(feedName + "StreamTitle"),GameWorld.textHandler.getTextFromId(feedName + "StreamInformation"),GameWorld.textHandler.getTextFromId(feedName + "StreamCaption"),GameWorld.textHandler.getTextFromId(feedName + "StreamDescription"),GameWorld.textHandler.getTextFromId(feedName + "StreamLinkText"),linkUrl,GameWorld.textHandler.getTextFromId(feedName + "StreamDashboardText"),null,GameWorld.textHandler.getTextFromId(feedName + "FeedTitle"),GameWorld.textHandler.getTextFromId(feedName + "FeedText"),GameWorld.textHandler.getTextFromId(feedName + "FeedLink"),GameWorld.FEED_FORM_GAME_LINK,"",[item.itemId.toString() + IMG_IDENTIFIER]);
         remove();
      }
   }
}


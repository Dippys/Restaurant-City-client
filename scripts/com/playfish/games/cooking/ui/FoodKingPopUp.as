package com.playfish.games.cooking.ui
{
   import com.playfish.coretech.platform.socialplatform.*;
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.foodking.*;
   import com.playfish.rpc.cooking.RpcClient;
   import com.playfish.stream.ActionLinkEncryptor;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   
   public class FoodKingPopUp extends WorldPopUp
   {
      
      public static var blackSheepItems:Array = new Array();
      
      public static var MAX_ITEMS:int = 3;
      
      public static var NUMBER_OF_RECIPES:int = 1;
      
      public static var NUMBER_OF_INGREDIENTS:int = 1;
      
      public static var NUMBER_OF_ITEMS:int = MAX_ITEMS - NUMBER_OF_RECIPES - NUMBER_OF_INGREDIENTS;
      
      private var strength:Number = 20;
      
      private var scene:MovieClip;
      
      private var sceneContent:MovieClip;
      
      private var blurX:Number = 6;
      
      private var blurY:Number = 6;
      
      private var foodKing:FoodKing;
      
      private var toolTip:ToolTip;
      
      private var shareButton:MovieClip;
      
      private var selectedIndex:int = -1;
      
      private var allIcons:Array;
      
      public function FoodKingPopUp(param1:FoodKing)
      {
         var _loc2_:MovieClip = null;
         var _loc4_:FoodKingItem = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TextField = null;
         var _loc8_:Recipe = null;
         var _loc9_:IngredientItem = null;
         allIcons = new Array();
         this.foodKing = param1;
         scene = Engine.getMovieClip("BlackSheepPopupAnim");
         sceneContent = scene.mc_content;
         setHandCursor(sceneContent.mc_cancel,true);
         GameWorld.textHandler.setTextFieldWithId(sceneContent.mc_cancel.mc_content.tf_text,"ButtonCancelText");
         super(null,null,sceneContent.mc_cancel);
         shareButton = sceneContent.mc_share;
         setHandCursor(shareButton,true);
         setButtonMode(shareButton,true);
         shareButton.addEventListener(MouseEvent.CLICK,onShareButtonClicked);
         if(GameWorld.isUserInSplitTestingGroupA(GameWorld.gameUser))
         {
            GameWorld.textHandler.setTextFieldWithId(shareButton.mc_content.tf_text,"ButtonContinueText");
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(shareButton.mc_content.tf_text,"ButtonShareText");
         }
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_text,"FoodKingPopUp");
         addChild(scene);
         toolTip = new ToolTip(shareButton,GameWorld.textHandler.getTextFromId("ToolTipSelectFoodKingItem"),false,false,false);
         var _loc3_:int = 0;
         while(_loc3_ < MAX_ITEMS)
         {
            _loc4_ = blackSheepItems[_loc3_];
            _loc5_ = sceneContent["mc_item" + _loc3_];
            _loc6_ = sceneContent["mc_rarity" + _loc3_];
            _loc7_ = sceneContent["tf_name" + _loc3_];
            if(Boolean(_loc4_) && Boolean(_loc5_))
            {
               if(_loc4_.itemType == GameUser.ITEM_TYPE_RECIPE)
               {
                  _loc8_ = new Recipe(_loc4_.itemConfig);
                  _loc2_ = Engine.getMovieClip(_loc8_.className);
                  _loc2_.scaleX = 1.5;
                  _loc2_.scaleY = 1.5;
                  _loc2_.y += 10;
                  _loc2_.mc_plate.gotoAndStop(1);
                  _loc2_.stop();
                  _loc5_.addEventListener(MouseEvent.CLICK,onItemClick,false,0,true);
                  _loc5_.mc_content.addChild(_loc2_);
                  setButtonMode(_loc5_,true);
                  _loc7_.text = _loc4_.name;
                  _loc6_.visible = false;
                  allIcons.push(_loc5_);
               }
               else if(_loc4_.itemType == GameUser.ITEM_TYPE_INGREDIENT)
               {
                  _loc9_ = new IngredientItem(_loc4_.itemConfig);
                  _loc2_ = Engine.getMovieClip(_loc9_.className);
                  _loc2_.stop();
                  _loc5_.addEventListener(MouseEvent.CLICK,onItemClick,false,0,true);
                  _loc5_.mc_content.addChild(_loc2_);
                  setButtonMode(_loc5_,true);
                  GameWorld.textHandler.setTextField(_loc7_,_loc4_.name);
                  _loc6_.gotoAndStop(_loc9_.rarity);
                  allIcons.push(_loc5_);
               }
               else if(_loc4_.itemType == GameUser.ITEM_TYPE_BUILDING || _loc4_.itemType == GameUser.ITEM_TYPE_RESTAURANT)
               {
                  _loc2_ = ItemChooser.getItemMovieClip(_loc4_.itemConfig);
                  _loc2_.stop();
                  _loc5_.addEventListener(MouseEvent.CLICK,onItemClick,false,0,true);
                  _loc5_.mc_content.addChild(_loc2_);
                  setButtonMode(_loc5_,true);
                  _loc7_.text = _loc4_.name;
                  _loc6_.visible = false;
                  allIcons.push(_loc5_);
               }
               else
               {
                  _loc5_.visible = false;
                  _loc6_.visible = false;
                  _loc7_.visible = false;
               }
            }
            else
            {
               _loc5_.visible = false;
               _loc6_.visible = false;
               _loc7_.visible = false;
            }
            _loc3_++;
         }
      }
      
      private static function getCanvasURL() : String
      {
         if(Debug.DEBUG)
         {
            return "http://apps.facebook.com/cooking-integration";
         }
         return "http://apps.facebook.com/restaurantcity";
      }
      
      private function onItemClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:String = _loc2_.name;
         var _loc4_:int = parseInt(_loc3_.charAt(_loc3_.length - 1));
         if(_loc2_ == sceneContent["mc_item" + selectedIndex])
         {
            _loc2_.filters = null;
            selectedIndex = -1;
            return;
         }
         _loc2_.filters = [new GlowFilter(16766464,1,12,12,100)];
         updateSelectorVisibility(_loc4_);
      }
      
      private function postFeed(param1:FoodKingItem, param2:String) : void
      {
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         GameWorld.textHandler.setReplaceString("ItemType",param1.typeToString());
         GameWorld.textHandler.setReplaceString("ItemName",param1.name);
         GameWorld.textHandler.setReplaceString("FeedFormGameLink",param2);
         if(param1.itemType == GameUser.ITEM_TYPE_RECIPE || param1.itemType == GameUser.ITEM_TYPE_INGREDIENT)
         {
            GameWorld.postFeed(GameWorld.textHandler.getTextFromId("FoodKingStreamTitle"),GameWorld.textHandler.getTextFromId("FoodKingStreamInformation"),GameWorld.textHandler.getTextFromId("FoodKingStreamCaption"),GameWorld.textHandler.getTextFromId("FoodKingStreamDescription"),GameWorld.textHandler.getTextFromId("FoodKingStreamLinkText"),param2 + "&" + GameWorld.textHandler.getTextFromId("FoodKingStreamLinkRef"),GameWorld.textHandler.getTextFromId("FoodKingStreamDashboardText"),null,GameWorld.textHandler.getTextFromId("FoodKingFeedTitle"),GameWorld.textHandler.getTextFromId("FoodKingFeedText"),GameWorld.textHandler.getTextFromId("FoodKingFeedLink"),param2,"",[param1.itemId.toString() + "feed.png"]);
         }
         else if(param1.itemType == GameUser.ITEM_TYPE_BUILDING || param1.itemType == GameUser.ITEM_TYPE_RESTAURANT)
         {
            GameWorld.postFeed(GameWorld.textHandler.getTextFromId("FoodKingItemStreamTitle"),GameWorld.textHandler.getTextFromId("FoodKingItemStreamInformation"),GameWorld.textHandler.getTextFromId("FoodKingItemStreamCaption"),GameWorld.textHandler.getTextFromId("FoodKingItemStreamDescription"),GameWorld.textHandler.getTextFromId("FoodKingItemStreamLinkText"),param2 + "&" + GameWorld.textHandler.getTextFromId("FoodKingItemStreamLinkRef"),GameWorld.textHandler.getTextFromId("FoodKingItemStreamDashboardText"),null,GameWorld.textHandler.getTextFromId("FoodKingFeedTitle"),GameWorld.textHandler.getTextFromId("FoodKingFeedText"),GameWorld.textHandler.getTextFromId("FoodKingFeedLink"),param2,"",[param1.itemId.toString() + "feed.png"]);
         }
      }
      
      private function showToolTip() : void
      {
         toolTip.show(5000);
      }
      
      private function onShareButtonClicked(param1:MouseEvent) : void
      {
         var expiryTime:uint;
         var logParam:String;
         var encryptedRequest:String;
         var itemId:Number;
         var requestURL:String;
         var expiry:int;
         var userId:String;
         var actionLinkEncryptor:ActionLinkEncryptor;
         var item:FoodKingItem;
         var e:MouseEvent = param1;
         if(selectedIndex < 0)
         {
            showToolTip();
            return;
         }
         foodKing.removeCurrentInstance();
         item = blackSheepItems[selectedIndex];
         itemId = item.itemId;
         userId = GameWorld.gameUser.userInfo.id.networkUid;
         expiry = 2 * 24 * 60 * 60;
         expiryTime = GameWorld.serverTime.time / 1000 + expiry;
         actionLinkEncryptor = new ActionLinkEncryptor();
         actionLinkEncryptor.addParameter("pf_i_id",itemId);
         actionLinkEncryptor.addParameter("pf_ex",expiryTime);
         actionLinkEncryptor.addParameter("pf_uid",userId);
         encryptedRequest = actionLinkEncryptor.toString();
         requestURL = getCanvasURL() + "/foodking?" + encryptedRequest + "&pf_ref=fg";
         logParam = shareButton.mc_content.tf_text.text;
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_BUTTON_CLICK,logParam.toLocaleLowerCase(),function():void
         {
         },function():void
         {
         });
         Debug.out("Logging Button Click Event: " + logParam.toLocaleLowerCase());
         postFeed(item,requestURL);
         FoodKing.foundForSession = true;
         e.stopImmediatePropagation();
         remove();
      }
      
      private function updateSelectorVisibility(param1:int) : void
      {
         if(selectedIndex >= 0)
         {
            sceneContent["mc_item" + selectedIndex].filters = null;
         }
         selectedIndex = param1;
      }
   }
}


package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class DishMaxLevelPopUp extends WorldPopUp
   {
      
      private var sceneContent:MovieClip;
      
      private var recipe:Recipe;
      
      public function DishMaxLevelPopUp(param1:Recipe)
      {
         super(null,null,null);
         this.recipe = param1;
         var _loc2_:MovieClip = Engine.getMovieClip("DishPopupAnim");
         addChild(_loc2_);
         sceneContent = _loc2_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_congratulation,"Congratulations");
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_text,"YourDishIsNowLevel10");
         setButtonMode(sceneContent.mc_share,true);
         setHandCursor(sceneContent.mc_share,true);
         GameWorld.textHandler.setTextFieldWithId(sceneContent.mc_share.mc_content.tf_text,"ShareFeed");
         sceneContent.mc_share.addEventListener(MouseEvent.CLICK,onShareClick,false,0,true);
         if(GameWorld.isUserInSplitTestingGroupA(GameWorld.gameUser))
         {
            GameWorld.textHandler.setTextFieldWithId(sceneContent.mc_share.mc_content.tf_text,"ButtonContinueText");
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(sceneContent.mc_share.mc_content.tf_text,"ButtonShareText");
         }
         setButtonMode(sceneContent.mc_skip,true);
         setHandCursor(sceneContent.mc_skip,true);
         sceneContent.mc_skip.addEventListener(MouseEvent.CLICK,onSkipClick,false,0,true);
         var _loc3_:MovieClip = Engine.getMovieClip(param1.config.className);
         _loc3_.x = sceneContent.mc_dish.x;
         _loc3_.y = sceneContent.mc_dish.y;
         _loc3_.scaleX = sceneContent.mc_dish.scaleX;
         _loc3_.scaleY = sceneContent.mc_dish.scaleY;
         _loc3_.stop();
         _loc3_.mc_plate.gotoAndStop(10);
         sceneContent.addChildAt(_loc3_,sceneContent.getChildIndex(sceneContent.mc_dish));
         sceneContent.removeChild(sceneContent.mc_dish);
         sceneContent.mc_dish = null;
      }
      
      private function onSkipClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onShareClick(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var logParam:String = sceneContent.mc_share.mc_content.tf_text.text;
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_BUTTON_CLICK,logParam.toLocaleLowerCase(),function():void
         {
         },function():void
         {
         });
         Debug.out("Logging Button Click Event: " + logParam.toLocaleLowerCase());
         GameWorld.textHandler.setReplaceString("FeedFormGameLink",GameWorld.FEED_FORM_GAME_LINK);
         GameWorld.textHandler.setReplaceString("DishName",recipe.name);
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         GameWorld.postFeed(GameWorld.textHandler.getTextFromId("Level10DishStreamTitle"),GameWorld.textHandler.getTextFromId("Level10DishStreamInformation"),GameWorld.textHandler.getTextFromId("Level10DishStreamCaption"),GameWorld.textHandler.getTextFromId("Level10DishStreamDescription"),GameWorld.textHandler.getTextFromId("Level10DishStreamLinkText"),GameWorld.STREAM_FEED_GAME_LINK + "&" + GameWorld.textHandler.getTextFromId("Level10DishStreamLinkRef"),GameWorld.textHandler.getTextFromId("Level10DishStreamDashboardText"),null,GameWorld.textHandler.getTextFromId("Level10DishFeedTitle"),GameWorld.textHandler.getTextFromId("Level10DishFeedBody"),GameWorld.textHandler.getTextFromId("FeedLinkText"),GameWorld.FEED_FORM_GAME_LINK,"",[recipe.config.id + ".png"]);
         remove();
      }
   }
}


package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.*;
   
   public class WorldAwardPopUp extends WorldPopUp
   {
      
      private var popupScene:MovieClip;
      
      private var awardItemConfig:Object;
      
      private var popUpSceneContent:MovieClip;
      
      public function WorldAwardPopUp(param1:Object)
      {
         super(null,null,null);
         this.awardItemConfig = param1;
         popupScene = Engine.getMovieClip("AwardPopUpAnim");
         popupScene.stop();
         addChild(popupScene);
         popUpSceneContent = popupScene.mc_content;
         popUpSceneContent.stop();
         GameWorld.textHandler.setReplaceString("AwardName",param1.name);
         GameWorld.textHandler.setTextFieldWithId(popUpSceneContent.tf_text,"TrophyAwarded",true);
         GameWorld.textHandler.setTextFieldWithId(popUpSceneContent.tf_title,"Congratulations");
         var _loc2_:MovieClip = ItemChooser.getItemMovieClip(param1);
         popUpSceneContent.mc_icon.removeChildAt(0);
         popUpSceneContent.mc_icon.addChild(_loc2_);
         setButtonMode(popUpSceneContent.mc_share,true);
         setHandCursor(popUpSceneContent.mc_share,true);
         if(GameWorld.isUserInSplitTestingGroupA(GameWorld.gameUser))
         {
            GameWorld.textHandler.setTextFieldWithId(popUpSceneContent.mc_share.mc_content.tf_text,"ButtonContinueText");
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(popUpSceneContent.mc_share.mc_content.tf_text,"ButtonShareText");
         }
         popUpSceneContent.mc_share.addEventListener(MouseEvent.CLICK,onShareClicked,false,0,true);
         setButtonMode(popUpSceneContent.mc_skip,true);
         setHandCursor(popUpSceneContent.mc_skip,true);
         popUpSceneContent.mc_skip.addEventListener(MouseEvent.CLICK,onSkipClicked,false,0,true);
      }
      
      private function onSkipClicked(param1:MouseEvent) : void
      {
         remove();
      }
      
      override public function show() : void
      {
         super.show();
         popupScene.gotoAndPlay(1);
         popUpSceneContent.gotoAndPlay(1);
         var _loc1_:GameSound = new GameSound("SfxLevelUp",GameSound.TYPE_SOUND);
         _loc1_.play(1);
      }
      
      private function onShareClicked(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var logParam:String = popUpSceneContent.mc_skip.mc_content.tf_text.text;
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_BUTTON_CLICK,logParam.toLocaleLowerCase(),function():void
         {
         },function():void
         {
         });
         Debug.out("Logging Button Click Event: " + logParam.toLocaleLowerCase());
         GameWorld.textHandler.setReplaceString("FeedFormGameLink",GameWorld.FEED_FORM_GAME_LINK);
         GameWorld.textHandler.setReplaceString("AwardName",awardItemConfig.name);
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         GameWorld.postFeed(GameWorld.textHandler.getTextFromId("AwardStreamTitle"),GameWorld.textHandler.getTextFromId("AwardStreamInformation"),GameWorld.textHandler.getTextFromId("AwardStreamCaption"),GameWorld.textHandler.getTextFromId("AwardStreamDescription"),GameWorld.textHandler.getTextFromId("AwardStreamLinkText"),GameWorld.STREAM_FEED_GAME_LINK + "&" + GameWorld.textHandler.getTextFromId("AwardStreamLinkRef"),GameWorld.textHandler.getTextFromId("AwardStreamDashboardText"),null,GameWorld.textHandler.getTextFromId("AwardFeedTitle"),GameWorld.textHandler.getTextFromId("AwardFeedBody"),GameWorld.textHandler.getTextFromId("FeedLinkText"),GameWorld.FEED_FORM_GAME_LINK,"",[awardItemConfig.className + ".png"]);
         remove();
      }
   }
}


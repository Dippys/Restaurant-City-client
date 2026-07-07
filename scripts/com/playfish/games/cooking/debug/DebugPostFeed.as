package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.GameWorld;
   import flash.events.MouseEvent;
   
   public class DebugPostFeed extends DebugEntryButton
   {
      
      public function DebugPostFeed()
      {
         super("Post a feed",null);
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         GameWorld.textHandler.setReplaceString("Level",GameWorld.gameUser.level.value.toString());
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         GameWorld.postFeed(GameWorld.textHandler.getTextFromId("LevelUpStreamTitle"),GameWorld.textHandler.getTextFromId("LevelUpStreamInformation"),GameWorld.textHandler.getTextFromId("LevelUpStreamCaption"),GameWorld.textHandler.getTextFromId("LevelUpStreamDescription"),GameWorld.textHandler.getTextFromId("LevelUpStreamLinkText"),GameWorld.STREAM_FEED_GAME_LINK + "&" + GameWorld.textHandler.getTextFromId("LevelUpStreamLinkRef"),GameWorld.textHandler.getTextFromId("LevelUpStreamDashboardText"),null,GameWorld.textHandler.getTextFromId("LevelUpFeedTitle"),GameWorld.textHandler.getTextFromId("LevelUpFeedBody"),GameWorld.textHandler.getTextFromId("FeedLinkText"),GameWorld.FEED_FORM_GAME_LINK,"",["levelup.png"]);
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}


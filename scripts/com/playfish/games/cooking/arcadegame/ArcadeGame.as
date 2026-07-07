package com.playfish.games.cooking.arcadegame
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.arcadegame.cave.WorldArcadeCave;
   import com.playfish.games.cooking.arcadegame.snake.WorldArcadeSnake;
   import com.playfish.games.cooking.ui.ToolTip;
   import com.playfish.games.cooking.ui.WorldPopUp;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ArcadeGame extends WorldPopUp
   {
      
      public static const GAME_WIDTH:int = 320;
      
      public static const GAME_HEIGHT:int = 240;
      
      public static const GAME_X:int = -160;
      
      public static const GAME_Y:int = 90;
      
      public var nameId:String;
      
      public var friendUser:GameUser;
      
      private var scene:MovieClip;
      
      private var lastScore:int;
      
      public function ArcadeGame()
      {
         super(null,null,null);
         scene = Engine.getMovieClip("ArcadeUi");
         addChild(scene);
         setButtonMode(scene.mc_quit,true);
         scene.mc_quit.addEventListener(MouseEvent.CLICK,onQuitClick,false,0,true);
         setButtonMode(scene.mc_share,false);
         scene.mc_share.mc_content.gotoAndStop("disabled");
         y = 0;
         refreshScore();
      }
      
      public static function createArcadeGame(param1:String) : ArcadeGame
      {
         var _loc2_:ArcadeGame = null;
         switch(param1)
         {
            case "Snake":
               _loc2_ = new WorldArcadeSnake();
               break;
            case "Cave":
               _loc2_ = new WorldArcadeCave();
         }
         _loc2_.nameId = param1;
         return _loc2_;
      }
      
      private function onQuitClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      public function setNewPlayerScore(param1:int) : void
      {
         lastScore = param1;
         if(param1 > getHighScore(GameWorld.gameUser))
         {
            setHighScore(param1);
            refreshScore();
         }
         setButtonMode(scene.mc_share,true);
         scene.mc_share.mc_content.gotoAndPlay("flash");
         scene.mc_share.addEventListener(MouseEvent.MOUSE_DOWN,onShareMouseDown,false,0,true);
         scene.mc_share.addEventListener(MouseEvent.CLICK,onShareClick,false,0,true);
         scene.mc_share.tooltip = new ToolTip(scene.mc_share,GameWorld.textHandler.getTextFromId("ShareYourResult"),false,false,false);
         scene.mc_share.tooltip.displayParent = this;
         scene.mc_share.tooltip.show();
      }
      
      private function onShareMouseDown(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      private function onShareClick(param1:MouseEvent) : void
      {
         disableShareButton();
         postFeed();
      }
      
      public function setHighScore(param1:int) : void
      {
      }
      
      public function disableShareButton() : void
      {
         setButtonMode(scene.mc_share,false);
         scene.mc_share.mc_content.gotoAndStop("disabled");
         scene.mc_share.removeEventListener(MouseEvent.CLICK,onShareClick);
         if(scene.mc_share.tooltip)
         {
            scene.mc_share.tooltip.destroy();
            scene.mc_share.tooltip = null;
         }
      }
      
      public function setFriendScore(param1:GameUser) : void
      {
         friendUser = param1;
         refreshScore();
      }
      
      public function refreshScore() : void
      {
         GameWorld.textHandler.setReplaceString("PlayerScore",getHighScore(GameWorld.gameUser).toString());
         var _loc1_:String = GameWorld.textHandler.getTextFromId("ArcadePlayerScore");
         if(friendUser)
         {
            GameWorld.textHandler.setReplaceString("FriendName",friendUser.firstName);
            GameWorld.textHandler.setReplaceString("FriendScore",getHighScore(friendUser).toString());
            _loc1_ += "\n" + GameWorld.textHandler.getTextFromId("ArcadeFriendScore");
         }
         GameWorld.textHandler.setTextField(scene.tf_score,_loc1_);
      }
      
      public function getHighScore(param1:GameUser) : int
      {
         return 0;
      }
      
      public function postFeed() : void
      {
         var _loc1_:String = "Arcade" + nameId;
         GameWorld.textHandler.setReplaceString("FeedFormGameLink",GameWorld.FEED_FORM_GAME_LINK);
         GameWorld.textHandler.setReplaceString("Score",lastScore.toString());
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         GameWorld.postFeed(GameWorld.textHandler.getTextFromId(_loc1_ + "StreamTitle"),GameWorld.textHandler.getTextFromId(_loc1_ + "StreamInformation"),GameWorld.textHandler.getTextFromId(_loc1_ + "StreamCaption"),GameWorld.textHandler.getTextFromId(_loc1_ + "StreamDescription"),GameWorld.textHandler.getTextFromId(_loc1_ + "StreamLinkText"),GameWorld.STREAM_FEED_GAME_LINK + "&" + GameWorld.textHandler.getTextFromId(_loc1_ + "StreamLinkRef"),GameWorld.textHandler.getTextFromId(_loc1_ + "StreamDashboardText"),null,GameWorld.textHandler.getTextFromId(_loc1_ + "FeedTitle"),GameWorld.textHandler.getTextFromId(_loc1_ + "FeedBody"),GameWorld.textHandler.getTextFromId("FeedLinkText"),GameWorld.FEED_FORM_GAME_LINK,"",["Arcade" + nameId + ".png"]);
      }
   }
}


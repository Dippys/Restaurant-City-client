package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.arcadegame.*;
   import com.playfish.rpc.share.NetworkUid;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class WorldItemInfoPopUp extends WorldPopUp
   {
      
      private var itemConfig:Object;
      
      private var ownerUser:GameUser;
      
      public function WorldItemInfoPopUp(param1:Object, param2:GameUser)
      {
         super(null,null,null);
         this.itemConfig = param1;
         this.ownerUser = param2;
         var _loc3_:MovieClip = Engine.getMovieClip("ItemInfoPopupAnim");
         addChild(_loc3_);
         var _loc4_:MovieClip = _loc3_.mc_content;
         var _loc5_:MovieClip = ItemChooser.getItemMovieClip(param1);
         _loc5_.width *= 2;
         _loc5_.height *= 2;
         _loc4_.mc_icon.addChild(_loc5_);
         GameWorld.textHandler.setTextField(_loc4_.tf_name,param1.name);
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_description,"ItemDescription" + param1.className,true);
         GameWorld.textHandler.setTextField(_loc4_.tf_function,GameWorld.textHandler.getTextFromId("ItemEffect") + " " + GameWorld.textHandler.getTextFromId("ItemFunction" + param1.className),true);
         setButtonMode(_loc4_.mc_playGame,true);
         if(Boolean(param1.arcadeGame) && param2 != null)
         {
            _loc4_.mc_playGame.addEventListener(MouseEvent.CLICK,onPlayGameClick,false,0,true);
            GameWorld.textHandler.setTextFieldWithId(_loc4_.mc_playGame.mc_content.tf_text,"PlayGame");
         }
         else
         {
            _loc4_.mc_playGame.visible = false;
         }
         setButtonMode(_loc4_.mc_tick,true);
         _loc4_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
      }
      
      private function onPlayGameClick(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:ArcadeGame = ArcadeGame.createArcadeGame(itemConfig.arcadeGame);
         if(Boolean(ownerUser) && !NetworkUid.areEqual(ownerUser.userInfo.id,GameWorld.gameUser.userInfo.id))
         {
            _loc2_.setFriendScore(ownerUser);
         }
         _loc2_.show();
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         remove();
      }
   }
}


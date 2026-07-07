package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class WorldEarningPopUp extends WorldPopUp
   {
      
      private var money:int;
      
      private var scene:MovieClip;
      
      private var sceneContent:MovieClip;
      
      public function WorldEarningPopUp(param1:int, param2:Number)
      {
         super(null,null,null);
         this.money = param1;
         scene = Engine.getMovieClip("EarningsPopupAnim");
         addChild(scene);
         sceneContent = scene.mc_content;
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"RecentEarning");
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_gpEarned,"GourmetPointsEarned");
         sceneContent.tf_money.text = param1;
         sceneContent.tf_gp.text = param2.toFixed(1);
         setButtonMode(sceneContent.mc_tick,true);
         sceneContent.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
      }
      
      override public function show() : void
      {
         super.show();
         scene.gotoAndPlay(0);
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         sceneContent.mc_tick.removeEventListener(MouseEvent.CLICK,onTickClick);
         GameWorld.cashPanel.addCoins(money);
         remove();
      }
   }
}


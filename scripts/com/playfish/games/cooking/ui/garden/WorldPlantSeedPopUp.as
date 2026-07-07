package com.playfish.games.cooking.ui.garden
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.actors.GardenPlotActor;
   import com.playfish.games.cooking.ui.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class WorldPlantSeedPopUp extends WorldPopUp
   {
      
      private var restaurant:WorldRestaurantPlay;
      
      private var gardenPlotActor:GardenPlotActor;
      
      public function WorldPlantSeedPopUp(param1:GardenPlotActor, param2:WorldRestaurantPlay)
      {
         super(null,null,null);
         this.gardenPlotActor = param1;
         this.restaurant = param2;
         var _loc3_:MovieClip = Engine.getMovieClip("SeedPopupAnim");
         var _loc4_:MovieClip = _loc3_.mc_content;
         addChild(_loc3_);
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_text,"PlantASeed");
         _loc4_.tf_price.text = GardenPlot.SEED_COST.toString();
         setButtonMode(_loc4_.mc_cancel,true);
         _loc4_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         if(GameWorld.gameUser.money.value < GardenPlot.SEED_COST)
         {
            _loc4_.mc_tick.stop();
            _loc4_.mc_tick.visible = false;
            setButtonMode(_loc4_.mc_addCoins,true);
            _loc4_.mc_addCoins.toolTip = new ToolTip(_loc4_.mc_addCoins,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughCoins"));
            _loc4_.mc_addCoins.addEventListener(MouseEvent.CLICK,onAddCoinsClick,false,0,true);
         }
         else
         {
            _loc4_.mc_addCoins.stop();
            _loc4_.mc_addCoins.visible = false;
            setButtonMode(_loc4_.mc_tick,true);
            _loc4_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
         }
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onAddCoinsClick(param1:MouseEvent) : void
      {
         remove();
         GameWorld.cashPanel.showAddCoinsPopUp();
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         gardenPlotActor.plantSeed();
         GameWorld.cashPanel.addCoins(-GardenPlot.SEED_COST);
         new GameSound("SfxPlaceItem",GameSound.TYPE_SOUND).play(1);
         remove();
      }
   }
}


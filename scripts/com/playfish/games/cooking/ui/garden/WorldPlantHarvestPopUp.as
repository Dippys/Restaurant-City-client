package com.playfish.games.cooking.ui.garden
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.actors.GardenPlotActor;
   import com.playfish.games.cooking.ui.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class WorldPlantHarvestPopUp extends WorldPopUp
   {
      
      private var ingredientConfig:Object;
      
      private var gardenPlotActor:GardenPlotActor;
      
      public function WorldPlantHarvestPopUp(param1:GardenPlotActor, param2:Object)
      {
         super(null,null,null);
         this.gardenPlotActor = param1;
         this.ingredientConfig = param2;
         var _loc3_:MovieClip = Engine.getMovieClip("HarvestPopupAnim");
         var _loc4_:MovieClip = _loc3_.mc_content;
         addChild(_loc3_);
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_text,"HarvestPlantToReceive");
         var _loc5_:MovieClip = Engine.getMovieClip(param2.className);
         _loc5_.stop();
         _loc4_.mc_icon.removeChildAt(0);
         _loc4_.mc_icon.addChild(_loc5_);
         _loc4_.mc_rarity.gotoAndStop(param2.rarity);
         _loc4_.tf_name.text = param2.name;
         setButtonMode(_loc4_.mc_cancel,true);
         _loc4_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         setButtonMode(_loc4_.mc_tick,true);
         _loc4_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         gardenPlotActor.harvestPlant();
         remove();
      }
   }
}


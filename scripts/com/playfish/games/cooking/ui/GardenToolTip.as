package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.actors.GardenPlotActor;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class GardenToolTip extends ToolTipBase
   {
      
      private var gardenPlotActor:GardenPlotActor;
      
      public function GardenToolTip(param1:GardenPlotActor, param2:Boolean = true)
      {
         this.gardenPlotActor = param1;
         super(param1,param2);
      }
      
      override public function refresh() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(toolTipMC)
         {
            _loc1_ = gardenPlotActor.plotContent.getBounds(displayParent);
            toolTipMC.y = _loc1_.top;
            toolTipMC.x = _loc1_.x + _loc1_.width / 2;
            _loc2_ = Math.ceil(gardenPlotActor.plot.wetness / (60 * 1000));
            _loc3_ = Math.floor(_loc2_ / 60);
            _loc2_ -= _loc3_ * 60;
            GameWorld.textHandler.setReplaceString("hours",_loc3_.toString());
            GameWorld.textHandler.setReplaceString("minutes",_loc2_.toString());
            GameWorld.textHandler.setTextFieldWithId(toolTipMC.mc_content.tf_waterTime,"HoursMinutes");
            _loc2_ = Math.ceil((GardenPlot.GROW_TIME - gardenPlotActor.plot.growTime) / (60 * 1000));
            _loc3_ = Math.floor(_loc2_ / 60);
            _loc2_ -= _loc3_ * 60;
            GameWorld.textHandler.setReplaceString("hours",_loc3_.toString());
            GameWorld.textHandler.setReplaceString("minutes",_loc2_.toString());
            GameWorld.textHandler.setTextFieldWithId(toolTipMC.mc_content.tf_growTime,"HoursMinutes");
         }
      }
      
      override public function getToolTipMC() : MovieClip
      {
         return Engine.getMovieClip("GardenToolTip");
      }
   }
}


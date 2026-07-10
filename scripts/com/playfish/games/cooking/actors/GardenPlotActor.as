package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.games.cooking.ui.garden.WorldPlantHarvestPopUp;
   import com.playfish.games.cooking.ui.garden.WorldPlantSeedPopUp;
   import com.playfish.rpc.share.NetworkUid;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GardenPlotActor extends RestaurantActor
   {
      
      private static const NUM_WETNESS_FRAMES:int = 3;
      
      private static const WETNESS_PER_FRAME:int = GardenPlot.MAX_WETNESS / NUM_WETNESS_FRAMES;
      
      private var tutorialTimer:Timer;
      
      private var timeToolTip:GardenToolTip;
      
      public var plotContent:MovieClip;
      
      private var plotId:int;
      
      public var plot:GardenPlot;
      
      private var toolTip:ToolTip;
      
      private var seed:MovieClip;
      
      private var ingredientConfig:Object = null;
      
      private var grownPlant:MovieClip;
      
      private var glowEffect:GlowEffect;
      
      public function GardenPlotActor(param1:int, param2:int, param3:WorldRestaurant, param4:GardenPlot, param5:int)
      {
         super("GardenPlot",param3);
         this.plotId = param5;
         this.plotContent = this.content;
         stop();
         setTilePosition(param1,param2);
         seed = Engine.getMovieClip("Seed");
         seed.stop();
         seed.mc_seed.gotoAndPlay("idle");
         seed.visible = false;
         addChild(seed);
         setPlot(param4);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      private function onTutorialTimerComplete(param1:TimerEvent) : void
      {
         tutorialTimer.stop();
         tutorialTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTutorialTimerComplete);
         tutorialTimer = null;
         GameWorld.showTutorialTextPopUp(GameWorld.textHandler.getTextFromId("TutorialGardenPlot"));
      }
      
      public function enable(param1:Boolean) : void
      {
         if(!param1 || Boolean(param1 && plot && plot.ingredientId != -1) && Boolean(!plot.isFullyGrown()))
         {
            mouseEnabled = true;
            mouseChildren = true;
         }
      }
      
      public function harvestPlant() : void
      {
         plot.harvest();
         removeIngredient();
         var _loc1_:GameObject = new GameObject("HarvestAnim");
         _loc1_.numLoops = 1;
         _loc1_.removeWhenComplete = true;
         addObject(_loc1_);
         update();
         WorldRestaurantPlay(restaurant).coinPickUpSound.play(1);
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(plot)
         {
            if(ingredientConfig == null)
            {
               if(plot.ingredientId != -1)
               {
                  setIngredient(plot.ingredientId);
               }
            }
            else if(ingredientConfig.id != plot.ingredientId)
            {
               setIngredient(plot.ingredientId);
            }
            if(ingredientConfig)
            {
               if(plot.isFullyGrown())
               {
                  seed.visible = false;
                  seed.gotoAndStop(1);
                  grownPlant.visible = true;
                  plotContent.gotoAndStop("empty");
                  if(grownPlant.currentFrame != grownPlant.totalFrames)
                  {
                     grownPlant.gotoAndStop(grownPlant.totalFrames);
                  }
                  if(timeToolTip)
                  {
                     timeToolTip.destroy();
                     timeToolTip = null;
                     toolTip = new ToolTip(this,GameWorld.textHandler.getTextFromId("ToolTipClickToHarvest"));
                  }
               }
               else
               {
                  _loc1_ = seed.totalFrames + grownPlant.totalFrames - 1;
                  _loc2_ = GardenPlot.GROW_TIME / _loc1_;
                  _loc3_ = Math.floor(plot.growTime / _loc2_);
                  if(_loc3_ < seed.totalFrames)
                  {
                     grownPlant.visible = false;
                     seed.visible = true;
                     _loc4_ = _loc3_ + 1;
                     if(seed.currentFrame != _loc4_)
                     {
                        seed.gotoAndStop(_loc4_);
                     }
                  }
                  else
                  {
                     seed.visible = false;
                     grownPlant.visible = true;
                     _loc4_ = _loc3_ + 1 - seed.totalFrames;
                     if(grownPlant.currentFrame != _loc4_)
                     {
                        grownPlant.gotoAndStop(_loc4_);
                     }
                  }
                  _loc4_ = Math.min(3 + Math.ceil(plot.wetness / WETNESS_PER_FRAME),plotContent.totalFrames);
                  if(plotContent.currentFrame != _loc4_)
                  {
                     plotContent.gotoAndStop(_loc4_);
                  }
               }
            }
         }
      }
      
      private function setIngredient(param1:int) : void
      {
         ingredientConfig = GameWorld.ingredientItemDatabase.getItemFromId(param1);
         if(grownPlant)
         {
            removeChild(grownPlant);
         }
         grownPlant = Engine.getMovieClip(ingredientConfig.plantClassName);
         grownPlant.stop();
         grownPlant.visible = false;
         addChild(grownPlant);
      }
      
      public function plantSeed() : void
      {
         plot.plantSeed();
         setIngredient(plot.ingredientId);
         seed.mc_seed.gotoAndPlay("start");
         timeToolTip = new GardenToolTip(this);
         update();
         if(toolTip)
         {
            toolTip.destroy();
            toolTip = null;
         }
         if(GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GARDEN_PLOT))
         {
            GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GARDEN_PLOT);
            tutorialTimer = new Timer(1500,1);
            tutorialTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTutorialTimerComplete,false,0,true);
            tutorialTimer.start();
         }
         if(glowEffect)
         {
            glowEffect.remove();
            glowEffect = null;
         }
         new GameSound("SfxPlaceItem",GameSound.TYPE_SOUND).play(1);
      }
      
      public function isPlotLocked() : Boolean
      {
         return plot == null;
      }
      
      override public function tick(param1:uint) : void
      {
         if(plot)
         {
            plot.tick(param1);
         }
         if(Boolean(plot) && plot.updateFlag)
         {
            update();
            plot.updateFlag = false;
            if(timeToolTip)
            {
               timeToolTip.refresh();
            }
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldPlantHarvestPopUp = null;
         var _loc3_:WorldPlantSeedPopUp = null;
         var _loc4_:Number = NaN;
         var _loc5_:NetworkUid = null;
         var _loc6_:Number = NaN;
         var _loc7_:GameObject = null;
         var _loc8_:WorldRestaurantPlay = null;
         if(plot)
         {
            if(plot.isFullyGrown())
            {
               _loc2_ = new WorldPlantHarvestPopUp(this,ingredientConfig);
               _loc2_.show();
            }
            else if(plot.ingredientId == -1)
            {
               _loc3_ = new WorldPlantSeedPopUp(this,restaurant as WorldRestaurantPlay);
               _loc3_.show();
            }
            else
            {
               _loc4_ = plot.wetness;
               _loc5_ = restaurant.gameUser.userInfo.id;
               plot.water(_loc5_);
               _loc6_ = plot.wetness - _loc4_;
               _loc7_ = new GameObject("WateringAnim");
               _loc7_.numLoops = 1;
               _loc7_.removeWhenComplete = true;
               addObject(_loc7_);
               if(!NetworkUid.areEqual(_loc5_,GameWorld.gameUser.userInfo.id) && _loc6_ >= GardenPlot.MIN_DELTA_WETNESS_FOR_COIN)
               {
                  _loc8_ = WorldRestaurantPlay(restaurant);
                  _loc8_.addCoin(x,y + 40,GameWorld.WATER_FRIENDS_PLOT);
               }
               new GameSound("SfxWatering",GameSound.TYPE_SOUND).play(1);
               update();
               timeToolTip.refresh();
            }
         }
      }
      
      public function setPlot(param1:GardenPlot) : void
      {
         var _loc2_:int = 0;
         this.plot = param1;
         if(param1)
         {
            if(toolTip)
            {
               toolTip.destroy();
               toolTip = null;
            }
            if(param1.ingredientId != -1)
            {
               setIngredient(param1.ingredientId);
               timeToolTip = new GardenToolTip(this);
               update();
            }
            else
            {
               plotContent.gotoAndStop("empty");
               toolTip = new ToolTip(this,GameWorld.textHandler.getTextFromId("ToolTipClickToPlantSeed"));
               if(plotId == 0 && restaurant.gameUser == GameWorld.gameUser)
               {
                  if(GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GARDEN_PLOT))
                  {
                     glowEffect = new GlowEffect(this);
                  }
               }
            }
            buttonMode = true;
            addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         }
         else
         {
            plotContent.gotoAndStop("locked");
            _loc2_ = 0;
            while(_loc2_ < GameWorld.LEVEL_THRESHOLDS.length)
            {
               if(GameWorld.LEVEL_THRESHOLDS[_loc2_].gardenPlots > plotId)
               {
                  GameWorld.textHandler.setReplaceString("level",_loc2_.toString());
                  break;
               }
               _loc2_++;
            }
            toolTip = new ToolTip(this,GameWorld.textHandler.getTextFromId("UnlocksAtLevel"));
         }
      }
      
      private function removeIngredient() : void
      {
         if(grownPlant)
         {
            removeChild(grownPlant);
            grownPlant = null;
         }
         ingredientConfig = null;
      }
      
      public function disableClicks() : void
      {
         mouseEnabled = false;
         mouseChildren = false;
      }
   }
}


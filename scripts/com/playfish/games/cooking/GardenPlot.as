package com.playfish.games.cooking
{
   import com.playfish.rpc.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   
   public class GardenPlot
   {
      
      public static var GROW_TIME:int = 48 * 60 * 60 * 1000;
      
      public static const WETNESS_PER_WATER:int = 3 * 60 * 60 * 1000;
      
      public static const MAX_WETNESS:int = 9 * 60 * 60 * 1000;
      
      public static const SEED_COST:int = 2000;
      
      public static const MIN_DELTA_WETNESS_FOR_COIN:int = 3 * 60 * 60 * 1000;
      
      public var growTime:Number = 0;
      
      public var plot:Plot;
      
      public var ingredientId:int = -1;
      
      public var updateFlag:Boolean = false;
      
      public var wetness:Number = 0;
      
      public function GardenPlot(param1:Plot)
      {
         super();
         setPlot(param1);
      }
      
      public function setPlot(param1:Plot) : void
      {
         this.plot = param1;
         if(param1.ingredientId != 0)
         {
            ingredientId = param1.ingredientId;
         }
         wetness = param1.timeToDry;
         growTime = param1.plantWetTime;
         updateFlag = true;
         Debug.out("plot.id=" + param1.id + " plot.ingredientId=" + param1.ingredientId + " plot.timeToDry=" + param1.timeToDry + " GameWorld.serverTime.time=" + GameWorld.serverTime.time + " wetness=" + wetness + " plot.plantWetTime=" + param1.plantWetTime);
      }
      
      private function getRandomIngredientWithPlant() : int
      {
         var _loc1_:Array = new Array();
         var _loc2_:Array = GameWorld.ingredientItemDatabase.getItems("Ingredient");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(Boolean(_loc2_[_loc3_].plantClassName) && _loc2_[_loc3_].plantClassName.length > 0)
            {
               _loc1_.push(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
         return _loc1_[Engine.rnd(0,_loc1_.length)].id;
      }
      
      public function harvest() : void
      {
         var _loc1_:Object = null;
         if(isFullyGrown())
         {
            _loc1_ = GameWorld.ingredientItemDatabase.getItemFromId(ingredientId);
            ingredientId = -1;
            wetness = 0;
            growTime = 0;
            GameWorld.saveProfileHandler.harvestPlant(plot.id,_loc1_);
            GameWorld.gameUser.addIngredient(_loc1_,1);
            GameWorld.gameUser.getIngredient(_loc1_).lock = true;
            GameWorld.addAwardValue(GameAwards.AWARD_HARVEST,1);
         }
      }
      
      public function setWetness(param1:int) : void
      {
         if(ingredientId != -1)
         {
            this.wetness = Math.max(0,Math.min(param1,MAX_WETNESS));
         }
      }
      
      public function water(param1:NetworkUid = null) : void
      {
         setWetness(wetness + WETNESS_PER_WATER);
         if(NetworkUid.areEqual(param1,GameWorld.gameUser.userInfo.id))
         {
            GameWorld.saveProfileHandler.waterPlant(plot.id);
         }
         else
         {
            GameWorld.globalRpcs.waterFriendsPlot(GameWorld.gameUser.userInfo.id,param1,plot.id);
         }
      }
      
      public function isFullyGrown() : Boolean
      {
         return ingredientId != -1 && growTime >= GROW_TIME;
      }
      
      public function plantSeed() : void
      {
         if(ingredientId == -1)
         {
            ingredientId = getRandomIngredientWithPlant();
            growTime = 0;
            setWetness(WETNESS_PER_WATER);
            GameWorld.saveProfileHandler.plantSeed(plot.id);
         }
      }
   }
}


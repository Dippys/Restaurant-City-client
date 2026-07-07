package com.playfish.games.cooking
{
   import com.playfish.games.cooking.utils.ProtectedInt;
   import flash.utils.ByteArray;
   
   public class GameAwards
   {
      
      public static const DATA_VERSION:int = 1;
      
      public static const AWARD_VISIT:int = 0;
      
      public static const AWARD_REMOVE_TRASH:int = 1;
      
      public static const AWARD_GIFT:int = 2;
      
      public static const AWARD_TRADE:int = 3;
      
      public static const AWARD_SPEND_COIN:int = 4;
      
      public static const AWARD_BUY_INDOOR_ITEM:int = 5;
      
      public static const AWARD_BUY_OUTDOOR_ITEM:int = 6;
      
      public static const AWARD_BUY_AVATAR_ITEM:int = 7;
      
      public static const AWARD_RECIPE_LEVEL_10:int = 8;
      
      public static const AWARD_HAPPY_CUSTOMERS:int = 9;
      
      public static const AWARD_UNHAPPY_CUSTOMERS:int = 10;
      
      public static const AWARD_RATE_COUNT:int = 11;
      
      public static const AWARD_HARVEST:int = 12;
      
      public static const AWARD_TASK_CLEAR_PLATE:int = 13;
      
      public static const AWARD_TASK_FIX_TOILET:int = 14;
      
      public static const AWARD_TASK_REPAIR_ITEM:int = 15;
      
      public static const AWARD_TASK_HELP_FRIEND:int = 16;
      
      public static const AWARD_ARCADE_SNAKE_SCORE:int = 17;
      
      public static const AWARD_ARCADE_CAVE_SCORE:int = 18;
      
      public static const AWARD_PARAMS:Array = [[{
         "text":"AwardVisitText",
         "target":100,
         "itemId":3400002
      },{
         "text":"AwardVisitText",
         "target":1000,
         "itemId":3400001
      },{
         "text":"AwardVisitText",
         "target":10000,
         "itemId":3400000
      }],[{
         "text":"AwardRemoveTrashText",
         "target":100,
         "itemId":3400023
      },{
         "text":"AwardRemoveTrashText",
         "target":1000,
         "itemId":3400022
      },{
         "text":"AwardRemoveTrashText",
         "target":10000,
         "itemId":3400021
      }],[{
         "text":"AwardGiftText",
         "target":50,
         "itemId":3400011
      },{
         "text":"AwardGiftText",
         "target":500,
         "itemId":3400010
      },{
         "text":"AwardGiftText",
         "target":5000,
         "itemId":3400009
      }],[{
         "text":"AwardTradeText",
         "target":50,
         "itemId":3400029
      },{
         "text":"AwardTradeText",
         "target":100,
         "itemId":3400028
      },{
         "text":"AwardTradeText",
         "target":5000,
         "itemId":3400027
      }],[{
         "text":"AwardSpendCoinsText",
         "target":2000,
         "itemId":3400008
      },{
         "text":"AwardSpendCoinsText",
         "target":20000,
         "itemId":3400007
      },{
         "text":"AwardSpendCoinsText",
         "target":200000,
         "itemId":3400006
      }],[{
         "text":"AwardBuyIndoorItemText",
         "target":10,
         "itemId":3400017
      },{
         "text":"AwardBuyIndoorItemText",
         "target":500,
         "itemId":3400016
      },{
         "text":"AwardBuyIndoorItemText",
         "target":2000,
         "itemId":3400015
      }],[{
         "text":"AwardBuyOutdoorItemText",
         "target":10,
         "itemId":3400014
      },{
         "text":"AwardBuyOutdoorItemText",
         "target":200,
         "itemId":3400013
      },{
         "text":"AwardBuyOutdoorItemText",
         "target":500,
         "itemId":3400012
      }],[{
         "text":"AwardBuyAvatarItemText",
         "target":10,
         "itemId":3400020
      },{
         "text":"AwardBuyAvatarItemText",
         "target":100,
         "itemId":3400019
      },{
         "text":"AwardBuyAvatarItemText",
         "target":500,
         "itemId":3400018
      }],[{
         "text":"AwardRecipeLevel10Text",
         "target":1,
         "itemId":3400026
      },{
         "text":"AwardRecipeLevel10Text",
         "target":5,
         "itemId":3400025
      },{
         "text":"AwardRecipeLevel10Text",
         "target":20,
         "itemId":3400024
      }],[],[],[{
         "text":"AwardRateCountText",
         "target":100,
         "itemId":3400005
      },{
         "text":"AwardRateCountText",
         "target":1000,
         "itemId":3400004
      },{
         "text":"AwardRateCountText",
         "target":10000,
         "itemId":3400003
      }],[{
         "text":"AwardHarvestText",
         "target":10,
         "itemId":3400032
      },{
         "text":"AwardHarvestText",
         "target":50,
         "itemId":3400031
      },{
         "text":"AwardHarvestText",
         "target":200,
         "itemId":3400030
      }],[{
         "text":"AwardClearPlateText",
         "target":50,
         "itemId":3400035
      },{
         "text":"AwardClearPlateText",
         "target":500,
         "itemId":3400034
      },{
         "text":"AwardClearPlateText",
         "target":2000,
         "itemId":3400033
      }],[{
         "text":"AwardFixToiletText",
         "target":20,
         "itemId":3400038
      },{
         "text":"AwardFixToiletText",
         "target":200,
         "itemId":3400037
      },{
         "text":"AwardFixToiletText",
         "target":1000,
         "itemId":3400036
      }],[{
         "text":"AwardRepairItemText",
         "target":20,
         "itemId":3400041
      },{
         "text":"AwardRepairItemText",
         "target":200,
         "itemId":3400040
      },{
         "text":"AwardRepairItemText",
         "target":1000,
         "itemId":3400039
      }],[{
         "text":"AwardHelpFriendText",
         "target":50,
         "itemId":3400044
      },{
         "text":"AwardHelpFriendText",
         "target":250,
         "itemId":3400043
      },{
         "text":"AwardHelpFriendText",
         "target":1000,
         "itemId":3400042
      }],[],[]];
      
      public var values:Array = new Array();
      
      public function GameAwards()
      {
         super();
         var _loc1_:Number = 0;
         while(_loc1_ < AWARD_PARAMS.length)
         {
            values[_loc1_] = new ProtectedInt(0);
            _loc1_++;
         }
      }
      
      public function addValue(param1:int, param2:int) : Object
      {
         var _loc3_:int = int(values[param1].value);
         var _loc4_:int = _loc3_ + param2;
         values[param1].value = _loc4_;
         var _loc5_:Number = AWARD_PARAMS[param1].length - 1;
         while(_loc5_ >= 0)
         {
            if(_loc3_ < AWARD_PARAMS[param1][_loc5_].target && _loc4_ >= AWARD_PARAMS[param1][_loc5_].target)
            {
               return AWARD_PARAMS[param1][_loc5_];
            }
            _loc5_--;
         }
         return null;
      }
      
      public function getOwnedAwardCount() : int
      {
         var _loc3_:Number = NaN;
         var _loc1_:int = 0;
         var _loc2_:Number = 0;
         while(_loc2_ < AWARD_PARAMS.length)
         {
            _loc3_ = 0;
            while(_loc3_ < AWARD_PARAMS[_loc2_].length)
            {
               if(values[_loc2_].value >= AWARD_PARAMS[_loc2_][_loc3_].target)
               {
                  _loc1_++;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function loadBytes(param1:ByteArray) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc2_:int = param1.readByte();
         if(_loc2_ == DATA_VERSION)
         {
            _loc3_ = param1.readByte();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = param1.readInt();
               if(_loc4_ < values.length)
               {
                  values[_loc4_].value = _loc5_;
               }
               _loc4_++;
            }
         }
      }
      
      public function getTotalAwardCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:Number = 0;
         while(_loc2_ < AWARD_PARAMS.length)
         {
            _loc1_ += AWARD_PARAMS[_loc2_].length;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getSaveBytes() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(1);
         _loc1_.writeByte(values.length);
         var _loc2_:Number = 0;
         while(_loc2_ < values.length)
         {
            _loc1_.writeInt(values[_loc2_].value);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getAllAwardObjects() : Array
      {
         var _loc3_:Number = NaN;
         var _loc1_:Array = new Array();
         var _loc2_:Number = 0;
         while(_loc2_ < AWARD_PARAMS.length)
         {
            _loc3_ = 0;
            while(_loc3_ < AWARD_PARAMS[_loc2_].length)
            {
               AWARD_PARAMS[_loc2_][_loc3_].value = values[_loc2_].value;
               _loc1_.push(AWARD_PARAMS[_loc2_][_loc3_]);
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getValue(param1:int) : int
      {
         return values[param1].value;
      }
      
      public function getAwardLevel(param1:int) : int
      {
         var _loc2_:int = int(values[param1].value);
         var _loc3_:Number = AWARD_PARAMS[param1].length - 1;
         while(_loc3_ >= 0)
         {
            if(_loc2_ >= AWARD_PARAMS[param1][_loc3_].target)
            {
               return _loc3_;
            }
            _loc3_--;
         }
         return -1;
      }
      
      public function setValue(param1:int, param2:int) : void
      {
         values[param1].value = param2;
      }
   }
}


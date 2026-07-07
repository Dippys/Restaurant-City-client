package com.playfish.rpc.cooking
{
   import com.playfish.rpc.share.RpcResponseBase;
   
   internal class RpcResponse extends RpcResponseBase
   {
      
      public function RpcResponse()
      {
         super();
      }
      
      internal function readOwnedItem() : OwnedItem
      {
         var _loc1_:OwnedItem = new OwnedItem();
         _loc1_.id = readIntvar32();
         _loc1_.globalItemId = readUintvar31();
         _loc1_.positionX = readIntvar32();
         _loc1_.positionY = readIntvar32();
         _loc1_.data = readUint8();
         _loc1_.employeeId = readNetworkUid();
         _loc1_.roomIndex = readUint8();
         return _loc1_;
      }
      
      internal function readProfile() : UserInfo
      {
         var _loc2_:int = 0;
         var _loc1_:UserInfo = new UserInfo();
         _loc1_.id = readNetworkUid();
         _loc2_ = int(readUint8());
         _loc1_.offlineShard = readBoolean();
         if(_loc2_ >= 1)
         {
            _loc1_.firstName = readString();
            _loc1_.fullName = readString();
            _loc1_.imageUrl = readString();
            _loc1_.profileUrl = readString();
            _loc1_.gender = readUint8();
         }
         if(_loc2_ >= 2)
         {
            _loc1_.restaurantName = readString();
            _loc1_.credits = readUintvar32();
            _loc1_.playCount = readIntvar32();
            _loc1_.gourmetPoint = readUintvar32();
            _loc1_.nbVote = readUintvar31();
            _loc1_.totalMark = readUintvar32();
            _loc1_.trashPoint = readUintvar31();
            _loc1_.demandPoint = readUintvar31();
            _loc1_.musicPlay = readUintvar31();
            _loc1_.isInStreet = readBoolean();
            _loc1_.lastSave = readUintvar31();
            _loc1_.lastSurveyTime = readDate();
            if(readBoolean())
            {
               _loc1_.awards = readByteArray();
            }
            _loc1_.userLevel = readUint8();
            _loc1_.consecutionCount = readUint8();
         }
         if(_loc2_ >= 3)
         {
            _loc1_.ownedItem = readArray(readOwnedItem);
         }
         if(_loc2_ >= 4)
         {
            if(readBoolean())
            {
               _loc1_.floor = readArray(readUintvar31);
            }
            else
            {
               _loc1_.floor = null;
            }
            _loc1_.floors = readArray(readFloor);
            _loc1_.activeFloorIndex = readUint8();
            _loc1_.employees = readArray(readEmployee);
            _loc1_.ingredients = readArray(readIngredient);
            if(readBoolean())
            {
               _loc1_.garden = readArray(readPlot);
            }
            else
            {
               _loc1_.garden = null;
            }
         }
         if(_loc2_ >= 5)
         {
            _loc1_.inventoryItem = readArray(readInventoryItem);
            _loc1_.visitedFriend = readArray(readNetworkUid);
            _loc1_.visitedFriendsToday = readArray(readNetworkUid);
         }
         return _loc1_;
      }
      
      internal function readEmployee() : Employee
      {
         var _loc1_:Employee = new Employee();
         _loc1_.id = readNetworkUid();
         _loc1_.happiness = readUintvar31();
         _loc1_.task = readUint8();
         _loc1_.notify = readBoolean();
         _loc1_.clothes = readArray(readOwnedItem);
         return _loc1_;
      }
      
      internal function readFloor() : Floor
      {
         var _loc1_:Floor = new Floor();
         _loc1_.floorIndex = readUintvar31();
         _loc1_.tiles = readArray(readUintvar31);
         return _loc1_;
      }
      
      internal function readIngredientMarketItem() : IngredientMarketItem
      {
         var _loc1_:IngredientMarketItem = new IngredientMarketItem();
         _loc1_.ingredientId = readUintvar31();
         _loc1_.price = readUintvar31();
         return _loc1_;
      }
      
      internal function readIngredient() : Ingredient
      {
         var _loc1_:Ingredient = new Ingredient();
         _loc1_.globalItemId = readUintvar31();
         _loc1_.isLocked = readBoolean();
         _loc1_.number = readUintvar31();
         return _loc1_;
      }
      
      internal function readInventoryItem() : InventoryItem
      {
         var _loc1_:InventoryItem = new InventoryItem();
         _loc1_.globalItemId = readUintvar31();
         _loc1_.number = readUintvar31();
         _loc1_.isSelected = readBoolean();
         return _loc1_;
      }
      
      internal function readMail() : Mail
      {
         var _loc1_:Mail = new Mail();
         _loc1_.id = readUintvar32();
         _loc1_.senderId = readNetworkUid();
         _loc1_.globalItemIds = readArray(readUintvar31);
         _loc1_.message = readString();
         _loc1_.read = readBoolean();
         _loc1_.sendDate = readDate();
         _loc1_.deleteTime = readUint8();
         _loc1_.type = readUint8();
         return _loc1_;
      }
      
      internal function readPlot() : Plot
      {
         var _loc1_:Plot = new Plot();
         _loc1_.id = readUint8();
         _loc1_.ingredientId = readUintvar31();
         _loc1_.plantWetTime = readUintvar32() * 1000;
         _loc1_.timeToDry = readUintvar32() * 1000;
         return _loc1_;
      }
   }
}


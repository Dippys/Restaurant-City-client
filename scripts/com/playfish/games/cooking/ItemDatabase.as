package com.playfish.games.cooking
{
   import com.playfish.games.cooking.utils.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.ByteArray;
   
   public class ItemDatabase extends EventDispatcher
   {
      
      public var itemGroups:Array;
      
      public function ItemDatabase(param1:ByteArray)
      {
         super();
         load(param1);
      }
      
      public function getItemsAboveCost(param1:String, param2:int) : Array
      {
         return getItemsBetweenCost(param1,param2,-1);
      }
      
      public function load(param1:ByteArray) : void
      {
         var langXML:XML = null;
         var groupList:XMLList = null;
         var curGroup:XML = null;
         var groupObj:Object = null;
         var type:String = null;
         var curGroupAttribute:XML = null;
         var items:Array = null;
         var curItem:XML = null;
         var value:String = null;
         var itemObj:Object = null;
         var curAttribute:XML = null;
         var attributeName:String = null;
         var i:int = 0;
         var j:int = 0;
         var theItem:Object = null;
         var data:ByteArray = param1;
         try
         {
            langXML = new XML(data);
            groupList = langXML.group;
            itemGroups = new Array();
            for each(curGroup in groupList)
            {
               groupObj = new Object();
               itemGroups.push(groupObj);
               groupObj.name = curGroup.attribute("name");
               type = curGroup.attribute("type");
               if(type != null && type.length > 0)
               {
                  groupObj.types = type.split(/\s*,\s*/);
               }
               for each(curGroupAttribute in curGroup.attributes())
               {
                  if(curGroupAttribute.name() != "name" && curGroupAttribute.name() != "type")
                  {
                     value = String(curGroupAttribute);
                     if(value == "null")
                     {
                        value = null;
                     }
                     groupObj[String(curGroupAttribute.name())] = value;
                  }
               }
               items = new Array();
               for each(curItem in curGroup.item)
               {
                  itemObj = new Object();
                  itemObj.group = groupObj;
                  itemObj.cash = 0;
                  itemObj.cost = 0;
                  for each(curAttribute in curItem.attributes())
                  {
                     attributeName = String(curAttribute.name());
                     value = String(curAttribute);
                     if(attributeName == "type")
                     {
                        itemObj.types = value.split(/\s*,\s*/);
                     }
                     else if(value == "true")
                     {
                        itemObj[attributeName] = true;
                     }
                     else if(value == "false")
                     {
                        itemObj[attributeName] = false;
                     }
                     else
                     {
                        if(value == "null")
                        {
                           value = null;
                        }
                        itemObj[attributeName] = value;
                     }
                  }
                  itemObj.children = curItem.children();
                  items.push(itemObj);
               }
               groupObj.items = items;
            }
         }
         catch(e:Error)
         {
         }
         if(Debug.DEBUG)
         {
            i = 0;
            while(i < itemGroups.length)
            {
               items = itemGroups[i].items;
               j = 0;
               while(j < items.length)
               {
                  theItem = items[j];
                  if(getAllItemsWithId(theItem.id).length > 1)
                  {
                     Debug.warning("Duplicated id " + theItem.id + " item " + theItem.name);
                  }
                  j++;
               }
               i++;
            }
         }
      }
      
      public function error(param1:IOErrorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function getItem(param1:String) : Object
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = 0;
         while(_loc2_ < itemGroups.length)
         {
            _loc3_ = 0;
            while(_loc3_ < itemGroups[_loc2_].items.length)
            {
               if(itemGroups[_loc2_].items[_loc3_].name == param1)
               {
                  return itemGroups[_loc2_].items[_loc3_];
               }
               _loc3_++;
            }
            _loc2_++;
         }
         Debug.warning("getItem(name): item " + param1 + " not found");
         return null;
      }
      
      public function getItems(param1:String) : Array
      {
         var _loc2_:Number = 0;
         while(_loc2_ < itemGroups.length)
         {
            if(itemGroups[_loc2_].name == param1)
            {
               return itemGroups[_loc2_].items;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getItemsBetweenCost(param1:String, param2:int, param3:int) : Array
      {
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc4_:Array = getItems(param1);
         if(_loc4_)
         {
            _loc5_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               if(Boolean(_loc4_[_loc6_].cost) && (Boolean(param2 == -1 || _loc4_[_loc6_].cost >= param2)) && (param3 == -1 || _loc4_[_loc6_].cost <= param3))
               {
                  _loc5_.push(_loc4_[_loc6_]);
               }
               _loc6_++;
            }
            return _loc5_;
         }
         return null;
      }
      
      public function getItemFromGroup(param1:String, param2:String) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc3_:Number = 0;
         while(_loc3_ < itemGroups.length)
         {
            _loc4_ = itemGroups[_loc3_];
            if(_loc4_.name == param2)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.items.length)
               {
                  if(_loc4_.items[_loc5_].name == param1)
                  {
                     return _loc4_.items[_loc5_];
                  }
                  _loc5_++;
               }
               break;
            }
            _loc3_++;
         }
         Debug.warning("item " + param1 + " not found in group " + param2);
         return null;
      }
      
      public function getItemFromGroupWithId(param1:int, param2:String) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc3_:Number = 0;
         while(_loc3_ < itemGroups.length)
         {
            _loc4_ = itemGroups[_loc3_];
            if(_loc4_.name == param2)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.items.length)
               {
                  if(_loc4_.items[_loc5_].id == param1)
                  {
                     return _loc4_.items[_loc5_];
                  }
                  _loc5_++;
               }
               break;
            }
            _loc3_++;
         }
         Debug.warning("item " + param1 + " not found in group " + param2);
         return null;
      }
      
      public function getGroup(param1:String) : Object
      {
         var _loc2_:Number = 0;
         while(_loc2_ < itemGroups.length)
         {
            if(itemGroups[_loc2_].name == param1)
            {
               return itemGroups[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getItemsBelowCost(param1:String, param2:int) : Array
      {
         return getItemsBetweenCost(param1,-1,param2);
      }
      
      public function getItemFromId(param1:int) : Object
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = 0;
         while(_loc2_ < itemGroups.length)
         {
            _loc3_ = 0;
            while(_loc3_ < itemGroups[_loc2_].items.length)
            {
               if(itemGroups[_loc2_].items[_loc3_].id == param1)
               {
                  return itemGroups[_loc2_].items[_loc3_];
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function getAllItemsWithId(param1:int) : Array
      {
         var _loc4_:Number = NaN;
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < itemGroups.length)
         {
            _loc4_ = 0;
            while(_loc4_ < itemGroups[_loc3_].items.length)
            {
               if(itemGroups[_loc3_].items[_loc4_].id == param1)
               {
                  _loc2_.push(itemGroups[_loc3_].items[_loc4_]);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function itemInGroup(param1:int, param2:String) : Boolean
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc3_:Number = 0;
         while(_loc3_ < itemGroups.length)
         {
            _loc4_ = itemGroups[_loc3_];
            if(_loc4_.name == param2)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.items.length)
               {
                  if(_loc4_.items[_loc5_].id == param1)
                  {
                     return true;
                  }
                  _loc5_++;
               }
               break;
            }
            _loc3_++;
         }
         return false;
      }
   }
}


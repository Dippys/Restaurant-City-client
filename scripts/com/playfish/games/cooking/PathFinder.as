package com.playfish.games.cooking
{
   public class PathFinder
   {
      
      public static const PROCESS_STATE_NO_PATH:int = 0;
      
      public static const PROCESS_STATE_PROCESSING:int = 1;
      
      public static const PROCESS_STATE_FOUND:int = 2;
      
      private var stopNextToDestTile:Boolean = false;
      
      private var openList:Array;
      
      private const NODE_STATE_CLOSED:int = 2;
      
      private const NODE_STATE_AVAILABLE:int = 0;
      
      private var startTileX:int;
      
      private var startTileY:int;
      
      private const STRAIGHT_SCORE:int = 10;
      
      private var destTileX:int;
      
      private var destTileY:int;
      
      private var nodeStateMap:Array;
      
      private const NODE_STATE_OPEN:int = 1;
      
      private var closeList:Array;
      
      private const DIAGONAL_SCORE:int = 14;
      
      private var restaurant:WorldRestaurant;
      
      public function PathFinder(param1:int, param2:int, param3:int, param4:int, param5:WorldRestaurant, param6:Boolean = false)
      {
         var _loc9_:int = 0;
         openList = new Array();
         closeList = new Array();
         nodeStateMap = new Array();
         super();
         this.restaurant = param5;
         this.startTileX = param1;
         this.startTileY = param2;
         this.destTileX = param3;
         this.destTileY = param4;
         this.stopNextToDestTile = param6;
         var _loc7_:int = 0;
         while(_loc7_ < WorldRestaurant.MAX_NUM_TILES_X)
         {
            nodeStateMap[_loc7_] = new Array();
            _loc9_ = 0;
            while(_loc9_ < WorldRestaurant.MAX_NUM_TILES_Y)
            {
               nodeStateMap[_loc7_][_loc9_] = null;
               _loc9_++;
            }
            _loc7_++;
         }
         var _loc8_:PathFinderNode = new PathFinderNode(param1,param2,null,0,0);
         openList.push(_loc8_);
         nodeStateMap[param1][param2] = _loc8_;
      }
      
      public function getFinalPath() : Array
      {
         var _loc2_:Array = null;
         var _loc3_:PathFinderNode = null;
         var _loc1_:PathFinderNode = openList[0];
         if(_loc1_.x == destTileX && _loc1_.y == destTileY)
         {
            _loc2_ = new Array();
            _loc3_ = _loc1_;
            while(_loc3_.parent != null)
            {
               _loc2_.splice(0,0,[_loc3_.x,_loc3_.y]);
               _loc3_ = _loc3_.parent;
            }
            return _loc2_;
         }
         return null;
      }
      
      private function getHeuristic(param1:int, param2:int) : int
      {
         return (Math.abs(destTileX - param1) + Math.abs(destTileY - param2)) * STRAIGHT_SCORE;
      }
      
      public function processOpenList(param1:int) : int
      {
         var _loc2_:PathFinderNode = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:PathFinderNode = null;
         var _loc6_:int = 0;
         while(param1 == -1 || param1-- > 0)
         {
            if(openList.length <= 0)
            {
               return PROCESS_STATE_NO_PATH;
            }
            _loc2_ = openList[0];
            if(_loc2_.x == destTileX && _loc2_.y == destTileY)
            {
               return PROCESS_STATE_FOUND;
            }
            nodeStateMap[_loc2_.x][_loc2_.y].state = NODE_STATE_CLOSED;
            openList.splice(0,1);
            _loc3_ = getValidAdjacentNodes(_loc2_);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               _loc6_ = 0;
               while(_loc6_ < openList.length)
               {
                  if(_loc5_.fScore <= openList[_loc6_].fScore)
                  {
                     openList.splice(_loc6_,0,_loc5_);
                     break;
                  }
                  _loc6_++;
               }
               if(_loc6_ >= openList.length)
               {
                  openList.push(_loc5_);
               }
               nodeStateMap[_loc5_.x][_loc5_.y] = _loc5_;
               _loc4_++;
            }
         }
         return PROCESS_STATE_PROCESSING;
      }
      
      private function getValidAdjacentNodes(param1:PathFinderNode) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = param1.x;
         var _loc4_:int = param1.y;
         var _loc5_:int = _loc3_ - 1;
         while(_loc5_ <= _loc3_ + 1)
         {
            if(_loc5_ >= 0)
            {
               _loc6_ = _loc4_ - 1;
               while(_loc6_ <= _loc4_ + 1)
               {
                  if(_loc6_ >= 0 && (_loc3_ != _loc5_ || _loc4_ != _loc6_))
                  {
                     if(nodeStateMap[_loc5_][_loc6_] == null)
                     {
                        if(isValid(_loc3_,_loc4_,_loc5_,_loc6_))
                        {
                           _loc7_ = param1.g;
                           if(_loc5_ == _loc3_ || _loc6_ == _loc4_)
                           {
                              _loc7_ += STRAIGHT_SCORE;
                           }
                           else
                           {
                              _loc7_ += DIAGONAL_SCORE;
                           }
                           _loc8_ = getHeuristic(_loc5_,_loc6_);
                           _loc2_.push(new PathFinderNode(_loc5_,_loc6_,param1,_loc7_,_loc7_ + _loc8_));
                        }
                     }
                     else if(nodeStateMap[_loc5_][_loc6_].state == NODE_STATE_OPEN)
                     {
                        _loc7_ = param1.g;
                        if(_loc5_ == _loc3_ || _loc6_ == _loc4_)
                        {
                           _loc7_ += STRAIGHT_SCORE;
                        }
                        else
                        {
                           _loc7_ += DIAGONAL_SCORE;
                        }
                        if(_loc7_ < nodeStateMap[_loc5_][_loc6_].g)
                        {
                           _loc8_ = getHeuristic(_loc5_,_loc6_);
                           _loc9_ = _loc7_ + _loc8_;
                           nodeStateMap[_loc5_][_loc6_].g = _loc7_;
                           nodeStateMap[_loc5_][_loc6_].fScore = _loc9_;
                           nodeStateMap[_loc5_][_loc6_].parent = param1;
                        }
                     }
                  }
                  _loc6_++;
               }
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      private function isValid(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         if(param3 == destTileX && param4 == destTileY)
         {
            if(stopNextToDestTile)
            {
               return true;
            }
            return restaurant.isWalkableFrom(param1,param2,param3,param4,true,false);
         }
         return restaurant.isWalkableFrom(param1,param2,param3,param4,false,false);
      }
   }
}


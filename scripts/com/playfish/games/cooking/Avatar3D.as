package com.playfish.games.cooking
{
   import away3d.animators.SkinAnimation;
   import away3d.containers.*;
   import away3d.core.base.Object3D;
   import away3d.core.math.Number3D;
   import away3d.materials.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.*;
   
   public class Avatar3D extends EventDispatcher
   {
      
      public static const ANIMATION_IDLE:int = 0;
      
      public static const ANIMATION_WALK:int = 1;
      
      public static const ANIMATION_SIT:int = 2;
      
      public static const ANIMATION_EAT:int = 3;
      
      public static const ANIMATION_WAITOR_WALK:int = 4;
      
      public static const ANIMATION_COOKING:int = 5;
      
      public static const ANIMATION_EDITOR_IDLE:int = 6;
      
      public static const ANIMATION_EDITOR_OUTFIT_CHANGE:int = 7;
      
      public static const ANIMATION_EDITOR_HEAD_CHANGE:int = 8;
      
      public static const ANIMATION_EDITOR_PANTS_CHANGE:int = 9;
      
      public static const ANIMATION_DEAD:int = 10;
      
      public static const ANIMATION_HIRE_TRASHCAN:int = 11;
      
      public static const ANIMATION_HIRE_BUS:int = 12;
      
      public static const ANIMATION_HIRE_BENCE:int = 13;
      
      public static const ANIMATION_WAITOR_WORKING:int = 14;
      
      public static const ANIMATION_STREET_WALK:int = 15;
      
      public static const ANIMATION_STREET_IDLE:int = 16;
      
      public static const ANIMATION_CLEAN:int = 17;
      
      public static const ANIMATION_CLEANER_WALK:int = 18;
      
      public static const ANIMATION_CLEANER_IDLE:int = 19;
      
      public static const ANIMATION_CLEANER_DEAD:int = 20;
      
      public static const ANIMATION_CLEANER_REPAIR:int = 21;
      
      public static const ANIMATION_FRAME_RANGE:Array = [20,23,0,3,35,35,36,39,10,13,30,33,45,68,72,90,92,101,103,129,133,133,132,132,131,131,130,130,30,33,0,3,20,23,136,140,10,13,20,23,133,133,141,144];
      
      public static const ANIMATION_FRAME_DELAY_MULTIPLIER:Array = [2,1.75,1,1,2,1,1,1,1,1,1,1,1,1,1,2,2,1,2,2,1,1];
      
      public static const ANIMATION_SHOW_OBJECTS:Array = [null,null,null,null,["tray"],null,null,null,null,null,null,null,null,null,null,null,null,["bucket","brush"],["bucket","brush"],["bucket","brush"],["bucket","brush"],["repair"]];
      
      public static const ANIMATION_CACHE_DIRECTIONS_ALL:Array = [0,1,2,3,4,5,6,7];
      
      public static const ANIMATION_CACHE_DIRECTIONS_DIAGONAL:Array = [1,3,5,7];
      
      public static const ANIMATION_CACHE_DIRECTIONS:Array = [ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_DIAGONAL,ANIMATION_CACHE_DIRECTIONS_DIAGONAL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_DIAGONAL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,[2,6],[0,4],ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL,ANIMATION_CACHE_DIRECTIONS_ALL];
      
      public static const ANIMATION_FPS:Number = 10;
      
      public static const ANIMATION_SPF:Number = 1 / ANIMATION_FPS;
      
      public static const DEFAULT_FRAME_DELAY:int = 80;
      
      public static const CUSTOMISABLE_OBJECT_PREFIX:Array = ["pants","dress","shirt","hat","hair","armleft","armright"];
      
      private static const ANIMATION_OBJECT_NAMES:Array = ["tray","bucket","brush","repair"];
      
      private static const CACHE_DIRECTIONS:int = 8;
      
      private static const ANGLE_PER_DIRECTION:int = 360 / CACHE_DIRECTIONS;
      
      private var cachingDirection:int = 0;
      
      private var cachingAnimation:int = 0;
      
      private var timeMillisToNextFrame:int;
      
      private var isoCacher:IsoCacher;
      
      private var destroyed:Boolean = false;
      
      public var curAnimation:int = -1;
      
      public var model:ObjectContainer3D;
      
      public var animationLoopCountQueue:Array = new Array();
      
      private var skinColour:int = 0;
      
      public var curAnimationFrame:int = 0;
      
      public var usePhongShading:Boolean = true;
      
      public var loopCount:int = -1;
      
      public var hideGroupItemConfigs:Array = new Array();
      
      private var hairColour:int = 0;
      
      public var curAnimationFrameDelay:int = 80;
      
      private var animationTypes:Array;
      
      private var cachingDirectionIndex:int = 0;
      
      private var hairMaterial:IMaterial;
      
      public var avatarItems:Array;
      
      public var animationQueue:Array = new Array();
      
      public var cachedFrameShape:Object;
      
      public var cachedIsoShapes:Array;
      
      public function Avatar3D(param1:ObjectContainer3D, param2:Boolean = true)
      {
         super();
         this.usePhongShading = param2;
         model = param1;
         model.lookAt(Number3D.FORWARD);
         if(param2)
         {
            hairMaterial = new PhongColorMaterial(hairColour);
         }
         else
         {
            hairMaterial = new ColorMaterial(hairColour);
         }
         model.materialLibrary.getMaterial("hair").material = hairMaterial;
         playAnimation(ANIMATION_IDLE);
      }
      
      public static function getAnimationFrameCount(param1:int) : int
      {
         return ANIMATION_FRAME_RANGE[param1 * 2 + 1] - ANIMATION_FRAME_RANGE[param1 * 2] + 1;
      }
      
      public static function getAnimationDelay(param1:int) : int
      {
         return DEFAULT_FRAME_DELAY * ANIMATION_FRAME_DELAY_MULTIPLIER[param1];
      }
      
      public function destroy() : void
      {
         if(isoCacher != null)
         {
            isoCacher.destroy();
            isoCacher = null;
         }
         destroyed = true;
      }
      
      private function singleFrameCacheCallback(param1:Object) : Boolean
      {
         cachedFrameShape = param1;
         if(isoCacher != null)
         {
            isoCacher.destroy();
            isoCacher = null;
         }
         dispatchEvent(new Event("cache_complete"));
         return false;
      }
      
      private function getFrameIndex() : int
      {
         return curAnimationFrame;
      }
      
      private function showGroup(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Number = 0;
         while(_loc2_ < avatarItems.length)
         {
            _loc3_ = avatarItems[_loc2_].itemConfig;
            if(_loc3_.group.name == param1)
            {
               showObjectsForItem(_loc3_);
            }
            _loc2_++;
         }
      }
      
      private function popAnimationQueue() : void
      {
         if(animationQueue.length > 0)
         {
            playAnimation(animationQueue[0]);
            loopCount = animationLoopCountQueue[0];
            animationQueue.splice(0,1);
            animationLoopCountQueue.splice(0,1);
         }
      }
      
      public function showChild(param1:String) : void
      {
         var _loc2_:Object3D = model.getChildByName(param1 + "-node");
         if(_loc2_ != null)
         {
            _loc2_.visible = true;
         }
      }
      
      public function cacheIsoAnimation(param1:Array) : void
      {
         this.animationTypes = param1;
         this.cachingAnimation = 0;
         this.cachingDirection = 0;
         cachedIsoShapes = new Array();
         var _loc2_:int = int(param1[0]);
         cachingDirectionIndex = 0;
         cachingDirection = ANIMATION_CACHE_DIRECTIONS[_loc2_][cachingDirectionIndex];
         playAnimation(_loc2_);
         isoCacher = new IsoCacher(this,isoCacheCallback,true,true,ANGLE_PER_DIRECTION * cachingDirection);
      }
      
      public function stopAnimation() : void
      {
         curAnimation = -1;
      }
      
      public function cacheSingleFrame(param1:int) : void
      {
         playAnimation(param1);
         isoCacher = new IsoCacher(this,singleFrameCacheCallback,false,false);
      }
      
      public function setAvatarItems(param1:Array, param2:int, param3:int) : void
      {
         this.avatarItems = param1;
         refreshObjects();
         setSkinColour(param3);
         setHairColour(param2);
      }
      
      public function setSkinColour(param1:int) : void
      {
         this.skinColour = param1;
         updateTextureMaterial();
      }
      
      private function getTextureMaterial() : IMaterial
      {
         if(usePhongShading)
         {
            return new PhongBitmapMaterial(constructTextureBitmapData());
         }
         return new BitmapMaterial(constructTextureBitmapData());
      }
      
      public function hideObjectsForItem(param1:Object) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Array = getObjectNamesForItem(param1);
         if(_loc2_ != null)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               hideChild(_loc2_[_loc4_]);
               _loc4_++;
            }
         }
         var _loc3_:Array = getGroupsToHide(param1);
         if(_loc3_ != null)
         {
            hideGroupItemConfigs.splice(hideGroupItemConfigs.indexOf(param1),1);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               showGroup(_loc3_[_loc4_]);
               _loc4_++;
            }
         }
      }
      
      private function setFrame(param1:int) : void
      {
         curAnimationFrame = param1;
         var _loc2_:SkinAnimation = model.animationLibrary.getAnimation("default").animation as SkinAnimation;
         _loc2_.update(ANIMATION_SPF * param1);
      }
      
      public function showObjectsForItem(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         if(!isItemGroupHidden(param1.group.name))
         {
            _loc3_ = getObjectNamesForItem(param1);
            if(_loc3_ != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  showChild(_loc3_[_loc4_]);
                  _loc4_++;
               }
            }
         }
         var _loc2_:Array = getGroupsToHide(param1);
         if(_loc2_ != null)
         {
            hideGroupItemConfigs.push(param1);
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               hideGroup(_loc2_[_loc4_]);
               _loc4_++;
            }
         }
      }
      
      public function playAnimation(param1:int, param2:int = -1) : void
      {
         curAnimation = param1;
         this.loopCount = param2;
         curAnimationFrameDelay = getAnimationDelay(curAnimation);
         var _loc3_:int = 0;
         while(_loc3_ < ANIMATION_OBJECT_NAMES.length)
         {
            hideChild(ANIMATION_OBJECT_NAMES[_loc3_]);
            _loc3_++;
         }
         var _loc4_:Array = ANIMATION_SHOW_OBJECTS[curAnimation];
         if(_loc4_ != null)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               showChild(_loc4_[_loc3_]);
               _loc3_++;
            }
         }
         setFrame(ANIMATION_FRAME_RANGE[param1 * 2]);
      }
      
      public function refreshObjects() : void
      {
         var _loc2_:Object3D = null;
         hideGroupItemConfigs.splice(0,hideGroupItemConfigs.length);
         var _loc1_:Number = 0;
         while(_loc1_ < model.children.length)
         {
            _loc2_ = model.children[_loc1_];
            if(isCustomisableChildObject(_loc2_.name))
            {
               _loc2_.visible = false;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < avatarItems.length)
         {
            showObjectsForItem(avatarItems[_loc1_].itemConfig);
            _loc1_++;
         }
      }
      
      private function nextFrame() : void
      {
         if(isLastFrame())
         {
            setFrame(ANIMATION_FRAME_RANGE[curAnimation * 2]);
         }
         else
         {
            setFrame(getFrameIndex() + 1);
         }
      }
      
      private function getGroupsToHide(param1:Object) : Array
      {
         if(param1.hideGroup)
         {
            return param1.hideGroup.split(/\s*,\s*/);
         }
         return null;
      }
      
      public function getBase() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(skinColour);
         _loc1_.graphics.drawRect(0,0,256,256);
         return _loc1_;
      }
      
      public function setHairColour(param1:int) : void
      {
         this.hairColour = param1;
         if(hairMaterial is PhongColorMaterial)
         {
            PhongColorMaterial(hairMaterial).color = hairColour;
         }
         else if(hairMaterial is ColorMaterial)
         {
            ColorMaterial(hairMaterial).color = hairColour;
         }
      }
      
      public function setLight(param1:Object3D) : void
      {
      }
      
      public function constructTextureBitmapData() : BitmapData
      {
         var _loc5_:Object = null;
         var _loc1_:Sprite = getBase();
         var _loc2_:Array = sortItemsByPriority(this.avatarItems);
         var _loc3_:Number = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc3_].itemConfig;
            if((Boolean(_loc5_)) && _loc5_.texture != null)
            {
               _loc1_.addChild(Engine.getMovieClip(_loc5_.texture));
            }
            _loc3_++;
         }
         var _loc4_:BitmapData = new BitmapData(256,256);
         _loc4_.draw(_loc1_);
         return _loc4_;
      }
      
      public function updateTextureMaterial() : void
      {
         model.materialLibrary.getMaterial("texture").material = getTextureMaterial();
      }
      
      private function hideGroup(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Number = 0;
         while(_loc2_ < avatarItems.length)
         {
            _loc3_ = avatarItems[_loc2_].itemConfig;
            if(_loc3_.group.name == param1)
            {
               hideObjectsForItem(_loc3_);
            }
            _loc2_++;
         }
      }
      
      private function getObjectNamesForItem(param1:Object) : Array
      {
         if(param1.object)
         {
            return param1.object.toLowerCase().split(/\s*,\s*/);
         }
         return null;
      }
      
      private function isItemGroupHidden(param1:String) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         var _loc2_:Number = 0;
         while(_loc2_ < hideGroupItemConfigs.length)
         {
            _loc3_ = getGroupsToHide(hideGroupItemConfigs[_loc2_]);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_] == param1)
               {
                  return true;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function tickAnimation(param1:uint) : void
      {
         if(curAnimation != -1)
         {
            timeMillisToNextFrame -= param1;
            if(timeMillisToNextFrame <= 0)
            {
               if(isLastFrame())
               {
                  if(loopCount > 0)
                  {
                     --loopCount;
                  }
                  if(loopCount == 0)
                  {
                     popAnimationQueue();
                  }
                  else
                  {
                     nextFrame();
                  }
               }
               else
               {
                  nextFrame();
               }
               timeMillisToNextFrame = curAnimationFrameDelay + timeMillisToNextFrame;
            }
         }
      }
      
      private function isoCacheCallback(param1:Object) : Boolean
      {
         if(destroyed)
         {
            return false;
         }
         var _loc2_:int = int(animationTypes[cachingAnimation]);
         if(cachedIsoShapes[_loc2_] == null)
         {
            cachedIsoShapes[_loc2_] = new Array();
         }
         if(cachedIsoShapes[_loc2_][cachingDirection] == null)
         {
            cachedIsoShapes[_loc2_][cachingDirection] = new Array();
         }
         cachedIsoShapes[_loc2_][cachingDirection].push(param1);
         var _loc3_:int = getFrameIndex();
         if(_loc3_ >= ANIMATION_FRAME_RANGE[_loc2_ * 2 + 1])
         {
            ++cachingDirectionIndex;
            cachingDirection = ANIMATION_CACHE_DIRECTIONS[_loc2_][cachingDirectionIndex];
            if(cachingDirectionIndex >= ANIMATION_CACHE_DIRECTIONS[_loc2_].length || cachingDirection >= CACHE_DIRECTIONS - 3)
            {
               ++cachingAnimation;
               if(cachingAnimation >= animationTypes.length)
               {
                  isoCacher.destroy();
                  isoCacher = null;
                  dispatchEvent(new Event("cache_complete"));
                  return false;
               }
               _loc2_ = int(animationTypes[cachingAnimation]);
               cachingDirectionIndex = 0;
               cachingDirection = ANIMATION_CACHE_DIRECTIONS[_loc2_][cachingDirectionIndex];
               playAnimation(_loc2_);
               isoCacher.setRotation(ANGLE_PER_DIRECTION * cachingDirection);
            }
            else
            {
               setFrame(ANIMATION_FRAME_RANGE[_loc2_ * 2]);
               isoCacher.setRotation(ANGLE_PER_DIRECTION * cachingDirection);
            }
         }
         else
         {
            setFrame(_loc3_ + 1);
         }
         return true;
      }
      
      public function queueAnimation(param1:int, param2:int = -1) : void
      {
         animationQueue.push(param1);
         animationLoopCountQueue.push(param2);
      }
      
      private function isLastFrame() : Boolean
      {
         return getFrameIndex() >= ANIMATION_FRAME_RANGE[curAnimation * 2 + 1];
      }
      
      public function hideChild(param1:String) : void
      {
         var _loc2_:Object3D = model.getChildByName(param1 + "-node");
         if(_loc2_ != null)
         {
            _loc2_.visible = false;
         }
      }
      
      private function isCustomisableChildObject(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         var _loc2_:Number = 0;
         while(_loc2_ < CUSTOMISABLE_OBJECT_PREFIX.length)
         {
            if(param1.indexOf(CUSTOMISABLE_OBJECT_PREFIX[_loc2_].toLowerCase()) == 0)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function sortItemsByPriority(param1:Array) : Array
      {
         var _loc4_:AvatarItem = null;
         var _loc5_:Number = NaN;
         var _loc6_:AvatarItem = null;
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc6_ = _loc2_[_loc5_];
               if(_loc4_.priority <= _loc6_.priority)
               {
                  _loc2_.splice(_loc5_,0,_loc4_);
                  break;
               }
               _loc5_++;
            }
            if(_loc5_ == _loc2_.length)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}


package away3d.core.utils
{
   import away3d.arcane;
   import away3d.core.base.*;
   import away3d.core.math.*;
   import away3d.materials.*;
   import away3d.primitives.data.*;
   import flash.display.BitmapData;
   
   use namespace arcane;
   
   public class Init
   {
      
      private static var inits:Array = [];
      
      arcane var _initData:Object;
      
      public function Init(param1:Object)
      {
         super();
         this._initData = param1;
      }
      
      arcane static function checkUnusedArguments() : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(inits.length == 0)
         {
            return;
         }
         var _loc1_:Array = inits;
         inits = [];
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.hasOwnProperty("dontCheckUnused"))
            {
               if(_loc2_["dontCheckUnused"])
               {
                  continue;
               }
            }
            _loc3_ = null;
            for(_loc4_ in _loc2_)
            {
               if(_loc4_ != "dontCheckUnused")
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = "";
                  }
                  else
                  {
                     _loc3_ += ", ";
                  }
                  _loc3_ += _loc4_ + ":" + _loc2_[_loc4_];
               }
            }
            if(_loc3_ != null)
            {
               Debug.warning("Unused arguments: {" + _loc3_ + "}");
            }
         }
      }
      
      public static function parse(param1:Object) : Init
      {
         if(param1 == null)
         {
            return new Init(null);
         }
         if(param1 is Init)
         {
            return param1 as Init;
         }
         inits.push(param1);
         return new Init(param1);
      }
      
      public function getCubeMaterials(param1:String) : CubeMaterialsData
      {
         var _loc2_:CubeMaterialsData = null;
         if(_initData == null)
         {
            return null;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return null;
         }
         if(_initData[param1] is CubeMaterialsData)
         {
            _loc2_ = _initData[param1] as CubeMaterialsData;
         }
         else if(_initData[param1] is Object)
         {
            _loc2_ = new CubeMaterialsData(_initData[param1]);
         }
         delete _initData[param1];
         return _loc2_;
      }
      
      public function getArray(param1:String) : Array
      {
         if(_initData == null)
         {
            return [];
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return [];
         }
         var _loc2_:Array = _initData[param1];
         delete _initData[param1];
         return _loc2_;
      }
      
      public function getSegmentMaterial(param1:String) : ISegmentMaterial
      {
         if(_initData == null)
         {
            return null;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return null;
         }
         var _loc2_:ISegmentMaterial = Cast.wirematerial(_initData[param1]);
         delete _initData[param1];
         return _loc2_;
      }
      
      public function getBitmap(param1:String) : BitmapData
      {
         if(_initData == null)
         {
            return null;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return null;
         }
         var _loc2_:BitmapData = Cast.bitmap(_initData[param1]);
         delete _initData[param1];
         return _loc2_;
      }
      
      public function getObject3D(param1:String) : Object3D
      {
         return getObject(param1,Object3D) as Object3D;
      }
      
      public function getString(param1:String, param2:String) : String
      {
         if(_initData == null)
         {
            return param2;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return param2;
         }
         var _loc3_:String = _initData[param1];
         delete _initData[param1];
         return _loc3_;
      }
      
      public function getObjectOrInit(param1:String, param2:Class = null) : Object
      {
         if(_initData == null)
         {
            return null;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return null;
         }
         var _loc3_:Object = _initData[param1];
         delete _initData[param1];
         if(_loc3_ == null)
         {
            return null;
         }
         if(param2 != null)
         {
            if(!(_loc3_ is param2))
            {
               return new param2(_loc3_);
            }
         }
         return _loc3_;
      }
      
      public function getInit(param1:String) : Init
      {
         if(_initData == null)
         {
            return new Init(null);
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return new Init(null);
         }
         var _loc2_:Init = Init.parse(_initData[param1]);
         delete _initData[param1];
         return _loc2_;
      }
      
      public function getNumber(param1:String, param2:Number, param3:Object = null) : Number
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(_initData == null)
         {
            return param2;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return param2;
         }
         var _loc4_:Number = Number(_initData[param1]);
         if(param3 != null)
         {
            if(param3.hasOwnProperty("min"))
            {
               _loc5_ = Number(param3["min"]);
               if(_loc4_ < _loc5_)
               {
                  _loc4_ = _loc5_;
               }
            }
            if(param3.hasOwnProperty("max"))
            {
               _loc6_ = Number(param3["max"]);
               if(_loc4_ > _loc6_)
               {
                  _loc4_ = _loc6_;
               }
            }
         }
         delete _initData[param1];
         return _loc4_;
      }
      
      arcane function addForCheck() : void
      {
         if(_initData == null)
         {
            return;
         }
         _initData["dontCheckUnused"] = false;
         inits.push(_initData);
      }
      
      public function getBoolean(param1:String, param2:Boolean) : Boolean
      {
         if(_initData == null)
         {
            return param2;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return param2;
         }
         var _loc3_:Boolean = Boolean(_initData[param1]);
         delete _initData[param1];
         return _loc3_;
      }
      
      public function getColor(param1:String, param2:uint) : uint
      {
         if(_initData == null)
         {
            return param2;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return param2;
         }
         var _loc3_:uint = Cast.color(_initData[param1]);
         delete _initData[param1];
         return _loc3_;
      }
      
      public function getObject(param1:String, param2:Class = null) : Object
      {
         if(_initData == null)
         {
            return null;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return null;
         }
         var _loc3_:Object = _initData[param1];
         delete _initData[param1];
         if(_loc3_ == null)
         {
            return null;
         }
         if(param2 != null)
         {
            if(!(_loc3_ is param2))
            {
               throw new CastError("Parameter \"" + param1 + "\" is not of class " + param2 + ": " + _loc3_);
            }
         }
         return _loc3_;
      }
      
      public function getNumber3D(param1:String) : Number3D
      {
         return getObject(param1,Number3D) as Number3D;
      }
      
      public function getInt(param1:String, param2:int, param3:Object = null) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(_initData == null)
         {
            return param2;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return param2;
         }
         var _loc4_:int = int(_initData[param1]);
         if(param3 != null)
         {
            if(param3.hasOwnProperty("min"))
            {
               _loc5_ = int(param3["min"]);
               if(_loc4_ < _loc5_)
               {
                  _loc4_ = _loc5_;
               }
            }
            if(param3.hasOwnProperty("max"))
            {
               _loc6_ = int(param3["max"]);
               if(_loc4_ > _loc6_)
               {
                  _loc4_ = _loc6_;
               }
            }
         }
         delete _initData[param1];
         return _loc4_;
      }
      
      arcane function removeFromCheck() : void
      {
         if(_initData == null)
         {
            return;
         }
         _initData["dontCheckUnused"] = true;
      }
      
      public function getMaterial(param1:String) : IMaterial
      {
         if(_initData == null)
         {
            return null;
         }
         if(!_initData.hasOwnProperty(param1))
         {
            return null;
         }
         var _loc2_:IMaterial = Cast.material(_initData[param1]);
         delete _initData[param1];
         return _loc2_;
      }
      
      public function getPosition(param1:String) : Number3D
      {
         var _loc3_:Object3D = null;
         var _loc2_:Object = getObject(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         if(_loc2_ is Number3D)
         {
            return _loc2_ as Number3D;
         }
         if(_loc2_ is Object3D)
         {
            _loc3_ = _loc2_ as Object3D;
            return _loc3_.scene ? _loc3_.scenePosition : _loc3_.position;
         }
         if(_loc2_ is String)
         {
            if(_loc2_ == "center")
            {
               return new Number3D();
            }
         }
         throw new CastError("Cast get position of " + _loc2_);
      }
   }
}



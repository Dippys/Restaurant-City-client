package away3d.animators.skin
{
   import away3d.containers.*;
   import away3d.core.base.*;
   
   public class Channel
   {
      
      private var _length:int;
      
      public var times:Array;
      
      public var name:String;
      
      public var param:Array;
      
      private var _oldlength:int;
      
      public var interpolations:Array;
      
      public var target:Object3D;
      
      private var _index:int;
      
      public var outTangent:Array;
      
      public var inTangent:Array;
      
      private var i:int;
      
      public var type:Array;
      
      public function Channel(param1:String)
      {
         super();
         this.name = param1;
         type = [];
         param = [];
         inTangent = [];
         outTangent = [];
         times = [];
         interpolations = [];
      }
      
      public function update(param1:Number, param2:Boolean = true) : void
      {
         if(!target)
         {
            return;
         }
         i = type.length;
         if(param1 < times[0])
         {
            while(i--)
            {
               target[type[i]] = param[0][i];
            }
         }
         else if(param1 > times[int(times.length - 1)])
         {
            while(i--)
            {
               target[type[i]] = param[int(times.length - 1)][i];
            }
         }
         else
         {
            _index = _length = _oldlength = times.length - 1;
            while(_length > 1)
            {
               _oldlength = _length;
               _length >>= 1;
               if(times[_index - _length] > param1)
               {
                  _index -= _length;
                  _length = _oldlength - _length;
               }
            }
            --_index;
            while(i--)
            {
               if(type[i] == "transform")
               {
                  target.transform = param[_index][i];
               }
               else if(type[i] == "visibility")
               {
                  target.visible = param[_index][i] > 0;
               }
               else if(param2)
               {
                  target[type[i]] = ((param1 - times[_index]) * param[int(_index + 1)][i] + (times[int(_index + 1)] - param1) * param[_index][i]) / (times[int(_index + 1)] - times[_index]);
               }
               else
               {
                  target[type[i]] = param[_index][i];
               }
            }
         }
      }
      
      public function clone(param1:ObjectContainer3D) : Channel
      {
         var _loc2_:Channel = new Channel(name);
         _loc2_.target = param1.getChildByName(name);
         _loc2_.type = type.concat();
         _loc2_.param = param.concat();
         _loc2_.inTangent = inTangent.concat();
         _loc2_.outTangent = outTangent.concat();
         _loc2_.times = times.concat();
         _loc2_.interpolations = interpolations.concat();
         return _loc2_;
      }
   }
}


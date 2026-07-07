package away3d.core.base
{
   import away3d.events.*;
   import flash.events.EventDispatcher;
   import flash.utils.*;
   
   public class Animation extends EventDispatcher implements IAnimation
   {
      
      public var sequence:Array = [];
      
      public var delay:Number = 0;
      
      public var cycleEvent:Boolean = false;
      
      public var sequenceEvent:Boolean = false;
      
      public var loop:Boolean = false;
      
      private var _latest:uint = 0;
      
      private var _cycle:AnimationEvent;
      
      private var _sequenceupdate:AnimationEvent;
      
      public var frame:Number = 0;
      
      public var smooth:Boolean = false;
      
      public var fps:Number = 24;
      
      private var _time:uint;
      
      private var _transition:AnimationTransition;
      
      private var _isRunning:Boolean = false;
      
      public var geometry:Geometry;
      
      public var mesh:Mesh;
      
      public function Animation(param1:Geometry)
      {
         super();
         geometry = param1;
         _cycle = new AnimationEvent(AnimationEvent.CYCLE,this);
         _sequenceupdate = new AnimationEvent(AnimationEvent.SEQUENCE_UPDATE,this);
      }
      
      public function get latest() : uint
      {
         return _latest;
      }
      
      public function update() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!_isRunning && !sequenceEvent)
         {
            return;
         }
         var _loc1_:uint = uint(getTimer());
         frame += (_loc1_ - _time) * fps / 1000;
         _time = _loc1_;
         var _loc2_:int = int(sequence.length);
         var _loc3_:int = _loc2_ - 1 + delay;
         if(_loc2_ == 1)
         {
            if(cycleEvent)
            {
               dispatchEvent(_cycle);
            }
            if(sequenceEvent)
            {
               dispatchEvent(_sequenceupdate);
            }
            if(!loop)
            {
               _isRunning = false;
            }
            _latest = 0;
            frame = 0;
         }
         else if(loop && !sequenceEvent)
         {
            while(frame > _loc3_)
            {
               frame -= _loc3_;
            }
         }
         else if(frame > _loc3_)
         {
            frame = _loc3_;
            if(cycleEvent)
            {
               dispatchEvent(_cycle);
            }
            if(sequenceEvent)
            {
               dispatchEvent(_sequenceupdate);
            }
            if(!loop)
            {
               _isRunning = false;
            }
         }
         var _loc4_:Number = frame;
         if(!smooth)
         {
            _loc4_ = Math.round(_loc4_);
         }
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         if(_loc4_ > _loc2_ - 1)
         {
            _loc4_ = _loc2_ - 1;
         }
         if(_loc4_ == Math.round(_loc4_))
         {
            geometry.frames[sequence[int(_loc4_)].frame].adjust(1);
         }
         else
         {
            _loc5_ = Math.floor(_loc4_);
            _loc6_ = Math.ceil(_loc4_);
            geometry.frames[sequence[int(_loc5_)].frame].adjust(1);
            geometry.frames[sequence[int(_loc6_)].frame].adjust(_loc4_ - _loc5_);
            if(loop || sequenceEvent)
            {
               if(_latest == 0 || _latest + 1 == sequence[int(_loc5_)].frame || _latest == sequence[int(_loc5_)].frame)
               {
                  _latest = sequence[int(_loc5_)].frame;
               }
               else
               {
                  _latest = 0;
                  if(cycleEvent)
                  {
                     dispatchEvent(_cycle);
                  }
                  if(sequenceEvent)
                  {
                     dispatchEvent(_sequenceupdate);
                  }
               }
            }
            else if(cycleEvent || sequenceEvent || _loc2_ == 2)
            {
               if(cycleEvent)
               {
                  dispatchEvent(_cycle);
               }
               if(sequenceEvent)
               {
                  dispatchEvent(_sequenceupdate);
               }
            }
         }
         if(smooth)
         {
            if(_transition.interpolate < 1)
            {
               _transition.update();
            }
         }
      }
      
      public function interpolate() : void
      {
         var _loc1_:Boolean = _transition == null;
         if(_loc1_)
         {
            createTransition();
         }
         else
         {
            _transition.reset();
         }
      }
      
      public function stop() : void
      {
         _isRunning = false;
         _latest = 0;
      }
      
      public function start() : void
      {
         _time = getTimer();
         _isRunning = true;
         _latest = 0;
         frame = 0;
      }
      
      public function get transitionValue() : Number
      {
         return _transition == null ? 10 : _transition.transitionValue;
      }
      
      public function createTransition() : void
      {
         if(_transition == null)
         {
            _transition = new AnimationTransition(geometry);
         }
      }
      
      public function get isRunning() : Boolean
      {
         return _isRunning;
      }
      
      public function set transitionValue(param1:Number) : void
      {
         createTransition();
         _transition.transitionValue = param1;
      }
   }
}


package away3d.core.block
{
   import away3d.core.draw.*;
   import away3d.core.geom.*;
   import away3d.core.render.*;
   import away3d.core.utils.*;
   import flash.display.Graphics;
   import flash.utils.*;
   
   public class ConvexBlocker extends Blocker
   {
      
      private var _boundlines:Array;
      
      public var vertices:Array;
      
      public function ConvexBlocker()
      {
         super();
      }
      
      override public function calc() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         _boundlines = [];
         screenZ = 0;
         maxX = -Infinity;
         maxY = -Infinity;
         minX = Infinity;
         minY = Infinity;
         var _loc1_:int = vertices.length / 3;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = Number(vertices[_loc2_]);
            _loc4_ = Number(vertices[_loc2_ + 1]);
            _loc5_ = Number(vertices[_loc2_ + 2]);
            _loc6_ = (_loc2_ + 3) % _loc1_;
            _boundlines.push(Line2D.from2points(_loc3_,_loc4_,vertices[_loc6_],vertices[_loc6_ + 1]));
            if(screenZ < _loc5_)
            {
               screenZ = _loc5_;
            }
            if(minX > _loc3_)
            {
               minX = _loc3_;
            }
            if(maxX < _loc3_)
            {
               maxX = _loc3_;
            }
            if(minY > _loc4_)
            {
               minY = _loc4_;
            }
            if(maxY < _loc4_)
            {
               maxY = _loc4_;
            }
            _loc2_++;
         }
         maxZ = screenZ;
         minZ = screenZ;
      }
      
      override public function render() : void
      {
         var _loc6_:Line2D = null;
         var _loc7_:Line2D = null;
         var _loc8_:Line2D = null;
         var _loc9_:ScreenVertex = null;
         var _loc10_:ScreenVertex = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc1_:Graphics = source.session.graphics;
         _loc1_.lineStyle(2,Color.fromHSV(0,0,(Math.sin(getTimer() / 1000) + 1) / 2));
         var _loc2_:int = int(_boundlines.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = _boundlines[_loc3_];
            _loc7_ = _boundlines[(_loc3_ - 1 + _loc2_) % _loc2_];
            _loc8_ = _boundlines[(_loc3_ + 1 + _loc2_) % _loc2_];
            _loc9_ = Line2D.cross(_loc7_,_loc6_);
            _loc10_ = Line2D.cross(_loc6_,_loc8_);
            _loc1_.moveTo(_loc9_.x,_loc9_.y);
            _loc1_.lineTo(_loc10_.x,_loc10_.y);
            _loc1_.moveTo(_loc9_.x,_loc9_.y);
            _loc3_++;
         }
         var _loc4_:int = (maxX - minX) * (maxY - minY) / 2000;
         if(_loc4_ > 50)
         {
            _loc4_ = 50;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc11_ = minX + (maxX - minX) * Math.random();
            _loc12_ = minY + (maxY - minY) * Math.random();
            if(contains(_loc11_,_loc12_))
            {
               _loc1_.lineStyle(1,Color.fromHSV(0,0,Math.random()));
               _loc1_.drawCircle(_loc11_,_loc12_,3);
            }
            _loc5_++;
         }
      }
      
      override public function block(param1:DrawPrimitive) : Boolean
      {
         var _loc2_:DrawTriangle = null;
         if(param1 is DrawTriangle)
         {
            _loc2_ = param1 as DrawTriangle;
            return contains(_loc2_.v0x,_loc2_.v0y) && contains(_loc2_.v1x,_loc2_.v1y) && contains(_loc2_.v2x,_loc2_.v2y);
         }
         return contains(param1.minX,param1.minY) && contains(param1.minX,param1.maxY) && contains(param1.maxX,param1.maxY) && contains(param1.maxX,param1.minY);
      }
      
      override public function contains(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Line2D = null;
         for each(_loc3_ in _boundlines)
         {
            if(_loc3_.side(param1,param2) < 0)
            {
               return false;
            }
         }
         return true;
      }
   }
}


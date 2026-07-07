package away3d.core.draw
{
   import away3d.core.base.*;
   
   public final class PrimitiveQuadrantTreeNode
   {
      
      public var parent:PrimitiveQuadrantTreeNode;
      
      public var create:Function;
      
      private var level:int;
      
      public var righttopFlag:Boolean;
      
      public var rightbottom:PrimitiveQuadrantTreeNode;
      
      public var righttop:PrimitiveQuadrantTreeNode;
      
      public var rightbottomFlag:Boolean;
      
      public var onlysource:Object3D;
      
      public var xdiv:Number;
      
      private var halfheight:Number;
      
      public var center:Array = new Array();
      
      private var maxlevel:int = 4;
      
      private var render_center_length:int = -1;
      
      public var onlysourceFlag:Boolean = true;
      
      private var render_center_index:int = -1;
      
      private var halfwidth:Number;
      
      public var lefttop:PrimitiveQuadrantTreeNode;
      
      public var ydiv:Number;
      
      public var leftbottom:PrimitiveQuadrantTreeNode;
      
      public var lefttopFlag:Boolean;
      
      public var leftbottomFlag:Boolean;
      
      public function PrimitiveQuadrantTreeNode(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:PrimitiveQuadrantTreeNode = null)
      {
         super();
         this.level = param5;
         this.xdiv = param1;
         this.ydiv = param2;
         halfwidth = param3 / 2;
         halfheight = param4 / 2;
         this.parent = param6;
      }
      
      public function reset(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.xdiv = param1;
         this.ydiv = param2;
         halfwidth = param3 / 2;
         halfheight = param4 / 2;
         lefttopFlag = false;
         leftbottomFlag = false;
         righttopFlag = false;
         rightbottomFlag = false;
         center.length = 0;
         onlysourceFlag = true;
         onlysource = null;
         render_center_length = -1;
         render_center_index = -1;
      }
      
      public function push(param1:DrawPrimitive) : void
      {
         if(onlysourceFlag)
         {
            if(onlysource != null && onlysource != param1.source)
            {
               onlysourceFlag = false;
            }
            onlysource = param1.source;
         }
         if(level < maxlevel)
         {
            if(param1.maxX <= xdiv)
            {
               if(param1.maxY <= ydiv)
               {
                  if(lefttop == null)
                  {
                     lefttopFlag = true;
                     lefttop = new PrimitiveQuadrantTreeNode(xdiv - halfwidth / 2,ydiv - halfheight / 2,halfwidth,halfheight,level + 1,this);
                  }
                  else if(!lefttopFlag)
                  {
                     lefttopFlag = true;
                     lefttop.reset(xdiv - halfwidth / 2,ydiv - halfheight / 2,halfwidth,halfheight);
                  }
                  lefttop.push(param1);
                  return;
               }
               if(param1.minY >= ydiv)
               {
                  if(leftbottom == null)
                  {
                     leftbottomFlag = true;
                     leftbottom = new PrimitiveQuadrantTreeNode(xdiv - halfwidth / 2,ydiv + halfheight / 2,halfwidth,halfheight,level + 1,this);
                  }
                  else if(!leftbottomFlag)
                  {
                     leftbottomFlag = true;
                     leftbottom.reset(xdiv - halfwidth / 2,ydiv + halfheight / 2,halfwidth,halfheight);
                  }
                  leftbottom.push(param1);
                  return;
               }
            }
            else if(param1.minX >= xdiv)
            {
               if(param1.maxY <= ydiv)
               {
                  if(righttop == null)
                  {
                     righttopFlag = true;
                     righttop = new PrimitiveQuadrantTreeNode(xdiv + halfwidth / 2,ydiv - halfheight / 2,halfwidth,halfheight,level + 1,this);
                  }
                  else if(!righttopFlag)
                  {
                     righttopFlag = true;
                     righttop.reset(xdiv + halfwidth / 2,ydiv - halfheight / 2,halfwidth,halfheight);
                  }
                  righttop.push(param1);
                  return;
               }
               if(param1.minY >= ydiv)
               {
                  if(rightbottom == null)
                  {
                     rightbottomFlag = true;
                     rightbottom = new PrimitiveQuadrantTreeNode(xdiv + halfwidth / 2,ydiv + halfheight / 2,halfwidth,halfheight,level + 1,this);
                  }
                  else if(!rightbottomFlag)
                  {
                     rightbottomFlag = true;
                     rightbottom.reset(xdiv + halfwidth / 2,ydiv + halfheight / 2,halfwidth,halfheight);
                  }
                  rightbottom.push(param1);
                  return;
               }
            }
         }
         center.push(param1);
         param1.quadrant = this;
      }
      
      public function render(param1:Number) : void
      {
         var _loc2_:DrawPrimitive = null;
         if(render_center_length == -1)
         {
            render_center_length = center.length;
            if(render_center_length)
            {
               if(render_center_length > 1)
               {
                  center.sortOn("screenZ",Array.DESCENDING | Array.NUMERIC);
               }
            }
            render_center_index = 0;
         }
         while(render_center_index < render_center_length)
         {
            _loc2_ = center[render_center_index];
            if(_loc2_.screenZ < param1)
            {
               break;
            }
            render_other(_loc2_.screenZ);
            _loc2_.render();
            ++render_center_index;
         }
         render_other(param1);
      }
      
      private function render_other(param1:Number) : void
      {
         if(lefttopFlag)
         {
            lefttop.render(param1);
         }
         if(leftbottomFlag)
         {
            leftbottom.render(param1);
         }
         if(righttopFlag)
         {
            righttop.render(param1);
         }
         if(rightbottomFlag)
         {
            rightbottom.render(param1);
         }
      }
   }
}


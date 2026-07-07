package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WorldPopUp extends BaseWorld
   {
      
      public static var activePopUp:Array = new Array();
      
      private static var popUpQueue:Array = new Array();
      
      private var startFrame:int;
      
      private var popUpContent:MovieClip;
      
      private var alphaLayer:BaseObject;
      
      public function WorldPopUp(param1:MovieClip, param2:MovieClip, param3:MovieClip, param4:Boolean = true)
      {
         super();
         if(param4)
         {
            alphaLayer = new BaseObject();
         }
         this.popUpContent = param1;
         if(popUpContent != null)
         {
            startFrame = popUpContent.currentFrame;
            addChild(popUpContent);
         }
         if(param2)
         {
            setButtonMode(param2,true);
            param2.addEventListener(MouseEvent.CLICK,onOkClick,false,0,true);
         }
         if(param3)
         {
            setButtonMode(param3,true);
            param3.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         }
         x = GameWorld.CANVAS_CENTER_X;
         y = GameWorld.CANVAS_CENTER_Y;
      }
      
      public static function getTopActivePopUp() : WorldPopUp
      {
         if(activePopUp.length == 0)
         {
            return null;
         }
         return activePopUp[activePopUp.length - 1];
      }
      
      public function getPopupContent() : MovieClip
      {
         return popUpContent;
      }
      
      public function remove() : void
      {
         if(alphaLayer)
         {
            Engine.worldContainer.removeObject(alphaLayer);
         }
         Engine.worldContainer.removeObject(this);
         activePopUp.splice(activePopUp.indexOf(this),1);
         if(activePopUp.length == 0 && popUpQueue.length > 0)
         {
            popUpQueue[0].show();
            popUpQueue.splice(0,1);
         }
      }
      
      public function isShown() : Boolean
      {
         return activePopUp.indexOf(this) != -1;
      }
      
      public function queueToShow() : void
      {
         if(activePopUp.length > 0)
         {
            popUpQueue.push(this);
         }
         else
         {
            show();
         }
      }
      
      private function onOkClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onFullScreen(param1:Event) : void
      {
         if(alphaLayer)
         {
            alphaLayer.graphics.clear();
            alphaLayer.graphics.beginFill(0,0.3);
            alphaLayer.graphics.drawRect(Engine.getStageX(),Engine.getStageY(),Engine.getStageWidth(),Engine.getStageHeight());
            alphaLayer.graphics.endFill();
         }
      }
      
      public function show() : void
      {
         if(activePopUp.indexOf(this) == -1)
         {
            if(alphaLayer)
            {
               alphaLayer.drawPriority = this.drawPriority;
               Engine.worldContainer.addObject(alphaLayer);
            }
            Engine.worldContainer.addObject(this);
            if(popUpContent != null)
            {
               popUpContent.gotoAndPlay(startFrame);
            }
            activePopUp.push(this);
            Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,0,true);
            onFullScreen(null);
         }
      }
   }
}


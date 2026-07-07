package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldRetryPopUp extends WorldPopUp
   {
      
      private var retryCancelCallBack:Function;
      
      private var retryCallBack:Function;
      
      public function WorldRetryPopUp(param1:String, param2:Function = null, param3:Function = null, param4:Boolean = false)
      {
         super(null,null,null);
         this.retryCallBack = param2;
         this.retryCancelCallBack = param3;
         var _loc5_:MovieClip = Engine.getMovieClip("RetryPopupAnim");
         addChild(_loc5_);
         var _loc6_:MovieClip = _loc5_.mc_content;
         GameWorld.textHandler.setTextField(_loc6_.tf_text,param1);
         setButtonMode(_loc6_.mc_tick,true);
         _loc6_.mc_tick.addEventListener(MouseEvent.CLICK,onRetryClick,false,0,true);
         if(!param4)
         {
            setButtonMode(_loc6_.mc_cancel,true);
            _loc6_.mc_cancel.addEventListener(MouseEvent.CLICK,onRetryCancelClick,false,0,true);
         }
         else
         {
            _loc6_.mc_cancel.stop();
            _loc6_.mc_cancel.visible = false;
         }
      }
      
      private function onRetryCancelClick(param1:MouseEvent) : void
      {
         remove();
         if(retryCancelCallBack != null)
         {
            retryCancelCallBack();
         }
      }
      
      private function onRetryClick(param1:MouseEvent) : void
      {
         remove();
         if(retryCallBack != null)
         {
            retryCallBack();
         }
      }
   }
}


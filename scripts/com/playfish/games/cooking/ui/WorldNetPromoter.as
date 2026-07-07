package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class WorldNetPromoter extends WorldPopUp
   {
      
      private static const COMMENT_LENGTH:int = 500;
      
      private var curIndex:int = -1;
      
      public var sceneContent:MovieClip;
      
      private var tickBoxes:Array;
      
      private var textField:TextField;
      
      public function WorldNetPromoter()
      {
         var _loc3_:MovieClip = null;
         tickBoxes = new Array();
         super(null,null,null);
         var _loc1_:MovieClip = Engine.getMovieClip("NetPromoterRatingAnim");
         addChild(_loc1_);
         sceneContent = _loc1_.mc_content;
         textField = sceneContent.tf_text;
         textField.text = "";
         textField.maxChars = COMMENT_LENGTH;
         Engine.setFocus(textField);
         var _loc2_:int = 0;
         while(_loc2_ < 11)
         {
            _loc3_ = sceneContent["mc_box" + _loc2_];
            setButtonMode(_loc3_,true);
            _loc3_.index = _loc2_;
            _loc3_.tf_number.text = _loc2_;
            _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,onTickBoxMouseDown,false,0,true);
            tickBoxes.push(_loc3_);
            _loc2_++;
         }
         setButtonMode(sceneContent.mc_cancel,true);
         sceneContent.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         setButtonMode(sceneContent.mc_tick,false);
         sceneContent.mc_tick.gotoAndStop("grey");
         sceneContent.mc_tick.toolTip = new ToolTip(sceneContent.mc_tick,GameWorld.textHandler.getTextFromId("ToolTipSelectARating"));
      }
      
      private function onTickBoxMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         if(curIndex == -1)
         {
            setButtonMode(sceneContent.mc_tick,true);
            sceneContent.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
            if(sceneContent.mc_tick.toolTip)
            {
               sceneContent.mc_tick.toolTip.destroy();
               sceneContent.mc_tick.toolTip = null;
            }
         }
         if(_loc2_.index != curIndex)
         {
            if(curIndex != -1)
            {
               setButtonMode(tickBoxes[curIndex],true);
               tickBoxes[curIndex].addEventListener(MouseEvent.MOUSE_DOWN,onTickBoxMouseDown,false,0,true);
            }
            setButtonMode(_loc2_,false);
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,onTickBoxMouseDown);
            _loc2_.gotoAndStop("selected");
            curIndex = _loc2_.index;
         }
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         Debug.out("netpromoter request " + "answer=" + curIndex + " comment=" + textField.text);
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_SURVEY_DONE,"answer=" + curIndex + " comment=" + textField.text,function():void
         {
         },function():void
         {
         });
         remove();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
   }
}


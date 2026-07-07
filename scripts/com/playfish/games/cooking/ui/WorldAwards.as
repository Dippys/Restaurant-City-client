package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class WorldAwards extends WorldPopUp
   {
      
      private static const NUM_PANELS_PER_PAGE:int = 6;
      
      private var awards:Array;
      
      private var curPanelIndex:int = 0;
      
      private var panels:Array;
      
      public function WorldAwards(param1:GameAwards)
      {
         super(null,null,null);
         this.awards = param1.getAllAwardObjects();
         var _loc2_:MovieClip = Engine.getMovieClip("AwardUiAnim");
         addChild(_loc2_);
         var _loc3_:MovieClip = _loc2_.mc_content;
         GameWorld.textHandler.setTextField(_loc3_.tf_title,GameWorld.textHandler.getTextFromId("Awards") + " " + param1.getOwnedAwardCount() + "/" + param1.getTotalAwardCount());
         panels = new Array();
         var _loc4_:Number = 0;
         while(_loc4_ < NUM_PANELS_PER_PAGE)
         {
            panels[_loc4_] = _loc3_["mc_panel" + _loc4_];
            _loc4_++;
         }
         setPanelIndex(0,true);
         setButtonMode(_loc3_.mc_cancel,true);
         setButtonMode(_loc3_.mc_up,true);
         setButtonMode(_loc3_.mc_down,true);
         _loc3_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         _loc3_.mc_up.addEventListener(MouseEvent.CLICK,onUpClick,false,0,true);
         _loc3_.mc_down.addEventListener(MouseEvent.CLICK,onDownClick,false,0,true);
      }
      
      private function setPanelIndex(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(curPanelIndex != param1 || param2)
         {
            curPanelIndex = param1;
            _loc3_ = 0;
            while(_loc3_ < NUM_PANELS_PER_PAGE)
            {
               _loc4_ = _loc3_ + curPanelIndex;
               if(_loc4_ < awards.length)
               {
                  setAwardPanel(panels[_loc3_],awards[_loc4_]);
               }
               else
               {
                  panels[_loc3_].visible = false;
               }
               _loc3_++;
            }
         }
      }
      
      private function onDownClick(param1:MouseEvent) : void
      {
         setPanelIndex(Math.min(awards.length - NUM_PANELS_PER_PAGE,curPanelIndex + 1));
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function setAwardPanel(param1:MovieClip, param2:Object) : void
      {
         if(param1.icon != null)
         {
            param1.removeChild(param1.icon);
            param1.icon = null;
         }
         var _loc3_:Object = GameWorld.getItemConfig(param2.itemId);
         GameWorld.textHandler.setReplaceString("AwardTarget",param2.target);
         GameWorld.textHandler.setTextField(param1.tf_text,_loc3_.name + "\n" + GameWorld.textHandler.getTextFromId(param2.text),true);
         param1.tf_value.text = param2.value;
         if(param2.value >= param2.target)
         {
            param1.mc_icon.visible = false;
            param1.icon = ItemChooser.getItemMovieClip(_loc3_);
            param1.icon.x += param1.mc_icon.x;
            param1.icon.y += param1.mc_icon.y;
            param1.addChild(param1.icon);
         }
         else
         {
            param1.mc_icon.visible = true;
         }
      }
      
      private function onUpClick(param1:MouseEvent) : void
      {
         setPanelIndex(Math.max(0,curPanelIndex - 1));
      }
   }
}


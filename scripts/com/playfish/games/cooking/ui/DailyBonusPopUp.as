package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.IngredientItem;
   import com.playfish.games.cooking.MailItem;
   import com.playfish.games.cooking.debug.DebugDailyBonus;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class DailyBonusPopUp extends WorldPopUp
   {
      
      private var movieClipQueue:Array;
      
      private var currentIndex:int = 1;
      
      private var currentItem:int = 0;
      
      private var sceneContent:MovieClip;
      
      public function DailyBonusPopUp(param1:MailItem)
      {
         var _loc5_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:IngredientItem = null;
         var _loc13_:IngredientItem = null;
         var _loc14_:MovieClip = null;
         var _loc15_:MovieClip = null;
         var _loc16_:TextField = null;
         var _loc2_:MovieClip = Engine.getMovieClip("FreeBonusAnim2");
         var _loc3_:MovieClip = _loc2_.mc_content;
         var _loc4_:int = 0;
         if(DebugDailyBonus.daysLoggedInARow)
         {
            _loc4_ = DebugDailyBonus.daysLoggedInARow - 1;
         }
         else
         {
            _loc4_ = int(GameWorld.gameUser.userInfo.consecutionCount);
         }
         if(_loc4_)
         {
            _loc5_ = new String(_loc4_ + 1 + " days");
         }
         else
         {
            _loc5_ = new String(_loc4_ + 1 + " day");
         }
         GameWorld.textHandler.setReplaceString("consecutionCount",new String(_loc5_));
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_title,"BonusIngredientsTitle");
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_text,"BonusIngredientsText",true);
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_instruction,"BonusIngredientsInstruction");
         var _loc6_:Array = new Array();
         if(DebugDailyBonus.daysLoggedInARow)
         {
            _loc7_ = new Array();
            _loc11_ = 0;
            while(_loc11_ < Math.min(DebugDailyBonus.daysLoggedInARow,DebugDailyBonus.spoofedGlobalItemIds.length))
            {
               _loc7_.push(DebugDailyBonus.spoofedGlobalItemIds[_loc11_]);
               _loc11_++;
            }
         }
         else
         {
            _loc7_ = param1.mailObject.globalItemIds;
         }
         for each(_loc8_ in _loc7_)
         {
            if(_loc8_)
            {
               _loc12_ = new IngredientItem(GameWorld.getItemConfig(_loc8_));
               _loc6_.push(_loc12_);
            }
         }
         _loc9_ = 0;
         while(Boolean(_loc3_["mc_item" + _loc9_]) && Boolean(_loc3_["tf_name" + _loc9_]))
         {
            _loc3_["mc_item" + _loc9_].visible = false;
            _loc3_["tf_name" + _loc9_].visible = false;
            _loc9_++;
         }
         var _loc10_:int = 0;
         while(_loc10_ < _loc6_.length)
         {
            _loc13_ = _loc6_[_loc10_];
            _loc14_ = Engine.getMovieClip(_loc13_.itemConfig.className);
            _loc14_.stop();
            _loc15_ = _loc3_["mc_item" + _loc10_];
            _loc15_.stop();
            _loc16_ = _loc3_["tf_name" + _loc10_];
            _loc15_.visible = true;
            _loc16_.visible = true;
            _loc15_.mc_icon.removeChildAt(0);
            _loc15_.mc_icon.addChild(_loc14_);
            GameWorld.textHandler.setTextField(_loc16_,_loc13_.name);
            setButtonMode(_loc2_.mc_tick,true);
            _loc10_++;
         }
         super(null,_loc3_.mc_tick,null);
         addChild(_loc2_);
         sceneContent = _loc3_;
         movieClipQueue = new Array();
      }
      
      override public function show() : void
      {
         var _loc1_:MovieClip = null;
         if(activePopUp.indexOf(this) == -1)
         {
            _loc1_ = sceneContent.mc_item0;
            if(_loc1_)
            {
               _loc1_.gotoAndPlay(1);
               movieClipQueue.push(_loc1_);
            }
         }
         super.show();
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc5_:MovieClip = null;
         var _loc2_:MovieClip = sceneContent["mc_item" + currentIndex];
         var _loc3_:MovieClip = sceneContent["mc_item" + (currentIndex - 1)];
         var _loc4_:Array = new Array();
         if(_loc2_)
         {
            if(Boolean(_loc3_) && _loc3_.currentFrame >= _loc3_.totalFrames / 4)
            {
               Debug.out("Animating item" + currentIndex);
               _loc2_.gotoAndPlay(1);
               movieClipQueue.push(_loc2_);
               ++currentIndex;
            }
         }
         for each(_loc5_ in movieClipQueue)
         {
            if(_loc5_.currentFrame >= _loc5_.totalFrames)
            {
               _loc5_.stop();
               _loc4_.push(_loc5_);
            }
         }
      }
   }
}


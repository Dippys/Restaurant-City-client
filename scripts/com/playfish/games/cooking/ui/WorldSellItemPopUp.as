package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class WorldSellItemPopUp extends WorldPopUp
   {
      
      private var okCallBack:Function;
      
      private var countTextField:TextField;
      
      private var bodyTextField:TextField;
      
      private var count:int = 1;
      
      private var maxCount:int = 1;
      
      private var item:UserItem;
      
      public function WorldSellItemPopUp(param1:UserItem, param2:Function)
      {
         super(null,null,null);
         this.item = param1;
         this.okCallBack = param2;
         var _loc3_:MovieClip = Engine.getMovieClip("SellPopUpAnim");
         var _loc4_:MovieClip = _loc3_.mc_content;
         addChild(_loc3_);
         ItemChooser.setItemOnIconButton(param1.itemConfig,_loc4_.mc_item);
         _loc4_.mc_addCoins.stop();
         _loc4_.mc_addCoins.visible = false;
         setButtonMode(_loc4_.mc_tick,true);
         setButtonMode(_loc4_.mc_cancel,true);
         _loc4_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
         _loc4_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         setButtonMode(_loc4_.mc_count.mc_plus,true);
         setButtonMode(_loc4_.mc_count.mc_minus,true);
         _loc4_.mc_count.mc_plus.addEventListener(MouseEvent.CLICK,onPlusClick,false,0,true);
         _loc4_.mc_count.mc_minus.addEventListener(MouseEvent.CLICK,onMinusClick,false,0,true);
         countTextField = _loc4_.mc_count.tf_count;
         countTextField.text = count.toString();
         maxCount = Math.max(GameWorld.gameUser.getInventoryItemCount(param1.itemConfig),1);
         Debug.out("maxCount=" + maxCount);
         bodyTextField = _loc4_.tf_text;
         refreshText();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function refreshText() : void
      {
         GameWorld.textHandler.setReplaceString("ItemName",item.itemConfig.name);
         GameWorld.textHandler.setReplaceString("ItemSellPrice",(GameWorld.getItemSellPrice(item.itemConfig) * count).toString());
         GameWorld.textHandler.setTextFieldWithId(bodyTextField,"SellItem",true);
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         okCallBack(item,count);
         remove();
      }
      
      private function onPlusClick(param1:MouseEvent) : void
      {
         if(count == maxCount)
         {
            count = 1;
         }
         else
         {
            ++count;
         }
         countTextField.text = count.toString();
         refreshText();
      }
      
      private function onMinusClick(param1:MouseEvent) : void
      {
         if(count == 1)
         {
            count = maxCount;
         }
         else
         {
            --count;
         }
         countTextField.text = count.toString();
         refreshText();
      }
   }
}


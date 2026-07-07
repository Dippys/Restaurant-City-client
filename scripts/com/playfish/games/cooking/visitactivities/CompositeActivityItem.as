package com.playfish.games.cooking.visitactivities
{
   public class CompositeActivityItem extends ActivityItem
   {
      
      private var childrenActivityItems:Array;
      
      public function CompositeActivityItem(param1:VisitActivity)
      {
         super(param1);
         childrenActivityItems = new Array();
         addEventListener(EVENT_ITEM_CLICKED,removeAllEventListeners,false,0,true);
      }
      
      override public function removeAllEventListeners() : void
      {
         var _loc1_:ActivityItem = null;
         for each(_loc1_ in childrenActivityItems)
         {
            _loc1_.removeAllEventListeners();
         }
      }
      
      public function getChildren() : Array
      {
         return childrenActivityItems;
      }
      
      override public function addToRestaurant() : Boolean
      {
         var _loc2_:ActivityItem = null;
         var _loc3_:Boolean = false;
         var _loc1_:Boolean = false;
         for each(_loc2_ in childrenActivityItems)
         {
            _loc3_ = _loc2_.addToRestaurant();
            _loc1_ ||= _loc3_;
         }
         return _loc1_;
      }
      
      public function addItem(param1:ActivityItem) : void
      {
         param1.parent = this;
         childrenActivityItems.push(param1);
      }
      
      override public function remove() : void
      {
         var _loc1_:ActivityItem = null;
         for each(_loc1_ in childrenActivityItems)
         {
            _loc1_.remove();
         }
      }
   }
}


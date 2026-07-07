package com.facebook.data.notes
{
   import com.facebook.data.FacebookData;
   import mx.events.PropertyChangeEvent;
   
   public class GetNotesData extends FacebookData
   {
      
      private var _1716839361notesCollection:NotesCollection;
      
      public function GetNotesData()
      {
         super();
      }
      
      public function set notesCollection(param1:NotesCollection) : void
      {
         var _loc2_:Object = this._1716839361notesCollection;
         if(_loc2_ !== param1)
         {
            this._1716839361notesCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"notesCollection",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get notesCollection() : NotesCollection
      {
         return this._1716839361notesCollection;
      }
   }
}


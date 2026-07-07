package com.playfish.games.cooking
{
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public class TextGroup
   {
      
      public var textId:Array;
      
      public var langCode:String;
      
      public var textBody:Array;
      
      public function TextGroup(param1:ByteArray, param2:String)
      {
         var langXML:XML = null;
         var contents:XMLList = null;
         var content:XML = null;
         var curContent:XML = null;
         var textAttributes:XMLList = null;
         var id:XML = null;
         var textBodies:XMLList = null;
         var body:XML = null;
         var data:ByteArray = param1;
         var langCode:String = param2;
         super();
         this.langCode = langCode;
         textId = new Array();
         textBody = new Array();
         try
         {
            langXML = new XML(data);
            contents = langXML.content;
            content = contents[0];
            for each(curContent in contents)
            {
               if(curContent.attribute("lang") == langCode)
               {
                  content = curContent;
                  break;
               }
            }
            textAttributes = content.text.attributes();
            for each(id in textAttributes)
            {
               if(id.name() == "id")
               {
                  textId.push(id.toString());
               }
            }
            textBodies = content.text;
            for each(body in textBodies)
            {
               textBody.push(body.toString());
            }
         }
         catch(e:Error)
         {
            Debug.out(e.toString());
         }
      }
   }
}


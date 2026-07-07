package com.playfish.coretech.engine
{
   import com.playfish.coretech.engine.core.*;
   import flash.display.*;
   import flash.system.*;
   import flash.utils.*;
   
   public class PFEngine extends MovieClip
   {
      
      public static var instance:PFEngine;
      
      protected var flashVars:Object;
      
      public function PFEngine()
      {
         super();
         instance = this;
      }
      
      public function initialize() : void
      {
         flashVars = stage.loaderInfo.parameters;
         if(PFDebug.DEBUG)
         {
            PFDebug.trace(null,"Setting up PFEngine with: " + flashVars.toString());
         }
      }
      
      public function getMovieClip(param1:String) : MovieClip
      {
         var mcClass:Class = null;
         var name:String = param1;
         try
         {
            mcClass = Class(getDefinitionByName(name));
            if(mcClass != null)
            {
               return new mcClass();
            }
         }
         catch(e:Error)
         {
            PFDebug.trace(null,e.getStackTrace());
         }
         return null;
      }
      
      public function getParameter(param1:String) : Object
      {
         if(flashVars == null)
         {
            return null;
         }
         return flashVars[param1];
      }
      
      public function setParameterVars(param1:Object) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            flashVars[_loc2_] = param1[_loc2_];
         }
      }
      
      public function getParameterString(param1:String) : String
      {
         return getParameter(param1) as String;
      }
      
      public function hasParameter(param1:String) : Boolean
      {
         return flashVars[param1] != undefined;
      }
      
      public function setParameter(param1:String, param2:String) : void
      {
         flashVars[param1] = param2;
      }
      
      public function setParameterString(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc2_:Array = param1.split("&");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.split("=");
            setParameter(_loc4_[0],_loc4_[1]);
         }
      }
   }
}


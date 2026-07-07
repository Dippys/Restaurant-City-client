package com.playfish.coretech.engine.debug.commands.system
{
   import com.playfish.coretech.engine.debug.DebugConsole;
   import com.playfish.coretech.engine.debug.commands.DebugCommand;
   import com.playfish.coretech.engine.debug.commands.IDebugTweak;
   
   public class DebugCommandSystemVarSet extends DebugCommand
   {
      
      public function DebugCommandSystemVarSet(param1:DebugConsole)
      {
         super();
         param1.registerCommand("set",this);
      }
      
      public static function parseVariable(param1:Array) : Object
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         _loc2_ = param1[1];
         _loc3_ = param1[2];
         _loc4_ = "";
         _loc6_ = 3;
         var _loc7_:Array = _loc2_.split(/\s*\.\s*/);
         if(_loc7_.length > 1)
         {
            _loc2_ = _loc7_[0];
            _loc3_ = _loc7_[1];
            _loc6_ = 2;
         }
         var _loc8_:Array = _loc3_.split(/\s*\=\s*/);
         if(_loc8_.length > 1)
         {
            _loc3_ = _loc8_[0];
            _loc4_ += _loc8_[1];
         }
         var _loc9_:uint = uint(_loc6_);
         while(_loc9_ < param1.length)
         {
            _loc4_ += param1[_loc9_] + " ";
            _loc9_++;
         }
         _loc5_ = "";
         var _loc10_:int = _loc3_.indexOf("+");
         if(_loc10_ != -1)
         {
            _loc5_ = _loc3_.substr(_loc10_);
            _loc3_ = _loc3_.substr(0,_loc10_);
         }
         _loc10_ = _loc3_.indexOf("-");
         if(_loc10_ != -1)
         {
            _loc5_ = _loc3_.substr(_loc10_);
            _loc3_ = _loc3_.substr(0,_loc10_);
         }
         return {
            "class":_loc2_,
            "member":_loc3_,
            "value":_loc4_,
            "modifier":_loc5_
         };
      }
      
      override public function usage() : String
      {
         return "name <member name> <new value>[++|--]";
      }
      
      override public function exec(param1:DebugConsole, param2:Array) : void
      {
         var _loc5_:IDebugTweak = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param2.length < 2)
         {
            param1.traceMessage(null,"No arguments specified.");
            return;
         }
         var _loc3_:Object = parseVariable(param2);
         var _loc4_:Object = DebugCommandSystem.watchVarList[_loc3_["class"]];
         if(_loc4_ == null)
         {
            param1.traceMessage(null,"Object " + _loc3_["class"] + " is not registered.");
         }
         else
         {
            _loc5_ = _loc4_["object"] as IDebugTweak;
            _loc6_ = "";
            if(_loc5_ == null)
            {
               _loc6_ = _loc3_["class"] + " is not a tweakable class. Ensure it implements \'IDebugTweak\'";
            }
            else if(_loc3_["value"] == null)
            {
               _loc6_ = _loc3_["class"] + " can not be set, because no value was given.";
            }
            else
            {
               if(_loc3_["modifier"] != "")
               {
                  _loc7_ = Number(_loc5_.getTweak(_loc3_["member"]));
                  if(isNaN(_loc7_))
                  {
                     param1.traceMessage(null,"You can only use operators on numeric values");
                     return;
                  }
                  _loc8_ = Number(_loc3_["modifier"].toString().substr(2));
                  switch(_loc3_["modifier"].toString().substr(0,2))
                  {
                     case "++":
                        _loc7_++;
                        break;
                     case "--":
                        _loc7_--;
                        break;
                     case "+=":
                        _loc7_ += _loc8_;
                        break;
                     case "-=":
                        _loc7_ -= _loc8_;
                        break;
                     case "*=":
                        _loc7_ *= _loc8_;
                        break;
                     case "/=":
                        _loc7_ /= _loc8_;
                  }
                  _loc3_["value"] = String(_loc7_);
               }
               _loc5_.setTweak(_loc3_["member"],_loc3_["value"]);
               _loc6_ = _loc3_["value"];
            }
            param1.traceMessage(null,_loc6_);
         }
      }
      
      override public function help() : String
      {
         return "Change the value of tweakable object member.";
      }
   }
}


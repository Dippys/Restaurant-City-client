package com.playfish.games.cooking
{
   import flash.events.Event;
   import flash.media.*;
   import flash.utils.*;
   
   public class GameSound
   {
      
      public static const TYPE_SOUND:int = 0;
      
      public static const TYPE_MUSIC:int = 1;
      
      private static const NUM_TYPES:int = 2;
      
      private static var volumes:Array = [1,1];
      
      public static var activeSoundChannels:Array = new Array();
      
      public static var activeGameSounds:Array = new Array();
      
      public var type:int;
      
      private var sound:Sound;
      
      public function GameSound(param1:String, param2:int, param3:Sound = null)
      {
         var soundClass:Class = null;
         var name:String = param1;
         var type:int = param2;
         var sound:Sound = param3;
         super();
         this.type = type;
         if(sound)
         {
            this.sound = sound;
         }
         else
         {
            try
            {
               soundClass = Class(getDefinitionByName(name));
               this.sound = new soundClass();
            }
            catch(e:Error)
            {
               Debug.out("Error loading sound: " + name);
               Debug.out(e.getStackTrace());
            }
         }
      }
      
      public static function setGlobalVolume(param1:Number, param2:int) : void
      {
         volumes[param2] = param1;
         var _loc3_:Number = 0;
         while(_loc3_ < activeGameSounds.length)
         {
            if(activeGameSounds[_loc3_].type == param2)
            {
               activeSoundChannels[_loc3_].soundTransform = new SoundTransform(param1);
            }
            _loc3_++;
         }
      }
      
      public static function stopAll() : void
      {
         var _loc1_:* = int(activeSoundChannels.length - 1);
         while(_loc1_ >= 0)
         {
            activeSoundChannels[_loc1_].stop();
            _loc1_--;
         }
      }
      
      public static function getGlobalVolume(param1:int) : int
      {
         return volumes[param1];
      }
      
      public function stop() : void
      {
         var i:int = 0;
         try
         {
            i = activeGameSounds.length - 1;
            while(i >= 0)
            {
               if(activeGameSounds[i] == this)
               {
                  stopSoundChannel(activeSoundChannels[i]);
               }
               i--;
            }
         }
         catch(e:Error)
         {
            Debug.out("Error stoping sound: " + getQualifiedClassName(sound));
            Debug.out(e.getStackTrace());
         }
      }
      
      public function play(param1:int) : void
      {
         var loopValue:int = 0;
         var soundChannel:SoundChannel = null;
         var loops:int = param1;
         try
         {
            loopValue = loops;
            if(loopValue == 0 || loopValue == -1)
            {
               loopValue = 999999;
            }
            soundChannel = sound.play(0,loopValue,new SoundTransform(volumes[type]));
            activeGameSounds.push(this);
            activeSoundChannels.push(soundChannel);
            soundChannel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete,false,0,true);
         }
         catch(e:Error)
         {
            Debug.out("Error playing sound: " + getQualifiedClassName(sound));
            Debug.out(e.getStackTrace());
         }
      }
      
      private function stopSoundChannel(param1:SoundChannel) : void
      {
         param1.stop();
         param1.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
         var _loc2_:int = activeSoundChannels.indexOf(param1);
         if(_loc2_ != -1)
         {
            activeSoundChannels.splice(_loc2_,1);
            activeGameSounds.splice(_loc2_,1);
         }
      }
      
      private function onSoundComplete(param1:Event) : void
      {
         stopSoundChannel(param1.currentTarget as SoundChannel);
      }
   }
}


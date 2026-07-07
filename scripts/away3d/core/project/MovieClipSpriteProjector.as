package away3d.core.project
{
   import away3d.cameras.lenses.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import away3d.sprites.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class MovieClipSpriteProjector implements IPrimitiveProvider
   {
      
      private var _movieclip:DisplayObject;
      
      private var _view:View3D;
      
      private var _movieClipSprite:MovieClipSprite;
      
      private var _screenVertices:Array;
      
      private var _screenX:Number;
      
      private var _screenY:Number;
      
      private var _drawPrimitiveStore:DrawPrimitiveStore;
      
      private var _screenZ:Number;
      
      private var _lens:ILens;
      
      public function MovieClipSpriteProjector()
      {
         super();
      }
      
      public function get view() : View3D
      {
         return _view;
      }
      
      public function set view(param1:View3D) : void
      {
         _view = param1;
         _drawPrimitiveStore = view.drawPrimitiveStore;
      }
      
      public function primitives(param1:Object3D, param2:Matrix3D, param3:IPrimitiveConsumer) : void
      {
         _screenVertices = _drawPrimitiveStore.getScreenVertices(param1.id);
         _movieClipSprite = param1 as MovieClipSprite;
         _lens = _view.camera.lens;
         _movieclip = _movieClipSprite.movieclip;
         _lens.project(param2,_movieClipSprite.center,_screenVertices);
         _screenX = _screenVertices[0];
         _screenY = _screenVertices[1];
         _screenZ = _screenVertices[2] = _screenVertices[2] + _movieClipSprite.deltaZ;
         if(_movieClipSprite.align != "none")
         {
            switch(_movieClipSprite.align)
            {
               case "center":
                  _screenX -= _movieclip.width / 2;
                  _screenY -= _movieclip.height / 2;
                  break;
               case "topcenter":
                  _screenX -= _movieclip.width / 2;
                  break;
               case "bottomcenter":
                  _screenX -= _movieclip.width / 2;
                  _screenY -= _movieclip.height;
                  break;
               case "right":
                  _screenX -= _movieclip.width;
                  _screenY -= _movieclip.height / 2;
                  break;
               case "topright":
                  _screenX -= _movieclip.width;
                  break;
               case "bottomright":
                  _screenX -= _movieclip.width;
                  _screenY -= _movieclip.height;
                  break;
               case "left":
                  _screenY -= _movieclip.height / 2;
                  break;
               case "topleft":
                  break;
               case "bottomleft":
                  _screenY -= _movieclip.height;
            }
         }
         if(_movieClipSprite.rescale)
         {
            _movieclip.scaleX = _movieclip.scaleY = _movieClipSprite.scaling * view.camera.zoom / (1 + _screenZ / view.camera.focus);
         }
         param3.primitive(_drawPrimitiveStore.createDrawDisplayObject(param1,_screenX,_screenY,_screenZ,_movieClipSprite.session,_movieclip));
      }
   }
}


using gfx
using fwt

@Js
class ScenePane : Pane
{

  new make(Scene scene) { this.scene = scene }

  Scene scene { private set }

  override Size prefSize(Hints hints := Hints.defVal) { Size.defVal }

  override Void onLayout()
  {
    scene.onResize(this.size)
  }

}

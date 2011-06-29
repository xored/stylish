using gfx
using fwt

@Js
class ScenePane : Pane
{

  native Scene? scene

  override Size prefSize(Hints hints := Hints.defVal)
  {
    scene?.root?.size ?: Size.defVal
  }

  override Void onLayout()
  {
    if (scene == null || scene.root == null) return
    scene.root.pos = Point.defVal
    scene.root.size = this.size
  }

}

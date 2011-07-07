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
    if (!attached)
    {
      doAttach()
      attach()
      attached = true
    }
    onResize(this.size)
  }

  virtual protected Void attach() {}

  virtual protected Void onResize(Size s) {}

  internal native Void doAttach()

  // fwt haven't dispose event, so this method never call for now
  internal native Void doDetach()

  private Bool attached := false

}

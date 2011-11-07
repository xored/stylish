using gfx
using fwt
using stylishScene

@Js
class Container : ScenePane
{

  Control root

  new make(Control root) : super(Scene { it.root = root.node })
  {
    this.root = root
  }

  Void open()
  {
    Window { content = this }.open()
  }

  override protected Void sceneAttach()
  {
    root.doAttach(null, null)
  }

  override protected Void onResize(Size s)
  {
    root.resize(s)
  }

}

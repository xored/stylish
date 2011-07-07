using gfx
using fwt
using kawhyScene

@Js
class Container : ScenePane
{

  Control root

  new make(Control root) : super(Scene { it.root = root.getNode })
  {
    this.root = root
  }

  Void open()
  {
    Window { content = this }.open()
  }

  override protected Void attach()
  {
    root.doAttach(null, null)
  }

  override protected Void onResize(Size s)
  {
    root.resize(s)
  }

}

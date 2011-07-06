using gfx
using fwt
using kawhyScene

@Js
class Container
{

  new make(Control control)
  {
    this.root = control
    pane = ScenePane(Scene
    {
      it.root = control.getNode
      onResize = |Size size|
      {
        control.resize(size)
        if (!attached)
        {
          control.doAttach(null, null)
          attached = true
        }
      }
    })
  }

  Void open()
  {
    Window
    {
      content = pane
    }.open()
  }

  Control root

  private ScenePane pane

  private Bool attached := false

}

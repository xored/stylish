using gfx
using fwt
using kawhyScene

@Js
class ControlPane : Pane
{

  Control? control
  {
    set
    {
      &control = it
      if (pane != null) remove(pane)
      node := it?.node
      pane = ScenePane
      {
        scene = Scene { root = node }
        onAttach = |->|
        {
          control.attach(null)
        }
      }
      add(pane)
    }
  }

  override Size prefSize(Hints hints := Hints.defVal)
  {
    pane.prefSize(hints)
  }

  override Void onLayout()
  {
    if (pane == null) return
    pane.size = this.size
    pane.pos = Point.defVal
    pane.onLayout()
  }

  private ScenePane? pane := null
}

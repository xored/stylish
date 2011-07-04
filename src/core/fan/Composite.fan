using kawhyScene

@Js
class Composite : GroupControl
{

  Void layout()
  {
    Layout:Control[] groups := [:]
    kids.each
    {
      layout := layouts[it.hints.layout]
      if (layout == null) throw ArgErr("Layout \"$it.hints.layout\" required by \"it\" doesn't exist")
      groups.getOrAdd(layout) { [,] }.add(it)
    }
  }

  Void add(Control kid)
  {
    kids.add(kid)
    if (parent != null) kid.doAttach(this, this.node)
  }

  Void remove(Control kid)
  {
    if (parent != null) kid.doDetach()
    kids.remove(kid)
  }

  private Str:Layout layouts := [RelativeLayout.id:RelativeLayout()]

}

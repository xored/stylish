using kawhyScene

@Js
class Composite : Control
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
    node.add(kid.node)
  }

  Void remove(Control kid)
  {
    node.remove(kid.node)
    kids.remove(kid)
  }

  private Control[] kids := [,]

  override protected Group node := Group()

  private Str:Layout layouts := [RelativeLayout.id:RelativeLayout()]

}

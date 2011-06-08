
@Js
class Composite : Control
{

  Control[] kids := [,]

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

  private Str:Layout layouts := [RelativeLayout.id:RelativeLayout()]

}

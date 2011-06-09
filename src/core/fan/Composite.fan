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

  override protected Group node

  private Control[] kids := [,]

  private Str:Layout layouts := [RelativeLayout.id:RelativeLayout()]

}

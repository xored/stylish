using gfx
using kawhyCss
using kawhyScene

@Js
abstract class Control
{

  Point pos() { node.pos }

  Size size() { node.size }

  Style? style
  {
    get { node.style }
    set { node.style = it }
  }

  LayoutHints hints := LayoutHints()

  internal virtual Void attach(GroupControl? parent)
  {
    this.parent = parent
    if (parent != null) parent.node.add(node)
  }

  internal virtual Void detach(GroupControl? parent)
  {
    if (parent != null)
    {
      parent.node.remove(node)
      this.parent = null
    }
  }

  internal GroupControl? parent

  abstract internal Node node()

}

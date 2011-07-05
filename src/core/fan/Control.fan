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

  GroupControl? parent { private set }

  LayoutHints hints := LayoutHints()

  internal Void doAttach(GroupControl? parent, Group? content)
  {
    this.parent = parent
    if (content != null) content.add(node)
    attach()
  }

  internal Void doDetach()
  {
    if (parent != null)
    {
      detach()
      node.parent?.remove(node)
      this.parent = null
    }
  }

  virtual protected Void attach() {}

  virtual protected Void detach() {}

  abstract protected Node node()

  internal Node getNode() { node() }

}

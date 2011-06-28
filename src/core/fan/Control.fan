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

  internal Void attach(Group parent) { parent.add(node) }

  internal Void detach(Group parent) { parent.remove(node) }

  abstract protected Node node()

}

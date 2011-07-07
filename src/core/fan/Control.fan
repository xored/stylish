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

  internal Void resize(Size s)
  {
    node.size = s
    onResize(s)
  }

  virtual protected Void onResize(Size s) {}

  GroupControl? parent { private set }

  LayoutHints hints := LayoutHints()

  Void onMouseMove(|Point| f) { mouseListener.onMove(f) }

  Void rmMouseMove(|Point| f) { mouseListener.rmMove(f) }

  Void onMouseClick(|Bool down, Int count| f) { mouseListener.onClick(f) }

  Void rmMouseClick(|Bool down, Int count| f) { mouseListener.rmClick(f) }

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

  virtual protected Node listenerNode() { node() }

  private once MouseListener mouseListener() { MouseListener(listenerNode) }

}

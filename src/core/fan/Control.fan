using gfx
using stylishCss
using stylishScene
using stylishNotice

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

  // need to make size notifications
  Void resize(Size s)
  {
    node.size = s
    onResize(s)
  }

  virtual protected Void onResize(Size s) {}

  GroupControl? parent { private set }

  LayoutHints hints := LayoutHints()

  //TODO implement :-)
  Void focus() {}

  Point? mouse := null { private set }

  Notice onMouseMove := Notice()

  Notice onHover := Notice()

  Keyboard? keyboard() { node.scene?.keyboard }

  Void onMouseClick(|Bool down, Int count| f) { clicks.add(f) }

  Void unMouseClick(|Bool down, Int count| f) { clicks.remove(f) }

  Void onMouseWheel(|Point| f) { wheels.add(f) }

  Void unMouseWheel(|Point| f) { wheels.remove(f) }

  private |Bool down, Int count|[] clicks := [,]

  private |Point|[] wheels := [,]

  internal Void doAttach(GroupControl? parent, Group? content)
  {
    this.parent = parent
    if (content != null) content.add(node)
    attach()

    mouseListener = MouseListener
    {
      it.node = this.listenerNode
      it.onHover = |Bool hover| { this.onHover.push(hover) }
      onMove = |Point p| { onMouseMove.push(mouse = p) }
      onClick = |Bool down, Int count| { this.clicks.each { it.call(down, count) } }
      onWheel = |Point p->Bool|
      {
        if (this.wheels.size > 0)
        {
          this.wheels.each { it.call(p) }
          return true
        }
        return false
      }
    }
  }

  internal Void doDetach()
  {
    if (parent != null)
    {
      detach()
      mouseListener?.detach
      mouseListener = null
      node.parent?.remove(node)
      this.parent = null
    }
  }

  virtual protected Void attach() {}

  virtual protected Void detach() {}

  abstract Node node()

  virtual protected Node listenerNode() { node() }

  private MouseListener? mouseListener

}

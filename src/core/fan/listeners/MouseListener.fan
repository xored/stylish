using gfx
using kawhyScene

@Js
class MouseListener
{

  new make(Node node)
  {
    this.node = node
    mouseListener = |Point p|
    {
      pos := node.posOnScreen()
      fireMove(Point(p.x - pos.x, p.y - pos.y))
    }
    leftMouseListener = |Bool down|
    {
      count := node.scene.mouse.left.clicks
      fireClick(down, count)
    }
    hoverListener = |Bool hover|
    {
      mouse := node.scene?.mouse
      if (mouse == null) return
      if (hover)
      {
        mouse.on(Mouse#pos).add(mouseListener)
        mouse.left.on(MouseButton#down).add(leftMouseListener)
      }
      else
      {
        mouse.on(Mouse#pos).remove(mouseListener)
        mouse.left.on(MouseButton#down).remove(leftMouseListener)
      }
    }
  }

  Void onMove(|Point| f)
  {
    if (hoverListenerCount == 0)
      node.onHover.add(hoverListener)
    moves.add(f)
  }

  Void rmMove(|Point| f)
  {
    moves.remove(f)
    if (hoverListenerCount == 0)
      node.onHover.remove(hoverListener)
  }

  Void onClick(|Bool, Int| f)
  {
    if (hoverListenerCount == 0)
      node.onHover.add(hoverListener)
    clicks.add(f)
  }

  Void rmClick(|Bool, Int| f)
  {
    if (hoverListenerCount == 0)
      node.onHover.add(hoverListener)
    clicks.add(f)
  }

  protected Void fireMove(Point p)
  {
    moves.each { it(p) }
  }

  protected Void fireClick(Bool down, Int count)
  {
    clicks.each { it(down, count) }
  }

  private Int hoverListenerCount() { moves.size + clickListenerCount }

  private Int clickListenerCount() { clicks.size }

  private |Point|[] moves := [,]
  private |Bool, Int|[] clicks := [,]

  private |Bool| hoverListener
  private |Point| mouseListener
  private |Obj?| leftMouseListener

  private Node node

}

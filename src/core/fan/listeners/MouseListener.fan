using gfx
using kawhyScene

@Js
class MouseListener
{

  new make(Node node)
  {
    this.node = node
    mouseListener = |Point p->Bool|
    {
      pos := node.posOnScreen()
      fireMove(Point(p.x - pos.x, p.y - pos.y))
      return true
    }
    leftMouseListener = |Bool down->Bool|
    {
      count := node.scene.mouse.left.clicks
      fireClick(down, count)
      return true
    }
    hoverListener = |Bool hover->Bool|
    {
      mouse := node.scene.mouse
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
      return true
    }
  }

  Void onMove(|Point| f)
  {
    if (hoverListenerCount == 0)
      node.onHover.add(hoverListener)
    moves.add(f)
  }

  Void unMove(|Point| f)
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

  Void unClick(|Bool, Int| f)
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

  private |Bool->Bool| hoverListener
  private |Point->Bool| mouseListener
  private |Obj?->Bool| leftMouseListener

  private Node node

}

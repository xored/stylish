using gfx
using kawhyScene

@Js
class MouseListener
{

  new make(Node node)
  {
    this.node = node
    move = |Point p->Bool|
    {
      pos := node.posOnScreen()
      fireMove(Point(p.x - pos.x, p.y - pos.y))
      return true
    }
    click = |Bool down->Bool|
    {
      count := node.scene.mouse.left.clicks
      fireClick(down, count)
      updateListeners()
      return true
    }
    hover = |Bool hover->Bool|
    {
      updateListeners()
    }
  }

  Void onMove(|Point| f)
  {
    if (hoverListenerCount == 0)
      node.onHover.add(hover)
    moves.add(f)
  }

  Void unMove(|Point| f)
  {
    moves.remove(f)
    if (hoverListenerCount == 0)
      node.onHover.remove(hover)
  }

  Void onClick(|Bool, Int| f)
  {
    if (hoverListenerCount == 0)
      node.onHover.add(hover)
    clicks.add(f)
  }

  Void unClick(|Bool, Int| f)
  {
    if (hoverListenerCount == 0)
      node.onHover.add(hover)
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

  private Bool updateListeners()
  {
    hover := node.hover
    mouse := node.scene.mouse
    down := mouse.left.down
    lfm := hover || down
    if (lfm && !lookForMouse)
    {
      mouse.on(Mouse#pos).add(move)
      mouse.left.on(MouseButton#down).add(click)
      lookForMouse = true
      return true
    }
    if (!lfm && lookForMouse)
    {
      mouse.on(Mouse#pos).remove(move)
      mouse.left.on(MouseButton#down).remove(click)
      lookForMouse = false
      return true
    }
    return false
  }

  private Bool lookForMouse := false

  private Int hoverListenerCount() { moves.size + clickListenerCount }

  private Int clickListenerCount() { clicks.size }

  private |Point|[] moves := [,]
  private |Bool, Int|[] clicks := [,]

  private |Bool->Bool| hover
  private |Point->Bool| move
  private |Obj?->Bool| click

  private Node node

}

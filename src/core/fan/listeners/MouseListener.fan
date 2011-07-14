using gfx
using kawhyScene

@Js
class MouseListener
{

  new make()
  {
    move = |Point p->Bool|
    {
      fireMove()
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

  Void attach(Control control, Node node)
  {
    this.control = control
    this.node = node
    node.onHover.add(hover)
  }

  Void detach()
  {
    node.onHover.remove(hover)
    this.control = null
    this.node = null
  }

  Void onMove(|Point| f) { moves.add(f) }

  Void unMove(|Point| f) { moves.remove(f) }

  Void onClick(|Bool, Int| f) { clicks.add(f) }

  Void unClick(|Bool, Int| f) { clicks.add(f) }

  protected Void fireMove()
  {
    np := node.posOnScreen()
    mp := node.scene.mouse.pos
    pos := Point(mp.x - np.x, mp.y - np.y)
    control.mouse = pos
    moves.each { it(pos) }
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
      fireMove()
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

  private Int clickListenerCount() { clicks.size }

  private |Point|[] moves := [,]
  private |Bool, Int|[] clicks := [,]

  private |Bool->Bool| hover
  private |Point->Bool| move
  private |Obj?->Bool| click

  private Control? control
  private Node? node

}

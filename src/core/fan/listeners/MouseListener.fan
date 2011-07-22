using gfx
using kawhyScene
using kawhyNotice

@Js
class MouseListener
{

  new make()
  {
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

  private Bool updateListeners()
  {
    hover := node.hover
    mouse := node.scene.mouse
    down := mouse.left
    lfm := hover || down
    if (lfm && !lookForMouse)
    {
      move  = mouse.onPos.handle { fireMove() }
      click = mouse.onLeft.handle |Bool val|
      {
        fireClick(val)
        updateListeners()
      }
      lookForMouse = true
      fireMove()
      return true
    }
    if (!lfm && lookForMouse)
    {
      move.discard
      click.discard
      lookForMouse = false
      return true
    }
    return false
  }

  protected Void fireClick(Bool down)
  {
    if (down)
    {
      now := DateTime.nowTicks / 1000000
      diff := now - clickTime
      clickTime = now
      pos := control.mouse
      if (diff < 600 && clickPos.equals(pos))
      {
        clickCount++
      }
      else
      {
        clickCount = 1
        clickPos = pos
      }
    }
    clicks.each { it(down, clickCount) }
  }

  private Int clickCount
  private Int clickTime
  private Point clickPos := Point.defVal

  private Bool lookForMouse := false

  private Int clickListenerCount() { clicks.size }

  private |Point|[] moves := [,]
  private |Bool, Int|[] clicks := [,]

  private |Bool->Bool| hover
  private Notice? move
  private Notice? click

  private Control? control
  private Node? node

}

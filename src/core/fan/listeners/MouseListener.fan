using gfx
using kawhyScene
using kawhyNotice

@Js
class MouseListener
{

  |Point|? onMove

  |Bool, Int|? onClick

  Node node

  new make(|This| f)
  {
    f.call(this)
    hover = node.onHover.handle { updateListeners() }
  }

  Void detach() { hover.discard }

  protected Void fireMove()
  {
    np := node.posOnScreen()
    mp := node.scene.mouse.pos
    pos = Point(mp.x - np.x, mp.y - np.y)
    onMove?.call(pos)
  }

  private Bool updateListeners()
  {
    hover := node.hover
    mouse := node.scene.mouse
    down := mouse.left
    lfm := hover || down
    if (lfm && pos == null)
    {
      move  = mouse.onPos.handle { fireMove() }
      click = mouse.onLeft.handle |Bool val|
      {
        fireClick(val)
        updateListeners()
      }
      fireMove()
      return true
    }
    if (!lfm && pos != null)
    {
      move.discard
      click.discard
      pos = null
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
    onClick?.call(down, clickCount)
  }

  private Int clickCount
  private Int clickTime
  private Point? pos
  private Point clickPos := Point.defVal

  private Notice hover
  private Notice? move
  private Notice? click

}

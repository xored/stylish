using gfx
using stylishScene
using stylishNotice

@Js
class MouseListener
{

  |Point|? onMove

  |Bool, Int|? onClick
  
  |Bool, Int, MouseBtn|? onBtnClick

  |Point->Bool|? onWheel

  |Bool|? onHover

  Node node

  new make(|This| f)
  {
    f.call(this)
    hover = node.onHover.handle { updateListeners() }
  }

  Void detach()
  {
    discardAll()
    hover.discard
  }

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
      onHover?.call(true)
      move  = mouse.onPos.handle { fireMove() }
      click = mouse.onLeft.handle |Bool val|
      {
        fireClick(val, MouseBtn.leftBtn)
        updateListeners()
      }
      rightClick = mouse.onRight.handle |Bool val|
      {
        fireClick(val, MouseBtn.rightBtn)
        updateListeners()
      }
      middleClick = mouse.onMiddle.handle |Bool val|
      {
        fireClick(val, MouseBtn.middleBtn)
        updateListeners()
      }
      wheel = mouse.onWheel.process |Point val->Bool|
      {
        if (onWheel == null) return false
        return onWheel.call(val)
      }
      fireMove()
      return true
    }
    if (!lfm && pos != null)
    {
      onHover?.call(false)
      discardAll()
      pos = null
      return true
    }
    return false
  }

  private Void discardAll()
  {
    move?.discard
    move = null
    click?.discard
    click = null
    rightClick?.discard
    rightClick = null
    middleClick?.discard
    middleClick = null
    wheel?.discard
    wheel = null
  }

  protected Void fireClick(Bool down, MouseBtn btn)
  {
    if (down)
    {
      now := DateTime.nowTicks / 1000000
      diff := now - clickTime
      clickTime = now
      if (diff < 600 && clickPos.equals(pos) && btn == clickBtn)
      {
        clickCount++
      }
      else
      {
        clickCount = 1
        clickBtn = btn
        clickPos = pos
      }
    }
    
    if (MouseBtn.leftBtn == clickBtn)
    {
      onClick?.call(down, clickCount)
    }
    onBtnClick?.call(down, clickCount, clickBtn)
  }

  private Int clickCount
  private Int clickTime
  private Point? pos
  private Point clickPos := Point.defVal
  private MouseBtn clickBtn := MouseBtn.leftBtn

  private Notice hover
  private Notice? move
  private Notice? click
  private Notice? rightClick
  private Notice? middleClick
  private Notice? wheel

}

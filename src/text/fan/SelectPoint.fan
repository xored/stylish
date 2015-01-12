using gfx
using fwt
using stylish
using stylishMath
using stylishNotice
using stylishScene

@Js
class SelectPoint : Policy
{

  override TextEdit control

  new make(|This| f) { f(this) }

  override Void attach()
  {
    onMove = control.onMouseMove.handle { if (pressed) move() }
    control.onMouseBtnClick(onBtnClick)
    control.keyboard?.on(Keyboard#key)?.add(onKeyPress)
  }

  override Void detach()
  {
    onMove.discard
    control.unMouseBtnClick(onBtnClick)
    control.keyboard?.on(Keyboard#key)?.remove(onKeyPress)
  }

  private Void move()
  {
    y := control.mouse.y
    row := control.rowByPos(y)
    if (row == null) row = control.source.size - 1
    rows := control.visibleRows
    if (row < rows.start)
    {
      pos := control.posByRow(rows.start)
      doAutoScroll(AutoScrollDirection.Up, pos - y)
    }
    else if (row > rows.last)
    {
      pos := control.posByRow(rows.last)
      doAutoScroll(AutoScrollDirection.Down, y - pos)
    }
    else
    {
      control.selection.extend(pos)
      endAutoScroll()
    }
  }

  private GridPos pos()
  {
    pos := control.textPos(control.mouse)
    size := control.source[pos.row].text.size
    if (pos.col < size)
    {
      region := control.colRegion(pos.row, pos.col)
      if (control.mouse.x - region.start >= region.size / 2)
        return GridPos(pos.row, pos.col + 1)
    }
    return pos
  }

  private Void endAutoScroll() { autoScrollDirection = AutoScrollDirection.None }

  private Void doAutoScroll(AutoScrollDirection direction, Int distance)
  {
    autoScrollDistance = distance
    // If we're already autoscrolling in the given direction do nothing
    if (autoScrollDirection == direction) return
    autoScrollDirection = direction
    Desktop.callLater(delay, autoScoll)
  }

  private |->| autoScoll := |->|
  {
    lines := 1.max(autoScrollDistance / control.itemSize)
    rows := control.visibleRows
    if (autoScrollDirection == AutoScrollDirection.Up)
    {
      control.selection.extend(GridPos(0.max(rows.start - lines), 0))
      Desktop.callLater(delay, autoScoll)
    }
    else if (autoScrollDirection == AutoScrollDirection.Down)
    {
      control.selection.extend(GridPos((rows.last + lines).min(control.source.size - 1), 0))
      Desktop.callLater(delay, autoScoll)
    }
  }

  private Notice? onMove
  
  private |Bool, Int, MouseBtn| onBtnClick := |Bool down, Int count, MouseBtn btn| 
  {
    if (MouseBtn.leftBtn == btn) {
      if (count == 1)
      {
        pressed = down
        if (down)
        {
          if (control.keyboard.key.isShift)
          {
            control.selection.extend(pos)
          }
          else
          {
            control.selection.range = GridRange(pos)
          }
        }
        else endAutoScroll()
      }
    } 
    else 
    {
      // clear selection on non-left click
      control.selection.range = GridRange(pos)
    }
  }
  
  private |Obj?->Bool| onKeyPress := |Obj? key -> Bool|
  {    
    k := (Key)key
    if (k.isShift) 
    {
      pk := k.primary
      r := control.selection.range
      e := r.end
      
      if (Key.left == pk)
      {
        e = GridPos(e.row, (e.col - 1).max(0))
      } 
      else if (Key.right == pk) 
      {
        e = GridPos(e.row, e.col + 1)
      } 
      else if (Key.up == pk) 
      {
        e = GridPos((e.row - 1).max(0), e.col)
      } 
      else if (Key.down == pk) 
      {
        e = GridPos(e.row + 1, e.col)
      }
      
      if (e != r.end) 
      {
        control.selection.extend(e)
      }      
    }
    return false
  }

  private Bool pressed := false

  private Int autoScrollDistance := 0
  private AutoScrollDirection autoScrollDirection := AutoScrollDirection.None
  private static const Duration delay := Duration(50 * 1000 * 1000)

}

@Js
enum class AutoScrollDirection { Up, Down, None }
using gfx
using fwt
using stylish
using stylishMath
using stylishNotice

@Js
class SelectPoint : Policy
{

  override TextEdit control

  new make(|This| f) { f(this) }

  override Void attach()
  {
    onMove = control.onMouseMove.handle { if (pressed) move() }
    control.onMouseClick(onClick)
  }

  override Void detach()
  {
    onMove.discard
    control.unMouseClick(onClick)
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

  private |Bool, Int| onClick := |Bool down, Int count|
  {
    if (count == 1)
    {
      pressed = down
      if (down)
      {
        if (control.keyboard.key.isShift)
          control.selection.extend(pos)
        else
          control.selection.range = GridRange(pos)
      }
      else endAutoScroll()
    }
  }

  private Bool pressed := false

  private Int autoScrollDistance := 0
  private AutoScrollDirection autoScrollDirection := AutoScrollDirection.None
  private static const Duration delay := Duration(50 * 1000 * 1000)

}

@Js
enum class AutoScrollDirection { Up, Down, None }
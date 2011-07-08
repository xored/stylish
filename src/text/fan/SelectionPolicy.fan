using gfx
using kawhy
using kawhyMath

@Js
class SelectionPolicy : Policy
{

  override TextEdit control { private set }

  new make(TextEdit control)
  {
    this.control = control
    onMove = |Point mouse|
    {
      this.mouse = mouse
      if (pressed) control.selection.extend(pos)
    }
    onClick = |Bool down, Int count|
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
      }
    }
    control.onMouseMove(onMove)
    control.onMouseClick(onClick)
  }

  private GridPos pos()
  {
    row := control.rowByPos(mouse.y)
    if (row == null) row = control.source.size - 1
    raws := control.visibleRaws
    if (row < raws.start) return GridPos(raws.start - 1, 0)
    if (row > raws.last) return GridPos(raws.last + 1, 0)
    col := control.colByPos(row, mouse.x)
    if (col == null) col = control.source[row].size
    else
    {
      region := control.colRegion(row, col)
      if (mouse.x - region.start >= region.size / 2) col++
    }
    return GridPos(row, col)
  }

  override Void dispose()
  {
    control.rmMouseMove(onMove)
    control.rmMouseClick(onClick)
  }

  private Point mouse := Point.defVal
  private Bool pressed := false

  private |Point| onMove
  private |Bool, Int| onClick

}
